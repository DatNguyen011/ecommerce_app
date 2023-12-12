import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import '../consts/colors.dart';
import '../services/utils.dart';
import '../widgets/category_widget.dart';
import '../widgets/text_widget.dart';

class CategoriesScreen extends StatelessWidget {
  CategoriesScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final utils = Utils(context);
    Color color = utils.color;

    return Scaffold(
      appBar: AppBar(
        toolbarHeight: 70,
        backgroundColor: AppColor.primaryColor,
        title: const Text(
          'Danh mục',style: TextStyle(
            color: Colors.white
        ),
        ),
        elevation: 1,
        actions: [
          Row(
            children: [
              IconButton(
                icon: Icon(IconlyLight.home),color: Colors.white,
                onPressed: () async {
                  // await Navigator.of(context).pushReplacement(MaterialPageRoute(
                  //   builder: (ctx) => FeedsScreen(),
                  // ));
                },
              ),
              const SizedBox(
                width: 10,
              ),
            ],
          ),
        ],
      ),
      body: StreamBuilder<QuerySnapshot>(
        stream: FirebaseFirestore.instance.collection('category').snapshots(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return CircularProgressIndicator();
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            List<Map<String, dynamic>> catInfo = snapshot.data!.docs.map((document) {
              return {
                'imgPath': document['imageUrl'],
                'catText': document['title'],
              };
            }).toList();

            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: GridView.count(
                crossAxisCount: 2,
                childAspectRatio: 240 / 250,
                crossAxisSpacing: 10,
                mainAxisSpacing: 10,
                children: List.generate(catInfo.length, (index) {
                  return CategoriesWidget(
                    catText: catInfo[index]['catText'],
                    imgPath: catInfo[index]['imgPath'],
                    passedColor: AppColor.primaryColor,
                  );
                }),
              ),
            );
          }
        },
      ),
    );
  }
}
