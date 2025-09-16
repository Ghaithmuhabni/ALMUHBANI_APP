//branch_details.dart
import 'package:flutter/material.dart';
import 'package:flutter_application_1/branch/add_item.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class BranchDetailsPage extends StatelessWidget {
  static const String routeName = '/branch-details';

  final Map<String, dynamic> branch;

  const BranchDetailsPage({required this.branch, Key? key}) : super(key: key);

  // دالة لفتح خرائط غوغل
  Future<void> _openGoogleMaps() async {
    const url =
        'https://www.google.com/maps/search/?api=1&query=34.73309996612312,36.703286909408746';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      throw 'لا يمكن فتح الرابط $url';
    }
  }

  // دالة للاتصال
  Future<void> _callPhone(String phoneNumber) async {
    final Uri phoneUri = Uri(scheme: 'tel', path: phoneNumber);

    if (!await launchUrl(phoneUri, mode: LaunchMode.externalApplication)) {
      throw 'لا يمكن إجراء الاتصال على $phoneNumber';
    }
  }

  // دالة لفتح واتساب
  Future<void> _openWhatsApp(String phoneNumber) async {
    final Uri whatsappUri = Uri.parse("https://wa.me/$phoneNumber");

    if (!await launchUrl(whatsappUri, mode: LaunchMode.externalApplication)) {
      throw 'لا يمكن فتح الواتساب للرقم $phoneNumber';
    }
  }

  // ✅ نافذة تعديل المنتج
  void _editItem(
    BuildContext context,
    String branchId,
    String docId,
    Map<String, dynamic> data,
  ) {
    final TextEditingController nameController = TextEditingController(
      text: data["name"],
    );
    final TextEditingController priceController = TextEditingController(
      text: data["price"],
    );

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "تعديل المنتج",
            style: TextStyle(fontFamily: "Amiri"),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: "اسم الصنف"),
              ),
              TextField(
                controller: priceController,
                decoration: const InputDecoration(labelText: "السعر"),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () async {
                await FirebaseFirestore.instance
                    .collection("branches")
                    .doc(branchId)
                    .collection("menu")
                    .doc(docId)
                    .update({
                      "name": nameController.text.trim(),
                      "price": priceController.text.trim(),
                    });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF8B0000),
              ),
              child: const Text("حفظ", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );
  }

  // ✅ تأكيد حذف المنتج
  void _deleteItem(BuildContext context, String branchId, String docId) async {
    final confirm = await showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text(
            "تأكيد الحذف",
            style: TextStyle(fontFamily: "Amiri"),
          ),
          content: const Text("هل أنت متأكد أنك تريد حذف هذا المنتج؟"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: const Text("إلغاء"),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text("حذف", style: TextStyle(color: Colors.white)),
            ),
          ],
        );
      },
    );

    if (confirm == true) {
      await FirebaseFirestore.instance
          .collection("branches")
          .doc(branchId)
          .collection("menu")
          .doc(docId)
          .delete();
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = FirebaseAuth.instance.currentUser; // ✅ معرفة حالة تسجيل الدخول

    return Directionality(
      textDirection: TextDirection.rtl,
      child: Scaffold(
        backgroundColor: const Color(0xFFE8D5B5),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            branch['name'] ?? '',
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF8B0000),
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        body: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // صورة ثابتة من الملف
                    Container(
                      width: double.infinity,
                      height: 225,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: const DecorationImage(
                          image: AssetImage('images/logo1.png'),
                          fit: BoxFit.fill,
                        ),
                      ),
                    ),
                    const SizedBox(height: 16),

                    // اسم المدير
                    Text(
                      'مدير الفرع: ${branch['manager'] ?? ''}',
                      style: const TextStyle(
                        fontFamily: 'Amiri',
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF8B0000),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // العنوان
                    Row(
                      children: [
                        const Icon(
                          Icons.location_on,
                          color: Color(0xFF8B0000),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'المنطقة: ${branch['region'] ?? ''}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.grey[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 16),

                    // أوقات العمل (ثابتة حاليا)
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time,
                          color: Color(0xFF8B0000),
                          size: 20,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'مفتوح من 8:00 صباحاً إلى 10:00 مساءً',
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            fontSize: 16,
                            color: Colors.grey[900],
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 16),
                    Row(
                      children: [
                        const Icon(Icons.phone,
                            color: Color(0xFF8B0000), size: 20),
                        const SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'ارقام التواصل: ${branch['linelnad_phone'] ?? ''} , ${branch['phone'] ?? ''}',
                            style: TextStyle(
                              fontFamily: 'Poppins',
                              fontSize: 16,
                              color: Colors.grey[900],
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 24),

                    // خريطة غوغل
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        color: Colors.white,
                        border:
                            Border.all(color: Color(0xFF8B0000), width: 2),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 5,
                            offset: Offset(0, 3),
                          ),
                        ],
                      ),
                      child: Stack(
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: GoogleMap(
                              initialCameraPosition: const CameraPosition(
                                target: LatLng(
                                    34.73309996612312, 36.703286909408746),
                                zoom: 15,
                              ),
                              markers: {
                                const Marker(
                                  markerId: MarkerId("branch"),
                                  position: LatLng(
                                    34.73309996612312,
                                    36.703286909408746,
                                  ),
                                  infoWindow: InfoWindow(title: "فرعنا هنا"),
                                ),
                              },
                              zoomControlsEnabled: false,
                              myLocationButtonEnabled: false,
                            ),
                          ),
                          Positioned(
                            bottom: 8,
                            right: 8,
                            child: ElevatedButton.icon(
                              onPressed: _openGoogleMaps,
                              icon: const Icon(
                                Icons.directions,
                                size: 16,
                                color: Colors.white,
                              ),
                              label: const Text(
                                'الاتجاهات',
                                style: TextStyle(
                                  fontFamily: 'Poppins',
                                  fontSize: 12,
                                  color: Colors.white,
                                ),
                              ),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF8B0000),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(8),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 24),

                    // القائمة + زر الإضافة إذا الأدمن مسجل دخول
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'القائمة',
                          style: TextStyle(
                            fontFamily: 'Amiri',
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF8B0000),
                          ),
                        ),
                        if (user != null) // ✅ فقط اذا الأدمن مسجل دخول
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      AddItemPage(branchId: branch['id']),
                                ),
                              );
                            },
                            icon: const Icon(
                              Icons.add_circle,
                              color: Color(0xFF8B0000),
                              size: 28,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 12),

                    SizedBox(
                      height: 400, // ارتفاع افتراضي للقائمة
                      child: _buildMenuItems(branch['id'], user),
                    ),

                    const SizedBox(height: 80),
                  ],
                ),
              ),
            ),
          ],
        ),

        // الأزرار في أسفل الصفحة
        bottomSheet: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border:
                Border(top: BorderSide(color: Color(0xFF8B0000), width: 2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => _callPhone(branch['phone'] ?? ''),
                  icon: const Icon(Icons.phone, size: 18, color: Colors.white),
                  label: const Text(
                    'اتصال',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B0000),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 16),
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {
                    final phone = branch['phone'] ?? '';
                    if (phone.isNotEmpty && phone.startsWith('0')) {
                      _openWhatsApp("963${phone.substring(1)}");
                    }
                  },
                  icon: const Icon(
                    Icons.message,
                    size: 18,
                    color: Colors.white,
                  ),
                  label: const Text(
                    'واتساب',
                    style: TextStyle(
                      fontFamily: 'Poppins',
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF8B0000),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  // ✅ جلب قائمة الطعام من Firestore مع ReorderableListView
  Widget _buildMenuItems(String branchId, User? user) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance
          .collection("branches")
          .doc(branchId)
          .collection("menu")
          .orderBy("position")
          .snapshots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
          return const Center(
            child: Text(
              "لا توجد أصناف مضافة بعد",
              style: TextStyle(fontFamily: 'Amiri', fontSize: 16),
            ),
          );
        }

        final items = snapshot.data!.docs;

        return ReorderableListView.builder(
          itemCount: items.length,
          onReorder: (oldIndex, newIndex) async {
            if (newIndex > oldIndex) newIndex -= 1;

            final updatedItems = List.from(items);
            final movedItem = updatedItems.removeAt(oldIndex);
            updatedItems.insert(newIndex, movedItem);

            // تحديث كل العناصر بالترتيب الجديد
            for (int i = 0; i < updatedItems.length; i++) {
              final doc = updatedItems[i];
              await FirebaseFirestore.instance
                  .collection("branches")
                  .doc(branchId)
                  .collection("menu")
                  .doc(doc.id)
                  .update({"position": i});
            }
          },
          itemBuilder: (context, index) {
            final doc = items[index];
            final data = doc.data() as Map<String, dynamic>;
            return Container(
              key: ValueKey(doc.id),
              margin: const EdgeInsets.symmetric(vertical: 8),
              decoration: BoxDecoration(
                color: Colors.white,
                border: Border.all(color: const Color(0xFF8B0000), width: 1.5),
                borderRadius: BorderRadius.circular(16),
                boxShadow: const [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: ListTile(
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                leading: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: data["image"] != null &&
                          data["image"].toString().isNotEmpty
                      ? Image.network(
                          data["image"],
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        )
                      : Image.asset(
                          "images/logo1.png",
                          width: 100,
                          height: 100,
                          fit: BoxFit.cover,
                        ),
                ),
                title: Text(
                  data["name"] ?? "",
                  style: const TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B0000),
                  ),
                ),
                subtitle: Text(
                  "${data["price"] ?? ""} ل.س",
                  style: const TextStyle(
                    fontFamily: 'Poppins',
                    fontSize: 14,
                    color: Colors.black87,
                  ),
                ),
                onTap: user != null
                    ? () {
                        showModalBottomSheet(
                          context: context,
                          builder: (context) => Wrap(
                            children: [
                              ListTile(
                                leading: const Icon(Icons.edit,
                                    color: Colors.blue),
                                title: const Text("تعديل"),
                                onTap: () {
                                  Navigator.pop(context);
                                  _editItem(context, branchId, doc.id, data);
                                },
                              ),
                              ListTile(
                                leading: const Icon(Icons.delete,
                                    color: Colors.red),
                                title: const Text("حذف"),
                                onTap: () {
                                  Navigator.pop(context);
                                  _deleteItem(context, branchId, doc.id);
                                },
                              ),
                            ],
                          ),
                        );
                      }
                    : null,
              ),
            );
          },
        );
      },
    );
  }
}


// import 'package:flutter/material.dart';
// // import 'package:url_launcher/url_launcher.dart';

// class BranchDetailsPage extends StatelessWidget {
//   static const String routeName = '/branch-details';

//   // بيانات الفرع
//   final Map<String, dynamic> branch;

//   const BranchDetailsPage({required this.branch, Key? key}) : super(key: key);

//   @override
//   Widget build(BuildContext context) {
//     return Directionality(
//       textDirection: TextDirection.rtl, // محاذاة النص لليمين
//       child: Scaffold(
//         appBar: AppBar(
//           centerTitle: true,
//           title: Text(
//             branch['name'],
//             style: const TextStyle(
//               fontFamily: 'Amiri',
//               fontSize: 20,
//               color: Colors.white,
//             ),
//           ),
//           backgroundColor: const Color(0xFF8B0000),
//           elevation: 0,
//           leading: IconButton(
//             icon: const Icon(Icons.arrow_back, color: Colors.white),
//             onPressed: () => Navigator.pop(context),
//           ),
//         ),

//         body: SingleChildScrollView(
//           padding: const EdgeInsets.all(16),
//           child: Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: [
//               // صورة الفرع
//               Container(
//                 width: double.infinity,
//                 height: 200,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   image: DecorationImage(
//                     image: AssetImage(branch['image']),
//                     fit: BoxFit.cover,
//                   ),
//                 ),
//               ),
//               const SizedBox(height: 16),

//               // اسم المدير
//               Text(
//                 'مدير الفرع: ${branch['manager']}',
//                 style: const TextStyle(
//                   fontFamily: 'Amiri',
//                   fontSize: 16,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF8B0000),
//                 ),
//               ),
//               const SizedBox(height: 8),

//               // العنوان
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.location_on,
//                     color: Color(0xFF8B0000),
//                     size: 20,
//                   ),
//                   const SizedBox(width: 8),
//                   Expanded(
//                     child: Text(
//                       'المنطقة: حمص - ${branch['region']}  ',
//                       style: TextStyle(
//                         fontFamily: 'Poppins',
//                         fontSize: 15,
//                         color: Colors.grey[900],
//                       ),
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 16),

//               // أوقات العمل
//               Row(
//                 children: [
//                   const Icon(
//                     Icons.access_time,
//                     color: Color(0xFF8B0000),
//                     size: 20,
//                   ),
//                   const SizedBox(width: 8),
//                   Text(
//                     'مفتوح من 7:00 صباحاً إلى 10:00 مساءً',
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       fontSize: 15,
//                       color: Colors.grey[900],
//                     ),
//                   ),
//                 ],
//               ),
//               const SizedBox(height: 24),

//               // خريطة
//               Container(
//                 width: double.infinity,
//                 height: 150,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(12),
//                   color: Colors.grey[200],
//                   border: Border.all(color: const Color(0xFFFFD700), width: 2),
//                 ),
//                 child: Stack(
//                   children: [
//                     Center(
//                       child: Text(
//                         'خريطة الموقع\n(يتم دمجها لاحقاً مع Google Maps)',
//                         textAlign: TextAlign.center,
//                         style: TextStyle(
//                           fontFamily: 'Poppins',
//                           color: Colors.grey[600],
//                         ),
//                       ),
//                     ),
//                     Positioned(
//                       bottom: 8,
//                       right: 8,
//                       child: ElevatedButton.icon(
//                         onPressed: () {},
//                         icon: const Icon(
//                           Icons.directions,
//                           size: 16,
//                           color: Colors.white,
//                         ),
//                         label: const Text(
//                           'الاتجاهات',
//                           style: TextStyle(
//                             fontFamily: 'Poppins',
//                             fontSize: 12,
//                             color: Colors.white,
//                           ),
//                         ),
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: const Color(0xFF8B0000),
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(8),
//                           ),
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(height: 24),

//               // قائمة الطعام
//               const Text(
//                 'القائمة  ',
//                 style: TextStyle(
//                   fontFamily: 'Amiri',
//                   fontSize: 18,
//                   fontWeight: FontWeight.bold,
//                   color: Color(0xFF8B0000),
//                 ),
//               ),
//               const SizedBox(height: 12),
//               _buildMenuItems(),

//               const SizedBox(height: 80), // مساحة لعدم تغطية المحتوى بالأزرار
//             ],
//           ),
//         ),

//         // الأزرار في أسفل الصفحة
//         bottomSheet: Container(
//           padding: const EdgeInsets.all(12),
//           decoration: const BoxDecoration(
//             color: Colors.white,
//             border: Border(top: BorderSide(color: Color(0xFFFFD700), width: 2)),
//           ),
//           child: Row(
//             children: [
//               Expanded(
//                 child: ElevatedButton.icon(
//                   onPressed: () {
//                     // _makePhoneCall('tel:${branch['phone']}');
//                   },
//                   icon: const Icon(
//                     Icons.phone,
//                     size: 18,
//                     color: Color(0xFFFFFFFF),
//                   ),
//                   label: const Text(
//                     'اتصال',
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       color: Color(0xFFFFFFFF),
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF8B0000),
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               Expanded(
//                 child: ElevatedButton.icon(
//                   onPressed: () {
//                     // _sendWhatsApp('963912345678', 'مرحباً، أريد طلب بعض الحلويات من فرع ${branch['name']}');
//                   },
//                   icon: const Icon(
//                     Icons.message,
//                     size: 18,
//                     color: Color(0xFFFFFFFF),
//                   ),
//                   label: const Text(
//                     'واتساب',
//                     style: TextStyle(
//                       fontFamily: 'Poppins',
//                       color: Color(0xFFFFFFFF),
//                       fontWeight: FontWeight.bold,
//                     ),
//                   ),
//                   style: ElevatedButton.styleFrom(
//                     backgroundColor: const Color(0xFF8B0000),
//                     padding: const EdgeInsets.symmetric(vertical: 12),
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(12),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }

//   // قائمة الطعام
//   Widget _buildMenuItems() {
//     final List<Map<String, dynamic>> menu = [
//       {'name': 'معمول بالفستق', 'price': '5,000', 'image': 'images/mamoul.jpg'},
//       {'name': 'بقلاوة', 'price': '4,500', 'image': 'images/mamoul.jpg'},
//       {'name': 'كنافة بالجبنة', 'price': '6,000', 'image': 'images/mamoul.jpg'},
//       {'name': 'سبيكة السحالي', 'price': '7,000', 'image': 'images/mamoul.jpg'},
//     ];

//     return Column(
//       children: menu.map((item) {
//         return Container(
//           margin: const EdgeInsets.symmetric(vertical: 8),
//           decoration: BoxDecoration(
//             color: Colors.white,
//             border: Border.all(color: Color(0xFFFFD700), width: 1.5),
//             borderRadius: BorderRadius.circular(16),
//             boxShadow: [
//               BoxShadow(
//                 color: Colors.black12,
//                 blurRadius: 4,
//                 offset: Offset(0, 2),
//               ),
//             ],
//           ),
//           child: ListTile(
//             contentPadding: const EdgeInsets.symmetric(
//               horizontal: 12,
//               vertical: 8,
//             ),
//             leading: ClipRRect(
//               borderRadius: BorderRadius.circular(12),
//               child: Image.asset(
//                 item['image'],
//                 width: 100,
//                 height: 100,
//                 fit: BoxFit.cover,
//               ),
//             ),
//             title: Text(
//               item['name'],
//               style: const TextStyle(
//                 fontFamily: 'Amiri',
//                 fontSize: 18,
//                 fontWeight: FontWeight.bold,
//                 color: Color(0xFF8B0000),
//               ),
//             ),
//             subtitle: Text(
//               '${item['price']} ل.س',
//               style: const TextStyle(
//                 fontFamily: 'Poppins',
//                 fontSize: 14,
//                 color: Colors.black87,
//               ),
//             ),
//           ),
//         );
//       }).toList(),
//     );
//   }
// }
