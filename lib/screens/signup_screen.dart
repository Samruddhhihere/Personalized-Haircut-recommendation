import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'home_screen.dart';
import 'login_screen.dart';
import 'package:firebase_auth/firebase_auth.dart';

class SignupScreen extends StatefulWidget {
  final VoidCallback? onSignupPressed;
  final VoidCallback? onGooglePressed;
  final VoidCallback? onApplePressed;
  final VoidCallback? onSignInPressed;

  const SignupScreen({
    super.key,
    this.onSignupPressed,
    this.onGooglePressed,
    this.onApplePressed,
    this.onSignInPressed,
  });

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen>
    with SingleTickerProviderStateMixin {
  final _formKey = GlobalKey<FormState>();

  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _obscurePassword = true;
  bool _obscureConfirmPassword = true;

  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  // ── Design tokens ────────────────────────────────────────────
  static const _bg = Color(0xFFFDF5F7);
  static const _fieldBg = Color(0xFFFFFFFF);
  static const _textDark = Color(0xFF2B1620);
  static const _textMid = Color(0xFF6B4A57);
  static const _placeholder = Color(0xFFB89AA5);
  static const _iconColor = Color(0xFFB68A98);
  static const _pinkAccent = Color(0xFFC4527A);
  static const _gradientStart = Color(0xFFB85C7E);
  static const _gradientEnd = Color(0xFF8B3A56);
  static const _dividerColor = Color(0xFFE8CBD4);

  @override
  void initState() {
    super.initState();

    _fadeController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );

    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeOut,
    );

    _slideAnimation = Tween<double>(begin: 28.0, end: 0.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeOutCubic),
    );

    _fadeController.forward();
  }

  @override
  void dispose() {
    _fadeController.dispose();
    _fullNameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _handleSignup() {
    if (_formKey.currentState?.validate() ?? false) {
      widget.onSignupPressed?.call();
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: AnimatedBuilder(
          animation: _fadeController,
          builder: (context, child) {
            return Opacity(
              opacity: _fadeAnimation.value,
              child: Transform.translate(
                offset: Offset(0, _slideAnimation.value),
                child: child,
              ),
            );
          },
          child: SingleChildScrollView(
            padding: EdgeInsets.symmetric(horizontal: w * 0.065),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: h * 0.045),

                  _buildHeader(w),

                  SizedBox(height: h * 0.038),

                  _buildFullNameField(w),
                  SizedBox(height: h * 0.018),

                  _buildEmailField(w),
                  SizedBox(height: h * 0.018),

                  _buildPasswordField(w),
                  SizedBox(height: h * 0.018),

                  _buildConfirmPasswordField(w),

                  SizedBox(height: h * 0.032),

                  _buildSignupButton(w),

                  SizedBox(height: h * 0.026),

                  _buildOrContinueWith(w),

                  SizedBox(height: h * 0.020),

                  _buildSocialButtons(w),

                  SizedBox(height: h * 0.028),

                  _buildOrDivider(w),

                  SizedBox(height: h * 0.022),

                  _buildSignInRow(w),

                  SizedBox(height: h * 0.035),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Header — title + subtitle
  // ─────────────────────────────────────────────────────────────
  Widget _buildHeader(double w) {
    return Column(
      children: [
        Text(
          'Create Account',
          textAlign: TextAlign.center,
          style: GoogleFonts.playfairDisplay(
            fontSize: _s(w, 34),
            fontWeight: FontWeight.w800,
            color: _textDark,
          ),
        ),
        SizedBox(height: w * 0.035),
        Text(
          'Join HairVerse and start your\nAI hair transformation',
          textAlign: TextAlign.center,
          style: GoogleFonts.poppins(
            fontSize: _s(w, 14.5),
            fontWeight: FontWeight.w400,
            color: _textMid,
            height: 1.55,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Full Name field
  // ─────────────────────────────────────────────────────────────
  Widget _buildFullNameField(double w) {
    return _InputField(
      controller: _fullNameController,
      hint: 'Full Name',
      prefixIcon: Icons.person_outline_rounded,
      keyboardType: TextInputType.name,
      textCapitalization: TextCapitalization.words,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your full name';
        }
        if (value.trim().length < 2) {
          return 'Name must be at least 2 characters';
        }
        return null;
      },
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Email field
  // ─────────────────────────────────────────────────────────────
  Widget _buildEmailField(double w) {
    return _InputField(
      controller: _emailController,
      hint: 'Email',
      prefixIcon: Icons.mail_outline_rounded,
      keyboardType: TextInputType.emailAddress,
      validator: (value) {
        if (value == null || value.trim().isEmpty) {
          return 'Please enter your email';
        }
        final emailRegex = RegExp(r'^[\w\.\-]+@[\w\-]+\.[\w\.\-]+$');
        if (!emailRegex.hasMatch(value.trim())) {
          return 'Please enter a valid email';
        }
        return null;
      },
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Password field
  // ─────────────────────────────────────────────────────────────
  Widget _buildPasswordField(double w) {
    return _InputField(
      controller: _passwordController,
      hint: 'Password',
      prefixIcon: Icons.lock_outline_rounded,
      obscureText: _obscurePassword,
      suffixIcon: IconButton(
        icon: Icon(
          _obscurePassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: _iconColor,
          size: 22,
        ),
        onPressed: () => setState(() => _obscurePassword = !_obscurePassword),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please enter a password';
        }
        if (value.length < 6) {
          return 'Password must be at least 6 characters';
        }
        return null;
      },
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Confirm Password field
  // ─────────────────────────────────────────────────────────────
  Widget _buildConfirmPasswordField(double w) {
    return _InputField(
      controller: _confirmPasswordController,
      hint: 'Confirm Password',
      prefixIcon: Icons.lock_outline_rounded,
      obscureText: _obscureConfirmPassword,
      suffixIcon: IconButton(
        icon: Icon(
          _obscureConfirmPassword
              ? Icons.visibility_outlined
              : Icons.visibility_off_outlined,
          color: _iconColor,
          size: 22,
        ),
        onPressed: () =>
            setState(() => _obscureConfirmPassword = !_obscureConfirmPassword),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please confirm your password';
        }
        if (value != _passwordController.text) {
          return 'Passwords do not match';
        }
        return null;
      },
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Sign Up Button (gradient + press animation)
  // ─────────────────────────────────────────────────────────────
  Widget _buildSignupButton(double w) {
    return _GradientButton(
      label: 'Sign Up',
      onTap: () async {
        try {
          if (_passwordController.text != _confirmPasswordController.text) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("Passwords do not match")),
            );
            return;
          }

          UserCredential userCredential = await FirebaseAuth.instance
              .createUserWithEmailAndPassword(
                email: _emailController.text.trim(),
                password: _passwordController.text.trim(),
              );

          await userCredential.user!.updateDisplayName(
            _fullNameController.text.trim(),
          );

          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const HomeScreen()),
          );
        } catch (e) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text(e.toString())));
        }
      },
      w: w,
      gradientStart: _gradientStart,
      gradientEnd: _gradientEnd,
    );
  }

  // ─────────────────────────────────────────────────────────────
  // "or continue with" text
  // ─────────────────────────────────────────────────────────────
  Widget _buildOrContinueWith(double w) {
    return Text(
      'or continue with',
      style: GoogleFonts.poppins(
        fontSize: _s(w, 14),
        fontWeight: FontWeight.w400,
        color: _textMid,
      ),
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Google + Apple buttons
  // ─────────────────────────────────────────────────────────────
  Widget _buildSocialButtons(double w) {
    return Row(
      children: [
        Expanded(
          child: _SocialButton(
            label: 'Google',
            onTap: widget.onGooglePressed,
            icon: _GoogleLogo(size: _s(w, 22)),
            w: w,
          ),
        ),
        SizedBox(width: w * 0.035),
        Expanded(
          child: _SocialButton(
            label: 'Apple',
            onTap: widget.onApplePressed,
            icon: Icon(
              Icons.apple_rounded,
              size: _s(w, 26),
              color: const Color(0xFF1C1C1C),
            ),
            w: w,
          ),
        ),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // Divider with "or" in center
  // ─────────────────────────────────────────────────────────────
  Widget _buildOrDivider(double w) {
    return Row(
      children: [
        Expanded(child: Divider(color: _dividerColor, thickness: 1)),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: w * 0.035),
          child: Text(
            'or',
            style: GoogleFonts.poppins(
              fontSize: _s(w, 14),
              fontWeight: FontWeight.w500,
              color: _textDark,
            ),
          ),
        ),
        Expanded(child: Divider(color: _dividerColor, thickness: 1)),
      ],
    );
  }

  // ─────────────────────────────────────────────────────────────
  // "Already have an account? Sign In"
  // ─────────────────────────────────────────────────────────────
  Widget _buildSignInRow(double w) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Already have an account? ',
          style: GoogleFonts.poppins(
            fontSize: _s(w, 14.5),
            fontWeight: FontWeight.w400,
            color: _textDark,
          ),
        ),
        GestureDetector(
          onTap: () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const LoginScreen()),
            );
          },
          child: Text(
            'Sign In',
            style: GoogleFonts.poppins(
              fontSize: _s(w, 14.5),
              fontWeight: FontWeight.w600,
              color: _pinkAccent,
            ),
          ),
        ),
      ],
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
  final IconData prefixIcon;
  final Widget? suffixIcon;
  final bool obscureText;
  final TextInputType keyboardType;
  final TextCapitalization textCapitalization;
  final String? Function(String?)? validator;

  const _InputField({
    required this.controller,
    required this.hint,
    required this.prefixIcon,
    this.suffixIcon,
    this.obscureText = false,
    this.keyboardType = TextInputType.text,
    this.textCapitalization = TextCapitalization.none,
    this.validator,
  });

  static const _fieldBg = Color(0xFFFFFFFF);
  static const _textDark = Color(0xFF2B1620);
  static const _placeholder = Color(0xFFB89AA5);
  static const _iconColor = Color(0xFFB68A98);

  @override
  Widget build(BuildContext context) {
    final w = MediaQuery.of(context).size.width;

    return Container(
      decoration: BoxDecoration(
        color: _fieldBg,
        borderRadius: BorderRadius.circular(18),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFD8A8B8).withValues(alpha: 0.18),
            blurRadius: 14,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextFormField(
        controller: controller,
        obscureText: obscureText,
        keyboardType: keyboardType,
        textCapitalization: textCapitalization,
        validator: validator,
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
          prefixIcon: Icon(prefixIcon, color: _iconColor, size: 22),
          suffixIcon: suffixIcon,
          filled: true,
          fillColor: _fieldBg,
          contentPadding: EdgeInsets.symmetric(
            vertical: w * 0.048,
            horizontal: 4,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Color(0xFFC4527A), width: 1.6),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.4),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(18),
            borderSide: const BorderSide(color: Colors.redAccent, width: 1.6),
          ),
          errorStyle: GoogleFonts.poppins(
            fontSize: _s(w, 11.5),
            color: Colors.redAccent,
          ),
        ),
      ),
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

// ─────────────────────────────────────────────────────────────
// Gradient pill button with press animation
// ─────────────────────────────────────────────────────────────
class _GradientButton extends StatefulWidget {
  final String label;
  final VoidCallback onTap;
  final double w;
  final Color gradientStart;
  final Color gradientEnd;

  const _GradientButton({
    required this.label,
    required this.onTap,
    required this.w,
    required this.gradientStart,
    required this.gradientEnd,
  });

  @override
  State<_GradientButton> createState() => _GradientButtonState();
}

class _GradientButtonState extends State<_GradientButton> {
  double _scale = 1.0;

  void _onTapDown(TapDownDetails details) {
    setState(() => _scale = 0.97);
  }

  void _onTapUp(TapUpDetails details) {
    setState(() => _scale = 1.0);
  }

  void _onTapCancel() {
    setState(() => _scale = 1.0);
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: _onTapDown,
      onTapUp: _onTapUp,
      onTapCancel: _onTapCancel,
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
                color: widget.gradientEnd.withValues(alpha: 0.35),
                blurRadius: 18,
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
          height: 56,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFD8A8B8).withValues(alpha: 0.18),
                blurRadius: 14,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              widget.icon,
              SizedBox(width: widget.w * 0.025),
              Text(
                widget.label,
                style: GoogleFonts.poppins(
                  fontSize: _s(widget.w, 16),
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

    // Four arcs forming the Google "G" ring
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

    // Horizontal blue bar (the crossbar of the G)
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
