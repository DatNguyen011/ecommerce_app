import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app_admin/inner_screen/edit_category.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../inner_screen/edit_prod.dart';
import '../services/global_method.dart';
import '../services/utils.dart';
import 'text_widget.dart';

class CategoryWidget extends StatefulWidget {
  const CategoryWidget({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;
  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  String categoryName = '';
  String? categoryImages;

  @override
  void initState() {
    getCategoryData();
    super.initState();
  }

  Future<void> getCategoryData() async {
    try {
      final DocumentSnapshot bannerDoc = await FirebaseFirestore.instance
          .collection('category')
          .doc(widget.id)
          .get();
      if (bannerDoc == null) {
        return;
      } else {
        // Add if mounted here
        if (mounted) {
          setState(() {
            categoryName = bannerDoc.get('title');
            categoryImages = bannerDoc.get('imageUrl');
          });
        }
      }
    } catch (error) {
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {}
  }

  @override
  Widget build(BuildContext context) {
    Size size = Utils(context).getScreenSize;
    final colorCard = Utils(context).colorCard;
    final color = Utils(context).color;
    return Card(
      elevation: 1,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Material(
          borderRadius: BorderRadius.circular(12),
          color:colorCard,
          child: InkWell(
            borderRadius: BorderRadius.circular(12),
            onTap: () {
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (context) => EditCategoryScreen(
                    id: widget.id,
                    name: categoryName,
                    imageUrl: categoryImages == null
                        ? 'https://yt3.googleusercontent.com/ytc/APkrFKaD8t4oFlgXcZKoW512Z81CBJuej3K9uHAlSI0x=s900-c-k-c0x00ffffff-no-rj'
                        : categoryImages!,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Flexible(
                        flex: 3,
                        child: Image.network(
                          categoryImages == null
                              ? 'https://yt3.googleusercontent.com/ytc/APkrFKaD8t4oFlgXcZKoW512Z81CBJuej3K9uHAlSI0x=s900-c-k-c0x00ffffff-no-rj'
                              : categoryImages!,
                          fit: BoxFit.fill,
                          // width: screenWidth * 0.12,
                          height: size.width * 0.12,
                        ),
                      ),
                      // const Spacer(),

                    ],
                  ),
                  Row(
                    children: [
                      TextWidget(
                        text: categoryName,
                        color: color,
                        textSize: 18,
                      ),
                      PopupMenuButton(
                          itemBuilder: (context) => [
                            // PopupMenuItem(
                            //   onTap: () {},
                            //   child: const Text('Edit'),
                            //   value: 1,
                            // ),
                            PopupMenuItem(
                              onTap: () {
                                deleteCategory(widget.id);
                              },
                              child:  const Text(
                                'Xóa',
                                style: TextStyle(color: Colors.red),
                              ),
                              value: 2,
                            ),
                          ])
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
  void deleteCategory(String id) async {
    try {

      await FirebaseFirestore.instance
          .collection('category')
          .doc(widget.id)
          .delete();

      Fluttertoast.showToast(
        msg: 'Đã xóa danh muc thành công',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        // textColor: Colors.white,
        // fontSize: 16.0,
      );

      setState(() {
        getCategoryData();
      });
    } catch (error) {

      Fluttertoast.showToast(
        msg: 'Xóa danh muc không thành công: $error',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        // fontSize: 16.0,
      );
    }
  }
}