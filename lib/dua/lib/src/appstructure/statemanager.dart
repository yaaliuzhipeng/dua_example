import 'dart:collection';
import 'dart:convert';
import 'dart:developer';
import 'package:flutter/widgets.dart';

///
/// 状态管理中心
///
/// 监听者widget无法知晓使用了哪些观察者、监听者可以在依赖数组中声明使用了哪些观察者值
/// 观察者类每次批更新都知道哪些观察者值执行了set方法
///

class PendingUpdate {
  final int observable;
  final List<int> observableValues;

  PendingUpdate(this.observable, this.observableValues);
}

class DuaStateManager {
  static DuaStateManager? _instance;

  static DuaStateManager get shared => _instance ??= DuaStateManager();

  void openDebugLog() {
    _debugLogEnabled = true;
  }

  bool _debugLogEnabled = false;

  void _log(String msg) {
    if (_debugLogEnabled) log("【DuaStateManager - ⚠️】$msg");
  }

  /// 观察者类标记数组 List<hashCode>
  final List<int> _obsObservables = [];
  final List<int> _frozenObservables = [];

  // 注册的观察者类
  List<int> get obsObservables => List.unmodifiable(_obsObservables);

  // 冻结的观察者类
  List<int> get frozenObservables => List.unmodifiable(_frozenObservables);

  /// 暂存的观察者值更新响应批次
  /// int observable, List<int> observableValues
  List<PendingUpdate> pendingUpdateBatches = [];

  /// 监听者类标记数组
  /// 不响应、响应全部、仅响应部分
  final List<int> _obsEmptyDepObserver = [];
  final List<int> _obsAllDepObserver = [];
  final List<int> _obsIncludeDepObserver = [];

  // 索引、 key为观察值、value为依赖该观察值的监听者组件
  final Map<int, List<int>> _observableValueRelObservers = {};

  // 观察者组件刷新通知器映射Map
  final Map<int, _ObserverUpdateNotifier> _notifiers = {};

  List<int> get obsEmptyDepObserver => List.unmodifiable(_obsEmptyDepObserver);

  List<int> get obsAllDepObserver => List.unmodifiable(_obsAllDepObserver);

  List<int> get obsIncludeDepObserver => List.unmodifiable(_obsIncludeDepObserver);

  /// 记录一个 Observable Class实例、标记为观察者
  void markObservableClass(dynamic cls) {
    var contains = obsObservables.contains(cls.hashCode);
    if (!contains) {
      _log("标记一个新的观察类: ${cls.runtimeType} | ${cls.hashCode}");
      _obsObservables.add(cls.hashCode);
    }
  }

  ///移除Observable Class观察者以及其内部注册的观察值
  void unmarkObservableClass(dynamic cls, List<int> observableValues) {
    int ind = obsObservables.indexOf(cls.hashCode);
    if (ind != -1) {
      _obsObservables.removeAt(ind);
    }
    pendingUpdateBatches.removeWhere((element) => element.observable == cls.hashCode);
  }

  /// 标记一个 Observalbe Class实例冻结状态、通常为跳转到另一个页面时，前一个页面用到的实例观察者临时冻结不用进行通知
  void toggleObservableFrozen(int code, bool frozen) {
    int ind = frozenObservables.indexOf(code);
    if (frozen) {
      if (ind == -1) _frozenObservables.add(code);
    } else {
      if (ind != -1) _frozenObservables.removeAt(ind);
    }
  }

  /// 记录一个 Observer Widget、标记为监听者
  /// - 依赖数组为 null 则非frozen观察者更新时将会通知该监听者
  /// - 依赖数组为 [] 则任何观察者更新都不会去通知该监听者
  /// - 依赖数组为 [A,B] 则仅当 A 或 B 的值更新时才会通知该监听者
  ///
  /// @param code => 当前监听者组件的标识
  /// @param deps => 当前监听者组件依赖的观察值
  /// @param notifier => 当前监听者刷新通知器
  void markObserverWidget(int code, List<dynamic>? deps, _ObserverUpdateNotifier notifier) {
    _notifiers[code] = notifier;
    // _log("标记监听者组件: $code   deps: $deps");
    if (deps == null) {
      if (!obsAllDepObserver.contains(code)) _obsAllDepObserver.add(code);
    } else if (deps.isEmpty) {
      if (!obsEmptyDepObserver.contains(code)) _obsEmptyDepObserver.add(code);
    } else {
      if (!obsIncludeDepObserver.contains(code)) _obsIncludeDepObserver.add(code);
      for (var dep in deps) {
        if (dep is OvValue) {
          int vc = dep.hashCode;
          if (_observableValueRelObservers[vc] != null) {
            //索引有该观察值、且存在关联数组
            if (!_observableValueRelObservers[vc]!.contains(code)) _observableValueRelObservers[vc]!.add(code);
          } else {
            //索引中不存在该观察值或者存在但是没有关联数组
            _observableValueRelObservers[vc] = [code];
          }
          _log("观察值 $vc 现在的关联监听者数组为 => ${_observableValueRelObservers[vc]}");
        } else {
          continue;
        }
      }
    }
  }

  /// 组件销毁时移除监听标记
  void unmarkObserverWidget(int code, List<dynamic>? deps) {
    _notifiers.remove(code);
    if (deps == null) {
      int ind = obsAllDepObserver.indexOf(code);
      if (ind != -1) _obsAllDepObserver.removeAt(ind);
    } else if (deps.isEmpty) {
      int ind = obsEmptyDepObserver.indexOf(code);
      if (ind != -1) _obsEmptyDepObserver.removeAt(ind);
    } else {
      int ind = obsIncludeDepObserver.indexOf(code);
      if (ind != -1) _obsIncludeDepObserver.removeAt(ind);
      for (var dep in deps) {
        if (dep is OvValue) {
          int vc = dep.hashCode;
          if (_observableValueRelObservers[vc] != null && _observableValueRelObservers[vc]!.contains(code)) {
            //索引有该观察值、且存在关联数组
            _observableValueRelObservers[vc]!.remove(code);
          }
          _log("观察值 $vc 移除监听者 $code 后的关联监听者数组为 => ${_observableValueRelObservers[vc]}");
        } else {
          continue;
        }
      }
    }
  }

  /// 通知本管理中心有值发生变更、需要更新
  /// @param observable => 哪一个注册的观察者
  /// @param observableValues => 本更新批次中观察者的哪些观察值变更了
  ///
  void requireUpdate(int observable, List<int> observableValues) {
    _log("要求更新的观察者类: $observable 以及观察者值: $observableValues");
    if (!obsObservables.contains(observable)) {
      _log("❌ 观察者已经销毁");
      return;
    }
    if (frozenObservables.contains(observable)) {
      _log("❄️观察者$observable当前已冻结、不进行通知");
      pendingUpdateBatches.add(PendingUpdate(observable, observableValues));
      return;
    }
    // 1. 通知所有未设置依赖的监听者
    for (int obr in obsAllDepObserver) {
      _notifiers[obr]?.up();
      _log("通知未设置依赖的监听者, ${_notifiers[obr]}");
    }
    // 2. 通知当前变更值下关联的监听者
    for (int obev in observableValues) {
      //遍历当前 观察值 下面关联的监听者、通知刷新
      for (int obr in (_observableValueRelObservers[obev] ?? [])) {
        // _log("通知观察值下的监听者: ${_notifiers[obr]}");
        _notifiers[obr]?.up();
      }
    }
  }

  void requirePendingUpdate(int observable) {
    var values = _allPendingUpdate(observable);
    requireUpdate(observable, values);
  }

  List<int> _allPendingUpdate(int observable) {
    List<int> values = [];
    List<PendingUpdate> updates = List.from(pendingUpdateBatches);
    while (true) {
      PendingUpdate? update;
      int index = -1;
      for (var i = 0; i < updates.length; i++) {
        if (updates[i].observable == observable) {
          update = updates[i];
          index = i;
          break;
        }
      }
      if (update == null) break;
      values.addAll(update.observableValues);
      updates.removeAt(index);
    }
    //更新合并了observable后的 pendingUpdateBatches
    pendingUpdateBatches = updates;
    return values.toSet().toList();
  }
}

// 用于拓展需要成为观察者的类
mixin Observable {
  final List<int> batchChangedValues = [];
  final List<int> observalbeValues = [];

  void _markChangedValue(int code) {
    if (!batchChangedValues.contains(code)) batchChangedValues.add(code);
  }

  void _registerObservableValue(int code) {
    if (!observalbeValues.contains(code)) observalbeValues.add(code);
  }

  List<dynamic> get i => [hashCode, _markChangedValue, _registerObservableValue];

  void makeAutoObservable() {
    DuaStateManager.shared.markObservableClass(this);
  }

  void pause() {
    DuaStateManager.shared.toggleObservableFrozen(hashCode, true);
  }

  void resume() {
    DuaStateManager.shared.toggleObservableFrozen(hashCode, false);
    DuaStateManager.shared.requirePendingUpdate(hashCode);
  }

  void dispose() {
    DuaStateManager.shared.unmarkObservableClass(this, observalbeValues);
  }

  void update() {
    //clear batchChangedValues
    DuaStateManager.shared.requireUpdate(hashCode, batchChangedValues);
    batchChangedValues.clear();
  }
}

class Observer<T> extends StatefulWidget {
  Observer(this.builder, [this.deps]);

  Widget Function() builder;
  List<dynamic>? deps;

  @override
  State<StatefulWidget> createState() => _ObserverState();
}

class _ObserverState extends State<Observer> {
  final _ObserverUpdateNotifier notifier = _ObserverUpdateNotifier();
  late List<dynamic> deps = widget.deps ?? [];
  bool isMounted = true;

  @override
  void initState() {
    notifier.addListener(() {
      if (isMounted == false) return;
      setState(() {});
    });
    // 这里必须使用widget.deps 、deps是否为null也影响组件更新决策
    DuaStateManager.shared.markObserverWidget(hashCode, widget.deps, notifier);
    super.initState();
  }

  @override
  void dispose() {
    isMounted = false;
    DuaStateManager.shared.unmarkObserverWidget(hashCode, deps);
    notifier.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return widget.builder();
  }
}

class _ObserverUpdateNotifier extends ChangeNotifier {
  void up() {
    notifyListeners();
  }
}

class O extends Observer {
  O(super.builder, [super.deps]);
}

class OvValue<T> {
  OvValue(this._value, {List<dynamic>? observable}) {
    if (observable != null) {
      _hashcode = observable[0];
      _markChangedValue = observable[1];
      observable[2](hashCode);
    }
  }

  /// 内部存储值
  dynamic _value;

  /// 创建该观察者值所在的 观察者类实例
  int? _hashcode;
  void Function(int code)? _markChangedValue;

  T get value => _value;

  set value(T newValue) {
    if (newValue != value) _markChangedValue!(hashCode);
    _value = newValue;
  }
}

class OvObject extends OvValue {
  OvObject(Object value, [List<dynamic>? observable]) : super(value, observable: observable);

  @override
  Object get value => _value as Object;

  void setValue(Function() callback) {
    callback();
    _markChangedValue!(hashCode);
  }
}

class OvInt extends OvValue {
  OvInt(int value, [List<dynamic>? observable]) : super(value, observable: observable);

  @override
  int get value => _value as int;

  @override
  set value(dynamic value) {
    if (value is int) {
      _value = value;
    } else if (value is String) {
      _value = int.parse(value);
    }
    _markChangedValue!(hashCode);
  }
}

class OvDouble extends OvValue {
  OvDouble(double value, [List<dynamic>? observable]) : super(value, observable: observable);

  @override
  double get value => _value as double;

  @override
  set value(dynamic value) {
    if (value is double) {
      _value = value;
    } else if (value is String) {
      _value = double.parse(value);
    }
    _markChangedValue!(hashCode);
  }
}

class OvBool extends OvValue {
  OvBool(bool value, [List<dynamic>? observable]) : super(value, observable: observable);

  @override
  bool get value => _value as bool;

  @override
  set value(dynamic value) {
    if (value is bool) {
      _value = value;
    } else if (value is String) {
      _value = (value == '1' || value == 'YES') ? true : false;
    } else if (value is int || value is double) {
      _value = value > 0 ? true : false;
    }
    _markChangedValue!(hashCode);
  }
}

class OvString extends OvValue {
  OvString(String value, [List<dynamic>? observable]) : super(value, observable: observable);

  @override
  String get value => _value as String;

  @override
  set value(dynamic value) {
    if (value is String) {
      _value = value;
    }
    _markChangedValue!(hashCode);
  }
}

/// extensions
///

extension OvObjectValueExtension on Object {
  OvObject ov(List<dynamic>? observable) => OvObject(this, observable);
}

extension OvIntValueExtension on int {
  OvInt ov(List<dynamic>? observable) => OvInt(this, observable);
}

extension OvDoubleValueExtension on double {
  OvDouble ov(List<dynamic>? observable) => OvDouble(this, observable);
}

extension OvBoolValueExtension on bool {
  OvBool ov(List<dynamic>? observable) => OvBool(this, observable);
}

extension OvStringValueExtension on String {
  OvString ov(List<dynamic>? observable) => OvString(this, observable);
}
