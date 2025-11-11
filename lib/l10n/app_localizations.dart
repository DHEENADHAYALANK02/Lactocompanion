import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ar.dart';
import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('ar'),
    Locale('en'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'LactoCompanion'**
  String get appTitle;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// No description provided for @cart.
  ///
  /// In en, this message translates to:
  /// **'Cart'**
  String get cart;

  /// No description provided for @checkout.
  ///
  /// In en, this message translates to:
  /// **'Checkout'**
  String get checkout;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @selectLanguage.
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @changeLanguage.
  ///
  /// In en, this message translates to:
  /// **'Change Language'**
  String get changeLanguage;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @confirmBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Booking'**
  String get confirmBooking;

  /// No description provided for @appointmentSummary.
  ///
  /// In en, this message translates to:
  /// **'Appointment Summary'**
  String get appointmentSummary;

  /// No description provided for @patientInformation.
  ///
  /// In en, this message translates to:
  /// **'Patient Information'**
  String get patientInformation;

  /// No description provided for @doctor.
  ///
  /// In en, this message translates to:
  /// **'Doctor'**
  String get doctor;

  /// No description provided for @hospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital'**
  String get hospital;

  /// No description provided for @date.
  ///
  /// In en, this message translates to:
  /// **'Date'**
  String get date;

  /// No description provided for @time.
  ///
  /// In en, this message translates to:
  /// **'Time'**
  String get time;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @mobileNumber.
  ///
  /// In en, this message translates to:
  /// **'Mobile Number'**
  String get mobileNumber;

  /// No description provided for @age.
  ///
  /// In en, this message translates to:
  /// **'Age'**
  String get age;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @languageConfirmation.
  ///
  /// In en, this message translates to:
  /// **'Language Confirmation'**
  String get languageConfirmation;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success!'**
  String get success;

  /// No description provided for @languagePreference.
  ///
  /// In en, this message translates to:
  /// **'Language Preference'**
  String get languagePreference;

  /// No description provided for @bookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Booking Confirmed'**
  String get bookingConfirmed;

  /// No description provided for @successfullyConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Successfully confirmed!'**
  String get successfullyConfirmed;

  /// No description provided for @yourBookingConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Your booking has been confirmed!'**
  String get yourBookingConfirmed;

  /// No description provided for @checkEmail.
  ///
  /// In en, this message translates to:
  /// **'Check your email'**
  String get checkEmail;

  /// No description provided for @confirmationDetailsSent.
  ///
  /// In en, this message translates to:
  /// **'Confirmation details sent'**
  String get confirmationDetailsSent;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @bookingDetailsComingSoon.
  ///
  /// In en, this message translates to:
  /// **'Booking details coming soon!'**
  String get bookingDetailsComingSoon;

  /// No description provided for @viewBookingDetails.
  ///
  /// In en, this message translates to:
  /// **'View booking details'**
  String get viewBookingDetails;

  /// No description provided for @loginTitle.
  ///
  /// In en, this message translates to:
  /// **'Log in to Your Account'**
  String get loginTitle;

  /// No description provided for @emailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailLabel;

  /// No description provided for @passwordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get passwordLabel;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @orContinueWith.
  ///
  /// In en, this message translates to:
  /// **'Or continue with'**
  String get orContinueWith;

  /// No description provided for @loginWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Login With Google'**
  String get loginWithGoogle;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don’t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @fillAllFields.
  ///
  /// In en, this message translates to:
  /// **'⚠️ Please fill all fields'**
  String get fillAllFields;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back,'**
  String get welcomeBack;

  /// No description provided for @loginFailed.
  ///
  /// In en, this message translates to:
  /// **'Login failed'**
  String get loginFailed;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password ❌'**
  String get invalidCredentials;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'User not found. Please signup first 📝'**
  String get userNotFound;

  /// No description provided for @loggedInAs.
  ///
  /// In en, this message translates to:
  /// **'Logged in as'**
  String get loggedInAs;

  /// No description provided for @googleLoginFailed.
  ///
  /// In en, this message translates to:
  /// **'Google login failed. Please try again.'**
  String get googleLoginFailed;

  /// No description provided for @enterEmailFirst.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email first'**
  String get enterEmailFirst;

  /// No description provided for @passwordResetSent.
  ///
  /// In en, this message translates to:
  /// **'📧 Password reset link sent! Check your email.'**
  String get passwordResetSent;

  /// No description provided for @resetFailed.
  ///
  /// In en, this message translates to:
  /// **'Reset failed. Try again later.'**
  String get resetFailed;

  /// No description provided for @enterYour.
  ///
  /// In en, this message translates to:
  /// **'Enter your'**
  String get enterYour;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @resetPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Reset Password'**
  String get resetPasswordTitle;

  /// No description provided for @newPassword.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @updatePasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Update Password'**
  String get updatePasswordButton;

  /// No description provided for @fillBothFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill both fields'**
  String get fillBothFields;

  /// No description provided for @passwordTooShort.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// No description provided for @passwordsDoNotMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// No description provided for @noActiveSession.
  ///
  /// In en, this message translates to:
  /// **'No active session. Please login again.'**
  String get noActiveSession;

  /// No description provided for @passwordUpdated.
  ///
  /// In en, this message translates to:
  /// **'Password updated successfully'**
  String get passwordUpdated;

  /// No description provided for @updateFailed.
  ///
  /// In en, this message translates to:
  /// **'Update failed: {error}'**
  String updateFailed(Object error);

  /// No description provided for @createAccountTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Your Account'**
  String get createAccountTitle;

  /// No description provided for @name.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// No description provided for @signupFailed.
  ///
  /// In en, this message translates to:
  /// **'Signup failed. Please try again.'**
  String get signupFailed;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong'**
  String get somethingWentWrong;

  /// No description provided for @accountExists.
  ///
  /// In en, this message translates to:
  /// **'Account already exists. Please login instead 🔑'**
  String get accountExists;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email. Please try again 📧'**
  String get invalidEmail;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password too weak. Use a stronger one 🔒'**
  String get weakPassword;

  /// No description provided for @googleSignupFailed.
  ///
  /// In en, this message translates to:
  /// **'Google signup failed. Please try again.'**
  String get googleSignupFailed;

  /// No description provided for @orSignUpWith.
  ///
  /// In en, this message translates to:
  /// **'Or sign up with'**
  String get orSignUpWith;

  /// No description provided for @signUpWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Sign Up With Google'**
  String get signUpWithGoogle;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @hello.
  ///
  /// In en, this message translates to:
  /// **'Hello 👋'**
  String get hello;

  /// No description provided for @guest.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guest;

  /// No description provided for @findVideo.
  ///
  /// In en, this message translates to:
  /// **'Lets Find Your Video'**
  String get findVideo;

  /// No description provided for @searchVideos.
  ///
  /// In en, this message translates to:
  /// **'Search videos'**
  String get searchVideos;

  /// No description provided for @untitled.
  ///
  /// In en, this message translates to:
  /// **'Untitled'**
  String get untitled;

  /// No description provided for @noDescription.
  ///
  /// In en, this message translates to:
  /// **'No description available'**
  String get noDescription;

  /// No description provided for @pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// No description provided for @completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// No description provided for @watched.
  ///
  /// In en, this message translates to:
  /// **'Watched'**
  String get watched;

  /// No description provided for @readMore.
  ///
  /// In en, this message translates to:
  /// **'Read more'**
  String get readMore;

  /// No description provided for @readLess.
  ///
  /// In en, this message translates to:
  /// **'Read less'**
  String get readLess;

  /// No description provided for @liveChat.
  ///
  /// In en, this message translates to:
  /// **'Live Chat'**
  String get liveChat;

  /// No description provided for @liveChatSpecialist.
  ///
  /// In en, this message translates to:
  /// **'Live Chat With Our Specialist'**
  String get liveChatSpecialist;

  /// No description provided for @typeMessage.
  ///
  /// In en, this message translates to:
  /// **'Type your message...'**
  String get typeMessage;

  /// No description provided for @expertConsultation.
  ///
  /// In en, this message translates to:
  /// **'Expert Consultation'**
  String get expertConsultation;

  /// No description provided for @available.
  ///
  /// In en, this message translates to:
  /// **'Available'**
  String get available;

  /// No description provided for @notAvailable.
  ///
  /// In en, this message translates to:
  /// **'Not Available'**
  String get notAvailable;

  /// No description provided for @bookNow.
  ///
  /// In en, this message translates to:
  /// **'Book Now'**
  String get bookNow;

  /// No description provided for @doctorDetails.
  ///
  /// In en, this message translates to:
  /// **'Doctor Details'**
  String get doctorDetails;

  /// No description provided for @bookAppointment.
  ///
  /// In en, this message translates to:
  /// **'Book Appointment'**
  String get bookAppointment;

  /// No description provided for @oneTapTo.
  ///
  /// In en, this message translates to:
  /// **'One Tap To'**
  String get oneTapTo;

  /// No description provided for @better.
  ///
  /// In en, this message translates to:
  /// **'Better'**
  String get better;

  /// No description provided for @health.
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// No description provided for @findSpecialist.
  ///
  /// In en, this message translates to:
  /// **'Find The Best Specialist At The Right Time'**
  String get findSpecialist;

  /// No description provided for @trustedCare.
  ///
  /// In en, this message translates to:
  /// **'Trusted Care'**
  String get trustedCare;

  /// No description provided for @signup.
  ///
  /// In en, this message translates to:
  /// **'Signup'**
  String get signup;

  /// No description provided for @secure.
  ///
  /// In en, this message translates to:
  /// **'Secure'**
  String get secure;

  /// No description provided for @verified.
  ///
  /// In en, this message translates to:
  /// **'Verified'**
  String get verified;

  /// No description provided for @caring.
  ///
  /// In en, this message translates to:
  /// **'Caring'**
  String get caring;

  /// No description provided for @welcomeTagline.
  ///
  /// In en, this message translates to:
  /// **'Your trusted companion for maternal health'**
  String get welcomeTagline;

  /// No description provided for @videos.
  ///
  /// In en, this message translates to:
  /// **'Videos'**
  String get videos;

  /// No description provided for @noVideosFound.
  ///
  /// In en, this message translates to:
  /// **'No videos found'**
  String get noVideosFound;

  /// No description provided for @watchNow.
  ///
  /// In en, this message translates to:
  /// **'Watch Now'**
  String get watchNow;

  /// No description provided for @watchThisVideo.
  ///
  /// In en, this message translates to:
  /// **'Watch this video:'**
  String get watchThisVideo;

  /// No description provided for @videoDescription.
  ///
  /// In en, this message translates to:
  /// **'Video Description'**
  String get videoDescription;

  /// No description provided for @uploadedByAdmin.
  ///
  /// In en, this message translates to:
  /// **'Uploaded by Admin'**
  String get uploadedByAdmin;

  /// No description provided for @likes.
  ///
  /// In en, this message translates to:
  /// **'Likes'**
  String get likes;

  /// No description provided for @comments.
  ///
  /// In en, this message translates to:
  /// **'Comments'**
  String get comments;

  /// No description provided for @noComments.
  ///
  /// In en, this message translates to:
  /// **'No comments yet.'**
  String get noComments;

  /// No description provided for @addComment.
  ///
  /// In en, this message translates to:
  /// **'Add a comment...'**
  String get addComment;

  /// No description provided for @share.
  ///
  /// In en, this message translates to:
  /// **'Share'**
  String get share;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @privacyPolicyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicyTitle;

  /// No description provided for @privacyIntro.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Lactocompanion! Your privacy is important to us. This Privacy Policy describes how Lactocompanion collects, uses, discloses, and protects personal information in compliance with applicable data protection laws, including the Indian IT Act and GDPR standards. By using our app, you agree to this Privacy Policy.'**
  String get privacyIntro;

  /// No description provided for @infoCollectTitle.
  ///
  /// In en, this message translates to:
  /// **'1. Information We Collect'**
  String get infoCollectTitle;

  /// No description provided for @infoCollect1.
  ///
  /// In en, this message translates to:
  /// **'We may collect the following information from you when you use our services:'**
  String get infoCollect1;

  /// No description provided for @infoCollect2.
  ///
  /// In en, this message translates to:
  /// **'• Personal Information: Name, email address, mobile number, and age.'**
  String get infoCollect2;

  /// No description provided for @infoCollect3.
  ///
  /// In en, this message translates to:
  /// **'• Usage Data: App activity, device information, and analytics data.'**
  String get infoCollect3;

  /// No description provided for @infoCollect4.
  ///
  /// In en, this message translates to:
  /// **'• Consultation Data: Messages or forms shared during free consultations, used for safety and quality purposes.'**
  String get infoCollect4;

  /// No description provided for @infoCollect5.
  ///
  /// In en, this message translates to:
  /// **'• Technical Data: Error logs, performance statistics, and interaction patterns for improving user experience.'**
  String get infoCollect5;

  /// No description provided for @infoCollect6.
  ///
  /// In en, this message translates to:
  /// **'• The app does not collect IP addresses for geolocation data.'**
  String get infoCollect6;

  /// No description provided for @infoUseTitle.
  ///
  /// In en, this message translates to:
  /// **'2. How We Use Your Information'**
  String get infoUseTitle;

  /// No description provided for @infoUse1.
  ///
  /// In en, this message translates to:
  /// **'We use your data to:'**
  String get infoUse1;

  /// No description provided for @infoUse2.
  ///
  /// In en, this message translates to:
  /// **'• Create and manage your user account.'**
  String get infoUse2;

  /// No description provided for @infoUse3.
  ///
  /// In en, this message translates to:
  /// **'• Schedule and manage consultations.'**
  String get infoUse3;

  /// No description provided for @infoUse4.
  ///
  /// In en, this message translates to:
  /// **'• Provide educational guidance and awareness content.'**
  String get infoUse4;

  /// No description provided for @infoUse5.
  ///
  /// In en, this message translates to:
  /// **'• Communicate updates, health tips, and reminders.'**
  String get infoUse5;

  /// No description provided for @infoUse6.
  ///
  /// In en, this message translates to:
  /// **'• Ensure security, prevent fraud, and comply with legal obligations.'**
  String get infoUse6;

  /// No description provided for @infoShareTitle.
  ///
  /// In en, this message translates to:
  /// **'3. Information Sharing and Disclosure'**
  String get infoShareTitle;

  /// No description provided for @infoShare1.
  ///
  /// In en, this message translates to:
  /// **'We respect your privacy. We do not sell, rent, or trade your personal information.'**
  String get infoShare1;

  /// No description provided for @infoShare2.
  ///
  /// In en, this message translates to:
  /// **'We may share limited information with trusted third-party services such as Google Firebase for authentication and analytics.'**
  String get infoShare2;

  /// No description provided for @infoShare3.
  ///
  /// In en, this message translates to:
  /// **'We may disclose information if required by law, court order, or government authority.'**
  String get infoShare3;

  /// No description provided for @infoShare4.
  ///
  /// In en, this message translates to:
  /// **'All third-party partners are bound by confidentiality and data protection agreements.'**
  String get infoShare4;

  /// No description provided for @dataSecurityTitle.
  ///
  /// In en, this message translates to:
  /// **'4. Data Security'**
  String get dataSecurityTitle;

  /// No description provided for @dataSecurity1.
  ///
  /// In en, this message translates to:
  /// **'We implement strict security measures including encryption, secure servers, and limited employee access.'**
  String get dataSecurity1;

  /// No description provided for @dataSecurity2.
  ///
  /// In en, this message translates to:
  /// **'All data transmissions are encrypted and stored on secure servers.'**
  String get dataSecurity2;

  /// No description provided for @dataSecurity3.
  ///
  /// In en, this message translates to:
  /// **'However, no online system can guarantee 100% security. You use the app at your own discretion.'**
  String get dataSecurity3;

  /// No description provided for @dataRetentionTitle.
  ///
  /// In en, this message translates to:
  /// **'5. Data Retention'**
  String get dataRetentionTitle;

  /// No description provided for @dataRetention1.
  ///
  /// In en, this message translates to:
  /// **'We retain your data only for as long as necessary to provide services or as required by law.'**
  String get dataRetention1;

  /// No description provided for @dataRetention2.
  ///
  /// In en, this message translates to:
  /// **'When you delete your account, we remove identifiable data within a reasonable time frame.'**
  String get dataRetention2;

  /// No description provided for @thirdPartyTitle.
  ///
  /// In en, this message translates to:
  /// **'6. Third-Party Services'**
  String get thirdPartyTitle;

  /// No description provided for @thirdParty1.
  ///
  /// In en, this message translates to:
  /// **'We use trusted tools such as Google Firebase and analytics services to enhance functionality.'**
  String get thirdParty1;

  /// No description provided for @thirdParty2.
  ///
  /// In en, this message translates to:
  /// **'These services operate under their own privacy policies, which apply alongside this one.'**
  String get thirdParty2;

  /// No description provided for @yourRightsTitle.
  ///
  /// In en, this message translates to:
  /// **'7. Your Rights'**
  String get yourRightsTitle;

  /// No description provided for @yourRights1.
  ///
  /// In en, this message translates to:
  /// **'You can request to access, review, or correct your personal data.'**
  String get yourRights1;

  /// No description provided for @yourRights2.
  ///
  /// In en, this message translates to:
  /// **'You can also request to delete your account or withdraw consent for data processing.'**
  String get yourRights2;

  /// No description provided for @yourRights3.
  ///
  /// In en, this message translates to:
  /// **'To exercise these rights, contact us at lactocompanion@gmail.com.'**
  String get yourRights3;

  /// No description provided for @childrenPrivacyTitle.
  ///
  /// In en, this message translates to:
  /// **'8. Children’s Privacy'**
  String get childrenPrivacyTitle;

  /// No description provided for @childrenPrivacy1.
  ///
  /// In en, this message translates to:
  /// **'Our app is not intended for children under 13 years old.'**
  String get childrenPrivacy1;

  /// No description provided for @childrenPrivacy2.
  ///
  /// In en, this message translates to:
  /// **'If we discover data collected from users under 13, we delete it immediately.'**
  String get childrenPrivacy2;

  /// No description provided for @internationalTransferTitle.
  ///
  /// In en, this message translates to:
  /// **'9. International Data Transfers'**
  String get internationalTransferTitle;

  /// No description provided for @internationalTransfer1.
  ///
  /// In en, this message translates to:
  /// **'Some data may be processed on international servers through our technology providers. We ensure all transfers are protected by lawful data transfer mechanisms.'**
  String get internationalTransfer1;

  /// No description provided for @termsTitle.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsTitle;

  /// No description provided for @termsIntro.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Lactocompanion! Please read these Terms and Conditions carefully before using our app. By accessing or using Lactocompanion, you agree to be bound by these Terms.'**
  String get termsIntro;

  /// No description provided for @termsSection1Title.
  ///
  /// In en, this message translates to:
  /// **'1. About the App'**
  String get termsSection1Title;

  /// No description provided for @termsSection1_1.
  ///
  /// In en, this message translates to:
  /// **'Lactocompanion is a mobile application available on Android and iOS.'**
  String get termsSection1_1;

  /// No description provided for @termsSection1_2.
  ///
  /// In en, this message translates to:
  /// **'The app provides educational guidance and awareness about breast milk and feeding.'**
  String get termsSection1_2;

  /// No description provided for @termsSection1_3.
  ///
  /// In en, this message translates to:
  /// **'The app offers free consultations and a live chat feature with certified breastfeeding experts, available in both English and Arabic, to provide personalized support and guidance.'**
  String get termsSection1_3;

  /// No description provided for @termsSection1_4.
  ///
  /// In en, this message translates to:
  /// **'Lactocompanion is owned and operated by Lactocompanion and technically developed by Rategle Technologies.'**
  String get termsSection1_4;

  /// No description provided for @termsSection2Title.
  ///
  /// In en, this message translates to:
  /// **'2. Medical Disclaimer'**
  String get termsSection2Title;

  /// No description provided for @termsSection2_1.
  ///
  /// In en, this message translates to:
  /// **'The information and consultations offered through Lactocompanion are for educational and awareness purposes only.'**
  String get termsSection2_1;

  /// No description provided for @termsSection2_2.
  ///
  /// In en, this message translates to:
  /// **'The app is not a substitute for professional medical diagnosis or emergency treatment.'**
  String get termsSection2_2;

  /// No description provided for @termsSection2_3.
  ///
  /// In en, this message translates to:
  /// **'Always consult a qualified healthcare provider for serious or urgent medical issues.'**
  String get termsSection2_3;

  /// No description provided for @termsSection2_4.
  ///
  /// In en, this message translates to:
  /// **'All consultations are provided by licensed medical professionals.'**
  String get termsSection2_4;

  /// No description provided for @termsSection2_5.
  ///
  /// In en, this message translates to:
  /// **'In case of medical emergencies, contact local emergency services immediately.'**
  String get termsSection2_5;

  /// No description provided for @termsSection3Title.
  ///
  /// In en, this message translates to:
  /// **'3. User Eligibility'**
  String get termsSection3Title;

  /// No description provided for @termsSection3_1.
  ///
  /// In en, this message translates to:
  /// **'You must be at least 13 years old to use the app.'**
  String get termsSection3_1;

  /// No description provided for @termsSection3_2.
  ///
  /// In en, this message translates to:
  /// **'If you are under 18, you must use the app under guardian supervision.'**
  String get termsSection3_2;

  /// No description provided for @termsSection3_3.
  ///
  /// In en, this message translates to:
  /// **'By using the app, you confirm that all information you provide is accurate and complete.'**
  String get termsSection3_3;

  /// No description provided for @termsSection4Title.
  ///
  /// In en, this message translates to:
  /// **'4. Account Registration and Security'**
  String get termsSection4Title;

  /// No description provided for @termsSection4_1.
  ///
  /// In en, this message translates to:
  /// **'Users can sign up using email or Google Authentication.'**
  String get termsSection4_1;

  /// No description provided for @termsSection4_2.
  ///
  /// In en, this message translates to:
  /// **'You are responsible for keeping your login credentials secure.'**
  String get termsSection4_2;

  /// No description provided for @termsSection4_3.
  ///
  /// In en, this message translates to:
  /// **'Misuse, impersonation, or sharing of accounts is prohibited and may result in termination.'**
  String get termsSection4_3;

  /// No description provided for @termsSection5Title.
  ///
  /// In en, this message translates to:
  /// **'5. Intellectual Property'**
  String get termsSection5Title;

  /// No description provided for @termsSection5_1.
  ///
  /// In en, this message translates to:
  /// **'All content, including videos, images, guides, and consultation materials, is the property of Lactocompanion.'**
  String get termsSection5_1;

  /// No description provided for @termsSection5_2.
  ///
  /// In en, this message translates to:
  /// **'You may only use app content for personal and non-commercial purposes.'**
  String get termsSection5_2;

  /// No description provided for @acknowledgmentTitle.
  ///
  /// In en, this message translates to:
  /// **'Acknowledgment'**
  String get acknowledgmentTitle;

  /// No description provided for @acknowledgment1.
  ///
  /// In en, this message translates to:
  /// **'By using Lactocompanion, you acknowledge that you have read, understood, and agreed to this Privacy Policy and Terms & Conditions.'**
  String get acknowledgment1;

  /// No description provided for @enterName.
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get enterName;

  /// No description provided for @noName.
  ///
  /// In en, this message translates to:
  /// **'No name'**
  String get noName;

  /// No description provided for @enterEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get enterEmail;

  /// No description provided for @noEmail.
  ///
  /// In en, this message translates to:
  /// **'No email'**
  String get noEmail;

  /// No description provided for @totalVideos.
  ///
  /// In en, this message translates to:
  /// **'Total Videos'**
  String get totalVideos;

  /// No description provided for @pendingVideos.
  ///
  /// In en, this message translates to:
  /// **'Pending Videos'**
  String get pendingVideos;

  /// No description provided for @completedVideos.
  ///
  /// In en, this message translates to:
  /// **'Completed Videos'**
  String get completedVideos;

  /// No description provided for @confirmLogout.
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogout;

  /// No description provided for @logoutMessage.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout?'**
  String get logoutMessage;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyTitle;

  /// No description provided for @aboutUsText.
  ///
  /// In en, this message translates to:
  /// **'At LactoCompanion, we simplify mother and baby care with trusted guidance and smart health support.\n\nDesigned and Developed by Rategle Technologies.'**
  String get aboutUsText;

  /// No description provided for @bookingSuccessful.
  ///
  /// In en, this message translates to:
  /// **'Booking Successful'**
  String get bookingSuccessful;

  /// No description provided for @appointmentBooked.
  ///
  /// In en, this message translates to:
  /// **'Appointment\nBooked\nSuccessfully!'**
  String get appointmentBooked;

  /// No description provided for @withDoctor.
  ///
  /// In en, this message translates to:
  /// **'With Dr. {doctorName}'**
  String withDoctor(Object doctorName);

  /// No description provided for @atTime.
  ///
  /// In en, this message translates to:
  /// **'at'**
  String get atTime;

  /// No description provided for @bookingEmailNote.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmation sent. We\'ll see you soon!'**
  String get bookingEmailNote;

  /// No description provided for @viewAppointment.
  ///
  /// In en, this message translates to:
  /// **'View appointment details'**
  String get viewAppointment;

  /// No description provided for @appointmentDetailsSnack.
  ///
  /// In en, this message translates to:
  /// **'Appointment details have been sent to your email.'**
  String get appointmentDetailsSnack;

  /// No description provided for @jan.
  ///
  /// In en, this message translates to:
  /// **'Jan'**
  String get jan;

  /// No description provided for @feb.
  ///
  /// In en, this message translates to:
  /// **'Feb'**
  String get feb;

  /// No description provided for @mar.
  ///
  /// In en, this message translates to:
  /// **'Mar'**
  String get mar;

  /// No description provided for @apr.
  ///
  /// In en, this message translates to:
  /// **'Apr'**
  String get apr;

  /// No description provided for @may.
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// No description provided for @jun.
  ///
  /// In en, this message translates to:
  /// **'Jun'**
  String get jun;

  /// No description provided for @jul.
  ///
  /// In en, this message translates to:
  /// **'Jul'**
  String get jul;

  /// No description provided for @aug.
  ///
  /// In en, this message translates to:
  /// **'Aug'**
  String get aug;

  /// No description provided for @sep.
  ///
  /// In en, this message translates to:
  /// **'Sep'**
  String get sep;

  /// No description provided for @oct.
  ///
  /// In en, this message translates to:
  /// **'Oct'**
  String get oct;

  /// No description provided for @nov.
  ///
  /// In en, this message translates to:
  /// **'Nov'**
  String get nov;

  /// No description provided for @dec.
  ///
  /// In en, this message translates to:
  /// **'Dec'**
  String get dec;

  /// No description provided for @fillFields.
  ///
  /// In en, this message translates to:
  /// **'Please fill all fields correctly'**
  String get fillFields;

  /// No description provided for @bookingFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed to confirm booking'**
  String get bookingFailed;

  /// No description provided for @patientInfo.
  ///
  /// In en, this message translates to:
  /// **'Patient Information'**
  String get patientInfo;

  /// No description provided for @yrs.
  ///
  /// In en, this message translates to:
  /// **'yrs'**
  String get yrs;

  /// No description provided for @monday.
  ///
  /// In en, this message translates to:
  /// **'Mon'**
  String get monday;

  /// No description provided for @tuesday.
  ///
  /// In en, this message translates to:
  /// **'Tue'**
  String get tuesday;

  /// No description provided for @wednesday.
  ///
  /// In en, this message translates to:
  /// **'Wed'**
  String get wednesday;

  /// No description provided for @thursday.
  ///
  /// In en, this message translates to:
  /// **'Thu'**
  String get thursday;

  /// No description provided for @friday.
  ///
  /// In en, this message translates to:
  /// **'Fri'**
  String get friday;

  /// No description provided for @nameTooShort.
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameTooShort;

  /// No description provided for @enterMobile.
  ///
  /// In en, this message translates to:
  /// **'Please enter mobile number'**
  String get enterMobile;

  /// No description provided for @mobileLength.
  ///
  /// In en, this message translates to:
  /// **'Mobile number must be 10 digits'**
  String get mobileLength;

  /// No description provided for @validMobile.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid mobile number'**
  String get validMobile;

  /// No description provided for @enterAge.
  ///
  /// In en, this message translates to:
  /// **'Please enter your age'**
  String get enterAge;

  /// No description provided for @validAge.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid age (1-120)'**
  String get validAge;

  /// No description provided for @validEmail.
  ///
  /// In en, this message translates to:
  /// **'Please enter valid email address'**
  String get validEmail;

  /// No description provided for @appointmentBookedSuccess.
  ///
  /// In en, this message translates to:
  /// **'Appointment Booked Successfully!'**
  String get appointmentBookedSuccess;

  /// No description provided for @atHospital.
  ///
  /// In en, this message translates to:
  /// **'Hospital: {hospitalName}'**
  String atHospital(Object hospitalName);

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsAndConditions.
  ///
  /// In en, this message translates to:
  /// **'Terms & Conditions'**
  String get termsAndConditions;

  /// No description provided for @selectDate.
  ///
  /// In en, this message translates to:
  /// **'Select Date'**
  String get selectDate;

  /// No description provided for @selectTime.
  ///
  /// In en, this message translates to:
  /// **'Select Time'**
  String get selectTime;

  /// No description provided for @phone.
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phone;

  /// No description provided for @patients.
  ///
  /// In en, this message translates to:
  /// **'Patients'**
  String get patients;

  /// No description provided for @experience.
  ///
  /// In en, this message translates to:
  /// **'Experience'**
  String get experience;

  /// No description provided for @rating.
  ///
  /// In en, this message translates to:
  /// **'Rating'**
  String get rating;

  /// No description provided for @bookingConfirmationSent.
  ///
  /// In en, this message translates to:
  /// **'Booking confirmation sent. We\'ll see you soon!'**
  String get bookingConfirmationSent;

  /// No description provided for @viewAppointmentDetails.
  ///
  /// In en, this message translates to:
  /// **'View appointment details'**
  String get viewAppointmentDetails;

  /// No description provided for @languageSwitchSubtitle.
  ///
  /// In en, this message translates to:
  /// **'يمكنك تغيير لغة التطبيق في أي وقت.'**
  String get languageSwitchSubtitle;

  /// No description provided for @bookingSuccessSubtitle.
  ///
  /// In en, this message translates to:
  /// **'تم تأكيد الحجز بنجاح.'**
  String get bookingSuccessSubtitle;

  /// No description provided for @feedbackTitle.
  ///
  /// In en, this message translates to:
  /// **'We Value Your Feedback! 💭'**
  String get feedbackTitle;

  /// No description provided for @feedbackSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Help us improve your experience'**
  String get feedbackSubtitle;

  /// No description provided for @feedbackQuestion.
  ///
  /// In en, this message translates to:
  /// **'How do you feel about the app? ⭐'**
  String get feedbackQuestion;

  /// No description provided for @feedbackBad.
  ///
  /// In en, this message translates to:
  /// **'Bad'**
  String get feedbackBad;

  /// No description provided for @feedbackOkay.
  ///
  /// In en, this message translates to:
  /// **'Okay'**
  String get feedbackOkay;

  /// No description provided for @feedbackGood.
  ///
  /// In en, this message translates to:
  /// **'Good'**
  String get feedbackGood;

  /// No description provided for @feedbackExcellent.
  ///
  /// In en, this message translates to:
  /// **'Excellent'**
  String get feedbackExcellent;

  /// No description provided for @feedbackShareThoughts.
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts 💬'**
  String get feedbackShareThoughts;

  /// No description provided for @feedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Tell us what you think... (optional)'**
  String get feedbackHint;

  /// No description provided for @feedbackSubmit.
  ///
  /// In en, this message translates to:
  /// **'Submit Feedback'**
  String get feedbackSubmit;

  /// No description provided for @feedbackThankYou.
  ///
  /// In en, this message translates to:
  /// **'✅ Thank you for your feedback! 🎉'**
  String get feedbackThankYou;

  /// No description provided for @feedbackError.
  ///
  /// In en, this message translates to:
  /// **'❌ Failed to submit feedback'**
  String get feedbackError;

  /// No description provided for @feedbackPleaseSelect.
  ///
  /// In en, this message translates to:
  /// **'Please select a rating! 🌟'**
  String get feedbackPleaseSelect;

  /// No description provided for @giveFeedback.
  ///
  /// In en, this message translates to:
  /// **'Give Feedback'**
  String get giveFeedback;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['ar', 'en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ar':
      return AppLocalizationsAr();
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
