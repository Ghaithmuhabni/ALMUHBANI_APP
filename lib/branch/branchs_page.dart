//branchs_page.dart
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'branch_details.dart';
import '../auth/login_page.dart';

class BranchesPage extends StatelessWidget {
  BranchesPage({Key? key}) : super(key: key);

  final user = FirebaseAuth.instance.currentUser;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFE8D5B5),
      body: Column(
        children: [
          // الشعار
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            child: GestureDetector(
              onLongPress: () {
                // فقط إذا لم يكن مسجل دخول → يروح على صفحة تسجيل الدخول
                if (FirebaseAuth.instance.currentUser == null) {
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => const LoginPage()),
                  );
                }
              },
              child: Image.asset(
                'images/logo1.png',
                height: 200,
                fit: BoxFit.fitHeight,
              ),
            ),
          ),

          // عنوان الفروع + زر تسجيل الخروج (للأدمن فقط)
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                // إذا المستخدم مسجل دخول (أدمن) → إظهر زر تسجيل الخروج
                if (user != null)
                  IconButton(
                    icon: const Icon(
                      Icons.logout,
                      color: Color(0xFF8B0000),
                      size: 28,
                    ),
                    onPressed: () async {
                      await FirebaseAuth.instance.signOut();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (_) => const LoginPage()),
                      );
                    },
                  ),
                const SizedBox(width: 140),
                Text(
                  "الفروع المتاحة",
                  style: TextStyle(
                    fontFamily: 'Amiri',
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF8B0000),
                    shadows: [
                      Shadow(
                        blurRadius: 2,
                        color: Colors.black.withOpacity(0.1),
                        offset: const Offset(1, 1),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                const Icon(
                  Icons.location_on,
                  color: Color(0xFF8B0000),
                  size: 28,
                ),
              ],
            ),
          ),

          // قائمة الفروع
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFF8B0000),
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(15),
                  topRight: Radius.circular(15),
                ),
              ),
              child: StreamBuilder<QuerySnapshot>(
                stream: FirebaseFirestore.instance
                    .collection('branches')
                    .snapshots(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (!snapshot.hasData || snapshot.data!.docs.isEmpty) {
                    return const Center(
                      child: Text(
                        'لا توجد فروع',
                        style: TextStyle(color: Colors.white, fontSize: 18),
                      ),
                    );
                  }

                  final branches = snapshot.data!.docs;

                  return ListView.builder(
                    padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
                    itemCount: branches.length,
                    itemBuilder: (context, index) {
                      final branch = branches[index];
                      final data = branch.data() as Map<String, dynamic>;

                      return _buildBranchCard(data, context);
                    },
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBranchCard(Map<String, dynamic> data, BuildContext context) {
    return Card(
      elevation: 2,
      margin: const EdgeInsets.only(bottom: 16),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
        side: const BorderSide(color: Color.fromARGB(255, 0, 0, 0), width: 2.5),
      ),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => BranchDetailsPage(
                branch: {
                  'id': data["id"],
                  'name': data['name'] ?? '',
                  'manager': data['manager'] ?? '',
                  'region': data['region'] ?? '',
                  'phone': data['phone'] ?? '',
                  'linelnad_phone': data['linelnad_phone'] ?? '',
                },
              ),
            ),
          );
        },
        borderRadius: BorderRadius.circular(15),
        child: Container(
          padding: const EdgeInsets.all(12),
          height: 150,
          decoration: BoxDecoration(
            color: const Color(0xFFE8D5B5),
            borderRadius: BorderRadius.circular(15),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // صورة الفرع
              Container(
                width: 110,
                height: 110,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Image.asset('images/logo1.png', fit: BoxFit.cover),
                ),
              ),
              const SizedBox(width: 16),
              // معلومات الفرع
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      data['name'] ?? '',
                      style: const TextStyle(
                        color: Color(0xFF8B0000),
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Amiri',
                      ),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Text(
                      "بإدارة : ${data['manager'] ?? ''}",
                      style: const TextStyle(
                        color: Color(0xFF8B0000),
                        fontSize: 18,
                        fontFamily: 'Amiri',
                      ),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Text(
                      data['region'] ?? '',
                      style: TextStyle(
                        color: const Color(0xFF8B0000).withOpacity(0.8),
                        fontSize: 16,
                        fontFamily: 'Amiri',
                      ),
                      textAlign: TextAlign.right,
                      overflow: TextOverflow.ellipsis,
                      maxLines: 2,
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              const Icon(
                Icons.arrow_forward_ios,
                color: Color(0xFF8B0000),
                size: 20,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Old Design Code
// import 'package:flutter/material.dart';
// import 'branch_details.dart';

// class Branch {
//   final String name;
//   final String manager;
//   final String imageUrl;
//   final String region;
//   final String phone;

//   Branch({
//     required this.name,
//     required this.manager,
//     required this.imageUrl,
//     required this.region,
//     required this.phone,
//   });
// }

// class BranchesPage extends StatefulWidget {
//   const BranchesPage({Key? key}) : super(key: key);

//   @override
//   State<BranchesPage> createState() => _BranchesPageState();
// }

// class _BranchesPageState extends State<BranchesPage> {
//   final List<Branch> branches = [
//     Branch(
//       name: "فرع الغوطة",
//       manager: "ابو بسام",
//       imageUrl: "images/logo.png",
//       region: "الغوطة جانب رينبو الغوطة",
//       phone: "0934567890",
//     ),
//     Branch(
//       name: "فرع الحمرا",
//       manager: "انس ابو احمد",
//       imageUrl: "images/logo.png",
//       region: "الحمرا جانب الملعب البلدي",
//       phone: "0934567891",
//     ),
//     Branch(
//       name: "فرع تركيا كوجالي",
//       manager: "كريم ",
//       imageUrl: "images/logo.png",
//       region: "تركيا كوجالي",
//       phone: "0934567893",
//     ),
//     Branch(
//       name: "فرع الانشاءات",
//       manager: "بلال",
//       imageUrl: "images/logo.png",
//       region: "الانشاءات",
//       phone: "0934567892",
//     ),
//     Branch(
//       name: "فرع الغوطة",
//       manager: "ابو بسام",
//       imageUrl: "images/logo.png",
//       region: "الغوطة جانب رينبو الغوطة",
//       phone: "0934567890",
//     ),
//     Branch(
//       name: "فرع الحمرا",
//       manager: "انس ابو احمد",
//       imageUrl: "images/logo.png",
//       region: "الحمرا جانب الملعب البلدي",
//       phone: "0934567891",
//     ),
//   ];

//   late List<Branch> _filteredBranches;
//   final TextEditingController _searchController = TextEditingController();

//   @override
//   void initState() {
//     super.initState();
//     _filteredBranches = branches;
//   }

//   void _filterBranches(String query) {
//     setState(() {
//       if (query.isEmpty) {
//         _filteredBranches = branches;
//       } else {
//         _filteredBranches = branches.where((branch) {
//           return branch.name.contains(query) || branch.manager.contains(query);
//         }).toList();
//       }
//     });
//   }

//   @override
//   void dispose() {
//     _searchController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: const Color(0xFF8B0000),
//       body: Column(
//         children: [
//           // الشعار
//           Padding(
//             padding: const EdgeInsets.only(top: 40, bottom: 20),
//             child: Image.asset(
//               'images/logo.png',
//               height: 150,
//               fit: BoxFit.contain,
//             ),
//           ),

//           // شريط البحث
//           Directionality(
//             textDirection: TextDirection.rtl,
//             child: Padding(
//               padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
//               child: Container(
//                 decoration: BoxDecoration(
//                   color: Colors.white,
//                   borderRadius: BorderRadius.circular(30),
//                   border: Border.all(color: const Color(0xFFFFD700), width: 2),
//                   boxShadow: [
//                     BoxShadow(
//                       color: Colors.black.withOpacity(0.1),
//                       blurRadius: 8,
//                       offset: const Offset(0, 3),
//                     ),
//                   ],
//                 ),
//                 child: TextField(
//                   controller: _searchController,
//                   style: const TextStyle(
//                     color: Colors.black87,
//                     fontFamily: 'Amiri',
//                   ),
//                   decoration: InputDecoration(
//                     hintText: 'ابحث عن فرع أو مدير...',
//                     hintStyle: TextStyle(
//                       color: Colors.grey[700],
//                       fontFamily: 'Amiri',
//                     ),
//                     prefixIcon: const Icon(
//                       Icons.search,
//                       color: Color(0xFFFFD700),
//                       size: 28,
//                     ),
//                     border: InputBorder.none,
//                     contentPadding: const EdgeInsets.symmetric(
//                       horizontal: 20,
//                       vertical: 16,
//                     ),
//                     suffixIcon: _searchController.text.isNotEmpty
//                         ? IconButton(
//                             icon: const Icon(Icons.clear, color: Colors.grey),
//                             onPressed: () {
//                               _searchController.clear();
//                               _filterBranches('');
//                             },
//                           )
//                         : null,
//                   ),
//                   onChanged: _filterBranches,
//                 ),
//               ),
//             ),
//           ),

//           // عنوان الفروع
//           Padding(
//             padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 25),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 Text(
//                   "الفروع المتاحة",
//                   style: TextStyle(
//                     fontFamily: 'Amiri',
//                     fontSize: 22,
//                     fontWeight: FontWeight.bold,
//                     color: const Color(0xFFFFD700),
//                     shadows: [
//                       Shadow(
//                         blurRadius: 2,
//                         color: Colors.black.withOpacity(0.3),
//                         offset: const Offset(1, 1),
//                       ),
//                     ],
//                   ),
//                 ),
//                 const SizedBox(width: 8),
//                 const Icon(
//                   Icons.location_on,
//                   color: Color(0xFFFFD700),
//                   size: 28,
//                 ),
//               ],
//             ),
//           ),

//           // قائمة الفروع
//           Expanded(
//             child: Container(
//               decoration: const BoxDecoration(
//                 color: Color(0xFFF5E4C3),
//                 borderRadius: BorderRadius.only(
//                   topLeft: Radius.circular(30),
//                   topRight: Radius.circular(30),
//                 ),
//               ),
//               child: _filteredBranches.isEmpty
//                   ? Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           Icon(
//                             Icons.search_off,
//                             size: 60,
//                             color: Colors.grey[600],
//                           ),
//                           const SizedBox(height: 16),
//                           Text(
//                             'لا يوجد فروع مطابقة',
//                             style: TextStyle(
//                               fontFamily: 'Amiri',
//                               fontSize: 20,
//                               color: Colors.grey[700],
//                             ),
//                           ),
//                         ],
//                       ),
//                     )
//                   : ListView.builder(
//                       padding: const EdgeInsets.fromLTRB(16, 20, 16, 16),
//                       itemCount: _filteredBranches.length,
//                       itemBuilder: (context, index) {
//                         final branch = _filteredBranches[index];
//                         return _buildBranchCard(branch, context);
//                       },
//                     ),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBranchCard(Branch branch, BuildContext context) {
//     return Card(
//       elevation: 4,
//       margin: const EdgeInsets.only(bottom: 16),
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(15),
//         side: const BorderSide(color: Color(0xFFFFD700), width: 1.5),
//       ),
//       child: InkWell(
//         onTap: () {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//               builder: (_) => BranchDetailsPage(
//                 branch: {
//                   'name': branch.name,
//                   'manager': branch.manager,
//                   'image': branch.imageUrl,
//                   'region': branch.region,
//                   'phone': branch.phone,
//                 },
//               ),
//             ),
//           );
//         },
//         borderRadius: BorderRadius.circular(15),
//         child: Container(
//           padding: const EdgeInsets.all(12),
//           height: 120,
//           decoration: BoxDecoration(
//             color: const Color(0xFF8B0000),
//             borderRadius: BorderRadius.circular(15),
//             gradient: const LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: [Color(0xFF8B0000), Color(0xFFA52A2A)],
//             ),
//           ),
//           child: Row(
//             crossAxisAlignment: CrossAxisAlignment.center,
//             children: [
//               // صورة الشعار
//               Container(
//                 width: 95,
//                 height: 95,
//                 decoration: BoxDecoration(
//                   borderRadius: BorderRadius.circular(10),
//                   border: Border.all(color: const Color(0xFFFFD700), width: 2),
//                 ),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(8),
//                   child: Image.asset(
//                     branch.imageUrl,
//                     fit: BoxFit.cover,
//                     errorBuilder: (context, error, stackTrace) {
//                       return Container(
//                         color: Colors.grey[300],
//                         child: const Icon(
//                           Icons.business,
//                           color: Colors.grey,
//                           size: 40,
//                         ),
//                       );
//                     },
//                   ),
//                 ),
//               ),
//               const SizedBox(width: 16),
//               // معلومات الفرع
//               Expanded(
//                 child: Column(
//                   mainAxisAlignment: MainAxisAlignment.center,
//                   crossAxisAlignment: CrossAxisAlignment.end,
//                   children: [
//                     Text(
//                       branch.name,
//                       style: const TextStyle(
//                         color: Color(0xFFFFD700),
//                         fontSize: 20,
//                         fontWeight: FontWeight.bold,
//                         fontFamily: 'Amiri',
//                       ),
//                       textAlign: TextAlign.right,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 6),
//                     Text(
//                       "مدير الفرع: ${branch.manager}",
//                       style: const TextStyle(
//                         color: Colors.white,
//                         fontSize: 16,
//                         fontFamily: 'Amiri',
//                       ),
//                       textAlign: TextAlign.right,
//                       overflow: TextOverflow.ellipsis,
//                     ),
//                     const SizedBox(height: 4),
//                     Text(
//                       branch.region,
//                       style: TextStyle(
//                         color: Colors.white.withOpacity(0.9),
//                         fontSize: 14,
//                         fontFamily: 'Amiri',
//                       ),
//                       textAlign: TextAlign.right,
//                       overflow: TextOverflow.ellipsis,
//                       maxLines: 1,
//                     ),
//                   ],
//                 ),
//               ),
//               const SizedBox(width: 8),
//               // أيقونة الانتقال للتفاصيل
//               const Icon(
//                 Icons.arrow_forward_ios,
//                 color: Color(0xFFFFD700),
//                 size: 20,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
