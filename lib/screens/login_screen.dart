import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginScreen extends StatefulWidget {
  final VoidCallback? onSignInPressed;
  final VoidCallback? onForgotPassword;
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onGuestPressed;

  const LoginScreen({
    super.key,
    this.onSignInPressed,
    this.onForgotPassword,
    this.onGooglePressed,
    this.onApplePressed,
    this.onGuestPressed,
  });

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _obscurePassword = true;

  // ── Design tokens ────────────────────────────────────────────
  static const _bg = Color(0xFFFFF8F8);
  static const _fieldBg = Color(0xFFFBF0F3);
  static const _textDark = Color(0xFF2B1620);
  static const _textMid = Color(0xFF6B4A57);
  static const _placeholder = Color(0xFFB89AA5);
  static const _iconColor = Color(0xFFB68A98);
  static const _pinkAccent = Color(0xFFC4527A);
  static const _gradientStart = Color(0xFFB85C7E);
  static const _gradientEnd = Color(0xFF8B3A56);
  static const _dividerColor = Color(0xFFE8CBD4);
  static const _outlineColor = Color(0xFFE0C2CC);

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _goToSignup() {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => const SignupScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: w * 0.07),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: h * 0.06),

              // ── Title ─────────────────────────────────────────
              Text(
                'Welcome Back',
                textAlign: TextAlign.center,
                style: GoogleFonts.playfairDisplay(
                  fontSize: _s(w, 30),
                  fontWeight: FontWeight.w800,
                  color: _textDark,
                ),
              ),

              SizedBox(height: h * 0.012),

              // ── Subtitle ──────────────────────────────────────
              Text(
                'Sign in to continue your\nHairVerse journey',
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: _s(w, 14),
                  fontWeight: FontWeight.w400,
                  color: _textMid,
                  height: 1.55,
                ),
              ),

              SizedBox(height: h * 0.04),

              // ── Email / Phone field ─────────────────────────
              _InputField(
                controller: _emailController,
                hint: 'Email or Phone',
                keyboardType: TextInputType.emailAddress,
              ),

              SizedBox(height: h * 0.016),

              // ── Password field ───────────────────────────────
              _InputField(
                controller: _passwordController,
                hint: 'Password',
                obscureText: _obscurePassword,
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword
                        ? Icons.visibility_outlined
                        : Icons.visibility_off_outlined,
                    color: _iconColor,
                    size: 22,
                  ),
                  onPressed: () =>
                      setState(() => _obscurePassword = !_obscurePassword),
                ),
              ),

              SizedBox(height: h * 0.012),

              // ── Forgot Password ──────────────────────────────
              Align(
                alignment: Alignment.centerRight,
                child: GestureDetector(
                  onTap: widget.onForgotPassword,
                  child: Text(
                    'Forgot Password?',
                    style: GoogleFonts.poppins(
                      fontSize: _s(w, 13),
                      fontWeight: FontWeight.w500,
                      color: _textMid,
                    ),
                  ),
                ),
              ),

              SizedBox(height: h * 0.026),

              // ── Sign In button ────────────────────────────────
              _GradientButton(
                label: 'Sign In',
                onTap: () async {
                  try {
                    await FirebaseAuth.instance.signInWithEmailAndPassword(
                      email: _emailController.text.trim(),
                      password: _passwordController.text.trim(),
                    );

                    Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => const HomeScreen(),
                      ),
                    );
                  } catch (e) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text("Invalid email or password"),
                      ),
                    );
                  }
                },
                w: w,
                gradientStart: _gradientStart,
                gradientEnd: _gradientEnd,
              ),

              SizedBox(height: h * 0.026),

              // ── OR divider ────────────────────────────────────
              _OrDivider(
                w: w,
                dividerColor: _dividerColor,
                textColor: _textDark,
              ),

              SizedBox(height: h * 0.022),

              // ── Google + Apple buttons ───────────────────────
              Row(
                children: [
                  Expanded(
                    child: _SocialButton(
                      label: 'Google',
                      icon: _GoogleLogo(size: _s(w, 20)),
                      onTap: widget.onGooglePressed,
                      w: w,
                    ),
                  ),
                  SizedBox(width: w * 0.035),
                  Expanded(
                    child: _SocialButton(
                      label: 'Apple',
                      icon: Icon(
                        Icons.apple_rounded,
                        size: _s(w, 24),
                        color: const Color(0xFF1C1C1C),
                      ),
                      onTap: widget.onApplePressed,
                      w: w,
                    ),
                  ),
                ],
              ),

              SizedBox(height: h * 0.018),

              // ── Continue as Guest ─────────────────────────────
              _OutlineButton(
                label: 'Continue as Guest',
                onTap: widget.onGuestPressed,
                w: w,
              ),

              SizedBox(height: h * 0.03),

              // ── Sign Up row ───────────────────────────────────
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    "Don't have an account? ",
                    style: GoogleFonts.poppins(
                      fontSize: _s(w, 14),
                      fontWeight: FontWeight.w400,
                      color: _textDark,
                    ),
                  ),
                  GestureDetector(
                    onTap: _goToSignup,
                    child: Text(
                      'Sign Up',
                      style: GoogleFonts.poppins(
                        fontSize: _s(w, 14),
                        fontWeight: FontWeight.w600,
                        color: _pinkAccent,
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: h * 0.035),
            ],
          ),
        ),
      ),
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

// ─────────────────────────────────────────────────────────────
// Reusable rounded input field
// ─────────────────────────────────────────────────────────────
class _InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;

  const _InputField({
    required this.controller,
    required this.hint,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
  });

  static const _fieldBg = Color(0xFFFBF0F3);
  static const _textDark = Color(0xFF2B1620);
  static const _placeholder = Color(0xFFB89AA5);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: _fieldBg,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD8A8B8).withOpacity(0.12),
            blurRadius: 10,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        style: GoogleFonts.poppins(
          fontSize: _s(w, 15),
          fontWeight: FontWeight.w400,
          color: _textDark,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.poppins(
            fontSize: _s(w, 15),
            fontWeight: FontWeight.w400,
            color: _placeholder,
          ),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: _fieldBg,
          contentPadding: EdgeInsets.symmetric(
            horizontal: w * 0.05,
            vertical: w * 0.045,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: Color(0xFFC4527A), width: 1.6),
          ),
        ),
      ),
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

// ─────────────────────────────────────────────────────────────
// OR divider
// ─────────────────────────────────────────────────────────────
class _OrDivider extends StatelessWidget {
  final double w;
  final Color dividerColor;
  final Color textColor;

  const _OrDivider({
    required this.w,
    required this.dividerColor,
    required this.textColor,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Divider(color: dividerColor, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.035),
          child: Text(
            'or continue with',
            style: GoogleFonts.poppins(
              fontSize: _s(w, 13),
              fontWeight: FontWeight.w400,
              color: textColor,
            ),
          ),
        ),
        Expanded(child: Divider(color: dividerColor, thickness: 1)),
      ],
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

// ─────────────────────────────────────────────────────────────
// Gradient pill button (Sign In)
// ─────────────────────────────────────────────────────────────
class _GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback? onTap;
  final double w;
  final Color gradientStart;
  final Color gradientEnd;

  const _GradientButton({
    required this.label,
    required this.w,
    required this.gradientStart,
    required this.gradientEnd,
    this.onTap,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _scale = 0.97),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          width: double.infinity,
          height: 56,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(32),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [widget.gradientStart, widget.gradientEnd],
            ),
            boxShadow: [
              BoxShadow(
                color: widget.gradientEnd.withOpacity(0.32),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          alignment: Alignment.center,
          child: Text(
            widget.label,
            style: GoogleFonts.poppins(
              fontSize: _s(widget.w, 17),
              fontWeight: FontWeight.w700,
              color: Colors.white,
              letterSpacing: 0.3,
            ),
          ),
        ),
      ),
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

// ─────────────────────────────────────────────────────────────
// Social login button (Google / Apple)
// ─────────────────────────────────────────────────────────────
class _SocialButton extends StatefulWidget {
  final String label;
  final Widget icon;
  final VoidCallback? onTap;
  final double w;

  const _SocialButton({
    required this.label,
    required this.icon,
    required this.w,
    this.onTap,
  });

  @override
  State<_SocialButton> createState() => _SocialButtonState();
}

class _SocialButtonState extends State<_SocialButton> {
  double _scale = 1.0;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) => setState(() => _scale = 0.96),
      onTapUp: (_) => setState(() => _scale = 1.0),
      onTapCancel: () => setState(() => _scale = 1.0),
      child: AnimatedScale(
        scale: _scale,
        duration: const Duration(milliseconds: 120),
        curve: Curves.easeOut,
        child: Container(
          height: 54,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: const Color(0xFFE0C2CC), width: 1.2),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.icon,
              SizedBox(width: widget.w * 0.022),
              Text(
                widget.label,
                style: GoogleFonts.poppins(
                  fontSize: _s(widget.w, 15),
                  fontWeight: FontWeight.w600,
                  color: const Color(0xFF2B1620),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

// ─────────────────────────────────────────────────────────────
// Outline button (Continue as Guest)
// ─────────────────────────────────────────────────────────────
class _OutlineButton extends StatelessWidget {
  final String label;
  final VoidCallback? onTap;
  final double w;

  const _OutlineButton({required this.label, required this.w, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: const Color(0xFFE0C2CC), width: 1.2),
        ),
        alignment: Alignment.center,
        child: Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: _s(w, 15),
            fontWeight: FontWeight.w600,
            color: const Color(0xFF2B1620),
          ),
        ),
      ),
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

// ─────────────────────────────────────────────────────────────
// Google "G" logo drawn with CustomPaint (no asset required)
// ─────────────────────────────────────────────────────────────
class _GoogleLogo extends StatelessWidget {
  final double size;
  const _GoogleLogo({required this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(painter: _GoogleLogoPainter()),
    );
  }
}

class _GoogleLogoPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;
    final cx = w / 2;
    final cy = h / 2;
    final r = w / 2;
    final strokeW = w * 0.22;

    final rect = Rect.fromCircle(
      center: Offset(cx, cy),
      radius: r - strokeW / 2,
    );

    final bluePaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.butt;

    final greenPaint = Paint()
      ..color = const Color(0xFF34A853)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.butt;

    final yellowPaint = Paint()
      ..color = const Color(0xFFFBBC05)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.butt;

    final redPaint = Paint()
      ..color = const Color(0xFFEA4335)
      ..style = PaintingStyle.stroke
      ..strokeWidth = strokeW
      ..strokeCap = StrokeCap.butt;

    const fullCircle = 2 * 3.1415926535;

    canvas.drawArc(rect, -0.45, fullCircle * 0.22, false, bluePaint);
    canvas.drawArc(
      rect,
      -0.45 + fullCircle * 0.22 + 0.05,
      fullCircle * 0.24,
      false,
      greenPaint,
    );
    canvas.drawArc(
      rect,
      -0.45 + fullCircle * 0.46 + 0.10,
      fullCircle * 0.27,
      false,
      yellowPaint,
    );
    canvas.drawArc(
      rect,
      -0.45 + fullCircle * 0.73 + 0.15,
      fullCircle * 0.24,
      false,
      redPaint,
    );

    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(cx, cy - strokeW * 0.45, r - strokeW * 0.1, strokeW * 0.9),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(_) => false;
}
