import 'package:flutter/material.dart';

class Unknown extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _Unknown();
}

class _Unknown extends State<Unknown> {
  @override
  Widget build(BuildContext context) {
    return (Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("Page Not Found", style: TextStyle(fontSize: 26, color: Color(0xFF000000))),
          TextButton(
              onPressed: () {},
              child: const Text(
                "Go Back",
                style: TextStyle(fontSize: 16, color: Colors.blue),
              )),
        ],
      ),
    ));
  }
}
