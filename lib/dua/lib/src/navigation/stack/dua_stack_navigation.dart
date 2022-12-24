import 'dart:math';

import '../page/default_unknown_page.dart';
import 'dua_navigation_focus_mixin.dart';
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

class DuaNavigationRoute {
  DuaNavigationRoute({
    required this.name,
    String? key,
    this.params,
  }) {
    this.key = key ?? "name-${DateTime.now().millisecondsSinceEpoch}";
  }

  late String key;
  String name;
  Object? params;
}

class DuaNavigationState {
  DuaNavigationState({
    List<DuaNavigationRoute>? routes,
    int? index,
    this.result,
  }) {
    this.routes = routes ?? [];
    this.index = index ?? 0;
  }

  late List<DuaNavigationRoute> routes;
  late int index;
  Object? result;

  List<String> get routeNames => List.unmodifiable(routes.map((e) => e.name));
}

class DuaStackNavigationPage {
  DuaStackNavigationPage(this.name, this.page);

  final String name;
  final Page page;
}

typedef NavigationResetCallack = List<DuaNavigationRoute> Function(List<DuaNavigationRoute> currentRoutes);

class DuaStackNavigationBuilder {
  DuaRouteInformationParser? _duaRouteInformationParser;
  DuaStackNavigation? _duaStackNavigation;

  Route<dynamic>? Function(RouteSettings)? _onUnknownRoute;
  List<NavigatorObserver>? _observers;
  String? _initialPage;
  List<DuaStackNavigationPage>? _pages;

  bool isPagesValide() => _pages != null && _pages!.isNotEmpty;

  DuaStackNavigationBuilder() {
    _duaRouteInformationParser = DuaRouteInformationParser();
  }

  DuaStackNavigationBuilder.fill({
    Route<dynamic>? Function(RouteSettings)? onUnknownRoute,
    List<NavigatorObserver>? observers,
    String? initialPage,
    List<DuaStackNavigationPage>? pages,
  })  : _onUnknownRoute = onUnknownRoute,
        _observers = observers,
        _initialPage = initialPage,
        _pages = pages {
    _duaRouteInformationParser = DuaRouteInformationParser();
  }

  DuaStackNavigationBuilder setOnUnknownRoute(Route<dynamic>? Function(RouteSettings)? onUnknownRoute) {
    _onUnknownRoute = onUnknownRoute;
    return this;
  }

  DuaStackNavigationBuilder setObservers(List<NavigatorObserver>? observers) {
    _observers = observers;
    return this;
  }

  DuaStackNavigationBuilder setInitialPage(String? initialPage) {
    _initialPage = initialPage;
    return this;
  }

  DuaStackNavigationBuilder setPages(List<DuaStackNavigationPage>? pages) {
    _pages = pages;
    return this;
  }

  RouterConfig<Object> build() {
    assert(isPagesValide(), "pages cannot leave empty");
    var initialLocation = "/";
    if (_initialPage != null) {
      var matched = false;
      for (var p in (_pages ?? <DuaStackNavigationPage>[])) {
        if (p.name == _initialPage) {
          matched = true;
          break;
        }
      }
      assert(matched, "initial page named: $_initialPage is not found in pages");
      initialLocation = _initialPage!;
    }
    _duaStackNavigation = DuaStackNavigation(
      pages: _pages!,
      observers: _observers ?? [],
      initialPage: _initialPage,
      onUnknownRoute: _onUnknownRoute,
    );
    return RouterConfig(
      routeInformationProvider: PlatformRouteInformationProvider(initialRouteInformation: RouteInformation(location: initialLocation, state: null)),
      routerDelegate: _duaStackNavigation!,
      routeInformationParser: _duaRouteInformationParser,
    );
  }
}

class DuaStackNavigation extends RouterDelegate<String> with PopNavigatorRouterDelegateMixin, ChangeNotifier, DuaNavigationFocusEmitterMixin {
  DuaStackNavigation({
    this.onUnknownRoute,
    this.observers = const [],
    this.initialPage,
    required this.pages,
  }) : assert(pages.isNotEmpty, "navigation pages cannot be empty!") {
    constructPageIndex();
  }

  final Route<dynamic>? Function(RouteSettings)? onUnknownRoute;
  final List<NavigatorObserver> observers;
  final String? initialPage;
  final List<DuaStackNavigationPage> pages;
  final Map<String, DuaStackNavigationPage> pagesIndex = {};

  String get _initialPage => initialPage ?? (pages.isEmpty ? '/' : pages.first.name);

  bool isInitialPage(String page) {
    return page == _initialPage || page == '/';
  }

  void constructPageIndex() {
    for (var p in pages) {
      pagesIndex[p.name] = p;
    }
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => GlobalKey<NavigatorState>();

  static DuaStackNavigation of(BuildContext context) {
    var routerDelegate = Router.of(context).routerDelegate;
    return routerDelegate as DuaStackNavigation;
  }

  /// 前一个路由跳转时是否请求了结果
  /// navigate[forResult]值为true将会设置 该值为对应的路由name
  /// 在goBack时将判断返回后栈顶是否为navigatedForResultRoute、匹配上则更新state中路由对应的result属性
  String? navigatedForResultRoute;
  final DuaNavigationState state = DuaNavigationState(
    routes: [],
    index: 0,
    result: null,
  );

  List get stack => List.unmodifiable(state.routeNames);

  @override
  String? get currentConfiguration => stack.isEmpty ? null : stack.last;

  @override
  Widget build(BuildContext context) {
    // debugPrint(">>>>>>>> DuaStackNavigation build 执行 <<<<<<<<<");
    List<Page> pages = [];

    /// stack 中首个路由在 setNewRoutePath中进行了判断处理、等同于传入的页面数组首个页面的 name
    /// 因此这里不再需要进行 '/' 判断
    for (var s in stack) {
      var p = pagesIndex[s];
      assert(p != null, "route named ${s} is not found in the pages");
      pages.add(p!.page);
    }
    dispatchFocus(stack.last);
    return Navigator(
      pages: pages,
      onPopPage: _onPopPage,
      observers: observers,
      onUnknownRoute: onUnknownRoute ?? buildDefaultUnknownRouteFactory,
    );
  }

  @override
  Future<void> setInitialRoutePath(String configuration) {
    return setNewRoutePath(configuration);
  }

  @override
  Future<void> setNewRoutePath(String configuration) {
    state.routes
      ..clear()
      ..add(DuaNavigationRoute(name: configuration == '/' ? _initialPage : configuration));
    return SynchronousFuture<void>(null);
  }

  bool _onPopPage(Route<dynamic> route, result) {
    if (stack.isNotEmpty && route.settings.name == stack.last) {
      state.routes.removeLast();
      notifyListeners();
    }
    return route.didPop(result);
  }

  /// 对外导出导航处理方法
  ///
  /// 导航跳转、navigate基本等同于 push
  void navigate(String name, {Object? params, bool? forResult}) {
    var route = DuaNavigationRoute(name: name, params: params);
    if (forResult ?? false) {
      navigatedForResultRoute = route.key;
    }
    state.routes.add(route);
    state.index = max(state.routes.length - 1, 0);
    notifyListeners();
  }

  /// 基本等同于 pop、但如果传入对应路由名、则会将找到的最后一个对应路由名的路由之上的路由全部弹出
  void goBack({String? name, Object? result}) {
    if (name == null) {
      if (stack.isNotEmpty) {
        state.routes.removeLast();
      }
    } else {
      int index = stack.lastIndexOf(name);
      if (index == -1) return;
      state.routes.removeRange(index + 1, state.routes.length);
    }
    state.index = max(state.routes.length - 1, 0);
    if (result != null && state.routes.last.key == navigatedForResultRoute) {
      state.result = result;
    }
    notifyListeners();
  }

  /// reset
  /// 重置导航栈、传入state的映射作为参数、以提供完全的自定义路由栈的能力
  void reset(NavigationResetCallack callack) {
    var routes = callack(state.routes);
    state.routes = routes;
    state.index = max(routes.length - 1, 0);
    notifyListeners();
  }

  Object? getRouteParams(String key) {
    int index = state.routes.lastIndexWhere((element) => element.key == key);
    if (index != -1) {
      return state.routes[index].params;
    }
    return null;
  }

  Object? getRouteResult(String key) {
    if (state.routes.isNotEmpty && state.routes.last.key == key) {
      return state.result;
    }
    return null;
  }
}
