import 'dart:io';

void main() {
  String num = stdin.readLineSync()!;
  final time1 = DateTime.now();
  print('${num[0]} ${num[1]}');
  final time2 = DateTime.now();
  print('time: ${time2.difference(time1).inMilliseconds}');
}
