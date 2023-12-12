import 'package:flutter/material.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:image_picker/image_picker.dart';

class EditUserProfileScreen extends StatefulWidget {
  // Các thuộc tính của người dùng
  final String name;
  final String email;
  final String address;
  final String phoneNumber;
  final String accountCreatedDate;
  final String imageUrl;

  const EditUserProfileScreen({
    Key? key,
    required this.name,
    required this.email,
    required this.address,
    required this.phoneNumber,
    required this.accountCreatedDate,
    required this.imageUrl,
  }) : super(key: key);

  @override
  _EditUserProfileScreenState createState() => _EditUserProfileScreenState();
}

class _EditUserProfileScreenState extends State<EditUserProfileScreen> {
  late TextEditingController _nameController,
      _emailController,
      _addressController,
      _phoneNumberController;

  File? _pickedImage;
  Uint8List? _webImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.name);
    _emailController = TextEditingController(text: widget.email);
    _addressController = TextEditingController(text: widget.address);
    _phoneNumberController = TextEditingController(text: widget.phoneNumber);
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _addressController.dispose();
    _phoneNumberController.dispose();
    super.dispose();
  }

  // Future<void> _pickImage() async {
  //   final ImagePicker _picker = ImagePicker();
  //   final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
  //
  //   if (image != null) {
  //     if (kIsWeb) {
  //       var f = await image.readAsBytes();
  //       setState(() {
  //         _pickedImage = null;
  //         _webImage = f;
  //       });
  //     } else {
  //       setState(() {
  //         _pickedImage = File(image.path);
  //         _webImage = null;
  //       });
  //     }
  //   }
  // }

  void _updateUserProfile() {
    // Thực hiện cập nhật thông tin người dùng trong cơ sở dữ liệu
    // Hãy đảm bảo xử lý logic cập nhật dữ liệu ở đây
    // ...

    // Hiển thị thông báo cập nhật thành công
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Thông tin người dùng đã được cập nhật')),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sửa thông tin người dùng'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hiển thị ảnh người dùng
            CircleAvatar(
              radius: 50,
              backgroundImage: NetworkImage('https://upload.wikimedia.org/wikipedia/vi/thumb/a/a1/Man_Utd_FC_.svg/1200px-Man_Utd_FC_.svg.png')
            ),
            const SizedBox(height: 16),
            // Nút chọn ảnh mới
            ElevatedButton(
              onPressed: (){},
              child: const Text('Chọn ảnh mới'),
            ),
            const SizedBox(height: 16),
            // Form sửa thông tin người dùng
            TextFormField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Tên'),
            ),
            TextFormField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
            ),
            TextFormField(
              controller: _addressController,
              decoration: const InputDecoration(labelText: 'Địa chỉ'),
            ),
            TextFormField(
              controller: _phoneNumberController,
              decoration: const InputDecoration(labelText: 'Số điện thoại'),
            ),
            const SizedBox(height: 16),
            // Nút cập nhật thông tin
            ElevatedButton(
              onPressed: _updateUserProfile,
              child: const Text('Cập nhật thông tin'),
            ),
          ],
        ),
      ),
    );
  }
}
