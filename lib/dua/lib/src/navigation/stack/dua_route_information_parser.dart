import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

class DuaRouteInformationParser extends RouteInformationParser<String> {
  @override
  Future<String> parseRouteInformation(RouteInformation info) {
    // debugPrint("[DuaRouteInformationParser] 解析系统路由 location:${info.state} | state:${info.state}");
    return SynchronousFuture(info.location ?? '/404');
  }

  @override
  RouteInformation? restoreRouteInformation(String configuration) {
    // debugPrint("[DuaRouteInformationParser]重建路由信息，配置参数: $configuration");
    return RouteInformation(location: configuration);
  }
}
