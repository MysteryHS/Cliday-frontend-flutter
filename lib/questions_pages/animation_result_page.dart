import 'dart:math';

import 'package:flutter/material.dart';

class RotationTransitionExample extends StatefulWidget {
  const RotationTransitionExample({
    Key? key,
    required this.child,
    required this.delay,
    required this.duration,
    this.nbOfTurns = 1,
  }) : super(key: key);

  final Widget child;
  final Duration delay;
  final Duration duration;
  final int nbOfTurns;

  @override
  _RotationTransitionState createState() => _RotationTransitionState();
}

class _RotationTransitionState extends State<RotationTransitionExample>
    with TickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _rotateX;

  @override
  initState() {
    super.initState();
    _controller = AnimationController(
      duration: widget.duration,
      vsync: this,
    );
    double begin = 1;
    double end = 0;
    _rotateX = Tween<double>(
      begin: begin,
      end: end,
    )
        .chain(
          TweenSequence(getTweenSequenceItem(widget.nbOfTurns)),
        )
        .animate(
          CurvedAnimation(
            parent: _controller,
            curve: Curves.easeOutCubic,
          ),
        );
    Future.delayed(widget.delay, () {
      setState(() {
        _controller.forward();
      });
    });
  }

  @override
  dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        return Transform(
          transform: Matrix4.rotationX(_rotateX.value * pi),
          alignment: Alignment.center,
          child: widget.child,
        );
      },
    );
  }
}

List<TweenSequenceItem<double>> getTweenSequenceItem(int nbOfTurns) {
  //Here we start at 1/2 to make the circle disapear (its rotation makes it
  //on the vertical plan) and then add as many turns as needed.
  List<TweenSequenceItem<double>> list = [];
  if (nbOfTurns == 0) {
    return list;
  }
  list.add(TweenSequenceItem(
    tween: Tween(begin: 1 / 2, end: 1),
    weight: 1,
  ));
  for (int i = 1; i < nbOfTurns; i++) {
    list.add(TweenSequenceItem(
      tween: Tween(begin: 1, end: 0),
      weight: 1,
    ));
  }
  return list;
}
