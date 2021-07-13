import 'dart:io';

int solve(String str) {
  int curPos = 0;
  int maxLeft = 0;
  int maxRight = 0;

  for (int i = 0; i < str.length; i++) {
    if (str[i] == 'R') {
      curPos++;
      if (maxRight < curPos) {
        maxRight = curPos;
      }
    } else if (str[i] == 'L') {
      curPos--;
      if (maxLeft > curPos) {
        maxLeft = curPos;
      }
    }
  }

  return 1 + maxRight - maxLeft;
}

void main() {
  String steps = stdin.readLineSync()!;
  final time1 = DateTime.now();
  print('${solve(steps)}');
  final time2 = DateTime.now();
  print('time: ${time2.difference(time1).inMilliseconds}');
}
