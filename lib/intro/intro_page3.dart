// ignore_for_file: prefer_const_constructors, prefer_const_literals_to_create_immutables

import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';

class IntroPage3 extends StatelessWidget {
  const IntroPage3({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 25.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              SizedBox(height: 60,),
              Lottie.network(
                'https://lottie.host/6ea6bf36-279c-4ffa-9771-48158092f650/LZnnWLcz7H.json',
                animate: true,
              ),
              SizedBox(height: 20,),
              Text('Be more creative and shareable',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 23, 4, 92),
                  fontSize: 24,
                  height: 2,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10,),
              Text('Be more creative and shareable, you will be closer to people who share the same interests',
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: Color.fromARGB(255, 121, 126, 203),
                  height: 2,
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}