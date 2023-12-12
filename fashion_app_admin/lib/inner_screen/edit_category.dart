import 'dart:developer';
import 'dart:io';
import 'dart:typed_data';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:fashion_app_admin/consts/colors.dart';
import 'package:fashion_app_admin/widgets/header.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconly/iconly.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../controllers/menucontroller.dart';
import '../responsive.dart';

import 'package:firebase/firebase.dart' as fb;

import '../screens/loading_manager.dart';
import '../services/global_method.dart';
import '../services/utils.dart';
import '../widgets/buttons.dart';
import '../widgets/side_menu.dart';
import '../widgets/text_widget.dart';

class EditCategoryScreen extends StatefulWidget {
  const EditCategoryScreen(
      {Key? key,
        required this.id,
        required this.name,
        required this.imageUrl,
        })
      : super(key: key);

  final String id, name, imageUrl;
  @override
  _EditCategoryScreenState createState() => _EditCategoryScreenState();
}

class _EditCategoryScreenState extends State<EditCategoryScreen> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  File? _pickedImage;
  Uint8List webImage = Uint8List(10);
  late String _imageUrl;
  late int val;
  bool _isLoading = false;
  @override
  void initState() {
    _nameController = TextEditingController(text: widget.name);
    _imageUrl = widget.imageUrl;
    print(_imageUrl);
    super.initState();
  }

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _updateCategory() async {
    final isValid = _formKey.currentState!.validate();
    FocusScope.of(context).unfocus();

    if (isValid) {
      _formKey.currentState!.save();

      try {
        Uri? imageUri;
        setState(() {
          _isLoading = true;
        });
        if (_pickedImage != null) {
          fb.StorageReference storageRef = fb
              .storage()
              .ref()
              .child('categoryImages')
              .child(widget.id + 'jpg');
          final fb.UploadTaskSnapshot uploadTaskSnapshot =
          await storageRef.put(kIsWeb ? webImage : _pickedImage).future;
          imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
        }
        await FirebaseFirestore.instance
            .collection('category')
            .doc(widget.id)
            .update({
          'title':_nameController.text,
          'imageUrl':
          _pickedImage == null ? widget.imageUrl : imageUri.toString(),

        });
        print(imageUri.toString());
        await Fluttertoast.showToast(
          msg: "Danh mục đã cập nhật thành công",
          toastLength: Toast.LENGTH_LONG,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIosWeb: 1,
        );
      } on FirebaseException catch (error) {
        GlobalMethods.errorDialog(
            subtitle: '${error.message}', context: context);
        setState(() {
          _isLoading = false;
        });
      } catch (error) {
        GlobalMethods.errorDialog(subtitle: '$error', context: context);
        setState(() {
          _isLoading = false;
        });
      } finally {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Utils(context).getTheme;
    final color = theme == true ? Colors.white : Colors.black;
    final _scaffoldColor = Theme.of(context).scaffoldBackgroundColor;
    Size size = Utils(context).getScreenSize;

    var inputDecoration = InputDecoration(
      filled: true,
      fillColor: _scaffoldColor,
      border: InputBorder.none,
      focusedBorder: OutlineInputBorder(
        borderSide: BorderSide(
          color: color,
          width: 1.0,
        ),
      ),
    );
    return Scaffold(
      key: context.read<MenuControllers>().getEditCategoryScaffoldKey,
      drawer: const SideMenu(),
      body: LoadingManager(
        isLoading: _isLoading,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            if (Responsive.isDesktop(context))
              const Expanded(
                child: SideMenu(),
              ),
            Expanded(
              flex: 5,
              child: SingleChildScrollView(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Header(
                        showTexField: false,
                        fct: () {
                          context.read<MenuControllers>().controlEditCategoryMenu();
                        },
                        title: 'Sửa danh mục',
                      ),
                    ),
                    Container(
                      width: size.width > 650 ? 650 : size.width,
                      //color: Theme.of(context).cardColor,
                      padding: const EdgeInsets.all(16),
                      margin: const EdgeInsets.all(16),
                      child: Form(
                        key: _formKey,
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.min,
                          children: <Widget>[
                            TextWidget(
                              text: 'Tên Danh Mục*',
                              color: color,
                              isTitle: true,
                            ),
                            const SizedBox(
                              height: 10,
                            ),
                            TextFormField(
                              controller: _nameController,
                              key: const ValueKey('Title'),
                              validator: (value) {
                                if (value!.isEmpty) {
                                  return 'Vui lòng điền !!!';
                                }
                                return null;
                              },
                              decoration: inputDecoration,
                            ),
                            const SizedBox(
                              height: 20,
                            ),
                            Row(
                              children: [
                                // Expanded(
                                //   flex: 1,
                                //   child: FittedBox(
                                //     // child: Column(
                                //     //   crossAxisAlignment: CrossAxisAlignment.start,
                                //     //   mainAxisAlignment: MainAxisAlignment.start,
                                //     //   children: [
                                //     //     const SizedBox(
                                //     //       height: 5,
                                //     //     ),
                                //     //     AnimatedSwitcher(
                                //     //       duration: const Duration(seconds: 1),
                                //     //       child: !_isOnSale
                                //     //           ? Container()
                                //     //           : Row(
                                //     //         children: [
                                //     //           TextWidget(
                                //     //               text: "$_salePrice VNĐ",
                                //     //               color: color),
                                //     //           const SizedBox(
                                //     //             width: 10,
                                //     //           ),
                                //     //           salePourcentageDropDownWidget(
                                //     //               color),
                                //     //         ],
                                //     //       ),
                                //     //     )
                                //     //   ],
                                //     // ),
                                //   ),
                                // ),
                                Expanded(
                                  flex: 3,
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Container(
                                      height: size.width > 650
                                          ? 350
                                          : size.width * 0.45,
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          12,
                                        ),
                                        color: Theme.of(context)
                                            .scaffoldBackgroundColor,
                                      ),
                                      child: ClipRRect(
                                        borderRadius: const BorderRadius.all(
                                            Radius.circular(12)),
                                        child: _pickedImage == null
                                            ? Image.network(_imageUrl)
                                            : (kIsWeb)
                                            ? Image.memory(
                                          webImage,
                                          fit: BoxFit.fill,
                                        )
                                            : Image.file(
                                          _pickedImage!,
                                          fit: BoxFit.fill,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Expanded(
                                    flex: 1,
                                    child: Column(
                                      children: [
                                        FittedBox(
                                          child: TextButton(
                                            onPressed: () {
                                              _pickImage();
                                            },
                                            child: TextWidget(
                                              text: 'Cập nhật ảnh',
                                              color: Colors.blue,
                                            ),
                                          ),
                                        ),
                                      ],
                                    )),
                              ],
                            ),
                            Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.spaceAround,
                                children: [
                                  ButtonsWidget(
                                    onPressed: () async {
                                      GlobalMethods.warningDialog(
                                          title: 'Thông báo',
                                          subtitle: 'Bạn có muốn xóa không',
                                          fct: () async {
                                            await FirebaseFirestore.instance
                                                .collection('category')
                                                .doc(widget.id)
                                                .delete();
                                            await Fluttertoast.showToast(
                                              msg: "Danh mục đã xóa thành công",
                                              toastLength: Toast.LENGTH_LONG,
                                              gravity: ToastGravity.CENTER,
                                              timeInSecForIosWeb: 1,
                                            );
                                            while (Navigator.canPop(context)) {
                                              Navigator.pop(context);
                                            }
                                          },
                                          context: context);
                                    },
                                    text: 'Xóa',
                                    icon: Icons.close,
                                    backgroundColor: Colors.red.shade700,
                                  ),
                                  ButtonsWidget(
                                    onPressed: () {
                                      _updateCategory();
                                    },
                                    text: 'Cập nhật',
                                    icon: IconlyBold.upload,
                                    backgroundColor: AppColor.primaryColor,
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Future<void> _pickImage() async {
    // MOBILE
    if (!kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);

      if (image != null) {
        var selected = File(image.path);

        setState(() {
          _pickedImage = selected;
        });
      } else {
        log('Không có ảnh nào được');
        // showToast("No file selected");
      }
    }
    // WEB
    else if (kIsWeb) {
      final ImagePicker _picker = ImagePicker();
      XFile? image = await _picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        var f = await image.readAsBytes();
        setState(() {
          _pickedImage = File("a");
          webImage = f;
        });
      } else {
        log('Không có ảnh nào được');
      }
    } else {
      log('Giấy phép không được cấp');
    }
  }
}