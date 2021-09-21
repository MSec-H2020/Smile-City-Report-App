import 'user.dart';


class PointUse
{
  final int id;
  final String timestamp;
  final Point point;

  PointUse(this.id, this.timestamp, this.point);
}


class Point
{
  final int id;
  final int point;
  final String reason;

  Point(this.id, this.point, this.reason);

  factory Point.createFrom(Map<String, dynamic> json)
  {
    return Point(json['id'], json['point'], json['reason']);
  }

}


class PointSummary
{
  final int allPoints;
  final int todayPoints;
  final List<User> rivals;
  final int rank;
  final int participants;

  PointSummary(this.allPoints, this.todayPoints, this.rivals, this.rank, this.participants);

  factory PointSummary.createFrom(Map<String, dynamic> json)
  {
    final rivals = json.containsKey('rivals') ? List<Map<String, dynamic>>.from(json['rivals']) : [];

    return PointSummary(
      json['all_points'] as int ?? 0,
      json['today_points'] as int ?? 0,
      rivals.map((json) => User.createFrom(json)).toList(),
      json['rank'] as int ?? 0,
      json['participants'] as int ?? 0,
    );
  }

}