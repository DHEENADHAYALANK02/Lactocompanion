import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'l10n/app_localizations.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

// Screens import
import 'Screens/LoginPage/newpasswordpage.dart';
import 'Screens/Welcome/welcomepage.dart';
import 'Screens/Home/homepage.dart';
import 'Screens/Profile/language.dart'; // ✅ Added import

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

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  /// Static function → dynamic language change
  static void setLocale(BuildContext context, Locale newLocale) async {
    _MyAppState? state = context.findAncestorStateOfType<_MyAppState>();
    state?.setLocale(newLocale);

    // ✅ Save locale to SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("app_lang", newLocale.languageCode);
  }

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  Locale _locale = const Locale('en'); // Default English

  @override
  void initState() {
    super.initState();
    _loadSavedLocale();
  }

  /// ✅ Load saved language from SharedPreferences
  Future<void> _loadSavedLocale() async {
    final prefs = await SharedPreferences.getInstance();
    final langCode = prefs.getString("app_lang");
    if (langCode != null && langCode.isNotEmpty) {
      setState(() {
        _locale = Locale(langCode);
      });
    }
  }

  void setLocale(Locale locale) {
    setState(() {
      _locale = locale;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      navigatorKey: navigatorKey,
      debugShowCheckedModeBanner: false,
      title: "Lacto Companion",
      theme: ThemeData(primarySwatch: Colors.pink),

      // ✅ Localization Setup
      locale: _locale,
      supportedLocales: const [
        Locale('en'), // English
        Locale('ar'), // Arabic
      ],
      localizationsDelegates: const [
        AppLocalizations.delegate,
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

      // 🔑 Add this builder for RTL support
      builder: (context, child) {
        return Directionality(
          textDirection:
              _locale.languageCode == "ar" ? TextDirection.rtl : TextDirection.ltr,
          child: child!,
        );
      },

      // ✅ The first screen is AppEntry (decides which screen to show)
      home: const AppEntry(),
    );
  }
}

/// 🚀 AppEntry → checks if language already chosen before showing WelcomePage
class AppEntry extends StatefulWidget {
  const AppEntry({super.key});

  @override
  State<AppEntry> createState() => _AppEntryState();
}

class _AppEntryState extends State<AppEntry> {
  bool _loading = true;
  bool _languageChosen = false;

  @override
  void initState() {
    super.initState();
    _checkLanguage();
  }

  Future<void> _checkLanguage() async {
    final prefs = await SharedPreferences.getInstance();
    final lang = prefs.getString("app_lang");
    debugPrint("🟡 [AppEntry] Found language: $lang");
    setState(() {
      _languageChosen = lang != null && lang.isNotEmpty;
      _loading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    debugPrint("🟢 [AppEntry] _languageChosen = $_languageChosen");

    if (_loading) {
      return const Scaffold(
        backgroundColor: Colors.white,
        body: Center(child: CircularProgressIndicator(color: Colors.pink)),
      );
    }

    if (_languageChosen) {
      debugPrint("🟢 [AppEntry] → SessionRedirector()");
      return const SessionRedirector();
    } else {
      debugPrint("🟢 [AppEntry] → LanguageSelectionPage()");
      return const LanguageSelectionPage();
    }
  }
}

/// ✅ Decides whether → Home / Welcome (after language selection)
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