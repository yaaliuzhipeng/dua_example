
typedef BackHandlerInvoker = Future<bool> Function();

class DuaBackHandler {
  static DuaBackHandler? _instance;

  static DuaBackHandler get shared => _instance ??= DuaBackHandler();

  final List<BackHandlerInvoker> _invokers = <BackHandlerInvoker>[];

  void addInvoker(BackHandlerInvoker invoker) {
    _invokers.add(invoker);
  }

  void pop() {
    if (_invokers.isNotEmpty) _invokers.removeLast();
  }

  BackHandlerInvoker? get invoker => _invokers.isEmpty ? null : _invokers.last;
}