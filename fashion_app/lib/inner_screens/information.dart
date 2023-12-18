import 'dart:developer';
import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app/screens/account_screen.dart';
import 'package:fashion_app/widgets/back_widget.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';

import '../consts/colors.dart';
import '../models/user.dart';
import '../services/utils.dart';

class ProfileScreen extends StatefulWidget {
  static const routeName = '/ProfileScreen';
  Users user;

  ProfileScreen({super.key, required this.user});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  String? _image;

  @override
  Widget build(BuildContext context) {
    final Utils utils = Utils(context);
    Size mq = utils.getScreenSize;
    void _showBottomSheet() {
      showModalBottomSheet(
          context: context,
          shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20), topRight: Radius.circular(20))),
          builder: (_) {
            return ListView(
              shrinkWrap: true,
              padding: EdgeInsets.only(
                  top: mq.height * .03, bottom: mq.height * .05),
              children: [
                //pick profile picture label
                const Text('Chọn ảnh hồ sơ',
                    textAlign: TextAlign.center,
                    style:
                        TextStyle(fontSize: 20, fontWeight: FontWeight.w500)),

                //for adding some space
                SizedBox(height: mq.height * .02),

                //buttons
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    //pick from gallery button
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            fixedSize: Size(mq.width * .3, mq.height * .15)),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();

                          // Pick an image
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.gallery, imageQuality: 80);
                          if (image != null) {
                            setState(() {
                              _image = image.path;
                            });

                            APIs.updateProfilePicture(File(_image!));

                            Navigator.pop(context);
                          }
                        },
                        child: Image.network(
                            'https://play-lh.googleusercontent.com/rPJjfIPXYy_XrZfTuofKfCJH54SRtjzU-eOYAXv-geSm-0hv1csnpBeEtztSHycYFlU')),
                    //take picture from camera button
                    ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            fixedSize: Size(mq.width * .3, mq.height * .15)),
                        onPressed: () async {
                          final ImagePicker picker = ImagePicker();

                          // Pick an image
                          final XFile? image = await picker.pickImage(
                              source: ImageSource.camera, imageQuality: 80);
                          if (image != null) {
                            setState(() {
                              _image = image.path;
                            });

                            APIs.updateProfilePicture(File(_image!));
                            // for hiding bottom sheet
                            Navigator.pop(context);
                          }
                        },
                        child: Image.network(
                            'https://cdn-icons-png.flaticon.com/512/883/883746.png')),
                  ],
                )
              ],
            );
          });
    }

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: Scaffold(
          appBar: AppBar(
            title: const Text(
              'Thông tin người dùng',
              style: TextStyle(color: Colors.white),
            ),
            backgroundColor: AppColor.primaryColor,
            leading: const BackWidget(),
          ),
          //body
          body: Form(
            key: _formKey,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: mq.width * .05),
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    // for adding some space
                    SizedBox(width: mq.width, height: mq.height * .03),

                    //user profile picture
                    Stack(
                      children: [
                        //profile picture
                        _image != null
                            ?

                            //local image
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: Image.file(File(_image!),
                                    width: mq.height * .2,
                                    height: mq.height * .2,
                                    fit: BoxFit.cover))
                            :

                            //image from server
                            ClipRRect(
                                borderRadius:
                                    BorderRadius.circular(mq.height * .1),
                                child: CachedNetworkImage(
                                  width: mq.height * .2,
                                  height: mq.height * .2,
                                  fit: BoxFit.cover,
                                  imageUrl: widget.user.image,
                                  errorWidget: (context, url, error) =>
                                      const CircleAvatar(
                                          child: Icon(CupertinoIcons.person)),
                                ),
                              ),

                        //edit image button
                        Positioned(
                          bottom: 0,
                          right: 0,
                          child: MaterialButton(
                            elevation: 1,
                            onPressed: () {
                              _showBottomSheet();
                            },
                            shape: const CircleBorder(),
                            color: Colors.white,
                            child: const Icon(Icons.edit,
                                color: AppColor.primaryColor),
                          ),
                        )
                      ],
                    ),

                    // for adding some space
                    SizedBox(height: mq.height * .03),

                    // user email label
                    Text(widget.user.email,
                        style: const TextStyle(
                            color: Colors.black54, fontSize: 16)),

                    // for adding some space
                    SizedBox(height: mq.height * .05),

                    // name input field
                    TextFormField(
                      initialValue: widget.user.name,
                      onSaved: (val) => APIs.me.name = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Vui lòng nhập đủ',
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.person,
                              color: AppColor.primaryColor),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'vd. Nguyễn Văn A',
                          label: const Text('Tên')),
                    ),

                    // for adding some space
                    SizedBox(height: mq.height * .02),
                    TextFormField(
                      initialValue: widget.user.phone,
                      onSaved: (val) => APIs.me.phone = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Vui lòng nhập đủ',
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.phone,
                              color: AppColor.primaryColor),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText: 'vd. 0123456789',
                          label: const Text('Sđt')),
                    ),
                    SizedBox(height: mq.height * .02),
                    TextFormField(
                      initialValue: widget.user.address,
                      onSaved: (val) => APIs.me.address = val ?? '',
                      validator: (val) => val != null && val.isNotEmpty
                          ? null
                          : 'Vui lòng nhập đủ',
                      decoration: InputDecoration(
                          prefixIcon: const Icon(Icons.location_on,
                              color: AppColor.primaryColor),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(12)),
                          hintText:
                              'vd. Phố Triều Khúc, Triều Khúc, Thanh Xuân Nam, Thanh Xuân, Hà Nội',
                          label: const Text('Địa chỉ')),
                    ),

                    // for adding some space
                    SizedBox(height: mq.height * .05),

                    // update profile button
                    ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                          shape: const StadiumBorder(),
                          backgroundColor: AppColor.primaryColor,
                          minimumSize: Size(mq.width * .5, mq.height * .06)),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          APIs.updateUserInfo().then((value) async {
                            await Fluttertoast.showToast(
                              msg: "Cập nhật thành công",
                              toastLength: Toast.LENGTH_SHORT,
                              gravity: ToastGravity.BOTTOM,
                            );
                          });
                        }
                      },
                      icon: const Icon(Icons.edit, size: 28),
                      label:
                          const Text('UPDATE', style: TextStyle(fontSize: 16)),
                    ),
                    SizedBox(height: mq.height * .05),
                  ],
                ),
              ),
            ),
          )),
    );
  }

// bottom sheet for picking a profile picture for user
}
