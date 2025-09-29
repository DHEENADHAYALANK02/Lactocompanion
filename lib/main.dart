import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Screens import
import 'Screens/LoginPage/newpasswordpage.dart';
import 'Screens/Welcome/welcomepage.dart';
import 'Screens/Home/homepage.dart';
import 'Screens/Profile/language.dart';

/// Global navigator key → auth events handle panna
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // ✅ Supabase Initialize
  await Supabase.initialize(
    url: 'https://uyncpwahvqntrfvdtcxy.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InV5bmNwd2FodnFudHJmdmR0Y3h5Iiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTc5NjExMzAsImV4cCI6MjA3MzUzNzEzMH0.3kr69KX4mB-wS1mrGH6mQuq-xi0o4ctI6ianukP3CcI',
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: "Lacto Companion",
      theme: ThemeData(primarySwatch: Colors.pink),

      // ✅ Localization Setup
      supportedLocales: const [
        Locale('en'), // English
        Locale('ar'), // Arabic
        Locale('ta'), // Tamil
        Locale('hi'), // Hindi (since u generated app_hi.arb)
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate, // Generated delegate
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ],
      localeResolutionCallback: (locale, supportedLocales) {
        if (locale == null) return const Locale('en');
        for (var supported in supportedLocales) {
          if (supported.languageCode == locale.languageCode) {
            return supported;
          }
        }
        return const Locale('en');
      },

      home: const SessionRedirector(),
    );
  }
}

/// Decides whether → Home / Welcome
class SessionRedirector extends StatefulWidget {
  const SessionRedirector({super.key});

  @override
  State<SessionRedirector> createState() => _SessionRedirectorState();
}

class _SessionRedirectorState extends State<SessionRedirector> {
  bool _loading = true;
  Widget _screen = const WelcomePage();

  @override
  void initState() {
    super.initState();
    _checkSession();
  }

  Future<void> _checkSession() async {
    // ✅ Check existing session
    final session = Supabase.instance.client.auth.currentSession;

    if (session != null) {
      _screen = const HomePage();
    } else {
      _screen = const WelcomePage();
    }

    setState(() => _loading = false);

    // ✅ Listen for auth changes
    Supabase.instance.client.auth.onAuthStateChange.listen((data) {
      final event = data.event;

      if (event == AuthChangeEvent.passwordRecovery) {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const NewPasswordPage()),
          (route) => false,
        );
      }

      if (event == AuthChangeEvent.signedIn) {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const HomePage()),
          (route) => false,
        );
      }

      if (event == AuthChangeEvent.signedOut) {
        navigatorKey.currentState?.pushAndRemoveUntil(
          MaterialPageRoute(builder: (_) => const WelcomePage()),
          (route) => false,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(
          child: CircularProgressIndicator(color: Colors.pink),
        ),
      );
    }
    return _screen;
  }
}
