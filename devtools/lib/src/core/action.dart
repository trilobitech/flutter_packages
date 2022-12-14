import 'dart:io' show stdin, exit;

typedef Action = Future<void> Function();

abstract class IAction {
  Future<void> call();
}

abstract class ConditionalAction extends IAction {
  bool get shouldRun;

  @override
  Future<void> call() async {
    if (!shouldRun) return;
    await whenRequired();
  }

  Future<void> whenRequired();
}

abstract class GrantedAction extends ConditionalAction {
  void requestPermission();

  void onDenied();

  Future<void> onAllowed();

  @override
  Future<void> whenRequired() async {
    requestPermission();
    if (_isDenied()) {
      onDenied();
      exit(1);
    }

    await onAllowed();
  }

  bool _isDenied() {
    final input = stdin.readLineSync()?.toString() ?? '';
    return input.isNotEmpty && input.toUpperCase() != 'Y';
  }
}
