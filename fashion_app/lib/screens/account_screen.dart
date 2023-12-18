import 'dart:developer';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app/inner_screens/information.dart';

import 'package:fashion_app/screens/home_screen.dart';
import 'package:fashion_app/screens/viewed_recently/viewed_recently.dart';
import 'package:fashion_app/screens/wishlist/wishlist_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_iconly/flutter_iconly.dart';
import 'package:provider/provider.dart';

import '../consts/colors.dart';
import '../consts/firebase_const.dart';
import '../models/user.dart';
import '../providers/dark_theme_provider.dart';
import '../services/global_methods.dart';
import '../widgets/text_widget.dart';
import 'auth/forget_pass.dart';
import 'auth/login.dart';
import 'btm_bar.dart';
import 'loading_manager.dart';
import 'orders/orders_screen.dart';

class UserScreen extends StatefulWidget {
  const UserScreen({Key? key}) : super(key: key);

  @override
  State<UserScreen> createState() => _UserScreenState();
}

class _UserScreenState extends State<UserScreen> {


  @override
  void dispose() {
    super.dispose();
  }

  String? email;
  String? name;
  String? address;
  String? phone;
  Timestamp? imgUrl;
  bool _isLoading = false;
  final User? user = authInstance.currentUser;
  @override
  void initState() {
    //getUserData();
    super.initState();
  }

  Future<void> getUserData() async {
    setState(() {
      _isLoading = true;
    });
    if (user == null) {
      setState(() {
        _isLoading = false;
      });
      return;
    }
    try {
      String _uid = user!.uid;

      final DocumentSnapshot userDoc =
      await FirebaseFirestore.instance.collection('users').doc(_uid).get();
      if (userDoc == null) {
        return;
      } else {
        email = userDoc.get('email');
        name = userDoc.get('name');
        address = userDoc.get('shipping-address');
        phone=userDoc.get('phone');
        imgUrl=userDoc.get('image');
        print('$imgUrl$phone');
      }
    } catch (error) {
      setState(() {
        _isLoading = false;
      });
      GlobalMethods.errorDialog(subtitle: '$error', context: context);
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final themeState = Provider.of<DarkThemeProvider>(context);
    final Color color = themeState.getDarkTheme ? Colors.white : Colors.black;
    final Color subTitleColor = themeState.getDarkTheme ? Colors.white : AppColor.subTextColor;
    return Scaffold(
        appBar: AppBar(
          automaticallyImplyLeading: false,
          toolbarHeight: 70,
          backgroundColor: AppColor.primaryColor,
          title: const Text(
            'Thông tin',style: TextStyle(
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
                    await Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (ctx) => BottomBarScreen(),
                    ));
                  },
                ),
                const SizedBox(
                  width: 10,
                ),
              ],
            ),
          ],
        ),
        body: LoadingManager(
          isLoading: _isLoading,
          child: Center(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Row(
                      children: [
                        CircleAvatar(
                          radius: 40.0,
                          backgroundColor: Colors.white,
                          backgroundImage: APIs.me.image != null
                              ? NetworkImage(APIs.me.image!)
                              : NetworkImage('https://scontent.fhan15-2.fna.fbcdn.net/v/t39.30808-6/279371357_112990048065141_1845581227208806699_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=efb6e6&_nc_eui2=AeFSrRH1P-X2QkMR7iqAkBBSB6ZsBA9ZOAcHpmwED1k4B2RRjcmMw140_TN-3bdXqOJ72zRDqUSfWQvbO87dETFx&_nc_ohc=hevKyO6z9JgAX_sg2BG&_nc_ht=scontent.fhan15-2.fna&oh=00_AfBy2QlUp-oZayyOI-r6UU9ipx3QTS_aB_3KIKAgVxrnIw&oe=657CEC71'),
                        ),
                        SizedBox(width: 10,),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                  text: APIs.me.name,
                                  style: TextStyle(
                                    color: color,
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                  ),
                                  recognizer: TapGestureRecognizer()
                                    ..onTap = () {

                                    }),
                            ),
                            const SizedBox(
                              height: 5,
                            ),
                            TextWidget(
                              text: APIs.me.email,
                              color: color,
                              textSize: 18,
                              // isTitle: true,
                            ),
                          ],
                        ),

                      ],
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    const Divider(
                      thickness: 1,
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    _listTiles(
                      title: 'Sửa hồ sơ',
                      // subtitle: address,
                      icon: IconlyLight.profile,
                      onPressed: () async {
                        if (user == null) {
                          GlobalMethods.errorDialog(
                              subtitle: 'Vui lòng đăng nhập trước',
                              context: context);
                          return;
                        }
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: ProfileScreen.routeName);
                      },
                      color: color,
                    ),
                    _listTiles(
                      title: 'Đơn đặt hàng',
                      icon: IconlyLight.bag,
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: OrdersScreen.routeName);
                      },
                      color: color,
                    ),
                    _listTiles(
                      title: 'Danh sách yêu thích',
                      icon: IconlyLight.heart,
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context, routeName: WishlistScreen.routeName);
                      },
                      color: color,
                    ),
                    _listTiles(
                      title: 'Lịch sử xem',
                      icon: IconlyLight.show,
                      onPressed: () {
                        GlobalMethods.navigateTo(
                            ctx: context,
                            routeName: ViewedRecentlyScreen.routeName);
                      },
                      color: color,
                    ),
                    _listTiles(
                      title: 'Quên mật khẩu',
                      icon: IconlyLight.unlock,
                      onPressed: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => const ForgetPasswordScreen(),
                          ),
                        );
                      },
                      color: color,
                    ),
                    SwitchListTile(
                      title: TextWidget(
                        text: themeState.getDarkTheme ? 'Chế độ tối' : 'Chế độ sáng',
                        color: color,
                        textSize: 18,
                        // isTitle: true,
                      ),
                      secondary: Icon(themeState.getDarkTheme
                          ? Icons.dark_mode_outlined
                          : Icons.light_mode_outlined),
                      onChanged: (bool value) {
                        setState(() {
                          themeState.setDarkTheme = value;
                        });
                      },
                      value: themeState.getDarkTheme,
                    ),
                    _listTiles(
                      title: user == null ? 'Đăng nhập' : 'Đăng xuất',
                      icon: user == null ? IconlyLight.login : IconlyLight.logout,
                      onPressed: () {
                        if (user == null) {
                          Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => const LoginScreen(),
                            ),
                          );
                          return;
                        }
                        GlobalMethods.warningDialog(
                            title: 'Đăng xuất',
                            subtitle: 'Bạn có muốn đăng xuất không?',
                            fct: () async {
                              await authInstance.signOut();
                              Navigator.of(context).push(
                                MaterialPageRoute(
                                  builder: (context) => const LoginScreen(),
                                ),
                              );
                            },
                            context: context);
                      },
                      color: color,
                    ),
                    // listTileAsRow(),
                  ],
                ),
              ),
            ),
          ),
        ));
  }

  // Future<void> _showAddressDialog() async {
  //   await showDialog(
  //       context: context,
  //       builder: (context) {
  //         return AlertDialog(
  //           title: const Text('Update'),
  //           content: TextField(
  //             // onChanged: (value) {
  //             //   print('_addressTextController.text ${_addressTextController.text}');
  //             // },
  //             controller: _addressTextController,
  //             maxLines: 5,
  //             decoration: const InputDecoration(hintText: "Your address"),
  //           ),
  //           actions: [
  //             TextButton(
  //               onPressed: () async {
  //                 String _uid = user!.uid;
  //                 try {
  //                   await FirebaseFirestore.instance
  //                       .collection('users')
  //                       .doc(_uid)
  //                       .update({
  //                     'shipping-address': _addressTextController.text,
  //                   });
  //
  //                   Navigator.pop(context);
  //                   setState(() {
  //                     address = _addressTextController.text;
  //                   });
  //                 } catch (err) {
  //                   GlobalMethods.errorDialog(
  //                       subtitle: err.toString(), context: context);
  //                 }
  //               },
  //               child: const Text('Update'),
  //             ),
  //           ],
  //         );
  //       });
  // }

  Widget _listTiles({
    required String title,
    String? subtitle,
    required IconData icon,
    required Function onPressed,
    required Color color,
  }) {
    return ListTile(
      title: TextWidget(
        text: title,
        color: color,
        textSize: 22,
        // isTitle: true,
      ),
      subtitle: TextWidget(
        text: subtitle == null ? "" : subtitle,
        color: color,
        textSize: 18,
      ),
      leading: Icon(icon),
      trailing: const Icon(IconlyLight.arrowRight2),
      onTap: () {
        onPressed();
      },
    );
  }

// // Alternative code for the listTile.
//   Widget listTileAsRow() {
//     return Padding(
//       padding: const EdgeInsets.all(8.0),
//       child: Row(
//         children: <Widget>[
//           const Icon(Icons.settings),
//           const SizedBox(width: 10),
//           Column(
//             crossAxisAlignment: CrossAxisAlignment.start,
//             children: const [
//               Text('Title'),
//               Text('Subtitle'),
//             ],
//           ),
//           const Spacer(),
//           const Icon(Icons.chevron_right)
//         ],
//       ),
//     );
//   }
}
class APIs{
  static Future<void> getSelfInfo() async {
    final User? user = authInstance.currentUser;
    if (user == null) {
      await FirebaseFirestore.instance.collection('users').doc('RWphgoBRWTyr5E3taT0e').get().then((user) async {
        if (user.exists) {
          me = Users.fromJson(user.data()!);
          print('My Data: ${user.data()}');
        }});
      print('User is not logged in.');
      return;
    }
    await FirebaseFirestore.instance.collection('users').doc(user!.uid).get().then((user) async {
      if (user.exists) {
        me = Users.fromJson(user.data()!);
        print('My Data: ${user.data()}');
      } else {
        me = Users(image: '', name: '', id: '', email: '', address: '', phone: ''); // Gán giá trị null cho biến me
        print('User data does not exist.');
        // await createUser().then((value) => getSelfInfo());
      }
    });
  }
  static Users me = Users(
    id: user.uid,
    name: user.displayName.toString(),
    email: user.email.toString(),
    image: user.photoURL.toString(),
    //createdAt: '',
    address: '',
    phone: '',);
  static FirebaseAuth auth = FirebaseAuth.instance;
  static User get user => auth.currentUser!;
  static Future<void> updateUserInfo() async {
    await FirebaseFirestore.instance.collection('users').doc(user.uid).update({
      'name': me.name,
      'phone': me.phone,
      'shipping-address': me.address,
      'image': me.image,
    });
  }
  static Future<void> updateProfilePicture(File file) async {
    //getting image file extension
    final ext = file.path.split('.').last;

    //storage file ref with path
    final ref = FirebaseStorage.instance.ref().child('userImages/${user.uid}.$ext');

    //uploading image
    await ref
        .putFile(file, SettableMetadata(contentType: 'image/$ext'))
        .then((p0) {
      log('Data Transferred: ${p0.bytesTransferred / 1000} kb');
    });

    //updating image in firestore database
    me.image = await ref.getDownloadURL();
    await FirebaseFirestore.instance
        .collection('users')
        .doc(user.uid)
        .update({'image': me.image});
  }
}