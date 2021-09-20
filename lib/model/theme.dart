import 'package:smile_x/controller/api/theme_api.dart';
import 'package:smile_x/model/smile.dart';

import 'user.dart';

class ReportTheme {
  final int id;
  final String area;
  final String title;
  final String message;
  final String timestamp;
  final String image;
  final int ownerId;
  final bool isFacing;
  final bool isGanonymize;
  final bool isPublic;

  Future<User> get owner async {
    if (_owner != null) {
      return _owner;
    } else {
      final result = await ThemeAPI.shared.fetchOwner(id);
      _owner = result.item1;
      return _owner;
    }
  }

  User _owner;

  Future<List<User>> get invited async {
    if (_invited != null) {
      return _invited;
    } else {
      final result = await ThemeAPI.shared.fetchInvitedUsers(id);
      _invited = result.item1;
      return _invited;
    }
  }

  List<User> _invited;

  Future<List<User>> get joining async {
    if (_joining != null) {
      return _joining;
    } else {
      final result = await ThemeAPI.shared.fetchJoiningUsers(id);
      _joining = result.item1;
      return _joining;
    }
  }

  List<User> _joining;

  Future<List<Smile>> get smiles async {
    if (_smiles != null) {
      return _smiles;
    } else {
      final result = await ThemeAPI.shared.fetchSmiles(id);
      _smiles = result.item1;
      return _smiles;
    }
  }

  List<Smile> _smiles;

  Future<List<Smile>> smilesFilteredBy(int userId) async {
    final smiles = await this.smiles;
    if (userId == null) {
      return smiles;
    } else {
      return smiles.where((smile) => smile.userId == userId).toList();
    }
  }

  ReportTheme({
    this.id,
    this.area,
    this.title,
    this.message,
    this.timestamp,
    this.image,
    this.ownerId,
    this.isFacing,
    this.isGanonymize,
    this.isPublic,
  });

  factory ReportTheme.createFrom(Map<String, dynamic> json) {
    final image = json.containsKey('image')
        ? json['image'] as Map<String, dynamic>
        : Map<String, dynamic>();

    return ReportTheme(
      id: json['id'],
      area: json['area'],
      title: json['title'],
      message: json['message'],
      timestamp: json['created_at'],
      image: image['url'] ?? '',
      ownerId: json['owner_id'],
      isFacing: json['facing'],
      isGanonymize: json['isGanonymize'] ?? false,
      isPublic: json['public'],
    );
  }
}

enum ThemeType { all, joining, invited }
