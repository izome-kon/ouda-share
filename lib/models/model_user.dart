class UserModel {
  late final int id;
  late String name;
  late final String nickname;
  late String image;
  late String url;
  late final int level;
  late String description;
  late final String tag;
  late final double rate;
  late final int comment;
  late int total;
  late final String token;
  late String email;

  UserModel({
    required this.id,
    required this.name,
    required this.nickname,
    required this.image,
    required this.url,
    required this.level,
    required this.description,
    required this.tag,
    required this.rate,
    required this.comment,
    required this.total,
    required this.token,
    required this.email,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json['id'] ?? 0,
      name: json['display_name'] ?? 'Unknown',
      nickname: json['user_nicename'] ?? 'Unknown',
      image: json['user_photo'] ?? 'Unknown',
      url: json['user_url'] ?? 'Unknown',
      level: json['user_level'] ?? 0,
      description: json['description'] ?? 'description',
      tag: json['tag'] ?? 'Unknown',
      rate: double.tryParse('${json['rating_avg']}') ?? 0.0,
      comment: int.tryParse('${json['total_comment']}') ?? 0,
      total: json['total'] ?? 0,
      token: json['token'] ?? "Unknown",
      email: json['user_email'] ?? 'Unknown',
    );
  }

  UserModel updateUser({
    String? name,
    String? email,
    String? url,
    String? description,
    String? image,
    int? total,
  }) {
    this.name = name ?? this.name;
    this.email = email ?? this.email;
    this.url = url ?? this.url;
    this.description = description ?? this.description;
    this.image = image ?? this.image;
    this.total = total ?? this.total;
    return clone();
  }

  UserModel.fromSource(source) {
    id = source.id;
    name = source.name;
    nickname = source.nickname;
    image = source.image;
    url = source.url;
    level = source.level;
    description = source.description;
    tag = source.tag;
    rate = source.rate;
    comment = source.comment;
    total = source.total;
    token = source.token;
    email = source.email;
  }

  UserModel clone() {
    return UserModel.fromSource(this);
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'display_name': name,
      'user_nicename': nickname,
      'user_photo': image,
      'user_url': url,
      'user_level': level,
      'description': description,
      'tag': tag,
      'rating_avg': rate,
      'total_comment': rate,
      'total': total,
      'token': token,
      'user_email': email
    };
  }
}
