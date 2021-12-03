import 'package:analyzer/dart/ast/ast.dart';
import 'package:analyzer/dart/ast/visitor.dart';
import 'package:analyzer_plugin/protocol/protocol_common.dart' as plugin;

/// Main check. Using for get issues from Dart Analyzer and cast it to [KurilPluginCheckerIssue].
class KurilPluginChecker {
  /// [CompilationUnit] for extract details for issues
  final CompilationUnit? _compilationUnit;

  KurilPluginChecker(this._compilationUnit);

  /// Parse errors from Dart Analyer and cast to [KurilPluginCheckerIssue].
  Iterable<KurilPluginCheckerIssue> kurilPluginErrors() {
    final visitor = _KurilPluginCheckerVisitor();
    _compilationUnit!.accept(visitor);
    return visitor.issues;
  }
}

class _KurilPluginCheckerVisitor extends RecursiveAstVisitor<void> {
  final _issues = <KurilPluginCheckerIssue>[];

  Iterable<KurilPluginCheckerIssue> get issues => _issues;

  @override
  void visitMethodInvocation(MethodInvocation node) {
    super.visitMethodInvocation(node);
    // 'first'
    // 'firstWhere'
    // 'last'
    // 'CachedNetworkImage'
    if (node.methodName.name == 'firstWhere') {
      _issues.add(
        KurilPluginCheckerIssue(
          plugin.AnalysisErrorSeverity.ERROR,
          plugin.AnalysisErrorType.LINT,
          node.offset,
          node.length,
          '禁止使用firstWhere',
          '可以使用firstElementWhere替换',
        ),
      );
    }
  }

  @override
  void visitPrefixedIdentifier(PrefixedIdentifier node) {
    node.visitChildren(this);
    if (node.identifier.name == 'first') {
      _issues.add(
        KurilPluginCheckerIssue(
          plugin.AnalysisErrorSeverity.ERROR,
          plugin.AnalysisErrorType.LINT,
          node.offset,
          node.length,
          '禁止使用first',
          '可以使用firstElement替换',
        ),
      );
    }
    if (node.identifier.name == 'last') {
      _issues.add(
        KurilPluginCheckerIssue(
          plugin.AnalysisErrorSeverity.ERROR,
          plugin.AnalysisErrorType.LINT,
          node.offset,
          node.length,
          '禁止使用last',
          '可以使用lastElement替换',
        ),
      );
    }
  }

  @override
  void visitSimpleIdentifier(SimpleIdentifier node) {
    node.visitChildren(this);
    if (node.name.contains('CachedNetworkImage') &&
        !node.name.startsWith('QD')) {
      _issues.add(
        KurilPluginCheckerIssue(
          plugin.AnalysisErrorSeverity.ERROR,
          plugin.AnalysisErrorType.LINT,
          node.offset,
          node.length,
          '禁止使用CachedNetworkImage',
          '可以改为QDCachedNetworkImage',
        ),
      );
    }
    if (node.name == 'first') {
      _issues.add(
        KurilPluginCheckerIssue(
          plugin.AnalysisErrorSeverity.ERROR,
          plugin.AnalysisErrorType.LINT,
          node.offset,
          node.length,
          '禁止使用first',
          '可以使用firstElement替换',
        ),
      );
    }
  }
}

/// Representation of issue that plugin use in internal methods.
class KurilPluginCheckerIssue {
  final plugin.AnalysisErrorSeverity analysisErrorSeverity;
  final plugin.AnalysisErrorType analysisErrorType;
  final int offset;
  final int length;
  final String message;
  final String code;

  KurilPluginCheckerIssue(
    this.analysisErrorSeverity,
    this.analysisErrorType,
    this.offset,
    this.length,
    this.message,
    this.code,
  );
}
