import 'dart:math';

import 'package:flutter/material.dart';
import 'package:sensors/sensors.dart';

import 'speedometer.dart';

class SpeedometerContainer extends StatefulWidget {
  @override
  _SpeedometerContainerState createState() => _SpeedometerContainerState();
}

class _SpeedometerContainerState extends State<SpeedometerContainer> {
  double velocity = 0;
  double highestVelocity = 0.0;

  BoxDecoration _boxDecoration = BoxDecoration(
    color: Colors.black,
  );

  String getBottomText() {
    return 'Highest speed:\n${highestVelocity.toStringAsFixed(2)} km/h';
  }

  String getTopText() {
    if (highestVelocity > 20) {
      if (highestVelocity > 40) {
        if (highestVelocity > 60) {
          return 'Congrats! You are a sigma male now!';
        }
        return 'Congrats! You are a boxeur!';
      }
      return 'You are weak like Will Smith. Punch harder!';
    }
    return '';
  }

  @override
  void initState() {
    userAccelerometerEvents.listen((UserAccelerometerEvent event) {
      _onAccelerate(event);
    });
    super.initState();
  }

  void _onAccelerate(UserAccelerometerEvent event) {
    double newVelocity =
        sqrt(event.x * event.x + event.y * event.y + event.z * event.z);

    if ((newVelocity - velocity).abs() < 1) {
      return;
    }

    setState(() {
      velocity = newVelocity;

      if (velocity > highestVelocity) {
        highestVelocity = velocity;
      }

      if (highestVelocity > 60) {
        _boxDecoration = BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/>90.jpeg"), fit: BoxFit.cover),
        );
      } else if (highestVelocity > 40) {
        _boxDecoration = BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/>40.jpg"), fit: BoxFit.cover),
        );
      } else if (highestVelocity > 20) {
        _boxDecoration = BoxDecoration(
          image: DecorationImage(
              image: AssetImage("images/>20.jpg"), fit: BoxFit.cover),
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: _boxDecoration,
        child: Stack(children: [
          Container(
              padding: EdgeInsets.only(bottom: 64),
              alignment: Alignment.bottomCenter,
              child: Text(
                getBottomText(),
                style: TextStyle(color: Colors.white, fontSize: 25),
                textAlign: TextAlign.center,
              )),
          Center(
              child: Speedometer(
            speed: velocity,
            speedRecord: highestVelocity,
          )),
          Container(
              padding: EdgeInsets.only(top: 64),
              alignment: Alignment.topCenter,
              child: Text(
                getTopText(),
                style: TextStyle(color: Colors.white, fontSize: 25),
                textAlign: TextAlign.center,
              )),
        ]));
  }
}
