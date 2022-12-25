import './dua_route_information_parser.dart';
import './dua_stack_navigation_delegate.dart';
import 'package:flutter/widgets.dart';

class DuaStackNavigationDelegateBuilder {
  DuaRouteInformationParser? _duaRouteInformationParser;
  DuaStackNavigationDelegate? _duaStackNavigationDelegate;
  DuaBackButtonDispatcher? _duaBackButtonDispatcher;
  RouterConfig<Object>? _routerConfig;

  Route<dynamic>? Function(RouteSettings)? _onUnknownRoute;
  List<NavigatorObserver>? _observers;
  String? _initialPage;
  List<DuaStackNavigationPage>? _pages;

  bool isPagesValide() => _pages != null && _pages!.isNotEmpty;

  DuaStackNavigationDelegateBuilder() {
    _duaRouteInformationParser = DuaRouteInformationParser();
  }

  DuaStackNavigationDelegateBuilder.fill({
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

  DuaStackNavigationDelegateBuilder setOnUnknownRoute(Route<dynamic>? Function(RouteSettings)? onUnknownRoute) {
    _onUnknownRoute = onUnknownRoute;
    return this;
  }

  DuaStackNavigationDelegateBuilder setObservers(List<NavigatorObserver>? observers) {
    _observers = observers;
    return this;
  }

  DuaStackNavigationDelegateBuilder setInitialPage(String? initialPage) {
    _initialPage = initialPage;
    return this;
  }

  DuaStackNavigationDelegateBuilder setPages(List<DuaStackNavigationPage>? pages) {
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
    _duaStackNavigationDelegate = DuaStackNavigationDelegate(
      pages: _pages!,
      observers: _observers ?? [],
      initialPage: _initialPage,
      onUnknownRoute: _onUnknownRoute,
    );
    _duaBackButtonDispatcher = DuaBackButtonDispatcher(_duaStackNavigationDelegate!);
    _routerConfig = RouterConfig(
      routeInformationProvider: PlatformRouteInformationProvider(initialRouteInformation: RouteInformation(location: initialLocation, state: null)),
      routerDelegate: _duaStackNavigationDelegate!,
      routeInformationParser: _duaRouteInformationParser,
      backButtonDispatcher: _duaBackButtonDispatcher,
    );
    return _routerConfig!;
  }
}
