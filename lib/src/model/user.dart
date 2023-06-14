class User {
  String? sId;
  String? email;
  String? name;
  String? photo;
  String? phone;
  String? address;

  User({this.sId, this.email, this.name, this.photo, this.phone, this.address});

  User.fromJson(Map<String, dynamic> json) {
    sId = json['_id'];
    email = json['email'];
    name = json['name'];
    photo = json['photo'];
    phone = json['phone'];
    address = json['address'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = <String, dynamic>{};
    data['_id'] = sId;
    data['email'] = email;
    data['name'] = name;
    data['photo'] = photo;
    data['phone'] = phone;
    data['address'] = address;
    return data;
  }
}
