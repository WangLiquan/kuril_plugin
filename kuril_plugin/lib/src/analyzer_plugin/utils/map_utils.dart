import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart';
import '../checker/kuril_plugin_checker.dart';

/// Get error for [CompilationUnit] unit.
AnalysisError analysisErrorFor(
  String path,
  KurilPluginCheckerIssue issue,
  CompilationUnit unit,
) {
  final offsetLocation = unit.lineInfo!.getLocation(issue.offset);
  return AnalysisError(
    issue.analysisErrorSeverity,
    issue.analysisErrorType,
    Location(
      path,
      issue.offset,
      issue.length,
      offsetLocation.lineNumber,
      offsetLocation.columnNumber,
      -1,
      -1,
    ),
    issue.message,
    issue.code,
  );
}
