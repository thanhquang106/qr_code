class UserModel {
  String? id;
  String? email;
  String? first_name;
  String? last_name;

  UserModel({
    this.id,
    this.email,
    this.first_name,
    this.last_name,
  });

  UserModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    email = json['email'];
    first_name = json['first_name'];
    last_name = json['last_name'];
  }
}
