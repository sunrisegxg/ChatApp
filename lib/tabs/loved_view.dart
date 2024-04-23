import 'package:flutter/material.dart';

class LovedView extends StatefulWidget {
  const LovedView({super.key});

  @override
  State<LovedView> createState() => _LovedViewState();
}

class _LovedViewState extends State<LovedView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text("Loved view"),
    );
  }
}