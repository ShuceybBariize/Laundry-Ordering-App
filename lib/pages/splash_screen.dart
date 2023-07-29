import 'package:flutter/material.dart';
import 'package:flare_flutter/flare_actor.dart'; // Import FlareActor

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Use FlareActor to display a Flare animation or logo
            FlareActor(
              'assets/your_animation.flr', // Replace with your Flare animation file
              animation:
                  'animation_name', // Replace with your animation name (if applicable)
              fit: BoxFit.contain,
              alignment: Alignment.center,
            ),
            SizedBox(height: 16),
            Text(
              'Your App Name',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
