import 'dart:io';

import 'package:dotenv/dotenv.dart';
import 'package:meta/meta.dart';

import '../../core/action.dart';
import '../../env.dart';
import '../../ext/shell.dart';

class PrintDartDefine extends IAction {
  final IDartDefineConfig source;

  PrintDartDefine(this.source);

  @override
  void call() {
    final env = loadEnv(Platform.environment);

    p(env.toDartDefine().join(source.outputSeparator));
  }

  @visibleForTesting
  DotEnv loadEnv(Map<String, String> platform) {
    final env = DotEnv()
      ..addAll(_filteredPlatformEnv(platform))
      ..load(source.files);

    return env;
  }

  Map<String, String> _filteredPlatformEnv(Map<String, String> platform) {
    if (source.platformExpr.isEmpty) return {};

    return Map.fromEntries(
      platform.entries.where(
        (entry) => source.platformExpr.any(
          (expr) => expr.isNotEmpty && RegExp(expr).hasMatch(entry.key),
        ),
      ),
    );
  }
}

abstract class IDartDefineConfig {
  List<String> get files;
  List<String> get platformExpr;
  String get outputSeparator;
}
