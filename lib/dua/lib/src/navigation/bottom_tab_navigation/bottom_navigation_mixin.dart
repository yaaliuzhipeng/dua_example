import '../../appstructure/broadcast.dart';

const String bottomNavigationEventName = 'BOT_NAVIGATION_EVENT';
mixin BottomNavigationMixin {
  void Function([bool? all])? off;

  void addBottomNavigationListener({
    void Function(int page)? onChangeCurrentPage,
  }) {
    off = Broadcast.shared.addListener(bottomNavigationEventName, (data) {
      if (data['type'] == 'setCurrentPage') {
        var value = data['value'];
        if (onChangeCurrentPage != null) onChangeCurrentPage(value);
      }
    });
  }

  void disposeBottomNavigationListener() {
    if (off != null) off!();
  }
}
