import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';


import '../services/utils.dart';
import 'text_widget.dart';

class UserWidget extends StatefulWidget {
  const UserWidget(
      {Key? key,
        required this.imageUrl, required this.name, required this.email, required this.address,required this.userId
      })
      : super(key: key);
  final String name, email, imageUrl, address, userId;
  @override
  _UserWidgetState createState() => _UserWidgetState();
}

class _UserWidgetState extends State<UserWidget> {
  late String orderDateStr;
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    Color color = theme == true ? Colors.white : Colors.black;
    Size size = Utils(context).getScreenSize;
    final colorCard = Utils(context).colorCard;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Material(
        borderRadius: BorderRadius.circular(8.0),
        color: colorCard,
        child: Padding(
          padding: const EdgeInsets.all(0.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Flexible(
                flex: size.width < 650 ? 3 : 1,
                child: Image.network(
                  widget.imageUrl,
                  fit: BoxFit.fitWidth,
                  height: size.height * 0.15,
                  width: size.width * 0.15,
                ),
              ),
              const SizedBox(
                width: 12,
              ),
              Expanded(
                flex: 10,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextWidget(
                      text:
                      'Tên Đăng Nhập: ${widget.name}',
                      color: color,
                      textSize: 16,
                      isTitle: true,
                    ),
                    TextWidget(
                      text:
                      'Email: ${widget.email}',
                      color: color,
                      textSize: 16,
                      isTitle: true,
                    ),
                    TextWidget(
                      text:
                      'Địa chỉ: ${widget.name}',
                      color: color,
                      textSize: 16,
                      isTitle: true,
                    ),
                    //Spacer(),
                    //IconButton(onPressed: (){}, icon: Icon(Icons.more_horiz))
                  ],
                ),
              ),
              Spacer(),
              IconButton(onPressed: (){
                showDeleteConfirmationDialog(context);
              }, icon: Icon(Icons.delete, color: Colors.red,))
              // PopupMenuButton(
              //     itemBuilder: (context) => [
              //       PopupMenuItem(
              //         onTap: () {
              //           showDeleteConfirmationDialog(context);
              //         },
              //         child: Text(
              //           'Delete',
              //           style: TextStyle(color: Colors.red),
              //         ),
              //         value: 1,
              //       ),
              //     ]),
            ],
          ),
        ),
      ),
    );
  }
  Future<void> showDeleteConfirmationDialog(BuildContext context) async {
    return showDialog<void>(
      context: context,
      builder: (_) {
        return AlertDialog(
          title: Text('Xác Nhận Xóa'),
          content: Text('Bạn có chắc chắn muốn xóa không?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Đóng hộp thoại
              },
              child: Text('Hủy'),
            ),
            TextButton(
              onPressed: () {
                deleteUser();
                // Đóng hộp thoại
                Navigator.of(context).pop();
              },
              child: Text('Xác Nhận'),
            ),
          ],
        );
      },
    );
  }
  void deleteUser() async {
    try {
      // Thực hiện xóa dữ liệu từ Firestore hoặc nơi lưu trữ dữ liệu
      await FirebaseFirestore.instance
          .collection('users')
          .doc(widget.userId)
          .delete();

      Fluttertoast.showToast(
        msg: 'Đã xóa user thành công',
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        // textColor: Colors.white,
        // fontSize: 16.0,
      );

      // setState(() {
      //   getProductsData();
      // });
    } catch (error) {

      Fluttertoast.showToast(
        msg: 'Xóa user không thành công: $error',
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