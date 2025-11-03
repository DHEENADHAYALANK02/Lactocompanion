import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lactocompanion/Screens/SignUp/signuppage.dart';
import '../../l10n/app_localizations.dart'; // ✅ Localization import

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool isPasswordVisible = false;
  bool rememberMe = false;
  bool isLoading = false;
  final supabase = Supabase.instance.client;

  late AnimationController _animController;
  late Animation<double> _fadeAnimation;
  late Animation<Offset> _slideAnimation;

  @override
  void initState() {
    super.initState();
    loadCredentials();

    _animController =
        AnimationController(vsync: this, duration: const Duration(milliseconds: 800));
    _fadeAnimation =
        CurvedAnimation(parent: _animController, curve: Curves.easeIn);
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.2),
      end: Offset.zero,
    ).animate(CurvedAnimation(parent: _animController, curve: Curves.easeOut));

    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  // Save credentials
  Future<void> saveCredentials(String email, String password) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString("email", email);
      await prefs.setString("password", password);
    } else {
      await prefs.clear();
    }
  }

  // Load saved credentials
  Future<void> loadCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    if (!mounted) return;
    setState(() {
      emailController.text = prefs.getString("email") ?? "";
      passwordController.text = prefs.getString("password") ?? "";
      rememberMe = prefs.getString("email") != null;
    });
  }

  // Animated popup
  void showPopup(String message, {bool isError = false}) {
    if (!mounted) return;
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: "Popup",
      transitionDuration: const Duration(milliseconds: 400),
      pageBuilder: (_, __, ___) {
        return Center(
          child: Container(
            margin: const EdgeInsets.symmetric(horizontal: 30),
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: isError ? Colors.red.shade400 : Colors.green.shade400,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 6),
                ),
              ],
            ),
            child: Material(
              color: Colors.transparent,
              child: Text(
                message,
                textAlign: TextAlign.center,
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  color: Colors.white,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ),
        );
      },
      transitionBuilder: (_, anim, __, child) {
        return SlideTransition(
          position:
              Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero).animate(anim),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (Navigator.canPop(context)) Navigator.pop(context);
    });
  }

  // Login with Email
  Future<void> loginWithEmail() async {
    final loc = AppLocalizations.of(context)!;

    if (emailController.text.isEmpty || passwordController.text.isEmpty) {
      showPopup("⚠️ ${loc.fillAllFields}", isError: true);
      return;
    }

    setState(() => isLoading = true);
    try {
      final res = await supabase.auth.signInWithPassword(
        email: emailController.text.trim(),
        password: passwordController.text,
      );

      if (!mounted) return;

      if (res.user != null) {
        await saveCredentials(emailController.text, passwordController.text);

        final profile = await supabase
            .from("profiles")
            .select("name")
            .eq("id", res.user!.id)
            .maybeSingle();

        String userName = profile?["name"] ?? res.user!.email ?? "User";

        if (!mounted) return;
        showPopup("${loc.welcomeBack} $userName");
      }
    } catch (e) {
      if (!mounted) return;
      String errorMessage = loc.loginFailed;

      if (e.toString().contains("invalid_credentials")) {
        errorMessage = loc.invalidCredentials;
      } else if (e.toString().contains("user_not_found")) {
        errorMessage = loc.userNotFound;
      }

      showPopup(errorMessage, isError: true);
    }
    if (!mounted) return;
    setState(() => isLoading = false);
  }

  // Google Login
  Future<void> loginWithGoogle() async {
    final loc = AppLocalizations.of(context)!;

    setState(() => isLoading = true);
    try {
      await supabase.auth.signInWithOAuth(
        OAuthProvider.google,
        redirectTo: "io.supabase.flutter://login-callback",
      );

      if (!mounted) return;
      final user = supabase.auth.currentUser;
      if (user != null) {
        showPopup("🚀 ${loc.loggedInAs} ${user.email}");
      }
    } catch (e) {
      if (!mounted) return;
      showPopup(loc.googleLoginFailed, isError: true);
    }
    if (!mounted) return;
    setState(() => isLoading = false);
  }

  // Reset Password
  Future<void> resetPassword() async {
    final loc = AppLocalizations.of(context)!;

    if (emailController.text.isEmpty) {
      showPopup(loc.enterEmailFirst, isError: true);
      return;
    }
    try {
      await supabase.auth.resetPasswordForEmail(
        emailController.text.trim(),
        redirectTo: "io.supabase.flutter://reset-callback",
      );
      if (!mounted) return;
      showPopup(loc.passwordResetSent);
    } catch (e) {
      if (!mounted) return;
      showPopup(loc.resetFailed, isError: true);
    }
  }

  @override
  Widget build(BuildContext context) {
    final loc = AppLocalizations.of(context)!;

    return Scaffold(
      backgroundColor: const Color(0xFFFDEFF4),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  IconButton(
                    onPressed: () {
                      if (!mounted) return;
                      Navigator.pop(context);
                    },
                    icon: const Icon(Icons.arrow_back),
                  ),
                  const SizedBox(height: 10),

                  Text(
                    loc.loginTitle,
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildInput(loc.email, emailController, Icons.email_outlined,
                      false,
                      type: TextInputType.emailAddress),
                  const SizedBox(height: 16),

                  _buildInput(
                      loc.password, passwordController, Icons.lock_outline, true),
                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: rememberMe,
                            onChanged: (val) =>
                                setState(() => rememberMe = val ?? false),
                          ),
                          Text(loc.rememberMe, style: GoogleFonts.poppins()),
                        ],
                      ),
                      TextButton(
                        onPressed: resetPassword,
                        child: Text(
                          loc.forgotPassword,
                          style: GoogleFonts.poppins(color: Colors.pink),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : loginWithEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              loc.login,
                              style: GoogleFonts.poppins(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Row(
                    children: [
                      const Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 8),
                        child: Text(loc.orContinueWith),
                      ),
                      const Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: isLoading ? null : loginWithGoogle,
                      style: OutlinedButton.styleFrom(
                        side: const BorderSide(color: Colors.grey),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                      ),
                      icon: Image.network(
                        "https://upload.wikimedia.org/wikipedia/commons/0/09/IOS_Google_icon.png",
                        height: 24,
                      ),
                      label: Text(loc.loginWithGoogle,
                          style: GoogleFonts.poppins()),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(loc.dontHaveAccount,
                            style: GoogleFonts.poppins()),
                        TextButton(
                          onPressed: () {
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const SignupPage()),
                            );
                          },
                          child: Text(
                            loc.signUp,
                            style: GoogleFonts.poppins(color: Colors.pink),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildInput(String label, TextEditingController controller,
      IconData icon, bool isPassword,
      {TextInputType type = TextInputType.text}) {
    final loc = AppLocalizations.of(context)!;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(
                fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: type,
          obscureText: isPassword && !isPasswordVisible,
          decoration: InputDecoration(
            hintText: "${loc.enterYour} $label",
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible
                          ? Icons.visibility_off
                          : Icons.visibility,
                    ),
                    onPressed: () =>
                        setState(() => isPasswordVisible = !isPasswordVisible),
                  )
                : Icon(icon),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            filled: true,
            fillColor: Colors.white,
          ),
        ),
      ],
    );
  }
}
