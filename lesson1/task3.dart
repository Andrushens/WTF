import 'dart:io';
import 'dart:math' as math;

int solve(int n) {
  int width = math.sqrt(n).ceil();
  int length = (n / width).ceil();
  int left = width * length - n;
  int res = length * (width + 1) + width * (length + 1) - 2 * left;
  return res;
}

void main() {
  int n = int.parse(stdin.readLineSync()!);
  final time1 = DateTime.now();
  print('${solve(n)}');
  final time2 = DateTime.now();
  print('time: ${time2.difference(time1).inMilliseconds}');
}
