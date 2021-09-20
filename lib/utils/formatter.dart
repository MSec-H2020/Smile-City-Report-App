import 'package:intl/intl.dart';

class Formatter {
  final String noDataStr;

  Formatter({this.noDataStr = ''});

  String formatSeconds(int seconds) {
    if (seconds == null) {
      return noDataStr;
    }
    
    int minutes = (seconds / 60).truncate();

    String minutesStr = (minutes % 60).toString().padLeft(2, '0');
    String secondsStr = (seconds % 60).toString().padLeft(2, '0');

    return "$minutesStr:$secondsStr";
  }

  String formatDistance(int meter) {
    if (meter == null) {
      return noDataStr;
    }

    if (meter < 1000) {
      return '$meter m';
    } else {
      final km = meter / 1000;
      return '${km.toStringAsFixed(2)} km';
    }
  }

  String formatInt(int value) {
    if (value == null) {
      return noDataStr;
    }

    return value.toString();
  }

  String formatDouble(double value,
      [String unit = '', int fractionDigits = 2]) {
    if (value == null) {
      return noDataStr;
    }

    if (unit.isNotEmpty) {
      return value.toStringAsFixed(fractionDigits) + ' ' + unit;
    }
    return value.toStringAsFixed(fractionDigits);
  }

  String formatCreatedAt(String str) {
    try {
      final date = DateFormat('YYYY-MM-DDThh:mm:ss.sTZD').parse(str);
      return DateFormat('yyyy/MM/dd hh:mm').format(date);
    } catch(e) {
      return noDataStr;
    }
  }
}