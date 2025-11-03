import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../../l10n/app_localizations.dart';
import 'confirm.dart';

final supabase = Supabase.instance.client;

class ConfirmBookingPage extends StatefulWidget {
  final String doctorName;
  final String hospital;
  final DateTime selectedDate;
  final String selectedTime;
  final int selectedDayIndex;

  const ConfirmBookingPage({
    super.key,
    required this.doctorName,
    required this.hospital,
    required this.selectedDate,
    required this.selectedTime,
    required this.selectedDayIndex,
  });

  @override
  State<ConfirmBookingPage> createState() => _ConfirmBookingPageState();
}

class _ConfirmBookingPageState extends State<ConfirmBookingPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _ageController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();

  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();

  Future<void> _submitBooking() async {
    if (!_formKey.currentState!.validate()) {
      _showSnackBar('⚠️ ${AppLocalizations.of(context)!.fillFields}');
      return;
    }

    setState(() => _isLoading = true);

    try {
      await supabase.from("appointments").insert({
        "doctor_name": widget.doctorName,
        "hospital": widget.hospital,
        "date":
            "${widget.selectedDate.day}/${widget.selectedDate.month}/${widget.selectedDate.year}",
        "time": widget.selectedTime,
        "patient_name": _nameController.text,
        "patient_mobile": _mobileController.text,
        "patient_age": _ageController.text,
        "patient_email": _emailController.text,
        "user_id": supabase.auth.currentUser?.id,
      });

      Navigator.pushReplacement(
        context,
        MaterialPageRoute(
          builder: (context) => BookingSuccessPage(
            doctorName: widget.doctorName,
            selectedDate: widget.selectedDate,
            selectedTime: widget.selectedTime,
          ),
        ),
      );
    } catch (e) {
      debugPrint("❌ Error inserting booking: $e");
      _showSnackBar('❌ ${AppLocalizations.of(context)!.bookingFailed}');
    } finally {
      setState(() => _isLoading = false);
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        margin: const EdgeInsets.all(16),
      ),
    );
  }

  void _cancelBooking() => Navigator.pop(context);

  String _formatDate(DateTime date) {
    final loc = AppLocalizations.of(context)!;
    final days = [
      loc.monday,
      loc.tuesday,
      loc.wednesday,
      loc.thursday,
      loc.friday,
    ];
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
    return '${days[widget.selectedDayIndex]}, ${date.day} ${months[date.month - 1]} ${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor:  Colors.white,
      body: Column(
        children: [
          _buildHeader(loc),
          Expanded(
            child: Container(
              decoration: const BoxDecoration(
                color:const Color(0xFFFDEFF4),
      
              ),
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: SingleChildScrollView(
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    children: [
                      _buildAppointmentCard(loc),
                      const SizedBox(height: 24),
                      _buildPatientInfoCard(loc),
                      const SizedBox(height: 32),
                      _buildActionButtons(loc),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader(AppLocalizations loc) {
    return Container(
      padding: const EdgeInsets.only(top: 60, left: 0, right: 16, bottom: 24),
      child: Row(
        children: [
          IconButton(
            icon: const Icon(Icons.arrow_back, size: 24),
            onPressed: () => Navigator.of(context).pop(),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              loc.confirmBooking,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAppointmentCard(AppLocalizations loc) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE91E63).withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.calendar_today_rounded,
                  color: Color(0xFFE91E63),
                  size: 22,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                loc.appointmentSummary,
                style: GoogleFonts.poppins(
                  fontSize: 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          _buildDetailRow(Icons.person_rounded, loc.doctor, widget.doctorName),
          _buildDetailRow(Icons.local_hospital_rounded, loc.hospital, widget.hospital),
          _buildDetailRow(Icons.date_range_rounded, loc.date, _formatDate(widget.selectedDate)),
          _buildDetailRow(Icons.access_time_rounded, loc.time, widget.selectedTime),
        ],
      ),
    );
  }

  Widget _buildDetailRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFFE91E63), size: 20),
          const SizedBox(width: 12),
          Text(
            "$label:",
            style: GoogleFonts.poppins(
              fontSize: 15,
              fontWeight: FontWeight.w500,
              color: Colors.grey[700],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              value,
              style: GoogleFonts.poppins(
                fontSize: 15,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPatientInfoCard(AppLocalizations loc) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 20,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFFE91E63).withOpacity(0.1),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.person_outline_rounded,
                    color: Color(0xFFE91E63),
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  loc.patientInfo,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),
            _buildInputField(loc.fullName, Icons.person_outline_rounded, _nameController,
                TextInputType.name, validator: _validateName),
            const SizedBox(height: 16),
            _buildInputField(loc.mobileNumber, Icons.phone_rounded, _mobileController,
                TextInputType.phone, maxLength: 10, validator: _validateMobile),
            const SizedBox(height: 16),
            _buildInputField(loc.age, Icons.cake_rounded, _ageController, TextInputType.number,
                maxLength: 3, suffix: loc.yrs, validator: _validateAge),
            const SizedBox(height: 16),
            _buildInputField(loc.email, Icons.email_rounded, _emailController,
                TextInputType.emailAddress, validator: _validateEmail),
          ],
        ),
      ),
    );
  }

  Widget _buildInputField(
    String hint,
    IconData icon,
    TextEditingController ctrl,
    TextInputType type, {
    int maxLength = 100,
    int maxLines = 1,
    String? suffix,
    String? Function(String?)? validator,
  }) {
    return TextFormField(
      controller: ctrl,
      keyboardType: type,
      maxLength: maxLength > 99 ? null : maxLength,
      maxLines: maxLines,
      validator: validator,
      style: GoogleFonts.poppins(fontSize: 15),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: GoogleFonts.poppins(color: Colors.grey[600]),
        prefixIcon: Container(
          margin: const EdgeInsets.all(12),
          child: Icon(icon, color: const Color(0xFFE91E63), size: 22),
        ),
        suffixText: suffix,
        counterText: '',
        filled: true,
        fillColor: Colors.grey[50],
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: BorderSide.none,
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(16),
          borderSide: const BorderSide(color: Color(0xFFE91E63), width: 2),
        ),
        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      ),
    );
  }

  Widget _buildActionButtons(AppLocalizations loc) {
    return Row(
      children: [
        Expanded(
          child: ElevatedButton(
            onPressed: _cancelBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              shadowColor: Colors.red.withOpacity(0.3),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.cancel_rounded, color: Colors.white, size: 20),
                const SizedBox(width: 8),
                Text(
                  loc.cancel,
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitBooking,
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              padding: const EdgeInsets.symmetric(vertical: 16),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
              elevation: 2,
              shadowColor: Colors.green.withOpacity(0.3),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 20,
                    height: 20,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      color: Colors.white,
                    ),
                  )
                : Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_circle_rounded, color: Colors.white, size: 20),
                      const SizedBox(width: 8),
                      Text(
                        loc.confirm,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  // Validation
  String? _validateName(String? value) {
    final loc = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) return loc.enterName;
    if (value.length < 2) return loc.nameTooShort;
    return null;
  }

  String? _validateMobile(String? value) {
    final loc = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) return loc.enterMobile;
    if (value.length != 10) return loc.mobileLength;
    if (!RegExp(r'^[0-9]+$').hasMatch(value)) {
      return loc.validMobile;
    }
    return null;
  }

  String? _validateAge(String? value) {
    final loc = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) return loc.enterAge;
    final age = int.tryParse(value);
    if (age == null || age < 1 || age > 120) {
      return loc.validAge;
    }
    return null;
  }

  String? _validateEmail(String? value) {
    final loc = AppLocalizations.of(context)!;
    if (value == null || value.isEmpty) return loc.enterEmail;
    if (!RegExp(r'^[^@]+@[^@]+\.[^@]+').hasMatch(value)) {
      return loc.validEmail;
    }
    return null;
  }
}
