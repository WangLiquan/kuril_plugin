import 'dart:isolate';

import 'package:analyzer/file_system/physical_file_system.dart';
import 'package:analyzer_plugin/starter.dart';
import 'package:kuril_plugin/src/logger/log.dart';

import 'analyzer_plugin.dart';

/// Entry point of plugin. Dart Analyzer Server runs it from its side.
void start(Iterable<String> _, SendPort sendPort) {
  mirrorLog.info('-----------restarted-------------');
  ServerPluginStarter(
          DartKurilPluginAnalyzerPlugin(PhysicalResourceProvider.INSTANCE))
      .start(sendPort);
}
