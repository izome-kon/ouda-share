import 'package:listar_flutter_pro/models/model.dart';

class CommentModel {
  final int id;
  final UserModel user;
  final String postName;
  final String comment;
  final DateTime createDate;
  final double rate;

  CommentModel({
    required this.id,
    required this.user,
    required this.postName,
    required this.comment,
    required this.createDate,
    required this.rate,
  });

  factory CommentModel.fromJson(Map<String, dynamic> json) {
    final userJson = {
      'id': int.tryParse(json['user_id'].toString()) ?? 0,
      'user_email': json['comment_author_email'],
      'display_name': json['comment_author'],
      'user_photo': json['comment_author_image']
    };

    return CommentModel(
      id: int.tryParse(json['comment_ID'].toString()) ?? 0,
      user: UserModel.fromJson(userJson),
      postName: json['post_title'] ?? '',
      comment: json['comment_content'] ?? '',
      createDate: DateTime.tryParse(json['comment_date']) ?? DateTime.now(),
      rate: double.tryParse(json['rate'].toString()) ?? 0.0,
    );
  }
}
