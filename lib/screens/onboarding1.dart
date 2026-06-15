import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'onboarding2.dart';

class Onboarding1Screen extends StatelessWidget {
  final VoidCallback? onNext;

  const Onboarding1Screen({super.key, this.onNext});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: const Color(0xFFF9EFF2),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.06),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: h * 0.055),

              // Title
              Text(
                'Upload Your Photo',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 30,
                  fontWeight: FontWeight.w700,
                  color: const Color(0xFF1C1C1C),
                ),
              ),

              SizedBox(height: h * 0.015),

              // Subtitle
              Text(
                'Discover haircuts\nthat suit your face',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: 15,
                  color: const Color(0xFF9B7C88),
                  height: 1.5,
                ),
              ),

              SizedBox(height: h * 0.05),

              // Photo Frame
              Expanded(
                child: Center(
                  child: Container(
                    width: w * 0.82,
                    decoration: BoxDecoration(
                      color: const Color(0xFFFBF0F3),
                      borderRadius: BorderRadius.circular(30),
                    ),
                    child: Center(
                      child: ClipOval(
                        child: Image.asset(
                          'assets/images/onboarding1_portrait.png',
                          width: w * 0.62,
                          height: w * 0.82,
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Bottom Section
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Page Indicators
                    Row(
                      children: List.generate(3, (index) {
                        bool active = index == 0;

                        return Container(
                          margin: const EdgeInsets.only(right: 8),
                          width: active ? 10 : 8,
                          height: active ? 10 : 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: active
                                ? const Color(0xFFB76E8A)
                                : const Color(0xFFE8D2DA),
                          ),
                        );
                      }),
                    ),

                    // Next Button
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const Onboarding2Screen(),
                          ),
                        );
                      },
                      child: Container(
                        width: 58,
                        height: 58,
                        decoration: const BoxDecoration(
                          color: Color(0xFF8B2252),
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.arrow_forward_rounded,
                          color: Colors.white,
                          size: 28,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
