class DeviceModel {
  String? token;
  String? id;
  String? name;
  String? type;
  int? created_time;

  DeviceModel({
    this.token,
    this.id,
    this.name,
    this.type,
    this.created_time,
  });

  DeviceModel.fromJson(Map<String, dynamic> json) {
    id = json['tokenDevice'];
    id = json['id'];
    name = json['name'];
    type = json['type'];
    created_time = json['created_time'];
  }
}
