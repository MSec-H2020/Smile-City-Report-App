import 'package:smile_x/model/othersmile.dart';
import 'package:smile_x/model/user.dart';
import 'package:smile_x/model/othersmile.dart';
import 'comment.dart';

class Smile {
  final int id;
  final double lat;
  final double lon;
  final int userId;
  final String createdAt;
  final String updatedAt;
  final String picPath;
  final String backPath;
  final String caption;
  final List<Comment> comments;
  final User user;
  List<Othersmile> others = [];

  Smile({
    this.id,
    this.lat,
    this.lon,
    this.userId,
    this.picPath,
    this.backPath,
    this.others,
    this.user,
    this.createdAt,
    this.updatedAt,
    this.caption,
    this.comments,
  });

  factory Smile.createFrom(Map<String, dynamic> json) {
    final othersDict = json.containsKey('othersmiles')
        ? List<Map<String, dynamic>>.from(json['othersmiles'])
        : [];
    var others = othersDict.map((json) => Othersmile.createFrom(json)).toList();
    others = others.where((othersmile) => othersmile.isSmiled()).toList();

    // Filter same user
    var userIds = [];
    others = others.map((smile) {
      if (userIds.contains(smile.userId)) {
        return null;
      }
      userIds.add(smile.userId);
      return smile;
    }).toList();
    others = others.where((smile) => smile != null).toList();

    final smile = json.containsKey('smile')
        ? json['smile'] as Map<String, dynamic>
        : Map<String, dynamic>();
    final user = json.containsKey('user')
        ? json['user'] as Map<String, dynamic>
        : Map<String, dynamic>();
    final comments = json.containsKey('comments')
        ? List<Map<String, dynamic>>.from(json['comments'])
        : [];

    final picPath = smile.containsKey('pic_path')
        ? smile['pic_path'] as Map<String, dynamic>
        : Map<String, dynamic>();

    final backPath = smile.containsKey('back_pic_path')
        ? smile['back_pic_path'] as Map<String, dynamic>
        : Map<String, dynamic>();

    return Smile(
      id: smile['id'] as int ?? 0,
      lat: smile['lat'] as double ?? 0,
      lon: smile['lon'] as double ?? 0,
      picPath: picPath['url'] as String ?? '',
      backPath: backPath['url'] as String ?? '',
      userId: smile['user_id'] as int ?? 0,
      createdAt: smile['created_at'] as String ?? '',
      updatedAt: smile['updated_at'] as String ?? '',
      others: others,
      user: User.createFrom(user),
      comments: comments.map((json) => Comment.createFrom(json)).toList(),
      caption: smile['caption'] as String ?? '',
    );
  }


  List<Comment> myComments(int userId) {
    if (userId == null) return [];
    return this.comments.where((c) => c.user.id == userId).toList();
  }
}