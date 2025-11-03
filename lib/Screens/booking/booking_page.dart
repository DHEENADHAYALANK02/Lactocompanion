import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:lactocompanion/l10n/app_localizations.dart';
import 'bookingconfrompage.dart';

final supabase = Supabase.instance.client;

class ExpertConsultationPage extends StatefulWidget {
  const ExpertConsultationPage({super.key});

  @override
  State<ExpertConsultationPage> createState() => _ExpertConsultationPageState();
}

class _ExpertConsultationPageState extends State<ExpertConsultationPage> {
  List<dynamic> _doctors = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchDoctors();
  }

  Future<void> _fetchDoctors() async {
    try {
      final response = await supabase.from('doctors').select();
      setState(() {
        _doctors = response;
        _isLoading = false;
      });
    } catch (e) {
      debugPrint("❌ Error fetching doctors: $e");
      setState(() => _isLoading = false);
    }
  }

  String _getLocalizedName(Map doctor, BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == "ar") {
      return doctor["name_ar"]?.toString().trim().isNotEmpty == true
          ? doctor["name_ar"]
          : (doctor["name_en"] ?? doctor["name"] ?? "Unknown");
    }
    return doctor["name_en"]?.toString().trim().isNotEmpty == true
        ? doctor["name_en"]
        : (doctor["name"] ?? "Unknown");
  }

  String _getLocalizedSpecialization(Map doctor, BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == "ar") {
      return doctor["specialization_ar"]?.toString().trim().isNotEmpty == true
          ? doctor["specialization_ar"]
          : (doctor["specialization_en"] ?? doctor["specialization"] ?? "General Doctor");
    }
    return doctor["specialization_en"]?.toString().trim().isNotEmpty == true
        ? doctor["specialization_en"]
        : (doctor["specialization"] ?? "General Doctor");
  }

  String _getLocalizedHospital(Map doctor, BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == "ar") {
      return doctor["hospital_ar"]?.toString().trim().isNotEmpty == true
          ? doctor["hospital_ar"]
          : (doctor["hospital_en"] ?? doctor["hospital"] ?? "Hospital");
    }
    return doctor["hospital_en"]?.toString().trim().isNotEmpty == true
        ? doctor["hospital_en"]
        : (doctor["hospital"] ?? "Hospital");
  }


  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final screenWidth = MediaQuery.of(context).size.width;

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDEFF4),
        appBar: AppBar(
          backgroundColor:  Colors.white,
          centerTitle: true,
          title: Text(
            loc.expertConsultation,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: screenWidth < 360 ? 18 : 20,
              color: Colors.black87,
            ),
          ),
          toolbarHeight: 70,
          leading: IconButton(
            icon: Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: Colors.grey.shade200,
              height: 1,
            ),
          ),
        ),
        body: _isLoading
            ? const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(Color(0xFFE91E63)),
                ),
              )
            : ListView.builder(
                padding: EdgeInsets.symmetric(
                  horizontal: screenWidth * 0.04,
                  vertical: 16,
                ),
                itemCount: _doctors.length,
                itemBuilder: (context, index) {
                  final doc = _doctors[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildDoctorCard(context, doc, loc, isRTL, screenWidth),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, Map doctor, AppLocalizations loc, bool isRTL, double screenWidth) {
    final isSmallScreen = screenWidth < 360;
    
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 14 : 16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: isSmallScreen ? 70 : 80,
                height: isSmallScreen ? 70 : 80,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFE91E63).withOpacity(0.1),
                      const Color(0xFFF06292).withOpacity(0.1),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: const Color(0xFFE91E63).withOpacity(0.2),
                    width: 2,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(14),
                  child: doctor['image_url'] != null
                      ? Image.network(
                          doctor['image_url'],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => Icon(
                            Icons.person,
                            size: isSmallScreen ? 35 : 40,
                            color: const Color(0xFFE91E63),
                          ),
                        )
                      : Icon(
                          Icons.person,
                          size: isSmallScreen ? 35 : 40,
                          color: const Color(0xFFE91E63),
                        ),
                ),
              ),
              SizedBox(width: isSmallScreen ? 12 : 16),
              Expanded(
                child: Column(
                  crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getLocalizedName(doctor, context),
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 15 : 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      textAlign: isRTL ? TextAlign.right : TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: const Color(0xFFE91E63).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        _getLocalizedSpecialization(doctor, context),
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 11 : 12,
                          color: const Color(0xFFE91E63),
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: isRTL ? MainAxisAlignment.end : MainAxisAlignment.start,
                      children: [
                        Icon(Icons.location_on, size: 14, color: Colors.grey.shade600),
                        const SizedBox(width: 4),
                        Flexible(
                          child: Text(
                            _getLocalizedHospital(doctor, context),
                            style: GoogleFonts.poppins(
                              fontSize: isSmallScreen ? 11 : 12,
                              color: Colors.grey.shade600,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: EdgeInsets.symmetric(
                  horizontal: isSmallScreen ? 12 : 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: doctor['is_available'] == true 
                      ? const Color(0xFF4CAF50).withOpacity(0.1)
                      : Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: doctor['is_available'] == true 
                        ? const Color(0xFF4CAF50)
                        : Colors.red,
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: doctor['is_available'] == true 
                            ? const Color(0xFF4CAF50)
                            : Colors.red,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                    Text(
                      doctor['is_available'] == true ? loc.available : loc.notAvailable,
                      style: GoogleFonts.poppins(
                        color: doctor['is_available'] == true 
                            ? const Color(0xFF4CAF50)
                            : Colors.red,
                        fontSize: isSmallScreen ? 11 : 12,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ],
                ),
              ),
              if (doctor['is_available'] == true)
                Container(
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [Color(0xFF2196F3), Color(0xFF1976D2)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: [
                      BoxShadow(
                        color: const Color(0xFF2196F3).withOpacity(0.3),
                        blurRadius: 8,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Material(
                    color: Colors.transparent,
                    child: InkWell(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => DoctorDetailsPage(doctor: doctor),
                          ),
                        );
                      },
                      borderRadius: BorderRadius.circular(14),
                      child: Padding(
                        padding: EdgeInsets.symmetric(
                          horizontal: isSmallScreen ? 18 : 24,
                          vertical: isSmallScreen ? 10 : 12,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(
                              Icons.calendar_today,
                              size: isSmallScreen ? 14 : 16,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Text(
                              loc.bookNow,
                              style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: isSmallScreen ? 12 : 14,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class DoctorDetailsPage extends StatefulWidget {
  final Map doctor;

  const DoctorDetailsPage({super.key, required this.doctor});

  @override
  State<DoctorDetailsPage> createState() => _DoctorDetailsPageState();
}

class _DoctorDetailsPageState extends State<DoctorDetailsPage> {
  DateTime _currentWeekStart = _getStartOfWeek(DateTime.now());
  String _selectedTime = '08:30 am';
  int _selectedDayIndex = 0;

  final List<String> _timeSlots = [
    '08:30 am',
    '10:00 am',
    '12:30 pm',
    '02:30 pm',
    '04:00 pm',
    '06:00 pm',
    
  ];

  static DateTime _getStartOfWeek(DateTime date) {
    return date.subtract(Duration(days: date.weekday - 1));
  }

  List<DateTime> get _currentWeekDays =>
      List.generate(5, (i) => _currentWeekStart.add(Duration(days: i)));

  void _navigateWeek(int dir) {
    setState(() {
      _currentWeekStart = _currentWeekStart.add(Duration(days: dir * 7));
      _selectedDayIndex = 0;
    });
  }

  String _getWeekRange() {
    final start = _currentWeekStart;
    final end = _currentWeekStart.add(const Duration(days: 4));
    return "${start.day}/${start.month} - ${end.day}/${end.month} ${start.year}";
  }

  String _getLocalizedName(Map doctor, BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == "ar") {
      return doctor["name_ar"]?.toString().trim().isNotEmpty == true
          ? doctor["name_ar"]
          : (doctor["name_en"] ?? doctor["name"] ?? "Doctor");
    }
    return doctor["name_en"]?.toString().trim().isNotEmpty == true
        ? doctor["name_en"]
        : (doctor["name"] ?? "Doctor");
  }

  String _getLocalizedSpecialization(Map doctor, BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == "ar") {
      return doctor["specialization_ar"]?.toString().trim().isNotEmpty == true
          ? doctor["specialization_ar"]
          : (doctor["specialization_en"] ?? doctor["specialization"] ?? "General Doctor");
    }
    return doctor["specialization_en"]?.toString().trim().isNotEmpty == true
        ? doctor["specialization_en"]
        : (doctor["specialization"] ?? "General Doctor");
  }

  String _getLocalizedHospital(Map doctor, BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == "ar") {
      return doctor["hospital_ar"]?.toString().trim().isNotEmpty == true
          ? doctor["hospital_ar"]
          : (doctor["hospital_en"] ?? doctor["hospital"] ?? "");
    }
    return doctor["hospital_en"]?.toString().trim().isNotEmpty == true
        ? doctor["hospital_en"]
        : (doctor["hospital"] ?? "");
  }

  String _getLocalizedAddress(Map doctor, BuildContext context) {
    final lang = Localizations.localeOf(context).languageCode;
    if (lang == "ar") {
      return doctor["address_ar"]?.toString().trim().isNotEmpty == true
          ? doctor["address_ar"]
          : (doctor["address_en"] ?? doctor["address"] ?? "");
    }
    return doctor["address_en"]?.toString().trim().isNotEmpty == true
        ? doctor["address_en"]
        : (doctor["address"] ?? "");
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.doctor;
    final loc = AppLocalizations.of(context)!;
    final isRTL = Directionality.of(context) == TextDirection.rtl;
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;
    final isSmallScreen = screenWidth < 360;

    return Directionality(
      textDirection: isRTL ? TextDirection.rtl : TextDirection.ltr,
      child: Scaffold(
        backgroundColor: const Color(0xFFFDEFF4),
        appBar: AppBar(
          backgroundColor: Colors.white,
          elevation: 0,
          centerTitle: true,
          title: Text(
            loc.doctorDetails,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w700,
              fontSize: isSmallScreen ? 18 : 20,
              color: Colors.black87,
            ),
          ),
          leading: IconButton(
            icon: const Icon(
              Icons.arrow_back,
              color: Colors.black87,
            ),
            onPressed: () => Navigator.pop(context),
          ),
          toolbarHeight: 60,
          bottom: PreferredSize(
            preferredSize: const Size.fromHeight(1),
            child: Container(
              color: Colors.grey.shade200,
              height: 1,
            ),
          ),
        ),
        body: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          padding: EdgeInsets.all(screenWidth * 0.04),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              _buildDoctorProfile(doc, loc, isRTL, screenWidth, isSmallScreen),
              SizedBox(height: screenHeight * 0.02),
              _buildContactInfo(doc, loc, isRTL, screenWidth, isSmallScreen),
              SizedBox(height: screenHeight * 0.03),
              _buildWeekNavigation(isRTL, screenWidth, isSmallScreen),
              SizedBox(height: screenHeight * 0.02),
              _buildDateSelection(loc, isRTL, screenWidth, isSmallScreen),
              SizedBox(height: screenHeight * 0.02),
              _buildTimeSelection(loc, isRTL, screenWidth, isSmallScreen),
              SizedBox(height: screenHeight * 0.03),
              _buildBookButton(loc, isRTL, screenWidth, isSmallScreen),
              SizedBox(height: screenHeight * 0.02),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorProfile(Map doc, AppLocalizations loc, bool isRTL, double screenWidth, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                width: isSmallScreen ? 90 : 110,
                height: isSmallScreen ? 90 : 110,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFE91E63).withOpacity(0.1),
                      const Color(0xFFF06292).withOpacity(0.1),
                    ],
                  ),
                  border: Border.all(
                    color: const Color(0xFFE91E63).withOpacity(0.3),
                    width: 3,
                  ),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(17),
                  child: doc['image_url'] != null
                      ? Image.network(
                          doc['image_url'],
                          fit: BoxFit.cover,
                          errorBuilder: (_, __, ___) => _buildPlaceholderIcon(),
                        )
                      : _buildPlaceholderIcon(),
                ),
              ),
              SizedBox(width: isSmallScreen ? 14 : 18),
              Expanded(
                child: Column(
                  crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      _getLocalizedName(doc, context),
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 17 : 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black87,
                      ),
                      textAlign: isRTL ? TextAlign.right : TextAlign.left,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        gradient: const LinearGradient(
                          colors: [Color(0xFFE91E63), Color(0xFFF06292)],
                        ),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        _getLocalizedSpecialization(doc, context),
                        style: GoogleFonts.poppins(
                          fontSize: isSmallScreen ? 12 : 13,
                          color: Colors.white,
                          fontWeight: FontWeight.w600,
                        ),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 18),
          _buildInfoRow(
            Icons.local_hospital,
            _getLocalizedHospital(doc, context),
            isRTL,
            isSmallScreen,
          ),
          const SizedBox(height: 10),
          _buildInfoRow(
            Icons.location_on,
            _getLocalizedAddress(doc, context),
            isRTL,
            isSmallScreen,
          ),
        ],
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String text, bool isRTL, bool isSmallScreen) {
    return Row(
      mainAxisAlignment: isRTL ? MainAxisAlignment.end : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE91E63).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFFE91E63), size: isSmallScreen ? 16 : 18),
        ),
        const SizedBox(width: 10),
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(top: 8),
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: isSmallScreen ? 13 : 14,
                color: Colors.grey.shade700,
              ),
              textAlign: isRTL ? TextAlign.right : TextAlign.left,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            const Color(0xFFE91E63).withOpacity(0.2),
            const Color(0xFFF06292).withOpacity(0.2),
          ],
        ),
        borderRadius: BorderRadius.circular(17),
      ),
      child: const Icon(Icons.person, size: 50, color: Color(0xFFE91E63)),
    );
  }

  Widget _buildContactInfo(Map doc, AppLocalizations loc, bool isRTL, double screenWidth, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          _buildContactItem(Icons.phone, loc.phone, doc['phone'] ?? '', isRTL, isSmallScreen),
          const SizedBox(height: 14),
          _buildContactItem(Icons.email, loc.email, doc['email'] ?? '', isRTL, isSmallScreen),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value, bool isRTL, bool isSmallScreen) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                const Color(0xFFE91E63).withOpacity(0.1),
                const Color(0xFFF06292).withOpacity(0.1),
              ],
            ),
            borderRadius: BorderRadius.circular(14),
          ),
          child: Icon(icon, color: const Color(0xFFE91E63), size: isSmallScreen ? 20 : 22),
        ),
        const SizedBox(width: 14),
        Expanded(
          child: Column(
            crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 11 : 12,
                  color: Colors.grey.shade600,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: isRTL ? TextAlign.right : TextAlign.left,
              ),
              const SizedBox(height: 3),
              Text(
                value.isNotEmpty ? value : 'Not available',
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 14 : 15,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
                textAlign: isRTL ? TextAlign.right : TextAlign.left,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildWeekNavigation(bool isRTL, double screenWidth, bool isSmallScreen) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            onPressed: () => _navigateWeek(-1),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE91E63).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_back,
                color: const Color(0xFFE91E63),
                size: isSmallScreen ? 20 : 24,
              ),
            ),
          ),
          Expanded(
            child: Center(
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(12),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.05),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: Text(
                  _getWeekRange(),
                  style: GoogleFonts.poppins(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: Colors.black87,
                  ),
                ),
              ),
            ),
          ),
          IconButton(
            onPressed: () => _navigateWeek(1),
            icon: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFFE91E63).withOpacity(0.1),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                Icons.arrow_forward,
                color: const Color(0xFFE91E63),
                size: isSmallScreen ? 20 : 24,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDateSelection(AppLocalizations loc, bool isRTL, double screenWidth, bool isSmallScreen) {
    final days = isRTL
        ? [loc.monday, loc.tuesday, loc.wednesday, loc.thursday, loc.friday]
        : ['Mo', 'Tue', 'We', 'Thu', 'Fri'];

    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFE91E63).withOpacity(0.15),
                      const Color(0xFFF06292).withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.calendar_today, color: Color(0xFFE91E63), size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                loc.selectDate,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: List.generate(5, (i) {
              final d = _currentWeekDays[i];
              final selected = i == _selectedDayIndex;
              return Flexible(
                child: GestureDetector(
                  onTap: () => setState(() => _selectedDayIndex = i),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 250),
                    margin: EdgeInsets.symmetric(horizontal: isSmallScreen ? 2 : 4),
                    padding: EdgeInsets.symmetric(
                      vertical: isSmallScreen ? 12 : 16,
                      horizontal: isSmallScreen ? 6 : 10,
                    ),
                    decoration: BoxDecoration(
                      gradient: selected
                          ? const LinearGradient(
                              colors: [Color(0xFFE91E63), Color(0xFFC2185B)],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            )
                          : null,
                      color: selected ? null : Colors.grey.shade50,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: selected ? const Color(0xFFE91E63) : Colors.grey.shade300,
                        width: selected ? 2 : 1,
                      ),
                      boxShadow: selected
                          ? [
                              BoxShadow(
                                color: const Color(0xFFE91E63).withOpacity(0.3),
                                blurRadius: 8,
                                offset: const Offset(0, 4),
                              ),
                            ]
                          : [],
                    ),
                    child: Column(
                      children: [
                        Text(
                          days[i],
                          style: GoogleFonts.poppins(
                            fontSize: isSmallScreen ? 11 : 12,
                            color: selected ? Colors.white : Colors.grey[600],
                            fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
                          ),
                        ),
                        const SizedBox(height: 6),
                        Text(
                          "${d.day}",
                          style: GoogleFonts.poppins(
                            fontSize: isSmallScreen ? 17 : 20,
                            fontWeight: FontWeight.bold,
                            color: selected ? Colors.white : Colors.black87,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelection(AppLocalizations loc, bool isRTL, double screenWidth, bool isSmallScreen) {
    return Container(
      padding: EdgeInsets.all(isSmallScreen ? 16 : 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: isRTL ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      const Color(0xFFE91E63).withOpacity(0.15),
                      const Color(0xFFF06292).withOpacity(0.15),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.access_time, color: Color(0xFFE91E63), size: 20),
              ),
              const SizedBox(width: 12),
              Text(
                loc.selectTime,
                style: GoogleFonts.poppins(
                  fontSize: isSmallScreen ? 16 : 18,
                  fontWeight: FontWeight.w600,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _timeSlots.length,
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: isSmallScreen ? 2 : 3,
              crossAxisSpacing: isSmallScreen ? 10 : 14,
              mainAxisSpacing: isSmallScreen ? 10 : 14,
              childAspectRatio: isSmallScreen ? 2.3 : 2.5,
            ),
            itemBuilder: (context, index) {
              final t = _timeSlots[index];
              final selected = _selectedTime == t;
              return GestureDetector(
                onTap: () => setState(() => _selectedTime = t),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    gradient: selected
                        ? const LinearGradient(
                            colors: [Color(0xFFE91E63), Color(0xFFC2185B)],
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                          )
                        : null,
                    color: selected ? null : Colors.grey.shade50,
                    border: Border.all(
                      color: selected ? const Color(0xFFE91E63) : Colors.grey.shade300,
                      width: selected ? 2 : 1,
                    ),
                    borderRadius: BorderRadius.circular(14),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: const Color(0xFFE91E63).withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 3),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    t,
                    style: GoogleFonts.poppins(
                      fontSize: isSmallScreen ? 13 : 14,
                      fontWeight: FontWeight.w600,
                      color: selected ? Colors.white : Colors.black87,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildBookButton(AppLocalizations loc, bool isRTL, double screenWidth, bool isSmallScreen) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 20),
      child: SafeArea(
        top: false,
        child: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFFE91E63), Color(0xFFC2185B)],
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
            ),
            borderRadius: BorderRadius.circular(18),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFFE91E63).withOpacity(0.4),
                blurRadius: 15,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                final selectedDate = _currentWeekDays[_selectedDayIndex];
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ConfirmBookingPage(
                      doctorName: _getLocalizedName(widget.doctor, context),
                      hospital: _getLocalizedHospital(widget.doctor, context),
                      selectedDate: selectedDate,
                      selectedTime: _selectedTime,
                      selectedDayIndex: _selectedDayIndex,
                    ),
                  ),
                );
              },
              borderRadius: BorderRadius.circular(18),
              child: Container(
                width: double.infinity,
                height: isSmallScreen ? 54 : 60,
                alignment: Alignment.center,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.calendar_month,
                      color: Colors.white,
                      size: 24,
                    ),
                    const SizedBox(width: 12),
                    Text(
                      loc.bookAppointment,
                      style: GoogleFonts.poppins(
                        fontSize: isSmallScreen ? 15 : 17,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
                        letterSpacing: 0.5,
                      ),
                    ),
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