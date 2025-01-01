import 'package:flutter/material.dart';

class IconGenerator extends StatelessWidget {
  const IconGenerator({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 1024,
      height: 1024,
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [
            Color(0xFF1976D2), // Mavi
            Color(0xFF0D47A1), // Koyu Mavi
          ],
        ),
      ),
      child: Center(
        child: Stack(
          alignment: Alignment.center,
          children: [
            // Arka plan efekti
            Container(
              width: 600,
              height: 600,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: Colors.white.withOpacity(0.1),
              ),
            ),
            // Ana ikon
            Container(
              padding: const EdgeInsets.all(100),
              child: const Icon(
                Icons.currency_exchange,
                size: 400,
                color: Colors.white,
              ),
            ),
            // Parlaklık efekti
            Positioned(
              top: 200,
              left: 200,
              child: Container(
                width: 100,
                height: 100,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withOpacity(0.2),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
