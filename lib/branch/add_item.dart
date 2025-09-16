import 'dart:io';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class AddItemPage extends StatefulWidget {
  final String branchId; // ID للفرع الحالي حتى نخزن المنتج داخله

  const AddItemPage({Key? key, required this.branchId}) : super(key: key);

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  File? _imageFile;
  bool _isLoading = false;

  String? _unit; // "كيلو" أو "قطعة"

  Future<void> _pickImage() async {
    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _addItem() async {
    if (!_formKey.currentState!.validate()) return;

    try {
      setState(() {
        _isLoading = true;
      });

      String? imageUrl;
      if (_imageFile != null) {
        // رفع الصورة إلى Firebase Storage
        final fileName = "${DateTime.now().millisecondsSinceEpoch}.jpg";
        final storageRef = FirebaseStorage.instance
            .ref()
            .child("items")
            .child(fileName);

        await storageRef.putFile(_imageFile!);
        imageUrl = await storageRef.getDownloadURL();
      }

      // تحديد النص النهائي للسعر
      String priceText = _unit == "كيلو"
          ? "الكيلو بـ ${_priceController.text.trim()}"
          : "القطعة بـ ${_priceController.text.trim()}";

      // 🔥 جلب آخر position موجود
      final querySnapshot = await FirebaseFirestore.instance
          .collection("branches")
          .doc(widget.branchId)
          .collection("menu")
          .orderBy("position", descending: true)
          .limit(1)
          .get();

      int newPosition = 0;
      if (querySnapshot.docs.isNotEmpty) {
        final lastDoc = querySnapshot.docs.first;
        newPosition = (lastDoc["position"] ?? 0) + 1;
      }

      // إضافة البيانات إلى Firestore
      await FirebaseFirestore.instance
          .collection("branches")
          .doc(widget.branchId)
          .collection("menu")
          .add({
            "name": _nameController.text.trim(),
            "price": priceText,
            "image": imageUrl ?? "", // إذا ما اختار صورة نخليها نص فاضي
            "unit": _unit,
            "createdAt": FieldValue.serverTimestamp(),
            "position": newPosition, // ✅ إضافة position
          });

      Navigator.pop(context); // رجوع بعد الإضافة
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("خطأ: $e")));
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  InputDecoration _inputDecoration(String label) {
    return InputDecoration(
      labelText: label,
      border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      focusedBorder: OutlineInputBorder(
        borderSide: const BorderSide(color: Color(0xFF8B0000), width: 2),
        borderRadius: BorderRadius.circular(12),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            "إضافة صنف جديد",
            style: TextStyle(fontFamily: "Amiri"),
          ),
          backgroundColor: const Color(0xFF8B0000),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16),
          child: Form(
            key: _formKey,
            child: ListView(
              children: [
                // الاسم
                TextFormField(
                  controller: _nameController,
                  decoration: _inputDecoration("اسم الصنف"),
                  validator: (value) =>
                      value == null || value.isEmpty ? "أدخل اسم الصنف" : null,
                ),
                const SizedBox(height: 16),

                // السعر
                TextFormField(
                  controller: _priceController,
                  decoration: _inputDecoration("السعر"),
                  keyboardType: TextInputType.number,
                  validator: (value) =>
                      value == null || value.isEmpty ? "أدخل السعر" : null,
                ),
                const SizedBox(height: 16),

                // الوحدة (كيلو / قطعة)
                DropdownButtonFormField<String>(
                  decoration: _inputDecoration("الوحدة"),
                  items: const [
                    DropdownMenuItem(value: "كيلو", child: Text("كيلو")),
                    DropdownMenuItem(value: "قطعة", child: Text("قطعة")),
                  ],
                  onChanged: (val) => setState(() => _unit = val),
                  validator: (val) => val == null ? "اختر الوحدة" : null,
                ),
                const SizedBox(height: 16),

                // اختيار صورة (اختياري)
                GestureDetector(
                  onTap: _pickImage,
                  child: Container(
                    height: 150,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.grey),
                      borderRadius: BorderRadius.circular(12),
                      color: Colors.grey[200],
                    ),
                    child: _imageFile == null
                        ? const Center(
                            child: Text("اضغط لاختيار صورة (اختياري)"),
                          )
                        : Image.file(_imageFile!, fit: BoxFit.cover),
                  ),
                ),
                const SizedBox(height: 24),

                // زر الإضافة
                ElevatedButton(
                  onPressed: _isLoading ? null : _addItem,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B0000),
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: _isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                          "إضافة",
                          style: TextStyle(
                            fontFamily: "Amiri",
                            fontSize: 18,
                            color: Colors.white,
                          ),
                        ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
