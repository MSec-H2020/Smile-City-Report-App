class FacebookUser
{
  final String id;
  final String name;
  final String email;
  final String iconUrl;

  FacebookUser({this.id, this.name, this.email, this.iconUrl});

  factory FacebookUser.createFrom(Map<String, dynamic> json)
  {
    var picture = json['picture'] as Map<String, dynamic> ?? null;
    var data = picture['data'] as Map<String, dynamic> ?? null;
    var url = data == null ? '' : data['url'] as String ?? '';

    return FacebookUser(
      id: json['id'] as String ?? '',
      name: json['name'] as String ?? '',
      email: json['email'] as String ?? '',
      iconUrl: url,
    );
  }
}