import 'dart:async';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../l10n/app_localizations.dart';

class BookingSuccessPage extends StatefulWidget {
  final String doctorName;
  final DateTime selectedDate;
  final String selectedTime;
  
  const BookingSuccessPage({
    super.key,
    required this.doctorName,
    required this.selectedDate,
    required this.selectedTime,
  });

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
 
  final TextEditingController _feedbackController = TextEditingController();
  bool _isSubmitting = false;
  int _selectedRating = 0;
 
  // ✅ Fixed: Only 4 emoji ratings, so generate only 4 buttons
  final List<Map<String, dynamic>> _emojiRatings = [
    {'emoji': '😕', 'label': 'Bad', 'color': Color(0xFFFF9800)},
    {'emoji': '😐', 'label': 'Okay', 'color': Color(0xFFFFC107)},
    {'emoji': '😊', 'label': 'Good', 'color': Color(0xFF66BB6A)},
    {'emoji': '😍', 'label': 'Excellent', 'color': Color(0xFF4CAF50)},
  ];

  final _supabase = Supabase.instance.client;

  @override
  void initState() {
    super.initState();
    _scaleController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );
    _slideController = AnimationController(
      duration: const Duration(milliseconds: 1000),
      vsync: this,
    );
    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 1200),
      vsync: this,
    );

    _scaleAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _scaleController, curve: Curves.elasticOut),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.5),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(parent: _slideController, curve: Curves.easeOutCubic),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _fadeController, curve: Curves.easeIn),
    );

    _scaleController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) _slideController.forward();
    });
    Future.delayed(const Duration(milliseconds: 600), () {
      if (mounted) _fadeController.forward();
    });
  }

  @override
  void dispose() {
    _scaleController.dispose();
    _slideController.dispose();
    _fadeController.dispose();
    _feedbackController.dispose();
    super.dispose();
  }

  String _formatDate(DateTime date, AppLocalizations loc) {
    final months = [
      loc.jan,
      loc.feb,
      loc.mar,
      loc.apr,
      loc.may,
      loc.jun,
      loc.jul,
      loc.aug,
      loc.sep,
      loc.oct,
      loc.nov,
      loc.dec,
    ];
    return '${date.day} ${months[date.month - 1]} ${date.year}';
  }

  Future<void> _submitFeedbackAndContinue() async {
    if (_selectedRating == 0) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Please select a rating before submitting! 🌟',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: Colors.orange,
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    setState(() => _isSubmitting = true);

    try {
      final user = _supabase.auth.currentUser;
      if (user == null) throw Exception('User not authenticated');

      String userName = user.userMetadata?['name'] ??
          user.userMetadata?['full_name'] ??
          user.email?.split('@')[0] ??
          'Anonymous User';

      final feedbackData = {
        'user_id': user.id,
        'user_name': userName,
        'doctor_name': widget.doctorName,
        'appointment_date': widget.selectedDate.toIso8601String(),
        'appointment_time': widget.selectedTime,
        'rating': _selectedRating,
        'feedback_text': _feedbackController.text.trim().isEmpty
            ? null
            : _feedbackController.text.trim(),
        'created_at': DateTime.now().toIso8601String(),
      };

      await _supabase.from('booking_feedback').insert(feedbackData);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Thank you for your feedback! 🎉',
            style: GoogleFonts.poppins(),
          ),
          backgroundColor: const Color(0xFF880E4F),
          duration: const Duration(seconds: 2),
        ),
      );

      await Future.delayed(const Duration(milliseconds: 800));
      if (mounted) {
        Navigator.popUntil(context, (route) => route.isFirst);
      }
    } on PostgrestException catch (e) {
      if (!mounted) return;
      String errorMessage = 'Error submitting feedback. Please try again.';
      if (e.code == '23505') {
        errorMessage = 'Feedback already submitted for this booking.';
      } else if (e.code == '42P01') {
        errorMessage = 'Database table not found. Please contact support.';
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage, style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error submitting feedback: ${e.toString()}',
              style: GoogleFonts.poppins()),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return WillPopScope(
      onWillPop: () async {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              'Please submit your feedback to continue! 🙏',
              style: GoogleFonts.poppins(),
            ),
            backgroundColor: const Color(0xFF880E4F),
            duration: const Duration(seconds: 2),
          ),
        );
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFFFFF0F5),
          elevation: 0,
          automaticallyImplyLeading: false,
          title: Text(
            loc.bookingSuccessful,
            style: GoogleFonts.poppins(
              fontSize: 20,
              fontWeight: FontWeight.w700,
              color: Colors.black,
            ),
          ),
          centerTitle: true,
        ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Color(0xFFFFF0F5),
                Color(0xFFFFE4E6),
                Color(0xFFFFF5F7),
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
          child: SafeArea(
            child: SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24.0),
                child: Column(
                  children: [
                    const SizedBox(height: 40),
                    ScaleTransition(
                      scale: _scaleAnimation,
                      child: Container(
                        width: 100,
                        height: 100,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          gradient: const LinearGradient(
                            colors: [Color(0xFFE91E63), Color(0xFFAD1457)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          ),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE91E63).withOpacity(0.4),
                              blurRadius: 20,
                              offset: const Offset(0, 8),
                            ),
                          ],
                        ),
                        child: const Icon(Icons.check, size: 50, color: Colors.white),
                      ),
                    ),
                    const SizedBox(height: 30),
                    SlideTransition(
                      position: _slideAnimation,
                      child: Column(
                        children: [
                          Text(
                            loc.appointmentBooked,
                            textAlign: TextAlign.center,
                            style: GoogleFonts.poppins(
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF880E4F),
                              height: 1.2,
                            ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            height: 4,
                            width: 60,
                            decoration: BoxDecoration(
                              gradient: const LinearGradient(
                                colors: [Color(0xFFE91E63), Color(0xFFF48FB1)],
                              ),
                              borderRadius: BorderRadius.circular(2),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 30),
                    SlideTransition(
                      position: _slideAnimation,
                      child: Container(
                        width: double.infinity,
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE91E63).withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              children: [
                                const Icon(Icons.local_hospital, color: Color(0xFF880E4F)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    loc.withDoctor(widget.doctorName),
                                    style: GoogleFonts.poppins(
                                      fontSize: 18,
                                      fontWeight: FontWeight.w600,
                                      color: const Color(0xFF880E4F),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 16),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, color: Color(0xFF880E4F)),
                                const SizedBox(width: 12),
                                Expanded(
                                  child: Text(
                                    "${_formatDate(widget.selectedDate, loc)} ${loc.atTime} ${widget.selectedTime}",
                                    style: GoogleFonts.poppins(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    // ✅ Fixed emoji section
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE91E63).withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Text(
                              'How was your booking experience? ⭐',
                              textAlign: TextAlign.center,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF880E4F),
                              ),
                            ),
                            const SizedBox(height: 24),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: List.generate(_emojiRatings.length, (index) {
                                final rating = _emojiRatings[index];
                                final isSelected = _selectedRating == index + 1;
                                return GestureDetector(
                                  onTap: () {
                                    setState(() {
                                      _selectedRating = index + 1;
                                    });
                                  },
                                  child: AnimatedContainer(
                                    duration: const Duration(milliseconds: 300),
                                    curve: Curves.easeInOut,
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: isSelected
                                          ? rating['color'].withOpacity(0.15)
                                          : Colors.grey[100],
                                      shape: BoxShape.circle,
                                      border: Border.all(
                                        color: isSelected
                                            ? rating['color']
                                            : Colors.transparent,
                                        width: 3,
                                      ),
                                      boxShadow: isSelected
                                          ? [
                                              BoxShadow(
                                                color: rating['color'].withOpacity(0.3),
                                                blurRadius: 12,
                                                offset: const Offset(0, 4),
                                              ),
                                            ]
                                          : [],
                                    ),
                                    child: Text(
                                      rating['emoji'],
                                      style: TextStyle(
                                        fontSize: isSelected ? 36 : 32,
                                      ),
                                    ),
                                  ),
                                );
                              }),
                            ),
                            if (_selectedRating > 0) ...[
                              const SizedBox(height: 16),
                              Text(
                                _emojiRatings[_selectedRating - 1]['label'],
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: _emojiRatings[_selectedRating - 1]['color'],
                                ),
                              ),
                            ],
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: Container(
                        padding: const EdgeInsets.all(20),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFFE91E63).withOpacity(0.08),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Share your thoughts 💭',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: const Color(0xFF880E4F),
                              ),
                            ),
                            const SizedBox(height: 12),
                            TextField(
                              controller: _feedbackController,
                              maxLines: 4,
                              maxLength: 500,
                              decoration: InputDecoration(
                                hintText:
                                    'Tell us about your booking experience... (optional)',
                                hintStyle: GoogleFonts.poppins(
                                  fontSize: 14,
                                  color: Colors.grey[400],
                                ),
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(12),
                                  borderSide: const BorderSide(
                                    color: Color(0xFFE91E63),
                                    width: 2,
                                  ),
                                ),
                                contentPadding: const EdgeInsets.all(16),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(height: 30),
                    FadeTransition(
                      opacity: _fadeAnimation,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: _isSubmitting ? null : _submitFeedbackAndContinue,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFE91E63),
                            padding: const EdgeInsets.symmetric(vertical: 18),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(16),
                            ),
                            disabledBackgroundColor: Colors.grey[400],
                            elevation: 8,
                          ),
                          child: _isSubmitting
                              ? const SizedBox(
                                  height: 24,
                                  width: 24,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2.5,
                                  ),
                                )
                              : Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Submit & Continue',
                                      style: GoogleFonts.poppins(
                                        fontSize: 18,
                                        fontWeight: FontWeight.w600,
                                        color: Colors.white,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    const Icon(Icons.arrow_forward, color: Colors.white),
                                  ],
                                ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
