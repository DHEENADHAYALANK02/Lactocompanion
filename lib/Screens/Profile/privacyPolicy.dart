import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor:const Color.fromRGBO(249, 182, 203, 1), // Same pink as previous
      appBar: AppBar(
        backgroundColor:const Color.fromRGBO(249, 182, 203, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Thick arrow
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Text(
              'Privacy Policy',
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
            const SizedBox(width: 8),
            
          ],
        ),
      ),
      body: Container(
        margin: const EdgeInsets.only(top: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(30),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Privacy Policy',
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                'Welcome to [Your App Name]! Your privacy is important to us. '
                'This Privacy Policy explains how we collect, use, and protect your personal information. '
                'By using our app, you agree to this Privacy Policy.',
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),
              _buildSection('1. Information We Collect', [
                'We may collect the following information:',
                '• Personal Information: Name, email address, phone number.',
                '• Account Information: Login details, preferences, profile information.',
                '• Usage Data: How you use our app, device details, IP address, cookies.',
                '• Health/Consultation Data (if applicable): Information you provide when booking or consulting specialists.',
              ]),
              _buildSection('2. How We Use Your Information', [
                'We use your data to:',
                '• Provide and improve our services.',
                '• Book and manage appointments.',
                '• Send notifications and updates.',
                '• Communicate with you (notifications, reminders, support).',
                '• Ensure security and prevent fraud.',
              ]),
              _buildSection('3. How We Share Information', [
                'We do not sell your personal data.',
                'We may share information with:',
                '• Trusted service providers (e.g., payment gateways, cloud hosting).',
                '• Specialists/doctors (only with your consent).',
                '• Legal authorities (if required by law).',
              ]),
              _buildSection('4. Data Security', [
                '• We use encryption and secure servers to protect your information.',
                '• Only authorized personnel can access your data.',
                '• However, no system is 100% secure, so we cannot guarantee absolute security.',
              ]),
              _buildSection('5. Your Rights', [
                'You have the right to:',
                '• Access and update your personal information.',
                '• Request deletion of your account and data.',
              ]),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSection(String title, List<String> content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.black,
          ),
        ),
        const SizedBox(height: 8),
        ...content.map(
          (text) => Padding(
            padding: const EdgeInsets.only(bottom: 4),
            child: Text(
              text,
              style: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black87,
                height: 1.4,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}
