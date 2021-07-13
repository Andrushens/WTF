import 'dart:io';

int solve(int n) {
  int res = 0;
  int left = 0;
  int step = 1;
  int rightSum, leftSum;

  if (n > 13) {
    n = 27 - n;
  }

  for (int i = 0; i < 1000000; i += step) {
    left = i ~/ 1000;
    leftSum = left % 10 + (left ~/ 10) % 10 + (left ~/ 100) % 10;
    rightSum = i % 10 + (i ~/ 10) % 10 + (i ~/ 100) % 10;

    if (leftSum == rightSum && leftSum == n) {
      if (step == 1) {
        step = 9;
      }
      res += 1;
    }
  }

  return res;
}

void main() {
  int n = int.parse(stdin.readLineSync()!);
  final time1 = DateTime.now();
  print('${solve(n)}');
  final time2 = DateTime.now();
  print('time: ${time2.difference(time1).inMilliseconds}');
}
