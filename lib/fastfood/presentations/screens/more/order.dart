import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class OrderScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Order Screen'),
      ),
      body: Center(
        child: Text('This is the Order Screen'),
      ),
    );
  }
}