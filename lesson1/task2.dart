import 'dart:io';
import 'dart:math' as math;

int solve(double x1, double y1, double r1, double x2, double y2, double r2) {
  double dist = math.sqrt(math.pow(x1 - x2, 2) + math.pow(y1 - y2, 2));

  if (dist == 0) {
    return r1 == r2 ? -1 : 0;
  }
  if (r1 + r2 == dist || (r1 - r2).abs() == dist) {
    return 1;
  }
  if (r1 + r2 < dist || (r1 - r2).abs() > dist) {
    return 0;
  }
  return 2;
}

void main() {
  double x1 = double.parse(stdin.readLineSync()!);
  double y1 = double.parse(stdin.readLineSync()!);
  double r1 = double.parse(stdin.readLineSync()!);
  double x2 = double.parse(stdin.readLineSync()!);
  double y2 = double.parse(stdin.readLineSync()!);
  double r2 = double.parse(stdin.readLineSync()!);
  final time1 = DateTime.now();
  print('${solve(x1, y1, r1, x2, y2, r2)}');
  final time2 = DateTime.now();
  print('time: ${time2.difference(time1).inMilliseconds}');
}
