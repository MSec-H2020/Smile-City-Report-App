import 'user.dart';
import 'theme.dart';

class Invitation
{
  final int id;
  final String code;
  final String timestamp;
  final User inviter;
  final ReportTheme theme;

  Invitation(this.id, this.code, this.timestamp, this.inviter, this.theme);

  factory Invitation.createFrom(Map<String, dynamic> json)
  {
    final user = json.containsKey('inviter_user') ? Map<String, dynamic>.from(json['inviter_user']) : [];
    final theme = json.containsKey('theme') ? Map<String, dynamic>.from(json['theme']) : [];
    return Invitation(
      json['id'],
      json['title'],
      json['expire'],
      User.createFrom(user),
      ReportTheme.createFrom(theme)
    );
  }
}