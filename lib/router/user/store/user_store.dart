import 'package:dua_example/dua/lib/structure.dart';

class UserStore with Observable {
  UserStore() {
    makeAutoObservable();
  }
  late var count = 0.ov(i);

  late var text = "yahoo".ov(i);

  setText(String v) {
    text.value = v;
    update();
  }

  setCount(int v) {
    count.value = v;
    update();
  }
}
