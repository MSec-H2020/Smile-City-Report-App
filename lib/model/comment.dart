import 'smile.dart';
import 'user.dart';


class Comment
{
  final int id;
  final String text;
  final Smile smile;
  final User user;
  final String createdAt;

  Comment(this.id, this.text, this.smile, this.user, this.createdAt);

  factory Comment.createFrom(Map<String, dynamic> json)
  {
    final user = json.containsKey('user') ?
    json['user'] as Map<String, dynamic> : Map<String, dynamic>();
    final smile = json.containsKey('smile') ?
    json['smile'] as Map<String, dynamic> : Map<String, dynamic>();
    return Comment(
      json['id'] as int ?? 0,
      json['text'] as String ?? '',
      Smile.createFrom(smile),
      User.createFrom(user),
      json['created_at'] as String ?? ''
    );
  }

}