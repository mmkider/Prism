import 'package:flutter/material.dart';

class ConnectivityWidget extends StatefulWidget {
  @override
  _ConnectivityWidgetState createState() => _ConnectivityWidgetState();
}

class _ConnectivityWidgetState extends State<ConnectivityWidget>
    with SingleTickerProviderStateMixin {
  bool dontAnimate;

  AnimationController animationController;

  @override
  @mustCallSuper
  void initState() {
    super.initState();
    animationController = AnimationController(
        duration: const Duration(milliseconds: 500), vsync: this);
    Future.delayed(Duration(seconds: 1)).then((value) {
      this.animationController.forward();
    });
    Future.delayed(Duration(seconds: 10))
        .then((value) => {this.animationController.reverse()});
  }

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomCenter,
      child: SlideTransition(
        position: animationController.drive(Tween<Offset>(
          begin: const Offset(0.0, 1.0),
          end: Offset.zero,
        ).chain(CurveTween(
          curve: Curves.fastOutSlowIn,
        ))),
        child: OfflineBanner(),
      ),
    );
  }
}

class OfflineBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(2),
      width: double.infinity,
      color: Colors.red,
      child: Text(
        "No Internet",
        style: TextStyle(
          fontSize: 10,
          color: Colors.white,
          fontWeight: FontWeight.bold,
          fontFamily: 'Proxima Nova',
        ),
        textAlign: TextAlign.center,
      ),
    );
  }
}
