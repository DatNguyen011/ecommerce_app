class Users {
  Users({
    required this.image,
    required this.name,
    //required this.createdAt,
    required this.id,
    required this.email,
    required this.address,
    required this.phone,
  });
  late String image;
  late String name;
 // late String createdAt;
  late String id;
  late String email;
  late String address;
  late String phone;

  Users.fromJson(Map<String, dynamic> json) {
    image = json['image'] ?? '';
    name = json['name'] ?? '';
    address = json['shipping-address'] ?? '';
    //createdAt = json['createdAt'] ?? '';
    id = json['id'] ?? '';
    email = json['email'] ?? '';
    phone = json['phone'] ?? '';
  }

  Map<String, dynamic> toJson() {
    final data = <String, dynamic>{};
    data['image'] = image;
    data['name'] = name;
    //data['createdAt'] = createdAt;
    data['shipping-address'] = address;
    data['id'] = id;
    data['email'] = email;
    data['phone'] = phone;
    return data;
  }
}
