enum Sensor { accelerometer, barometer, gyroscope, location }

class Accelerometer {
  final double x; // G
  final double y;
  final double z;

  Accelerometer(this.x, this.y, this.z);

  Accelerometer.fromData(Map data)
      : x = data['double_values_0'],
        y = data['double_values_1'],
        z = data['double_values_2'];
}

class Barometer {
  final double pressure; // hPa

  Barometer(this.pressure);

  Barometer.fromData(Map data) : pressure = data['double_values_0'];
}

class Gyroscope {
  final double x; // rad/s
  final double y;
  final double z;

  Gyroscope(this.x, this.y, this.z);

  Gyroscope.fromData(Map data)
      : x = data['double_values_0'],
        y = data['double_values_1'],
        z = data['double_values_2'];
}

class Location {
  final double latitude;
  final double longitude;
  final double bearing;
  final double speed;
  final double altitude;

  Location(
      this.latitude, this.longitude, this.bearing, this.speed, this.altitude);

  Location.fromData(Map data)
      : latitude = data['double_latitude'],
        longitude = data['double_longitude'],
        bearing = data['double_bearing'],
        speed = data['double_speed'],
        altitude = data['double_altitude'];
}