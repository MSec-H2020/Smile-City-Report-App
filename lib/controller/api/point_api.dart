import 'package:tuple/tuple.dart';

import '../request_manager.dart';

import 'package:smile_x/model/point.dart';


class PointAPI
{
  // -------------------------------------//
  //  -- Initialize --
  //--------------------------------------//

  static final shared = PointAPI._internal();

  factory PointAPI()
  {
    return shared;
  }

  PointAPI._internal();


  // -------------------------------------//
  //  -- API --
  //--------------------------------------//

  Future<Tuple3<List<Point>, bool, String>> fetchPoints() async
  {
    final result = await fetch('/points', {});
    return !result.item2 ? Tuple3(null, result.item2, result.item3) :
    Tuple3(parsePoints(result.item1), result.item2, result.item3) ;
  }


  List<Point> parsePoints(Map<String, dynamic> data)
  {
    final points = List<Map<String, dynamic>>.from(data['points']) ?? null;
    return points.map((json) {
      return Point.createFrom(json);
    }).toList();
  }

  PointSummary parsePointSummary(Map<String, dynamic> data)
  {
    final json = data.containsKey('point_summary') ? cast<Map<String, dynamic>>(data['point_summary']) : null;
    return PointSummary.createFrom(json);
  }
}
