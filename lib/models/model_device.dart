class DeviceModel {
  String uuid;
  String? name;
  String model;
  String version;
  String? token;
  String type;
  bool? used;

  DeviceModel({
    required this.uuid,
    this.name,
    required this.model,
    required this.version,
    this.token,
    required this.type,
    this.used,
  });
}
