import 'package:flutter/material.dart';

class MyCircle extends StatelessWidget {
  const MyCircle({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        children: [
          ClipOval(
            child: SizedBox(
              width: 50,
              height: 50,
              child: Image.asset('lib/images/user.png'),
            ),
          ),
          Text('abc')
        ],
      ),
    );
  }
}