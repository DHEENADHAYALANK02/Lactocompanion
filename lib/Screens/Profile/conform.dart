import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';
import '../../main.dart';

class BookingSuccessPage extends StatefulWidget {
  final String? selectedLanguage;

  const BookingSuccessPage({super.key, this.selectedLanguage});

  @override
  State<BookingSuccessPage> createState() => _BookingSuccessPageState();
}

class _BookingSuccessPageState extends State<BookingSuccessPage>
    with TickerProviderStateMixin {
  late AnimationController _scaleController;
  late AnimationController _slideController;
  late AnimationController _fadeController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();

    _scaleController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);
    _slideController = AnimationController(
        duration: const Duration(milliseconds: 900), vsync: this);
    _fadeController = AnimationController(
        duration: const Duration(milliseconds: 1000), vsync: this);

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );

    _slideAnimation =
        Tween<Offset>(begin: const Offset(0.0, 0.3), end: Offset.zero).animate(
            CurvedAnimation(parent: _slideController, curve: Curves.easeOutQuart));

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scaleController.forward();
    Future.delayed(
        const Duration(milliseconds: 200), () => _slideController.forward());
    Future.delayed(
        const Duration(milliseconds: 500), () => _fadeController.forward());
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final size = MediaQuery.of(context).size;
    final isSmallDevice = size.height < 700;
    final isTablet = size.width > 600;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Color(0xFFFFF0F5),
              Color(0xFFFFE4E6),
              Color(0xFFFFF5F7),
              Color(0xFFFFEBEE)
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            stops: [0.0, 0.3, 0.7, 1.0],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // ✨ Header with Title
              Padding(
                padding: EdgeInsets.fromLTRB(
                  isTablet ? 24 : 16,
                  isSmallDevice ? 8 : 12,
                  isTablet ? 24 : 16,
                  isSmallDevice ? 12 : 20,
                ),
                child: Row(
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: IconButton(
                        onPressed: () => Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back,
                            color: Color.fromARGB(255, 0, 0, 0), size: 24),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Text(
                        loc.languageConfirmation,
                        style: GoogleFonts.poppins(
                          fontSize: isTablet ? 22 : (isSmallDevice ? 18 : 20),
                          fontWeight: FontWeight.w600,
                          color: Colors.black,
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: isTablet ? 48 : 24,
                    ),
                    child: Column(
                      children: [
                        SizedBox(height: isSmallDevice ? 20 : (isTablet ? 60 : 40)),

                        // 🎉 Success Icon with Glow (Responsive)
                        ScaleTransition(
                          scale: _scaleAnimation,
                          child: Stack(
                            alignment: Alignment.center,
                            children: [
                              // Outer glow
                              Container(
                                width: isSmallDevice ? 110 : (isTablet ? 160 : 140),
                                height: isSmallDevice ? 110 : (isTablet ? 160 : 140),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: RadialGradient(
                                    colors: [
                                      const Color(0xFFE91E63).withOpacity(0.3),
                                      const Color(0xFFE91E63).withOpacity(0.0),
                                    ],
                                  ),
                                ),
                              ),
                              // Icon
                              Container(
                                width: isSmallDevice ? 90 : (isTablet ? 130 : 110),
                                height: isSmallDevice ? 90 : (isTablet ? 130 : 110),
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  gradient: const LinearGradient(
                                    colors: [Color(0xFFE91E63), Color(0xFFAD1457)],
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                  ),
                                  boxShadow: [
                                    BoxShadow(
                                      color:
                                          const Color(0xFFE91E63).withOpacity(0.5),
                                      blurRadius: 30,
                                      offset: const Offset(0, 10),
                                    ),
                                  ],
                                ),
                                child: Center(
                                  child: Icon(
                                    Icons.check_rounded,
                                    size: isSmallDevice ? 50 : (isTablet ? 70 : 60),
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),

                        SizedBox(height: isSmallDevice ? 24 : (isTablet ? 48 : 36)),

                        // 🎯 Title (Responsive)
                        SlideTransition(
                          position: _slideAnimation,
                          child: Text(
                            loc.success,
                            style: GoogleFonts.poppins(
                              fontSize: isSmallDevice ? 32 : (isTablet ? 48 : 40),
                              fontWeight: FontWeight.w700,
                              color: const Color(0xFF880E4F),
                              letterSpacing: -0.5,
                              height: 1.2,
                            ),
                          ),
                        ),

                        SizedBox(height: isSmallDevice ? 8 : 12),

                        // 💬 Subtitle (Responsive)
                        SlideTransition(
                          position: _slideAnimation,
                          child: Text(
                            widget.selectedLanguage != null
                                ? loc.languagePreference
                                : loc.bookingConfirmed,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: isSmallDevice ? 14 : (isTablet ? 18 : 16),
                              fontWeight: FontWeight.w400,
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                        ),

                        SizedBox(height: isSmallDevice ? 24 : (isTablet ? 40 : 32)),

                        // 🎨 Language Card (Responsive)
                        if (widget.selectedLanguage != null)
                          SlideTransition(
                            position: _slideAnimation,
                            child: Container(
                              width: double.infinity,
                              constraints: BoxConstraints(
                                maxWidth: isTablet ? 500 : double.infinity,
                              ),
                              padding: EdgeInsets.all(isSmallDevice ? 20 : (isTablet ? 32 : 28)),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(24),
                                boxShadow: [
                                  BoxShadow(
                                    color:
                                        const Color(0xFFE91E63).withOpacity(0.12),
                                    blurRadius: 30,
                                    offset: const Offset(0, 12),
                                  ),
                                ],
                              ),
                              child: Column(
                                children: [
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: isSmallDevice ? 16 : 20,
                                      vertical: isSmallDevice ? 8 : 10,
                                    ),
                                    decoration: BoxDecoration(
                                      gradient: LinearGradient(
                                        colors: [
                                          const Color(0xFFE91E63).withOpacity(0.15),
                                          const Color(0xFFAD1457).withOpacity(0.08),
                                        ],
                                      ),
                                      borderRadius: BorderRadius.circular(30),
                                      border: Border.all(
                                        color: const Color(0xFFE91E63)
                                            .withOpacity(0.2),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisSize: MainAxisSize.min,
                                      children: [
                                        Icon(
                                          Icons.language_rounded,
                                          color: const Color(0xFF880E4F),
                                          size: isSmallDevice ? 20 : (isTablet ? 24 : 22),
                                        ),
                                        SizedBox(width: isSmallDevice ? 8 : 10),
                                        Flexible(
                                          child: Text(
                                            widget.selectedLanguage!,
                                            style: GoogleFonts.poppins(
                                              fontSize: isSmallDevice ? 18 : (isTablet ? 22 : 20),
                                              fontWeight: FontWeight.w700,
                                              color: const Color(0xFF880E4F),
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: isSmallDevice ? 12 : 16),
                                  Text(
                                    loc.successfullyConfirmed,
                                    textAlign: TextAlign.center,
                                    style: GoogleFonts.poppins(
                                      fontSize: isSmallDevice ? 13 : (isTablet ? 16 : 14),
                                      color: Colors.black54,
                                      height: 1.5,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),

                        SizedBox(height: isSmallDevice ? 20 : (isTablet ? 32 : 24)),

                        // 🚀 Continue Button (Responsive - Smooth Hover)
                        FadeTransition(
                          opacity: _fadeAnimation,
                          child: Container(
                            width: double.infinity,
                            constraints: BoxConstraints(
                              maxWidth: isTablet ? 500 : double.infinity,
                            ),
                            height: isSmallDevice ? 56 : (isTablet ? 64 : 60),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(20),
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE91E63), Color(0xFFAD1457)],
                              ),
                              boxShadow: [
                                BoxShadow(
                                  color:
                                      const Color(0xFFE91E63).withOpacity(0.4),
                                  blurRadius: 20,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushAndRemoveUntil(
                                  context,
                                  MaterialPageRoute(
                                      builder: (_) => const SessionRedirector()),
                                  (route) => false,
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.transparent,
                                foregroundColor: Colors.white,
                                shadowColor: Colors.transparent,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                              ),
                              child: Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    loc.continueText,
                                    style: GoogleFonts.poppins(
                                      fontSize: isSmallDevice ? 16 : (isTablet ? 20 : 18),
                                      fontWeight: FontWeight.w600,
                                      letterSpacing: 0.3,
                                    ),
                                  ),
                                  SizedBox(width: isSmallDevice ? 8 : 12),
                                  Icon(
                                    Icons.arrow_forward_rounded,
                                    size: isSmallDevice ? 20 : (isTablet ? 24 : 22),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: isSmallDevice ? 24 : (isTablet ? 40 : 30)),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}