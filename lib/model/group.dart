import 'user.dart';
import 'smile.dart';


class Group
{
  final int id;
  final String name;
  List<User> members = [];
  List<Smile> smiles = [];

  Group({this.id, this.name, this.members, this.smiles});

  factory Group.createFrom(Map<String, dynamic> json)
  {
    final smilesJson = json.containsKey('smiles') ? List<Map<String, dynamic>>.from(json['smiles']) : [];
    var smiles = smilesJson.map((json) => Smile.createFrom(json)).toList();
    smiles.sort((a, b) => b.id.compareTo(a.id));

    final users = json.containsKey('users') ? List<Map<String, dynamic>>.from(json['users']) : [];
    return Group(
      id: json['id'] as int ?? 0,
      name: json['group_name'] as String ?? '',
      members: users.map((json) => User.createFrom(json)).toList(),
      smiles: smiles
    );
  }

  List<Smile> smilesFilteredBy(int userId)
  {
    if (userId == null) {
      return this.smiles;
    }
    else {
      return this.smiles.where((smile) => smile.userId == userId).toList();
    }
  }
}