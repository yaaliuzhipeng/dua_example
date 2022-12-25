import 'package:flutter/widgets.dart';

import '../../appstructure/dio.dart';
import './dua_stack_navigation_delegate.dart';

mixin DuaNavigationParamResultMixin {
  /// 从dependency中获取delegate、拿取参数
  /// 要求必须注入delegate依赖
  Object? get routeParams {
    DuaStackNavigationDelegate? delegate = Dio.find<DuaStackNavigationDelegate>();
    assert(delegate != null,
        "you have to inject DuaStackNavigationDelegate with Dio manually or set injectDelegateDependency to true through DuaStackNavigationDelegateBuilder before use this get property");
    return delegate!.getRouteParams(name);
  }

  ///
  Object? get routeResult {
    DuaStackNavigationDelegate? delegate = Dio.find<DuaStackNavigationDelegate>();
    assert(delegate != null,
        "you have to inject DuaStackNavigationDelegate with Dio manually or set injectDelegateDependency to true through DuaStackNavigationDelegateBuilder before use this get property");
    return delegate!.getRouteResult(name);
  }

  //override required
  String get name;

  ///
  ///context version
  Object? getRouteParams(BuildContext context) {
    return DuaStackNavigationDelegate.of(context).getRouteParams(name);
  }

  Object? getRouteResult(BuildContext context) {
    return DuaStackNavigationDelegate.of(context).getRouteResult(name);
  }
}
