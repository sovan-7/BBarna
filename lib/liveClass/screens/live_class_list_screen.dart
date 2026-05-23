import 'package:b_barna_app/core/route/route_name.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';

import 'package:b_barna_app/liveClass/models/live_class_model.dart';

class LiveClassListScreen extends StatefulWidget {
  const LiveClassListScreen({super.key});

  @override
  State<LiveClassListScreen> createState() =>
      _LiveClassListScreenState();
}

class _LiveClassListScreenState
    extends State<LiveClassListScreen> {

  Future<List<LiveClassModel>> getAllClasses() async {
    try {
      QuerySnapshot<Map<String, dynamic>> snapshot =
      await FirebaseFirestore.instance
          .collection('live_classes')
          .get();

      print("Total Docs: ${snapshot.docs.length}");

      return snapshot.docs
          .map(
            (docSnapshot) => LiveClassModel.fromMap(
          docSnapshot.data(),
        ),
      )
          .toList();
    } catch (e) {
      print("Firestore Error: $e");
      return [];
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          'Live Classes',
        ),
      ),
      body: FutureBuilder<List<LiveClassModel>>(
        future: getAllClasses(),
        builder: (_, snapshot) {

          if (snapshot.connectionState ==
              ConnectionState.waiting) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }

          if (snapshot.hasError) {
            return Center(
              child: Text(
                snapshot.error.toString(),
              ),
            );
          }

          final list = snapshot.data ?? [];

          if (list.isEmpty) {
            return const Center(
              child: Text(
                'No Classes Found',
              ),
            );
          }

          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (_, index) {
              final item = list[index];

              return Card(
                margin: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                elevation: 3,
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    /// Thumbnail
                    ClipRRect(
                      borderRadius:
                      const BorderRadius.vertical(
                        top: Radius.circular(12),
                      ),
                      child: Image.network(
                        "https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcSHkz-CtfvMGgRgdHNQsxEMfsV37rycmXyYn4jbyBlVnEZZ-edxrgDlTl1Rbfo6teEkc2zsRuzlDUSc71RWUp5JtoegBcvnZPuUMwRmkDw&s=10",
                       // item.thumbnail,
                        width: double.infinity,
                        height: 200,
                        fit: BoxFit.cover,
                      ),
                    ),

                    Padding(
                      padding: const EdgeInsets.all(12),
                      child: Column(
                        crossAxisAlignment:
                        CrossAxisAlignment.start,
                        children: [

                          /// Title
                          Text(
                            item.title,
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight:
                              FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// Teacher
                          Text(
                            "Teacher: ${item.teacherName}",
                            style: const TextStyle(
                              fontSize: 15,
                            ),
                          ),

                          const SizedBox(height: 8),

                          /// Time
                          Text(
                            "Start Time: ${item.startTime}",
                            style: TextStyle(color: Colors.black),
                          ),

                          Text(
                            "End Time: ${item.endTime}",
                            style: TextStyle(color: Colors.black),
                          ),

                          const SizedBox(height: 12),

                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
Navigator.pushNamed(context, RouteName.liveClassRoute,arguments: {
  "liveClass":item
});


                              },
                              child: const Text(
                                "Join Class",
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            },
          );
        },
      ),
    );
  }
}