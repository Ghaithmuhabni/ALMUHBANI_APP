import 'package:flutter/material.dart';

class BranchDetailsPage extends StatelessWidget {
  static const String routeName = '/branch-details';

  final Map<String, dynamic> branch;

  const BranchDetailsPage({required this.branch, Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.rtl, // محاذاة النص لليمين
      child: Scaffold(
        backgroundColor: Color(0xFFE8D5B5),
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            branch['name'],
            style: const TextStyle(
              fontFamily: 'Amiri',
              fontSize: 20,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: const Color(0xFF8B0000), // أحمر غامق
          elevation: 0,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
        ),

        body: Container(
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // صورة الفرع
                Container(
                  width: double.infinity,
                  height: 225,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    image: DecorationImage(
                      image: AssetImage(branch['image']),
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
                const SizedBox(height: 16),

                // اسم المدير
                Text(
                  'مدير الفرع: ${branch['manager']}',
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
                        'المنطقة: حمص - ${branch['region']}  ',
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

                // أوقات العمل
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
                const SizedBox(height: 24),

                // خريطة
                Container(
                  width: double.infinity,
                  height: 150,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(12),
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(0xFF8B0000),
                      width: 2,
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        blurRadius: 5,
                        offset: Offset(0, 3),
                      ),
                    ],
                  ),
                  child: Stack(
                    children: [
                      Center(
                        child: Text(
                          'خريطة الموقع\n(يتم دمجها لاحقاً مع Google Maps)',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontFamily: 'Poppins',
                            color: Colors.grey[600],
                          ),
                        ),
                      ),
                      Positioned(
                        bottom: 8,
                        right: 8,
                        child: ElevatedButton.icon(
                          onPressed: () {},
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

                // قائمة الطعام
                const Text(
                  'القائمة',
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFF8B0000),
                  ),
                ),
                const SizedBox(height: 12),
                _buildMenuItems(),

                const SizedBox(height: 80),
              ],
            ),
          ),
        ),

        // الأزرار في أسفل الصفحة
        bottomSheet: Container(
          padding: const EdgeInsets.all(12),
          decoration: const BoxDecoration(
            color: Colors.white,
            border: Border(top: BorderSide(color: Color(0xFF8B0000), width: 2)),
          ),
          child: Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
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
                  onPressed: () {},
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

  // قائمة الطعام
  Widget _buildMenuItems() {
    final List<Map<String, dynamic>> menu = [
      {'name': 'معمول بالفستق', 'price': '5,000', 'image': 'images/mamoul.jpg'},
      {'name': 'بقلاوة', 'price': '4,500', 'image': 'images/mamoul.jpg'},
      {'name': 'كنافة بالجبنة', 'price': '6,000', 'image': 'images/mamoul.jpg'},
      {'name': 'سبيكة السحالي', 'price': '7,000', 'image': 'images/mamoul.jpg'},
    ];

    return Column(
      children: menu.map((item) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: Color(0xFF8B0000), width: 1.5),
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
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
              child: Image.asset(
                item['image'],
                width: 100,
                height: 100,
                fit: BoxFit.cover,
              ),
            ),
            title: Text(
              item['name'],
              style: const TextStyle(
                fontFamily: 'Amiri',
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF8B0000),
              ),
            ),
            subtitle: Text(
              '${item['price']} ل.س',
              style: const TextStyle(
                fontFamily: 'Poppins',
                fontSize: 14,
                color: Colors.black87,
              ),
            ),
          ),
        );
      }).toList(),
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
