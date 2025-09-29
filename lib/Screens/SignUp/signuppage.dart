import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lactocompanion/Screens/LoginPage/login_page.dart';
import 'package:lactocompanion/Screens/Home/Homepage.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({super.key});

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage>
    with SingleTickerProviderStateMixin {
  final TextEditingController nameController = TextEditingController();
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

    _animController = AnimationController(
        vsync: this, duration: const Duration(milliseconds: 800));
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
  Future<void> saveCredentials(
      String email, String password, String name) async {
    final prefs = await SharedPreferences.getInstance();
    if (rememberMe) {
      await prefs.setString("email", email);
      await prefs.setString("password", password);
      await prefs.setString("name", name);
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
      nameController.text = prefs.getString("name") ?? "";
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
                  color: Colors.black.withValues(alpha: 0.2),
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
              Tween<Offset>(begin: const Offset(0, -1), end: Offset.zero)
                  .animate(anim),
          child: FadeTransition(opacity: anim, child: child),
        );
      },
    );

    Future.delayed(const Duration(seconds: 3), () {
      if (Navigator.canPop(context)) Navigator.pop(context);
    });
  }

  // Signup with Email
Future<void> signUpWithEmail() async {
  if (nameController.text.isEmpty ||
      emailController.text.isEmpty ||
      passwordController.text.isEmpty) {
    showPopup("⚠️ Please fill all fields", isError: true);
    return;
  }

  setState(() => isLoading = true);
  try {
    final res = await supabase.auth.signUp(
      email: emailController.text.trim(),
      password: passwordController.text,
    );

    final user = res.user;

    if (!mounted) return;

    if (user != null) {
      // ✅ Insert profile with name
      await supabase.from('profiles').upsert({
        'id': user.id,
        'name': nameController.text.trim(),
      });

      await saveCredentials(
          emailController.text, passwordController.text, nameController.text);

      // ✅ Redirect to HomePage
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (_) => const HomePage()),
        (route) => false,
      );
    } else {
      showPopup("❌ Signup failed. Please try again.", isError: true);
    }
  } catch (e) {
    if (!mounted) return;
    String errorMessage = "Something went wrong";

    if (e.toString().contains("user_already_exists")) {
      errorMessage = "Account already exists. Please login instead 🔑";
    } else if (e.toString().contains("invalid_email")) {
      errorMessage = "Invalid email. Please try again 📧";
    } else if (e.toString().contains("weak_password")) {
      errorMessage = "Password too weak. Use a stronger one 🔒";
    }

    showPopup(errorMessage, isError: true);
  }

  if (!mounted) return;
  setState(() => isLoading = false);
}

 // Google Signup
Future<void> signUpWithGoogle() async {
  setState(() => isLoading = true);
  try {
    await supabase.auth.signInWithOAuth(
      OAuthProvider.google,
      redirectTo: "io.supabase.flutter://login-callback", // ✅ match manifest + supabase redirect URLs
    );

    // ⚡ User null irukkum here, wait for listener
  } catch (e) {
    if (!mounted) return;
    showPopup("Google signup failed. Please try again.", isError: true);
  }
  if (!mounted) return;
  setState(() => isLoading = false);
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFDEFF4),
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SlideTransition(
            position: _slideAnimation,
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
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
                    "Create Your\nAccount",
                    style: GoogleFonts.poppins(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                      height: 1.2,
                    ),
                  ),
                  const SizedBox(height: 20),

                  _buildInput("Name", nameController, Icons.person_outline, false),
                  const SizedBox(height: 16),

                  _buildInput("Email", emailController, Icons.email_outlined, false,
                      type: TextInputType.emailAddress),
                  const SizedBox(height: 16),

                  _buildInput("Password", passwordController, Icons.lock_outline, true),
                  const SizedBox(height: 10),

                  Row(
                    children: [
                      Checkbox(
                        value: rememberMe,
                        onChanged: (val) =>
                            setState(() => rememberMe = val ?? false),
                      ),
                      Text("Remember Me", style: GoogleFonts.poppins()),
                    ],
                  ),
                  const SizedBox(height: 20),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: isLoading ? null : signUpWithEmail,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.pink.shade400,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(25),
                        ),
                      ),
                      child: isLoading
                          ? const CircularProgressIndicator(color: Colors.white)
                          : Text(
                              "Signup",
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
                    children: const [
                      Expanded(child: Divider(thickness: 1)),
                      Padding(
                        padding: EdgeInsets.symmetric(horizontal: 8),
                        child: Text("Or sign up with"),
                      ),
                      Expanded(child: Divider(thickness: 1)),
                    ],
                  ),
                  const SizedBox(height: 16),

                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: OutlinedButton.icon(
                      onPressed: isLoading ? null : signUpWithGoogle,
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
                      label: Text("Sign Up With Google",
                          style: GoogleFonts.poppins()),
                    ),
                  ),
                  const SizedBox(height: 20),

                  Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Already have an account? ",
                            style: GoogleFonts.poppins()),
                        TextButton(
                          onPressed: () {
                            if (!mounted) return;
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => const LoginPage()),
                            );
                          },
                          child: Text(
                            "Login",
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label,
            style: GoogleFonts.poppins(fontWeight: FontWeight.w600, fontSize: 14)),
        const SizedBox(height: 6),
        TextField(
          controller: controller,
          keyboardType: type,
          obscureText: isPassword && !isPasswordVisible,
          decoration: InputDecoration(
            hintText: "Enter your $label",
            suffixIcon: isPassword
                ? IconButton(
                    icon: Icon(
                      isPasswordVisible ? Icons.visibility_off : Icons.visibility,
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
