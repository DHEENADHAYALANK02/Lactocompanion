import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';

class TermsOfConditionPage extends StatelessWidget {
  const TermsOfConditionPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color.fromRGBO(249, 182, 203, 1), // Same pink as previous
      appBar: AppBar(
        backgroundColor: const Color.fromRGBO(249, 182, 203, 1),
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black), // Thick arrow
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Row(
          children: [
            Text(
              loc.termsTitle, // 🔑 localized
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w700,
                fontSize: 20,
                color: Colors.black,
              ),
            ),
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
                loc.termsTitle,
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                loc.termsIntro, // 🔑 localized intro text
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              _buildSection(loc.termsSection1Title, [
                loc.termsSection1_1,
                loc.termsSection1_2,
                loc.termsSection1_3,
                loc.termsSection1_4,
              ]),
              _buildSection(loc.termsSection2Title, [
                loc.termsSection2_1,
                loc.termsSection2_2,
                loc.termsSection2_3,
                loc.termsSection2_4,
                loc.termsSection2_5,
              ]),
              _buildSection(loc.termsSection3Title, [
                loc.termsSection3_1,
                loc.termsSection3_2,
                loc.termsSection3_3,
              ]),
              _buildSection(loc.termsSection4Title, [
                loc.termsSection4_1,
                loc.termsSection4_2,
                loc.termsSection4_3,
              ]),
              _buildSection(loc.termsSection5Title, [
                loc.termsSection5_1,
                loc.termsSection5_2,
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
