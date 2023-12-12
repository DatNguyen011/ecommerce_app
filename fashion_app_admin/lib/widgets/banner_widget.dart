import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../inner_screen/edit_prod.dart';
import '../services/global_method.dart';
import '../services/utils.dart';
import 'text_widget.dart';

class BannerWidget extends StatefulWidget {
  const BannerWidget({
    Key? key,
    required this.id,
  }) : super(key: key);
  final String id;
  @override
  _BannerWidgetState createState() => _BannerWidgetState();
}

class _BannerWidgetState extends State<BannerWidget> {
  String bannerName = '';
  String? bannerImages;

  @override
  void initState() {
    getBannerData();
    super.initState();
  }

  Future<void> getBannerData() async {
    try {
      final DocumentSnapshot bannerDoc = await FirebaseFirestore.instance
          .collection('banners')
          .doc(widget.id)
          .get();
      if (bannerDoc == null) {
        return;
      } else {
        // Add if mounted here
        if (mounted) {
          setState(() {
            bannerName = bannerDoc.get('title');
            bannerImages = bannerDoc.get('imageUrl');
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
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        elevation: 1,
        borderRadius: BorderRadius.circular(12),
        color: colorCard,
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
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
                        bannerImages == null
                            ? 'https://yt3.googleusercontent.com/ytc/APkrFKaD8t4oFlgXcZKoW512Z81CBJuej3K9uHAlSI0x=s900-c-k-c0x00ffffff-no-rj'
                            : bannerImages!,
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
                      text: bannerName,
                      color: color,
                      textSize: 18,
                    ),
                    PopupMenuButton(
                        itemBuilder: (context) => [
                          PopupMenuItem(
                            onTap: () {
                              deleteBanner(widget.id);
                            },
                            value: 2,
                            child:  const Text(
                              'Xóa',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ])
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void deleteBanner(String id) async {
    try {
      // Thực hiện xóa dữ liệu từ Firestore hoặc nơi lưu trữ dữ liệu
      await FirebaseFirestore.instance
          .collection('banners')
          .doc(widget.id)
          .delete();

      Fluttertoast.showToast(
        msg: 'Đã banner phẩm thành công',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        // textColor: Colors.white,
        // fontSize: 16.0,
      );

      setState(() {
        //getProductsData();
      });
    } catch (error) {

      Fluttertoast.showToast(
        msg: 'Xóa banner không thành công: $error',
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