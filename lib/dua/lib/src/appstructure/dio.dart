class _Factory {
  _Factory({
    required this.type,
    this.tag,
    this.factory,
  });

  final String? tag;
  final String type;
  final dynamic factory;
}

class Dio {
  static Dio? _instance;

  static Dio get shared => _instance ??= Dio();

  static void put<D>(D object, {String? tag}) {
    Dio.shared._put<D>(object, tag: tag);
  }

  static void lazyPut<D>(D Function() factory, {String? tag}) {
    Dio.shared._lazyPut<D>(factory, tag: tag);
  }

  static D? find<D>([String? identity]) {
    var key = identity ?? D.toString();
    var obj = Dio.shared._find<D>(key);
    return obj;
  }

  static void remove(String identity) {
    Dio.shared._remove(identity);
  }

  final Map<String, dynamic> map = {};
  final Map<String, _Factory> _factories = {};

  void _put<D>(D object, {String? tag}) {
    var key = tag ?? D.toString();
    map[key] = object;
  }

  void _lazyPut<D>(D Function() factory, {String? tag}) {
    var key = tag ?? D.toString();
    _factories[key] = _Factory(type: D.toString(), tag: tag, factory: factory);
  }

  //identity => runtimeType(string) | tag
  D? _find<D>(String identity) {
    var fac = _factories[identity];
    if (fac != null) {
      var obj = fac.factory();
      if (D.toString() == obj.runtimeType.toString()) {
        map[fac.tag ?? fac.type] = obj;
        _factories.remove(identity);
        return obj;
      } else {
        return null;
      }
    }
    return map[identity];
  }

  void _remove(String identity) {
    map.remove(identity);
  }
}
