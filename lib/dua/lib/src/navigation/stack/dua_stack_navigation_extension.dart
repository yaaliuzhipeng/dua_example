import 'package:dua/structure.dart';
import 'package:flutter/widgets.dart';
import './dua_stack_navigation_delegate.dart';

extension DuaStackNavigationBuildContextExtension on BuildContext {
  void navigate(String name, {Object? params, bool? forResult}) {
    DuaStackNavigationDelegate.of(this).navigate(name, params: params, forResult: forResult);
  }

  /// 基本等同于 pop、但如果传入对应路由名、则会将找到的最后一个对应路由名的路由之上的路由全部弹出
  void goBack({String? name, Object? result}) {
    DuaStackNavigationDelegate.of(this).goBack(name: name, result: result);
  }

  /// 重置导航栈、传入state的映射作为参数、以提供完全的自定义路由栈的能力
  void reset(NavigationResetCallack callack) {
    DuaStackNavigationDelegate.of(this).reset(callack);
  }

  Object? getRouteParams(String key) {
    return DuaStackNavigationDelegate.of(this).getRouteParams(key);
  }

  Object? getRouteResult(String key) {
    return DuaStackNavigationDelegate.of(this).getRouteResult(key);
  }
}

extension DuaStackNavigationStringExtension on String {
  void go() {
    var delegate = Dio.find<DuaStackNavigationDelegate>();
    delegate?.navigate(this);
  }

  void goForResult() {
    var delegate = Dio.find<DuaStackNavigationDelegate>();
    delegate?.navigate(this, forResult: true);
  }

  void goBack({Object? result}) {
    var delegate = Dio.find<DuaStackNavigationDelegate>();
    bool isEmptyString = this == "";
    delegate?.goBack(name: isEmptyString ? null : this, result: result);
  }
}
