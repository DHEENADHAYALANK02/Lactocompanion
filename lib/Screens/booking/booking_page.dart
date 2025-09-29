import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF8BBD9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8BBD9),
        elevation: 0,
        title: Text(
          "Expert Consultation",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        toolbarHeight: 80,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 0),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 250, 231, 233),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: _isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _doctors.length,
                itemBuilder: (context, index) {
                  final doc = _doctors[index];
                  return Padding(
                    padding: const EdgeInsets.only(bottom: 16),
                    child: _buildDoctorCard(context, doc),
                  );
                },
              ),
      ),
    );
  }

  Widget _buildDoctorCard(BuildContext context, Map doctor) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(12),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: doctor['image_url'] != null
                  ? Image.network(doctor['image_url'], fit: BoxFit.cover)
                  : Icon(Icons.person, size: 40, color: Colors.grey[600]),
            ),
          ),
          const SizedBox(width: 12),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doctor['name'] ?? "Unknown",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  doctor['hospital'] ?? "Hospital",
                  style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey),
                ),
                const SizedBox(height: 4),
                Row(
                  children: List.generate(5, (index) {
                    return Icon(
                      Icons.star,
                      size: 16,
                      color: index < (doctor['rating'] ?? 0)
                          ? Colors.amber
                          : Colors.grey[300],
                    );
                  }),
                ),
              ],
            ),
          ),

          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: doctor['is_available'] == true
                      ? Colors.green
                      : Colors.red,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  doctor['is_available'] == true
                      ? 'Available'
                      : 'Not Available',
                  style: GoogleFonts.poppins(
                    color: Colors.white,
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
              const SizedBox(height: 8),
              if (doctor['is_available'] == true)
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (_) => DoctorDetailsPage(doctor: doctor),
                      ),
                    );
                  },
                  child: Text(
                    "Book Now",
                    style: GoogleFonts.poppins(
                      color: Colors.blue,
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
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
    '06:30 pm',
    '05:00 pm',
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

  Future<void> _bookAppointment() async {
    final selectedDate = _currentWeekDays[_selectedDayIndex];
    final doctorName = widget.doctor['name'];
    final doctorAddress = widget.doctor['address'];
    final dateStr =
        "${selectedDate.day}/${selectedDate.month}/${selectedDate.year}";

    try {
      await supabase.from("appointments").insert({
        "doctor_name": doctorName,
        "doctor_address": doctorAddress,
        "date": dateStr,
        "time": _selectedTime,
        "user_id": supabase.auth.currentUser?.id,
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "✅ Appointment booked with $doctorName at $doctorAddress on $dateStr at $_selectedTime",
            style: GoogleFonts.poppins(fontSize: 14),
          ),
        ),
      );
    } catch (e) {
      debugPrint("❌ Error booking appointment: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "❌ Failed to book appointment",
            style: GoogleFonts.poppins(),
          ),
        ),
      );
    }
  }

  String _getWeekRange() {
    final start = _currentWeekStart;
    final end = _currentWeekStart.add(const Duration(days: 4));
    return "${start.day}/${start.month} - ${end.day}/${end.month} ${start.year}";
  }

  @override
  Widget build(BuildContext context) {
    final doc = widget.doctor;

    return Scaffold(
      backgroundColor: const Color(0xFFF8BBD9),
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8BBD9),
        elevation: 0,
        title: Text(
          "Doctor Details",
          style: GoogleFonts.poppins(
            fontWeight: FontWeight.w700,
            fontSize: 20,
            color: Colors.black,
          ),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        toolbarHeight: 50,
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        padding: const EdgeInsets.all(24),
        decoration: const BoxDecoration(
          color: Color.fromARGB(255, 250, 231, 233),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: SingleChildScrollView(
          physics: const BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Doctor Profile Card
              _buildDoctorProfile(doc),
              const SizedBox(height: 24),

              // Contact Information
              _buildContactInfo(doc),
              const SizedBox(height: 24),

              // Stats Cards
              _buildStatsSection(doc),
              const SizedBox(height: 32),

              // Week Navigation
              _buildWeekNavigation(),
              const SizedBox(height: 20),

              // Date Selection
              _buildDateSelection(),
              const SizedBox(height: 32),

              // Time Selection
              _buildTimeSelection(),
              const SizedBox(height: 32),

              // Book Button
              _buildBookButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildDoctorProfile(Map doc) {
    return Container(
      padding: const EdgeInsets.all(20),
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
      child: Row(
        children: [
          Container(
            width: 100,
            height: 100,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(20),
              color: const Color(0xFFF8BBD9).withOpacity(0.3),
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(20),
              child: doc['image_url'] != null
                  ? Image.network(
                      doc['image_url'],
                      width: 100,
                      height: 100,
                      fit: BoxFit.cover,
                      errorBuilder: (context, error, stackTrace) =>
                          _buildPlaceholderIcon(),
                    )
                  : _buildPlaceholderIcon(),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  doc['name'] ?? "Doctor",
                  style: GoogleFonts.poppins(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  doc['specialization'] ?? "General Doctor",
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    color: const Color.fromARGB(255, 233, 64, 120),
                    fontWeight: FontWeight.w500,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      Icons.local_hospital,
                      color: Colors.grey[600],
                      size: 16,
                    ),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        doc['hospital'] ?? "",
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: Colors.black54,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Icon(Icons.location_on, color: Colors.grey[600], size: 16),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        doc['address'] ?? '',
                        style: GoogleFonts.poppins(
                          fontSize: 13,
                          color: Colors.grey[600],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholderIcon() {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFFF8BBD9).withOpacity(0.5),
        borderRadius: BorderRadius.circular(20),
      ),
      child: const Icon(Icons.person, size: 50, color: Colors.white),
    );
  }

  Widget _buildContactInfo(Map doc) {
    return Container(
      padding: const EdgeInsets.all(20),
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
        children: [
          _buildContactItem(Icons.phone, "Phone", doc['phone'] ?? ''),
          const SizedBox(height: 12),
          _buildContactItem(Icons.email, "Email", doc['email'] ?? ''),
        ],
      ),
    );
  }

  Widget _buildContactItem(IconData icon, String label, String value) {
    return Row(
      children: [
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFE91E63).withOpacity(0.1),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFFE91E63), size: 20),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: GoogleFonts.poppins(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                value.isNotEmpty ? value : 'Not available',
                style: GoogleFonts.poppins(
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                  color: Colors.black87,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildStatsSection(Map doc) {
    return Row(
      children: [
        Expanded(
          child: _buildStatCard(
            "Patients",
            doc['patients'] ?? 'N/A',
            Icons.people,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            "Experience",
            doc['experience'] ?? 'N/A',
            Icons.work,
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _buildStatCard(
            "Rating",
            doc['rating']?.toString() ?? 'N/A',
            Icons.star,
          ),
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: const Color(0xFFF8BBD9).withOpacity(0.3),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFFE91E63), size: 20),
          ),
          const SizedBox(height: 8),
          Text(
            value,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.black87,
            ),
          ),
          Text(
            title,
            style: GoogleFonts.poppins(fontSize: 12, color: Colors.grey[600]),
          ),
        ],
      ),
    );
  }

  Widget _buildWeekNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        IconButton(
          onPressed: () => _navigateWeek(-1),
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
        ),
        Expanded(
          child: Center(
            child: Text(
              _getWeekRange(),
              style: GoogleFonts.poppins(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Colors.black87,
              ),
            ),
          ),
        ),
        IconButton(
          onPressed: () => _navigateWeek(1),
          icon: const Icon(Icons.arrow_forward_ios, color: Colors.black),
        ),
      ],
    );
  }

  Widget _buildDateSelection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Text(
            "Select Date",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: List.generate(5, (i) {
              final d = _currentWeekDays[i];
              final days = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri'];
              final selected = i == _selectedDayIndex;
              return GestureDetector(
                onTap: () => setState(() => _selectedDayIndex = i),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: selected ? Colors.pink.shade400 : Colors.transparent,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: selected
                          ? Colors.pink.shade400
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                  ),
                  child: Column(
                    children: [
                      Text(
                        days[i],
                        style: GoogleFonts.poppins(
                          fontSize: 14,
                          color: selected ? Colors.white : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "${d.day}",
                        style: GoogleFonts.poppins(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          color: selected ? Colors.white : Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  Widget _buildTimeSelection() {
    return Container(
      padding: const EdgeInsets.all(20),
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
          Text(
            "Select Time",
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: Colors.black87,
            ),
          ),
          const SizedBox(height: 16),

          // ✅ Grid for Times
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: _timeSlots.length,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 3, // 3 slots per row
              crossAxisSpacing: 12,
              mainAxisSpacing: 12,
              childAspectRatio: 2.5, // width / height ratio
            ),
            itemBuilder: (context, index) {
              final t = _timeSlots[index];
              final selected = _selectedTime == t;
              return GestureDetector(
                onTap: () => setState(() => _selectedTime = t),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  alignment: Alignment.center,
                  decoration: BoxDecoration(
                    color: selected ? Colors.pink.shade400 : Colors.white,
                    border: Border.all(
                      color: selected
                          ? Colors.pink.shade400
                          : Colors.grey[300]!,
                      width: 2,
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: selected
                        ? [
                            BoxShadow(
                              color: Colors.pink.shade400.withOpacity(0.3),
                              blurRadius: 8,
                              offset: const Offset(0, 2),
                            ),
                          ]
                        : [],
                  ),
                  child: Text(
                    t,
                    style: GoogleFonts.poppins(
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
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

  Widget _buildBookButton() {
    return SizedBox(
      width: double.infinity,
      height: 56,
      child: ElevatedButton(
        onPressed: () {
          final selectedDate = _currentWeekDays[_selectedDayIndex];
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (_) => ConfirmBookingPage(
                doctorName: widget.doctor['name'] ?? "Unknown",
                hospital: widget.doctor['hospital'] ?? "N/A",
                selectedDate: selectedDate,
                selectedTime: _selectedTime,
                selectedDayIndex: _selectedDayIndex,
              ),
            ),
          );
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Colors.pink.shade400,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          elevation: 4,
          shadowColor: Colors.pink.shade400.withOpacity(0.3),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.calendar_today, color: Colors.white, size: 20),
            const SizedBox(width: 8),
            Text(
              "Book Appointment",
              style: GoogleFonts.poppins(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.white,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
