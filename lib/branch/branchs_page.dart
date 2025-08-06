import 'package:flutter/material.dart';
import 'branch_details.dart';

class Branch {
  final String name;
  final String manager;
  final String imageUrl;
  final String region;
  final String phone;

  Branch({
    required this.name,
    required this.manager,
    required this.imageUrl,
    required this.region,
    required this.phone,
  });
}

class BranchesPage extends StatelessWidget {
  BranchesPage({Key? key}) : super(key: key);
  final List<Branch> branches = [
    Branch(
      name: "فرع الغوطة",
      manager: "أبو بسام",
      imageUrl: "images/logo.jpg",
      region: "الغوطة جانب رينبو الغوطة",
      phone: "0934567890",
    ),
    Branch(
      name: "فرع الحمرا",
      manager: "انس ابو احمد",
      imageUrl: "images/logo.jpg",
      region: "الحمرا جانب الملعب البلدي",
      phone: "0934567891",
    ),
    Branch(
      name: "فرع تركيا كوجالي",
      manager: "كريم ",
      imageUrl: "images/logo.jpg",
      region: "تركيا كوجالي",
      phone: "0934567893",
    ),
    Branch(
      name: "فرع الانشاءات",
      manager: "بلال",
      imageUrl: "images/logo.jpg",
      region: "الانشاءات",
      phone: "0934567892",
    ),
    Branch(
      name: "فرع الغوطة",
      manager: "أبو بسام",
      imageUrl: "images/logo.jpg",
      region: "الغوطة جانب رينبو الغوطة",
      phone: "0934567890",
    ),
    Branch(
      name: "فرع الحمرا",
      manager: "انس ابو احمد",
      imageUrl: "images/logo.jpg",
      region: "الحمرا جانب الملعب البلدي",
      phone: "0934567891",
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF8B0000), // خلفية الصفحة أحمر داكن
      body: Column(
        children: [
          // الشعار الكبير
          Padding(
            padding: const EdgeInsets.only(top: 40, bottom: 20),
            child: Image.asset(
              'images/logo.jpg',
              height: 200,
              fit: BoxFit.contain,
            ),
          ),

          // القائمة
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color: Color(0xFFF5E4C3), // الخلفية البيج
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(25),
                  topRight: Radius.circular(25),
                ),
              ),
              child: ListView.builder(
                padding: const EdgeInsets.all(12),
                itemCount: branches.length,
                itemBuilder: (context, index) {
                  final branch = branches[index];
                  return GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (_) => BranchDetailsPage(
                            branch: {
                              'name': branch.name,
                              'manager': branch.manager,
                              'image': branch.imageUrl,
                              'region': branch.region,
                              'phone': branch.phone,
                            },
                          ),
                        ),
                      );
                    },
                    child: Container(
                      margin: const EdgeInsets.only(bottom: 12),
                      padding: const EdgeInsets.all(12),
                      height: 120, // جعل الكرت أكبر
                      decoration: BoxDecoration(
                        color: const Color(0xFF8B0000),
                        borderRadius: BorderRadius.circular(10),
                        border: Border.all(
                          color: const Color(0xFFFFD700), // إطار ذهبي
                          width: 2,
                        ),
                      ),
                      child: Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // صورة الشعار
                          ClipRRect(
                            borderRadius: BorderRadius.circular(8),
                            child: Image.asset(
                              branch.imageUrl,
                              width: 95,
                              height: 95,
                              fit: BoxFit.cover,
                            ),
                          ),
                          const SizedBox(width: 12),

                          // النصوص على اليمين
                          Expanded(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment:
                                  CrossAxisAlignment.end, // محاذاة لليمين
                              children: [
                                Text(
                                  branch.name,
                                  style: const TextStyle(
                                    color: Color(0xFFFFD700), // ذهبي
                                    fontSize: 20,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                Text(
                                  branch.manager,
                                  style: const TextStyle(
                                    color: Color(0xFFFFD700), // ذهبي
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}
