import 'dart:math' show Random;
import 'package:flutter/material.dart';

class AnimatedScreen extends StatefulWidget {
  static const name = 'animated_screen';

  const AnimatedScreen({super.key});

  @override
  State<AnimatedScreen> createState() => _AnimatedScreenState();
}

class _AnimatedScreenState extends State<AnimatedScreen> {
  double width = 50;
  double height = 50;
  Color color = Colors.indigo;
  double borderRadius = 10.0;

  void changeShape() {
    final ramdom = Random();

    width = ramdom.nextInt(300) + 120;
    height = ramdom.nextInt(450) + 120;
    borderRadius = ramdom.nextInt(50) + 20.0;

    color = Color.fromRGBO(
        ramdom.nextInt(255), //red
        ramdom.nextInt(255), //green
        ramdom.nextInt(255), // blue
        1 //opacity
        );

    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Animated Container'),
      ),
      body: Center(
        child: AnimatedContainer(
          curve: Curves.bounceOut,
          width: width,
          height: height,
          decoration: BoxDecoration(
              color: color,
              borderRadius:
                  BorderRadius.circular(borderRadius == 0 ? 10 : borderRadius)),
          duration: const Duration(milliseconds: 400),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => changeShape(),
        child: const Icon(Icons.play_arrow_rounded),
      ),
    );
  }
}
