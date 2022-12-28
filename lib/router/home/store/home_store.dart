import 'package:dua_example/dua/lib/structure.dart';
import 'package:flutter/cupertino.dart';

class User {
  int id;
  String name;

  User(this.id, this.name);

  @override
  String toString() {
    return '''
    ====> User <====
    id: $id
    name: $name
    ================
    ''';
  }

  @override
  bool operator ==(Object other) {
    if (other.runtimeType != runtimeType) return false;
    User o = other as User;
    return o.name == name && o.id == id;
  }
}

class HomeStore with Observable {
  HomeStore() {
    makeAutoObservable();
  }

  late var count = 0.ov(i);

  late var text = "yahoo".ov(i);

  late var user = User(1, "lilya").ov(i);

  setText(String v) {
    text.value = v;
    update();
  }

  setCount(int v) {
    count.value = v;
    update();
  }

  setUser(User v) {
    user.value = v;
    update();
  }
}
