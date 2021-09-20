import 'smile.dart';

enum UserRoll {
  teacher, // 0
  student, // 1
  sata, // 2
}

class User {
  final int id;
  final String name;
  final String nickname;
  final String email;
  final String gender;
  final int age;
  final String job;
  final String facebookId;
  final String iconUrl;
  final List<Smile> smiles;
  final int todayPoints;
  final int allPoints;
  final List<int> registerdClasses;
  final UserRoll userRoll;

  User(
      {this.id,
      this.name,
      this.nickname,
      this.email,
      this.gender,
      this.age,
      this.job,
      this.facebookId,
      this.iconUrl,
      this.smiles,
      this.todayPoints,
      this.allPoints,
      this.registerdClasses,
      this.userRoll});

  factory User.createFrom(Map<String, dynamic> json) {
    final smilesJson = json.containsKey('smiles')
        ? List<Map<String, dynamic>>.from(json['smiles'])
        : [];
    final smiles = smilesJson.map((json) => Smile.createFrom(json)).toList();
    smiles.sort((a, b) => b.id.compareTo(a.id));

    final profilePath = json.containsKey('profile_path')
        ? json['profile_path'] as Map<String, dynamic> ?? Map<String, dynamic>()
        : Map<String, dynamic>();

    final classesStr = json['user_class'] as String ?? '';
    final classes = classesStr
        .split(',')
        .where((e) => e.isNotEmpty)
        .map((e) => int.parse(e))
        .toList();
    classes.sort();

    return User(
        id: json["id"] as int ?? 0,
        name: json["name"] as String ?? '',
        nickname: json["nickname"] as String ?? '',
        email: json["email"] as String ?? '',
        age: json.containsKey('age') ? json['age'] as int ?? 0 : 0,
        gender: json["gender"] as String ?? '',
        job: json["job"] as String ?? '',
        facebookId: json["fbid"] as String ?? '',
        iconUrl: profilePath['url'] as String ?? '',
        smiles: smiles,
        todayPoints: json.containsKey('today_points')
            ? json['today_points'] as int ?? 0
            : 0,
        allPoints:
            json.containsKey('all_points') ? json['all_points'] as int ?? 0 : 0,
        registerdClasses: classes,
        userRoll: _getUserRoll(json['user_type']));
  }

  static UserRoll _getUserRoll(int value) {
    if (value == null) {
      return null;
    }
    if (value < UserRoll.values.length) {
      return UserRoll.values[value];
    } else {
      return UserRoll.student;
    }
  }
}
