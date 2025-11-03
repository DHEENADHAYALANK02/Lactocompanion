import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({Key? key}) : super(key: key);

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
              loc.privacyPolicyTitle, // 🔑 from arb
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
                loc.privacyPolicyTitle, // 🔑
                style: GoogleFonts.poppins(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                loc.privacyIntro, // 🔑
                style: GoogleFonts.poppins(
                  fontSize: 14,
                  color: Colors.black87,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: 20),

              _buildSection(loc.infoCollectTitle, [
                loc.infoCollect1,
                loc.infoCollect2,
                loc.infoCollect3,
                loc.infoCollect4,
              ]),
              _buildSection(loc.infoUseTitle, [
                loc.infoUse1,
                loc.infoUse2,
                loc.infoUse3,
                loc.infoUse4,
                loc.infoUse5,
              ]),
              _buildSection(loc.infoShareTitle, [
                loc.infoShare1,
                loc.infoShare2,
                loc.infoShare3,
              ]),
              _buildSection(loc.dataSecurityTitle, [
                loc.dataSecurity1,
                loc.dataSecurity2,
                loc.dataSecurity3,
              ]),
              _buildSection(loc.yourRightsTitle, [
                loc.yourRights1,
                loc.yourRights2,
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
