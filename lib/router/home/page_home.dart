import 'package:dua_example/dua/lib/dua.dart';
import 'package:dua_example/dua/lib/navigation.dart';
import 'package:dua_example/dua/lib/animation.dart';
import 'package:dua_example/router/home/store/home_store.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Home();
}

class _Home extends State<Home> {
  final style = const TextStyle(fontSize: 18, color: Colors.blue);

  bool visible = false;

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.add),
        onPressed: () {
          setState(() {
            visible = !visible;
          });
        },
      ),
      body: SizedBox.expand(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // SlideInOutLayoutAnimationWidget(visible: visible, child: ModalContentView()),
            const ModalContentView().slideInDown(),
            // const ModalBackgroundView().fade(to: 0.3)
          ],
        ),
      ),
    );
  }
}

class ModalContentView extends StatelessWidget {
  const ModalContentView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 320,
      height: 600,
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 6, spreadRadius: 3),
        ],
        borderRadius: const BorderRadius.only(topLeft: Radius.circular(12), topRight: Radius.circular(12)),
      ),
    );
  }
}

class ModalBackgroundView extends StatelessWidget {
  const ModalBackgroundView({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(color: Colors.black, width: 375, height: 800);
  }
}
