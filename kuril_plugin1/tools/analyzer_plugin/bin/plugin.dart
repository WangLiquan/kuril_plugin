import 'dart:isolate';

import 'package:kuril_plugin/kuril_plugin.dart';

void main(List<String> args, SendPort sendPort) {
  start(args, sendPort);
}
