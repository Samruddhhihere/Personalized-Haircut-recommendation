import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'saved_screen.dart';
import 'dart:io';
import '../services/ai_tryon_service.dart';
import '../services/cloudinary_service.dart';

// ─────────────────────────────────────────────────────────────
// Data model
// ─────────────────────────────────────────────────────────────
class _StyleOption {
  final String name;
  final String thumbnailPath;
  final String beforeImagePath;
  final String afterImagePath;
  final String hairstyleName;
  final String imagePath;

  const _StyleOption({
    required this.name,
    required this.thumbnailPath,
    required this.beforeImagePath,
    required this.afterImagePath,
    required this.hairstyleName,
    required this.imagePath,
  });
}

class TryOnScreen extends StatefulWidget {
  final VoidCallback? onBack;
  final VoidCallback? onSaveLook;
  final String hairstyleName;
  final String imagePath;
  final String userImagePath;

  const TryOnScreen({
    super.key,
    this.onBack,
    this.onSaveLook,
    required this.hairstyleName,
    required this.imagePath,
    required this.userImagePath,
  });

  @override
  State<TryOnScreen> createState() => _TryOnScreenState();
}

class _TryOnScreenState extends State<TryOnScreen> {
  // ── Hairstyle prompts ────────────────────────────────────────
  static const Map<String, String> _hairstylePrompts = {
    'Layer Cut':
        'Layered haircut with face-framing layers, medium length, natural volume. Keep the face, skin, background and everything else completely unchanged. Only modify the hair.',
    'Curtain Bangs':
        'Curtain bangs, middle part, fringe swept to both sides framing the face. Do not change the face, skin tone, background or any other feature. Only modify the hair.',
    'Wolf Cut':
        'Wolf cut hairstyle, shaggy layers, voluminous crown, choppy ends. Keep the face, skin, background and everything else completely unchanged. Only modify the hair.',
    'Butterfly Cut':
        'Butterfly haircut, long layers, shorter layers near the crown, voluminous and bouncy. Keep the face, skin, background and everything else completely unchanged. Only modify the hair.',
  };

  static final List<_StyleOption> _styles = [
    _StyleOption(
      name: 'Layer Cut',
      thumbnailPath: 'assets/images/hair_layer_cut.png',
      beforeImagePath: 'assets/images/onboarding1_portrait.png',
      afterImagePath: 'assets/images/hair_layer_cut.png',
      hairstyleName: 'Layer Cut',
      imagePath: 'assets/images/hair_layer_cut.png',
    ),

    _StyleOption(
      name: 'Curtain Bangs',
      thumbnailPath: 'assets/images/hair_curtain_bangs.png',
      beforeImagePath: 'assets/images/onboarding1_portrait.png',
      afterImagePath: 'assets/images/hair_curtain_bangs.png',
      hairstyleName: 'Curtain Bangs',
      imagePath: 'assets/images/hair_curtain_bangs.png',
    ),

    _StyleOption(
      name: 'Wolf Cut',
      thumbnailPath: 'assets/images/hair_wolf_cut.png',
      beforeImagePath: 'assets/images/onboarding1_portrait.png',
      afterImagePath: 'assets/images/hair_wolf_cut.png',
      hairstyleName: 'Wolf Cut',
      imagePath: 'assets/images/hair_wolf_cut.png',
    ),

    _StyleOption(
      name: 'Butterfly Cut',
      thumbnailPath: 'assets/images/hair_butterfly_cut.png',
      beforeImagePath: 'assets/images/onboarding1_portrait.png',
      afterImagePath: 'assets/images/hair_butterfly_cut.png',
      hairstyleName: 'Butterfly Cut',
      imagePath: 'assets/images/hair_butterfly_cut.png',
    ),
  ];

  int _selectedIndex = 0;
  final CloudinaryService _cloudinaryService = CloudinaryService();
  final AiTryOnService _aiService = AiTryOnService();

  String? generatedImageUrl;
  bool isGenerating = false;

  @override
  void initState() {
    super.initState();
    print("TRYON RECEIVED:");
    print(widget.hairstyleName);
    final index = _styles.indexWhere((s) => s.name == widget.hairstyleName);

    if (index != -1) {
      _selectedIndex = index;
    }
    WidgetsBinding.instance.addPostFrameCallback((_) {
      generateHairstylePreview();
    });
  }

  Future<void> generateHairstylePreview() async {
    try {
      setState(() {
        isGenerating = true;
      });

      print("SELECTED HAIRSTYLE:");
      print(widget.hairstyleName);

      final imageUrl = await _cloudinaryService.uploadImage(
        File(widget.userImagePath),
      );

      print("CLOUDINARY URL:");
      print(imageUrl);

      if (imageUrl == null) {
        return;
      }

      // Use descriptive prompt so API applies haircut to hair only
      final prompt = _hairstylePrompts[widget.hairstyleName] ??
          'Transform only the hair to a ${widget.hairstyleName} hairstyle. Do not change the face, skin, background or any other feature. Only modify the hair.';

      final orderId = await _aiService.generateHairstyle(
        imageUrl: imageUrl,
        prompt: prompt,
      );

      print("ORDER ID:");
      print(orderId);

      if (orderId == null) {
        return;
      }

      String? resultUrl;
      for (int i = 0; i < 8; i++) {
        await Future.delayed(const Duration(seconds: 10));
        resultUrl = await _aiService.getResult(orderId);
        if (resultUrl != null) break;
      }

      print("RESULT URL:");
      print(resultUrl);

      if (!mounted) return;

      setState(() {
        generatedImageUrl = resultUrl;
      });
    } finally {
      if (mounted) {
        setState(() {
          isGenerating = false;
        });
      }
    }
  }

  static const _bg = Color(0xFFF9EFF2);
  static const _cardBg = Color(0xFFFBF0F3);
  static const _pink = Color(0xFF8B2252);
  static const _textDark = Color(0xFF1C1C1C);

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final w = size.width;
    final h = size.height;
    final current = _styles[_selectedIndex];

    return Scaffold(
      backgroundColor: _bg,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: h * 0.014),

            // ── Screen title ─────────────────────────────────────
            Text(
              'AI Hairstyle Preview',
              style: GoogleFonts.playfairDisplay(
                fontSize: _s(w, 18),
                fontWeight: FontWeight.w800,
                color: _textDark,
              ),
            ),

            SizedBox(height: h * 0.018),

            Expanded(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: w * 0.045),
                child: Container(
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: _cardBg,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFFCB8FA8).withValues(alpha: 0.12),
                        blurRadius: 20,
                        offset: const Offset(0, 6),
                      ),
                    ],
                  ),
                  clipBehavior: Clip.hardEdge,
                  child: Column(
                    children: [
                      SizedBox(height: h * 0.020),

                      // ── Card title ──────────────────────────────
                      Text(
                        'Try-On Preview',
                        style: GoogleFonts.playfairDisplay(
                          fontSize: _s(w, 17),
                          fontWeight: FontWeight.w700,
                          color: _textDark,
                        ),
                      ),

                      SizedBox(height: h * 0.016),

                      // ── Preview image ───────────────────────────
                      Expanded(
                        child: Padding(
                          padding: EdgeInsets.symmetric(horizontal: w * 0.04),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(18),
                            child: Stack(
                              fit: StackFit.expand,
                              children: [
                                // Show generated result if ready, else show user photo
                                _buildPreviewImage(current),

                                // Loading overlay while generating
                                if (isGenerating)
                                  Container(
                                    color: Colors.black.withValues(alpha: 0.35),
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        const CircularProgressIndicator(
                                          color: Color(0xFFCB8FA8),
                                          strokeWidth: 2.5,
                                        ),
                                        const SizedBox(height: 16),
                                        Text(
                                          'Generating your look…',
                                          style: GoogleFonts.playfairDisplay(
                                            fontSize: _s(w, 14),
                                            color: Colors.white,
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                        const SizedBox(height: 6),
                                        Text(
                                          'This takes about 50 seconds',
                                          style: GoogleFonts.playfairDisplay(
                                            fontSize: _s(w, 12),
                                            color: Colors.white70,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      SizedBox(height: h * 0.018),

                      SizedBox(height: h * 0.020),

                      // ── Save Look button ────────────────────────
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: w * 0.06),
                        child: _SaveButton(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const SavedLooksScreen(),
                              ),
                            );
                          },
                          w: w,
                        ),
                      ),

                      SizedBox(height: h * 0.022),
                    ],
                  ),
                ),
              ),
            ),

            SizedBox(height: h * 0.018),
          ],
        ),
      ),
    );
  }

  Widget _buildPreviewImage(_StyleOption current) {
    if (generatedImageUrl != null) {
      // Show AI generated result full image
      return Image.network(
        generatedImageUrl!,
        fit: BoxFit.cover,
        loadingBuilder: (context, child, progress) {
          if (progress == null) return child;
          return Container(
            color: const Color(0xFFF0DDE4),
            child: const Center(
              child: CircularProgressIndicator(
                color: Color(0xFFCB8FA8),
                strokeWidth: 2.5,
              ),
            ),
          );
        },
        errorBuilder: (_, _, _) => Image.file(
          File(widget.userImagePath),
          fit: BoxFit.cover,
        ),
      );
    }

    // Show user's original photo while generating
    return Image.file(
      File(widget.userImagePath),
      fit: BoxFit.cover,
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}

// ─────────────────────────────────────────────────────────────
// Save Look Button
// ─────────────────────────────────────────────────────────────
class _SaveButton extends StatelessWidget {
  final VoidCallback? onTap;
  final double w;

  const _SaveButton({this.onTap, required this.w});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: const Color(0xFF8B2252),
          borderRadius: BorderRadius.circular(30),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF8B2252).withValues(alpha: 0.28),
              blurRadius: 16,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        alignment: Alignment.center,
        child: Text(
          'Save Look',
          style: GoogleFonts.playfairDisplay(
            fontSize: _s(w, 16),
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }

  double _s(double w, double base) =>
      (base * w / 390).clamp(base * 0.78, base * 1.28);
}