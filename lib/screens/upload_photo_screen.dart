import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';

import 'analysis_screen.dart';
import 'results_screen.dart';

// ─────────────────────────────────────────────
// Design tokens
// ─────────────────────────────────────────────
const _kPrimary = Color(0xFFB5527A);
const _kPrimaryLight = Color(0xFFF7E8EF);
const _kBackground = Color(0xFFFDF4F7);
const _kCardBorder = Color(0xFFE8C4D4);
const _kSubtitle = Color(0xFFB08090);
const _kGreen = Color(0xFF4CAF8A);

// ─────────────────────────────────────────────
// Screen
// ─────────────────────────────────────────────
class UploadPhotoScreen extends StatefulWidget {
  const UploadPhotoScreen({super.key});

  @override
  State<UploadPhotoScreen> createState() => _UploadPhotoScreenState();
}

class _UploadPhotoScreenState extends State<UploadPhotoScreen>
    with SingleTickerProviderStateMixin {
  File? _selectedImage;
  bool _isLoading = false;

  late final AnimationController _buttonController;
  late final Animation<double> _buttonFade;

  final ImagePicker _imagePicker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _buttonController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 350),
    );
    _buttonFade = CurvedAnimation(
      parent: _buttonController,
      curve: Curves.easeIn,
    );
  }

  @override
  void dispose() {
    _buttonController.dispose();
    super.dispose();
  }

  // ── source selection ──────────────────────────
  void _showSourceSheet() {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => _SourceBottomSheet(
        onCamera: () {
          Navigator.pop(context);
          _pickFromCamera();
        },
        onGallery: () {
          Navigator.pop(context);
          _pickFromGallery();
        },
      ),
    );
  }

  // ── pickers ──────────────────────────────────
  Future<void> _pickFromCamera() async {
    setState(() => _isLoading = true);
    try {
      final XFile? xfile = await _imagePicker.pickImage(
        source: ImageSource.camera,
        imageQuality: 90,
        preferredCameraDevice: CameraDevice.front,
      );
      if (xfile != null) _setImage(File(xfile.path));
    } catch (e) {
      _showError('Could not open camera. Please check permissions.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _pickFromGallery() async {
    setState(() => _isLoading = true);
    try {
      final XFile? xfile = await _imagePicker.pickImage(
        source: ImageSource.gallery,
        imageQuality: 90,
      );
      if (xfile != null) {
        print('IMAGE PATH: ${xfile.path}');
        _setImage(File(xfile.path));
      }
    } catch (e) {
      _showError('Could not open gallery. Please check permissions.');
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  void _setImage(File file) {
    print('SETTING IMAGE: ${file.path}');
    setState(() => _selectedImage = file);
    _buttonController.forward();
  }

  void _showError(String message) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: _kPrimary,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  // ── navigation ───────────────────────────────
  Future<void> _analyzePhoto() async {
    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const AnalysisScreen()),
    );

    if (!mounted) return;

    await Navigator.push(
      context,
      MaterialPageRoute(builder: (_) => const ResultsScreen()),
    );
  }

  // ── build ─────────────────────────────────────
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: _kBackground,
      appBar: AppBar(
        backgroundColor: _kBackground,
        elevation: 0,
        leading: GestureDetector(
          onTap: () => Navigator.maybePop(context),
          child: Container(
            margin: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: _kCardBorder),
            ),
            child: const Icon(Icons.chevron_left, color: _kPrimary),
          ),
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: 8,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const SizedBox(height: 8),
              _buildHeader(),
              const SizedBox(height: 28),
              _buildUploadCard(),
              const SizedBox(height: 24),
              _buildAnalyzeButton(),
              const SizedBox(height: 24),
              _buildTipsCard(),
              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    return Column(
      children: [
        Text(
          'Upload Your Photo',
          style: GoogleFonts.playfairDisplay(
            fontSize: 26,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2D1B2E),
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 6),
        Text(
          'For best results',
          style: GoogleFonts.lato(
            fontSize: 14,
            color: _kSubtitle,
            fontWeight: FontWeight.w400,
          ),
        ),
      ],
    );
  }

  Widget _buildUploadCard() {
    return GestureDetector(
      onTap: _isLoading ? null : _showSourceSheet,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 300),
        width: double.infinity,
        height: 260,
        decoration: BoxDecoration(
          color: _selectedImage != null ? Colors.black : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: _selectedImage != null ? Colors.transparent : _kCardBorder,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: _kPrimary.withValues(alpha: 0.07),
              blurRadius: 20,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        clipBehavior: Clip.antiAlias,
        child: _isLoading
            ? const Center(child: CircularProgressIndicator(color: _kPrimary))
            : _selectedImage != null
            ? _buildImagePreview()
            : _buildUploadPlaceholder(),
      ),
    );
  }

  Widget _buildImagePreview() {
    debugPrint('IMAGE PATH = ${_selectedImage?.path}');

    return Stack(
      fit: StackFit.expand,
      children: [
        Image.file(
          _selectedImage!,
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
          errorBuilder: (context, error, stackTrace) {
            return const Center(child: Text('Could not load image'));
          },
        ),
        // Tap-to-change overlay
        Positioned(
          bottom: 12,
          right: 12,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            decoration: BoxDecoration(
              color: Colors.black.withValues(alpha: 0.55),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(Icons.edit, color: Colors.white, size: 14),
                const SizedBox(width: 4),
                Text(
                  'Change',
                  style: GoogleFonts.lato(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildUploadPlaceholder() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: _kPrimaryLight,
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.cloud_upload_outlined,
            size: 36,
            color: _kPrimary,
          ),
        ),
        const SizedBox(height: 16),
        Text(
          'Tap to upload',
          style: GoogleFonts.lato(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: const Color(0xFF2D1B2E),
          ),
        ),
        const SizedBox(height: 10),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Expanded(
              child: Divider(color: _kCardBorder, indent: 32, endIndent: 12),
            ),
            Text(
              'or',
              style: GoogleFonts.lato(fontSize: 13, color: _kSubtitle),
            ),
            Expanded(
              child: Divider(color: _kCardBorder, indent: 12, endIndent: 32),
            ),
          ],
        ),
        const SizedBox(height: 10),
        _ChooseGalleryButton(onTap: _showSourceSheet),
      ],
    );
  }

  Widget _buildAnalyzeButton() {
    return FadeTransition(
      opacity: _buttonFade,
      child: SizeTransition(
        sizeFactor: _buttonFade,
        axisAlignment: -1,
        child: SizedBox(
          width: double.infinity,
          height: 54,
          child: ElevatedButton(
            onPressed: _selectedImage != null ? _analyzePhoto : null,
            style: ElevatedButton.styleFrom(
              backgroundColor: _kPrimary,
              disabledBackgroundColor: _kPrimary.withValues(alpha: 0.4),
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 4,
              shadowColor: _kPrimary.withValues(alpha: 0.4),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.auto_fix_high_rounded, size: 20),
                const SizedBox(width: 8),
                Text(
                  'Analyze Photo',
                  style: GoogleFonts.lato(
                    fontSize: 16,
                    fontWeight: FontWeight.w700,
                    letterSpacing: 0.5,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTipsCard() {
    const tips = [
      'Use a front-facing clear photo',
      'Good lighting',
      'Hair tied back or away from face',
    ];

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: _kCardBorder, width: 1.2),
        boxShadow: [
          BoxShadow(
            color: _kPrimary.withValues(alpha: 0.05),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Tips for best results:',
            style: GoogleFonts.lato(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: const Color(0xFF2D1B2E),
            ),
          ),
          const SizedBox(height: 12),
          ...tips.map((tip) => _TipRow(tip: tip)),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Bottom Sheet
// ─────────────────────────────────────────────
class _SourceBottomSheet extends StatelessWidget {
  const _SourceBottomSheet({required this.onCamera, required this.onGallery});

  final VoidCallback onCamera;
  final VoidCallback onGallery;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // Handle bar
          Container(
            width: 40,
            height: 4,
            margin: const EdgeInsets.only(bottom: 20),
            decoration: BoxDecoration(
              color: const Color(0xFFE0D0D8),
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          Text(
            'Select Photo Source',
            style: GoogleFonts.playfairDisplay(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF2D1B2E),
            ),
          ),
          const SizedBox(height: 20),
          _SourceOption(
            icon: Icons.camera_alt_rounded,
            label: 'Camera',
            subtitle: 'Take a new photo',
            onTap: onCamera,
          ),
          const SizedBox(height: 12),
          _SourceOption(
            icon: Icons.photo_library_rounded,
            label: 'Gallery',
            subtitle: 'Choose from your photos',
            onTap: onGallery,
          ),
        ],
      ),
    );
  }
}

// ─────────────────────────────────────────────
// Helper Widgets
// ─────────────────────────────────────────────
class _SourceOption extends StatelessWidget {
  const _SourceOption({
    required this.icon,
    required this.label,
    required this.subtitle,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final String subtitle;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: _kPrimaryLight,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(color: _kCardBorder),
        ),
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: _kPrimary.withValues(alpha: 0.12),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: _kPrimary, size: 22),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: GoogleFonts.lato(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF2D1B2E),
                    ),
                  ),
                  Text(
                    subtitle,
                    style: GoogleFonts.lato(fontSize: 12, color: _kSubtitle),
                  ),
                ],
              ),
            ),
            const Icon(Icons.chevron_right, color: _kPrimary, size: 20),
          ],
        ),
      ),
    );
  }
}

class _ChooseGalleryButton extends StatelessWidget {
  const _ChooseGalleryButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 12),
        decoration: BoxDecoration(
          color: _kPrimaryLight,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: _kCardBorder),
        ),
        child: Text(
          'Choose from Gallery',
          style: GoogleFonts.lato(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: _kPrimary,
          ),
        ),
      ),
    );
  }
}

class _TipRow extends StatelessWidget {
  const _TipRow({required this.tip});

  final String tip;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            margin: const EdgeInsets.only(top: 2),
            width: 18,
            height: 18,
            decoration: BoxDecoration(
              color: _kGreen.withValues(alpha: 0.12),
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.check, color: _kGreen, size: 12),
          ),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              tip,
              style: GoogleFonts.lato(
                fontSize: 13,
                color: const Color(0xFF5A3A4A),
                height: 1.4,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
