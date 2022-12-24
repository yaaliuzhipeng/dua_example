import 'package:flutter/material.dart';

extension ModalExtension on BuildContext {
  int showModal(dynamic widget) {
    return Modal.show(widget);
  }

  void hideModal(int hashcode) {
    Modal.hide(hashcode);
  }
}

/// Modal
/// 对外导出快捷类、用于展示和隐藏浮层
class Modal {
  static int show(dynamic widget) {
    _ModalChangeNotifier.shared.setModal(action: 1, widget: widget, code: null);
    return widget.hashCode;
  }

  static void hide(int widget) {
    _ModalChangeNotifier.shared.setModal(action: 0, widget: null, code: widget);
  }
}

/// @widget ModalProvider
/// 浮层容器、用以接收以及展示浮层
class ModalProvider extends StatefulWidget {
  ModalProvider({Key? key});

  @override
  ModalProviderState createState() => ModalProviderState();
}

class ModalProviderState extends State<ModalProvider> {
  List<dynamic> modals = [];

  void show(dynamic widget) {
    int index = modals.indexWhere((el) => el.hashCode == widget.hashCode);
    if (index == -1) {
      modals.add(widget);
      setState(() {});
      return;
    }
    modals.removeAt(index);
    modals.insert(index, widget);
    setState(() {});
  }

  void hide(int code) {
    int index = modals.indexWhere((el) => el.hashCode == code);
    if (index != -1) {
      modals.removeAt(index);
      setState(() {});
    }
  }

  @override
  void initState() {
    _ModalChangeNotifier.shared.addListener(() {
      //展示浮层、清除数据
      int? action = _ModalChangeNotifier.shared.modal['action'];
      if (action == null) return;
      if (action == 1) {
        var widget = _ModalChangeNotifier.shared.modal['widget'];
        if (widget != null) {
          show(widget);
        }
      } else {
        var code = _ModalChangeNotifier.shared.modal['code'];
        if (code != null) {
          hide(code);
        }
      }
      _ModalChangeNotifier.shared.clear();
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      fit: StackFit.expand,
      children: [for (var m in modals) m],
    );
  }
}

class _ModalChangeNotifier extends ChangeNotifier {
  static _ModalChangeNotifier? _instance;
  static _ModalChangeNotifier get shared => _instance ??= _ModalChangeNotifier();

  static final Map<String, dynamic> _defaultModal = {
    'action': null,
    'code': null,
    'widget': null,
  };
  Map<String, dynamic> modal = _defaultModal;

  void setModal({
    int? action, //  0 => remove modal | 1 => show modal
    int? code,
    Widget? widget,
  }) {
    modal = {'action': action, 'code': code, 'widget': widget};
    notifyListeners();
  }

  void clear() {
    modal = _defaultModal;
  }
}
