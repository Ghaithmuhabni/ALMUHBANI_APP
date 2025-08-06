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

class BranchesPage extends StatefulWidget {
  const BranchesPage({Key? key}) : super(key: key);

  @override
  State<BranchesPage> createState() => _BranchesPageState();
}

class _BranchesPageState extends State<BranchesPage> {
  final List<Branch> branches = [
    Branch(
      name: "فرع الغوطة",
      manager: "ابو بسام",
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
      manager: "ابو بسام",
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

  // قائمة مؤقتة تعرض النتائج بعد التصفية
  late List<Branch> _filteredBranches;

  @override
  void initState() {
    super.initState();
    _filteredBranches = branches; // في البداية، اعرض كل الفروع
  }

  // دالة لتصفية الفروع حسب اسم الفرع أو المدير
  void _filterBranches(String query) {
    setState(() {
      if (query.isEmpty) {
        _filteredBranches = branches;
      } else {
        _filteredBranches = branches.where((branch) {
          return branch.name.contains(query) || branch.manager.contains(query);
        }).toList();
      }
    });
  }

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

          // شريط البحث
          Directionality(
            textDirection: TextDirection.rtl, // محاذاة النص لليمين
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFFFFD700), width: 2),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 6,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: TextField(
                  style: TextStyle(color: Colors.black),
                  decoration: InputDecoration(
                    hintText: 'ابحث عن فرع أو مدير...',
                    hintStyle: TextStyle(color: Colors.grey[900]),
                    prefixIcon: Icon(Icons.search, color: Color(0xFFFFD700)),
                    border: InputBorder.none,
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 14,
                    ),
                  ),
                  onChanged: (value) {
                    _filterBranches(value);
                  },
                ),
              ),
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
              child: _filteredBranches.isEmpty
                  ? Center(
                      child: Text(
                        'لا يوجد فروع مطابقة',
                        style: TextStyle(
                          fontFamily: 'Amiri',
                          fontSize: 18,
                          color: Colors.grey[700],
                        ),
                      ),
                    )
                  : ListView.builder(
                      padding: const EdgeInsets.all(12),
                      itemCount: _filteredBranches.length,
                      itemBuilder: (context, index) {
                        final branch = _filteredBranches[index];
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
                            height: 120,
                            decoration: BoxDecoration(
                              color: const Color(0xFF8B0000),
                              borderRadius: BorderRadius.circular(10),
                              border: Border.all(
                                color: const Color(0xFFFFD700),
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
                                    crossAxisAlignment: CrossAxisAlignment.end,
                                    children: [
                                      Text(
                                        branch.name,
                                        style: const TextStyle(
                                          color: Color(0xFFFFD700),
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      Text(
                                        branch.manager,
                                        style: const TextStyle(
                                          color: Color(0xFFFFD700),
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
