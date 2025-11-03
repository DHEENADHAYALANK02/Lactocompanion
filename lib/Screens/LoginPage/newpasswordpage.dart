import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../Home/Homepage.dart';
import '../../l10n/app_localizations.dart';

class NewPasswordPage extends StatefulWidget {
  const NewPasswordPage({super.key});

  @override
  State<NewPasswordPage> createState() => _NewPasswordPageState();
}

class _NewPasswordPageState extends State<NewPasswordPage> {
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController confirmController = TextEditingController();

  final supabase = Supabase.instance.client;
  bool isLoading = false;
  bool isPasswordVisible = false;
  bool isConfirmVisible = false;

  Future<void> updatePassword() async {
    final loc = AppLocalizations.of(context)!;
    final newPassword = passwordController.text.trim();
    final confirmPassword = confirmController.text.trim();

    if (newPassword.isEmpty || confirmPassword.isEmpty) {
      _showPopup("⚠️ ${loc.fillBothFields}", isError: true);
      return;
    }

    if (newPassword.length < 6) {
      _showPopup("🔒 ${loc.passwordTooShort}", isError: true);
      return;
    }

    if (newPassword != confirmPassword) {
      _showPopup("❌ ${loc.passwordsDoNotMatch}", isError: true);
      return;
    }

    final user = supabase.auth.currentUser;
    if (user == null) {
      _showPopup("❌ ${loc.noActiveSession}", isError: true);
      return;
    }

    setState(() => isLoading = true);

    try {
      await supabase.auth.updateUser(UserAttributes(password: newPassword));

      if (!mounted) return;

      _showPopup("✅ ${loc.passwordUpdated}", isError: false);

      // Redirect after a short delay
      Future.delayed(const Duration(seconds: 2), () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      });
    } catch (e) {
      if (!mounted) return;
      final errorMessage = e is AuthException ? e.message : e.toString();
      _showPopup("❌ ${loc.updateFailed(errorMessage)}", isError: true);
    }

    setState(() => isLoading = false);
  }

  // 🔥 Fancy popup from bottom
  void _showPopup(String message, {bool isError = false}) {
    showModalBottomSheet(
      context: context,
      backgroundColor: Colors.transparent,
      isScrollControlled: true,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(16),
        child: Container(
          padding: const EdgeInsets.all(18),
          decoration: BoxDecoration(
            color: isError ? Colors.red.shade400 : Colors.green.shade400,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Row(
            children: [
              Icon(
                isError ? Icons.error_outline : Icons.check_circle_outline,
                color: Colors.white,
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  message,
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.w600),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFFDEFF4),
      appBar: AppBar(
        backgroundColor: Colors.pink.shade400,
        title: Text(loc.resetPasswordTitle),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            // New Password
            TextField(
              controller: passwordController,
              obscureText: !isPasswordVisible,
              decoration: InputDecoration(
                labelText: loc.newPassword,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      setState(() => isPasswordVisible = !isPasswordVisible),
                ),
              ),
            ),
            const SizedBox(height: 16),

            // Confirm Password
            TextField(
              controller: confirmController,
              obscureText: !isConfirmVisible,
              decoration: InputDecoration(
                labelText: loc.confirmPassword,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                ),
                suffixIcon: IconButton(
                  icon: Icon(
                    isConfirmVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed: () =>
                      setState(() => isConfirmVisible = !isConfirmVisible),
                ),
              ),
            ),
            const SizedBox(height: 24),

            SizedBox(
              width: double.infinity,
              height: 55,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.pink.shade400,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(25),
                  ),
                ),
                onPressed: isLoading ? null : updatePassword,
                child: isLoading
                    ? const CircularProgressIndicator(color: Colors.white)
                    : Text(
                        loc.updatePasswordButton,
                        style:
                            const TextStyle(color: Colors.white, fontSize: 18),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
