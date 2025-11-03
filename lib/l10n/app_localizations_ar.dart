// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'لاكتو كومبانيون';

  @override
  String get welcome => 'مرحبا';

  @override
  String get cart => 'عربة التسوق';

  @override
  String get checkout => 'الدفع';

  @override
  String get profile => 'الملف الشخصي';

  @override
  String get selectLanguage => 'اختر اللغة';

  @override
  String get changeLanguage => 'تغيير اللغة';

  @override
  String get confirm => 'تأكيد';

  @override
  String get cancel => 'إلغاء';

  @override
  String get confirmBooking => 'تأكيد الحجز';

  @override
  String get appointmentSummary => 'ملخص الموعد';

  @override
  String get patientInformation => 'معلومات المريض';

  @override
  String get doctor => 'الطبيب';

  @override
  String get hospital => 'المستشفى';

  @override
  String get date => 'التاريخ';

  @override
  String get time => 'الوقت';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get mobileNumber => 'رقم الهاتف';

  @override
  String get age => 'العمر';

  @override
  String get email => 'بريد إلكتروني';

  @override
  String get languageConfirmation => 'تأكيد اللغة';

  @override
  String get success => 'نجاح!';

  @override
  String get languagePreference => 'تفضيل اللغة';

  @override
  String get bookingConfirmed => 'تم تأكيد الحجز';

  @override
  String get successfullyConfirmed => 'تم التأكيد بنجاح!';

  @override
  String get yourBookingConfirmed => 'تم تأكيد حجزك!';

  @override
  String get checkEmail => 'تحقق من بريدك الإلكتروني';

  @override
  String get confirmationDetailsSent => 'تم إرسال تفاصيل التأكيد';

  @override
  String get continueText => 'استمر';

  @override
  String get bookingDetailsComingSoon => 'تفاصيل الحجز قادمة قريبًا!';

  @override
  String get viewBookingDetails => 'عرض تفاصيل الحجز';

  @override
  String get loginTitle => 'تسجيل الدخول إلى حسابك';

  @override
  String get emailLabel => 'البريد الإلكتروني';

  @override
  String get passwordLabel => 'كلمة المرور';

  @override
  String get rememberMe => 'تذكرني';

  @override
  String get forgotPassword => 'هل نسيت كلمة المرور؟';

  @override
  String get login => 'تسجيل الدخول';

  @override
  String get orContinueWith => 'أو تابع مع';

  @override
  String get loginWithGoogle => 'تسجيل الدخول باستخدام جوجل';

  @override
  String get dontHaveAccount => 'ليس لديك حساب؟';

  @override
  String get signUp => 'إنشاء حساب';

  @override
  String get fillAllFields => '⚠️ يرجى ملء جميع الحقول';

  @override
  String get welcomeBack => 'مرحبًا بعودتك،';

  @override
  String get loginFailed => 'فشل تسجيل الدخول';

  @override
  String get invalidCredentials =>
      'البريد الإلكتروني أو كلمة المرور غير صحيحة ❌';

  @override
  String get userNotFound => 'المستخدم غير موجود. يرجى التسجيل أولاً 📝';

  @override
  String get loggedInAs => 'تم تسجيل الدخول باسم';

  @override
  String get googleLoginFailed =>
      'فشل تسجيل الدخول باستخدام جوجل. حاول مرة أخرى.';

  @override
  String get enterEmailFirst => 'الرجاء إدخال بريدك الإلكتروني أولاً';

  @override
  String get passwordResetSent =>
      '📧 تم إرسال رابط إعادة تعيين كلمة المرور! تحقق من بريدك الإلكتروني.';

  @override
  String get resetFailed => 'فشل إعادة التعيين. حاول مرة أخرى لاحقًا.';

  @override
  String get enterYour => 'أدخل';

  @override
  String get password => 'كلمة المرور';

  @override
  String get resetPasswordTitle => 'إعادة تعيين كلمة المرور';

  @override
  String get newPassword => 'كلمة مرور جديدة';

  @override
  String get confirmPassword => 'تأكيد كلمة المرور';

  @override
  String get updatePasswordButton => 'تحديث كلمة المرور';

  @override
  String get fillBothFields => 'يرجى ملء كلا الحقلين';

  @override
  String get passwordTooShort => 'يجب أن تكون كلمة المرور 6 أحرف على الأقل';

  @override
  String get passwordsDoNotMatch => 'كلمات المرور غير متطابقة';

  @override
  String get noActiveSession =>
      'لا توجد جلسة نشطة. يرجى تسجيل الدخول مرة أخرى.';

  @override
  String get passwordUpdated => 'تم تحديث كلمة المرور بنجاح';

  @override
  String updateFailed(Object error) {
    return 'فشل التحديث: $error';
  }

  @override
  String get createAccountTitle => 'إنشاء حسابك';

  @override
  String get name => 'الاسم';

  @override
  String get signupFailed => 'فشل التسجيل. حاول مرة أخرى.';

  @override
  String get somethingWentWrong => 'حدث خطأ ما';

  @override
  String get accountExists => 'الحساب موجود بالفعل. يرجى تسجيل الدخول 🔑';

  @override
  String get invalidEmail => 'البريد الإلكتروني غير صالح. حاول مرة أخرى 📧';

  @override
  String get weakPassword => 'كلمة المرور ضعيفة جدًا. استخدم واحدة أقوى 🔒';

  @override
  String get googleSignupFailed =>
      'فشل التسجيل باستخدام Google. حاول مرة أخرى.';

  @override
  String get orSignUpWith => 'أو سجل باستخدام';

  @override
  String get signUpWithGoogle => 'سجل باستخدام Google';

  @override
  String get alreadyHaveAccount => 'هل لديك حساب بالفعل؟';

  @override
  String get hello => 'مرحبا 👋';

  @override
  String get guest => 'زائر';

  @override
  String get findVideo => 'دعنا نجد الفيديو الخاص بك';

  @override
  String get searchVideos => 'ابحث عن مقاطع الفيديو';

  @override
  String get untitled => 'بدون عنوان';

  @override
  String get noDescription => 'لا يوجد وصف متاح';

  @override
  String get pending => 'قيد الانتظار';

  @override
  String get completed => 'مكتمل';

  @override
  String get watched => 'تمت المشاهدة';

  @override
  String get readMore => 'اقرأ المزيد';

  @override
  String get readLess => 'اقرأ أقل';

  @override
  String get liveChat => 'الدردشة المباشرة';

  @override
  String get liveChatSpecialist => 'دردشة مباشرة مع أخصائيينا';

  @override
  String get typeMessage => 'اكتب رسالتك...';

  @override
  String get expertConsultation => 'استشارة الخبراء';

  @override
  String get available => 'متاح';

  @override
  String get notAvailable => 'غير متاح';

  @override
  String get bookNow => 'احجز الآن';

  @override
  String get doctorDetails => 'تفاصيل الطبيب';

  @override
  String get bookAppointment => 'حجز موعد';

  @override
  String get oneTapTo => 'بنقرة واحدة';

  @override
  String get better => 'صحة';

  @override
  String get health => 'أفضل';

  @override
  String get findSpecialist => 'اعثر على أفضل الأطباء في الوقت المناسب';

  @override
  String get trustedCare => 'رعاية موثوقة';

  @override
  String get signup => 'إنشاء حساب';

  @override
  String get secure => 'آمن';

  @override
  String get verified => 'موثوق';

  @override
  String get caring => 'رعاية';

  @override
  String get welcomeTagline => 'رفيقك الموثوق لصحة الأم';

  @override
  String get videos => 'الفيديوهات';

  @override
  String get noVideosFound => 'لا توجد فيديوهات';

  @override
  String get watchNow => 'شاهد الآن';

  @override
  String get watchThisVideo => 'شاهد هذا الفيديو:';

  @override
  String get videoDescription => 'وصف الفيديو';

  @override
  String get uploadedByAdmin => 'تم الرفع بواسطة المشرف';

  @override
  String get likes => 'إعجابات';

  @override
  String get comments => 'التعليقات';

  @override
  String get noComments => 'لا توجد تعليقات.';

  @override
  String get addComment => 'أضف تعليقًا...';

  @override
  String get share => 'مشاركة';

  @override
  String get unknown => 'Unknown';

  @override
  String get privacyPolicyTitle => 'سياسة الخصوصية';

  @override
  String get privacyIntro =>
      'مرحبًا بك في Lactocompanion! خصوصيتك مهمة بالنسبة لنا. توضح سياسة الخصوصية هذه كيفية جمع واستخدام وحماية معلوماتك الشخصية وفقًا لقوانين حماية البيانات، بما في ذلك قانون تكنولوجيا المعلومات الهندي ومعايير GDPR. باستخدامك للتطبيق، فإنك توافق على هذه السياسة.';

  @override
  String get infoCollectTitle => '1. المعلومات التي نجمعها';

  @override
  String get infoCollect1 => 'قد نقوم بجمع المعلومات التالية:';

  @override
  String get infoCollect2 =>
      '• المعلومات الشخصية: الاسم، البريد الإلكتروني، رقم الهاتف المحمول، والعمر.';

  @override
  String get infoCollect3 =>
      '• بيانات الاستخدام: نشاط التطبيق، معلومات الجهاز، وبيانات التحليل.';

  @override
  String get infoCollect4 =>
      '• بيانات الاستشارة: الرسائل أو النماذج التي يتم مشاركتها أثناء الاستشارات الطبية المجانية.';

  @override
  String get infoCollect5 =>
      '• البيانات التقنية: سجلات الأخطاء وإحصاءات الأداء لتحسين تجربة المستخدم.';

  @override
  String get infoUseTitle => '2. كيفية استخدام المعلومات';

  @override
  String get infoUse1 => 'نستخدم بياناتك من أجل:';

  @override
  String get infoUse2 => '• إنشاء وإدارة حساب المستخدم.';

  @override
  String get infoUse3 => '• إدارة الاستشارات الطبية المجانية.';

  @override
  String get infoUse4 =>
      '• تقديم محتوى تعليمي وإرشادي وتوعوي للأمهات ومقدمي الرعاية.';

  @override
  String get infoUse5 => '• إرسال النصائح الصحية والتحديثات والتذكيرات.';

  @override
  String get infoUse6 => '• ضمان الأمان والامتثال للقوانين.';

  @override
  String get infoShareTitle => '3. مشاركة المعلومات';

  @override
  String get infoShare1 =>
      'نحن نحترم خصوصيتك — لا نقوم ببيع أو مشاركة بياناتك مع أي طرف خارجي.';

  @override
  String get infoShare2 =>
      'قد تتم مشاركة بيانات محدودة مع خدمات موثوقة مثل Google Firebase لأغراض المصادقة والتحليل.';

  @override
  String get infoShare3 => 'قد يتم الكشف عن المعلومات إذا طلب القانون ذلك.';

  @override
  String get infoShare4 => 'يلتزم جميع مزودي الخدمات باتفاقيات سرية صارمة.';

  @override
  String get dataSecurityTitle => '4. أمان البيانات';

  @override
  String get dataSecurity1 =>
      'يتم تشفير جميع البيانات وتخزينها على خوادم آمنة مع تقييد الوصول للأشخاص المصرح لهم فقط.';

  @override
  String get dataSecurity2 =>
      'نستخدم بروتوكولات أمان قياسية لحماية بياناتك من الوصول غير المصرح به.';

  @override
  String get dataSecurity3 =>
      'لكن لا يوجد نظام عبر الإنترنت آمن بنسبة 100٪. استخدامك للتطبيق يكون على مسؤوليتك.';

  @override
  String get dataRetentionTitle => '5. الاحتفاظ بالبيانات';

  @override
  String get dataRetention1 =>
      'نحتفظ ببياناتك طالما كان ذلك ضروريًا لتقديم الخدمة أو الامتثال للقانون.';

  @override
  String get dataRetention2 =>
      'عند حذف الحساب، نقوم بإزالة جميع البيانات الشخصية خلال فترة زمنية معقولة.';

  @override
  String get thirdPartyTitle => '6. خدمات الجهات الخارجية';

  @override
  String get thirdParty1 =>
      'نستخدم خدمات موثوقة مثل Google Firebase لتحسين الأداء والوظائف.';

  @override
  String get thirdParty2 =>
      'تخضع هذه الخدمات لسياساتها الخاصة إلى جانب هذه السياسة.';

  @override
  String get userRightsTitle => '7. حقوقك';

  @override
  String get yourRightsTitle => '7. Your Rights';

  @override
  String get userRights1 => 'يمكنك طلب ما يلي:';

  @override
  String get yourRights1 => 'You can request to:';

  @override
  String get userRights2 => '• الوصول إلى بياناتك الشخصية أو تصحيحها أو حذفها.';

  @override
  String get yourRights2 => '• Access, review, or correct your personal data.';

  @override
  String get userRights3 => '• سحب موافقتك على معالجة البيانات.';

  @override
  String get userRights4 => '• التواصل معنا عبر lactocompanion@gmail.com.';

  @override
  String get userRights5 =>
      'To exercise these rights, contact us at lactocompanion@gmail.com.';

  @override
  String get childrenPrivacyTitle => '8. خصوصية الأطفال';

  @override
  String get childrenPrivacy1 => 'التطبيق غير مخصص للأطفال دون 13 عامًا.';

  @override
  String get childrenPrivacy2 =>
      'سيتم حذف أي بيانات يتم جمعها من الأطفال على الفور.';

  @override
  String get internationalTransferTitle => '9. نقل البيانات الدولي';

  @override
  String get internationalTransfer1 =>
      'قد تتم معالجة بعض البيانات على خوادم دولية متوافقة مع معايير GDPR.';

  @override
  String get bugReportTitle => '10. الإبلاغ عن الأخطاء';

  @override
  String get bugReport1 => '• للأخطاء التقنية: rategletechnologies@gmail.com';

  @override
  String get bugReport2 =>
      '• لمشاكل المحتوى أو الاستشارات: lactocompanion@gmail.com';

  @override
  String get policyUpdateTitle => '11. تحديثات السياسة';

  @override
  String get policyUpdate1 =>
      'قد نقوم بتحديث هذه السياسة من وقت لآخر، وستكون النسخة الأحدث متاحة داخل التطبيق.';

  @override
  String get policyUpdate2 =>
      'استخدامك المستمر بعد التحديث يعني موافقتك على النسخة الجديدة.';

  @override
  String get privacyContactTitle => '12. التواصل بخصوص الخصوصية';

  @override
  String get privacyContact1 => '• للاستفسارات: lactocompanion@gmail.com';

  @override
  String get privacyContact2 => '• للدعم الفني: rategletechnologies@gmail.com';

  @override
  String get termsTitle => 'الشروط والأحكام';

  @override
  String get termsIntro =>
      'مرحبًا بك في Lactocompanion! يرجى قراءة هذه الشروط بعناية، فباستخدامك للتطبيق، فإنك توافق عليها.';

  @override
  String get termsSection1Title => '1. عن التطبيق';

  @override
  String get termsSection1_1 =>
      'Lactocompanion هو تطبيق متاح على أنظمة Android وiOS.';

  @override
  String get termsSection1_2 =>
      'يقدم محتوى تعليميًا وتوعويًا للأمهات ومقدمي الرعاية.';

  @override
  String get termsSection1_3 => 'كما يوفر استشارات مجانية مع أطباء موثوقين.';

  @override
  String get termsSection1_4 =>
      'تم تصميم وتطوير التطبيق بواسطة Rategle Technologies.';

  @override
  String get termsSection2Title => '2. Medical Disclaimer';

  @override
  String get termsSection2_1 =>
      'The information and consultations offered through Lactocompanion are for educational and awareness purposes only.';

  @override
  String get termsSection2_2 =>
      'The app is not a substitute for professional medical diagnosis or emergency treatment.';

  @override
  String get termsSection2_3 =>
      'Always consult a qualified healthcare provider for serious or urgent medical issues.';

  @override
  String get termsSection2_4 =>
      'All consultations are provided by licensed medical professionals.';

  @override
  String get termsSection2_5 =>
      'In case of medical emergencies, contact local emergency services immediately.';

  @override
  String get termsSection3Title => '3. User Eligibility';

  @override
  String get termsSection3_1 =>
      'You must be at least 13 years old to use the app.';

  @override
  String get termsSection3_2 =>
      'If you are under 18, you must use the app under guardian supervision.';

  @override
  String get termsSection3_3 =>
      'By using the app, you confirm that all information you provide is accurate and complete.';

  @override
  String get termsSection4Title => '4. Account Registration and Security';

  @override
  String get termsSection4_1 =>
      'Users can sign up using email or Google Authentication.';

  @override
  String get termsSection4_2 =>
      'You are responsible for keeping your login credentials secure.';

  @override
  String get termsSection4_3 =>
      'Misuse, impersonation, or sharing of accounts is prohibited and may result in termination.';

  @override
  String get termsSection5Title => '5. Intellectual Property';

  @override
  String get termsSection5_1 =>
      'All content, including videos, images, guides, and consultation materials, is the property of Lactocompanion.';

  @override
  String get termsSection5_2 =>
      'You may only use app content for personal and non-commercial purposes.';

  @override
  String get termsSection5_3 =>
      'Copying, redistributing, or modifying app content is strictly prohibited.';

  @override
  String get termsSection6Title => '6. Acceptable Use Policy';

  @override
  String get termsSection6_1 =>
      'You agree not to upload or distribute abusive, false, or illegal content.';

  @override
  String get termsSection6_2 =>
      'You must not misuse consultations or impersonate healthcare professionals.';

  @override
  String get termsSection6_3 =>
      'Violation of these rules may result in suspension or legal action.';

  @override
  String get termsSection7Title => '7. Free Consultation Terms';

  @override
  String get termsSection7_1 =>
      'Consultations are provided free of cost by verified doctors.';

  @override
  String get termsSection7_2 =>
      'Availability depends on doctor schedules and may change without notice.';

  @override
  String get termsSection7_3 =>
      'Any abuse, spam, or offensive behavior during consultations will result in suspension.';

  @override
  String get termsSection8Title => '8. Limitation of Liability';

  @override
  String get termsSection8_1 =>
      'Lactocompanion and its consulting doctors are not liable for any damages or consequences resulting from the use of app content or consultations.';

  @override
  String get termsSection8_2 =>
      'Users are responsible for how they interpret and act upon provided information.';

  @override
  String get termsSection9Title => '9. Reporting Issues';

  @override
  String get termsSection9_1 =>
      '• For bugs, crashes, or performance errors: rategletechnologies@gmail.com.';

  @override
  String get termsSection9_2 =>
      '• For content or consultation issues: lactocompanion@gmail.com.';

  @override
  String get termsSection10Title => '10. Indemnification';

  @override
  String get termsSection10_1 =>
      'You agree to indemnify and hold harmless Lactocompanion and its partners from claims, damages, or losses caused by your use or misuse of the app.';

  @override
  String get termsSection11Title => '11. Termination';

  @override
  String get termsSection11_1 =>
      'Lactocompanion may suspend or terminate accounts for violations, fraudulent activities, or legal obligations without prior notice.';

  @override
  String get termsSection12Title => '12. Governing Law';

  @override
  String get termsSection12_1 =>
      'These Terms shall be governed by the laws of India and subject to the jurisdiction of the courts in Trichy, Tamil Nadu.';

  @override
  String get termsSection13Title => '13. Modifications';

  @override
  String get termsSection13_1 =>
      'Lactocompanion may update or modify these Terms at any time. Continued use of the app indicates acceptance of the updated version.';

  @override
  String get termsSection14Title => '14. Contact Information';

  @override
  String get termsSection14_1 =>
      '• General and consultation inquiries: lactocompanion@gmail.com.';

  @override
  String get termsSection14_2 =>
      '• Technical or performance support: rategletechnologies@gmail.com.';

  @override
  String get acknowledgmentTitle => 'إقرار المستخدم';

  @override
  String get acknowledgment1 =>
      'باستخدامك لتطبيق Lactocompanion، فإنك تؤكد أنك قرأت وفهمت ووافقت على سياسة الخصوصية والشروط والأحكام.';

  @override
  String get enterName => 'الرجاء إدخال اسمك';

  @override
  String get noName => 'لا يوجد اسم';

  @override
  String get enterEmail => 'الرجاء إدخال بريدك الإلكتروني';

  @override
  String get noEmail => 'لا يوجد بريد إلكتروني';

  @override
  String get totalVideos => 'إجمالي الفيديوهات';

  @override
  String get pendingVideos => 'الفيديوهات المعلقة';

  @override
  String get completedVideos => 'الفيديوهات المكتملة';

  @override
  String get confirmLogout => 'تأكيد تسجيل الخروج';

  @override
  String get logoutMessage => 'هل أنت متأكد أنك تريد تسجيل الخروج؟';

  @override
  String get logout => 'تسجيل الخروج';

  @override
  String get privacyTitle => 'سياسة الخصوصية';

  @override
  String get aboutUsText =>
      'في LactoCompanion، نسهل رعاية الأم والطفل بتوجيه موثوق ودعم صحي ذكي.\n\nتم التصميم والتطوير بواسطة Rategle Technologies';

  @override
  String get bookingSuccessful => 'تم الحجز بنجاح';

  @override
  String get appointmentBooked => 'تم حجز الموعد\nبنجاح!';

  @override
  String withDoctor(Object doctorName) {
    return 'مع د. $doctorName';
  }

  @override
  String get atTime => 'في';

  @override
  String get bookingEmailNote => 'تم إرسال تأكيد الحجز. نراك قريبًا!';

  @override
  String get viewAppointment => 'عرض تفاصيل الموعد';

  @override
  String get appointmentDetailsSnack =>
      'تم إرسال تفاصيل الموعد إلى بريدك الإلكتروني.';

  @override
  String get jan => 'يناير';

  @override
  String get feb => 'فبراير';

  @override
  String get mar => 'مارس';

  @override
  String get apr => 'أبريل';

  @override
  String get may => 'مايو';

  @override
  String get jun => 'يونيو';

  @override
  String get jul => 'يوليو';

  @override
  String get aug => 'أغسطس';

  @override
  String get sep => 'سبتمبر';

  @override
  String get oct => 'أكتوبر';

  @override
  String get nov => 'نوفمبر';

  @override
  String get dec => 'ديسمبر';

  @override
  String get fillFields => '⚠️ يرجى ملء جميع الحقول بشكل صحيح';

  @override
  String get bookingFailed => 'فشل تأكيد الحجز';

  @override
  String get patientInfo => 'معلومات المريض';

  @override
  String get yrs => 'سنة';

  @override
  String get monday => 'الاثنين';

  @override
  String get tuesday => 'الثلاثاء';

  @override
  String get wednesday => 'الأربعاء';

  @override
  String get thursday => 'الخميس';

  @override
  String get friday => 'الجمعة';

  @override
  String get nameTooShort => 'يجب أن يكون الاسم على الأقل 2 حروف';

  @override
  String get enterMobile => 'الرجاء إدخال رقم الجوال';

  @override
  String get mobileLength => 'يجب أن يتكون رقم الجوال من 10 أرقام';

  @override
  String get validMobile => 'الرجاء إدخال رقم جوال صحيح';

  @override
  String get enterAge => 'الرجاء إدخال عمرك';

  @override
  String get validAge => 'الرجاء إدخال عمر صحيح (1-120)';

  @override
  String get validEmail => 'الرجاء إدخال بريد إلكتروني صالح';

  @override
  String get appointmentBookedSuccess => 'تم حجز الموعد بنجاح!';

  @override
  String atHospital(Object hospitalName) {
    return 'المستشفى: $hospitalName';
  }

  @override
  String get privacyPolicy => 'سياسة الخصوصية';

  @override
  String get termsAndConditions => 'الشروط والأحكام';

  @override
  String get selectDate => 'اختر التاريخ';

  @override
  String get selectTime => 'اختر الوقت';

  @override
  String get phone => 'هاتف';

  @override
  String get patients => 'المرضى';

  @override
  String get experience => 'خبرة';

  @override
  String get rating => 'تقييم';

  @override
  String get bookingConfirmationSent => 'تم إرسال تأكيد الحجز. نراك قريباً!';

  @override
  String get viewAppointmentDetails => 'عرض تفاصيل الموعد';

  @override
  String get languageSwitchSubtitle => 'يمكنك تغيير لغة التطبيق في أي وقت.';

  @override
  String get bookingSuccessSubtitle => 'تم تأكيد الحجز بنجاح.';

  @override
  String get feedbackTitle => 'نقدّر ملاحظاتك! 💭';

  @override
  String get feedbackSubtitle => 'ساعدنا في تحسين تجربتك';

  @override
  String get feedbackQuestion => 'ما رأيك في التطبيق؟ ⭐';

  @override
  String get feedbackBad => 'سيئ';

  @override
  String get feedbackOkay => 'مقبول';

  @override
  String get feedbackGood => 'جيد';

  @override
  String get feedbackExcellent => 'ممتاز';

  @override
  String get feedbackShareThoughts => 'شاركنا رأيك 💬';

  @override
  String get feedbackHint => 'أخبرنا بما تفكر به... (اختياري)';

  @override
  String get feedbackSubmit => 'إرسال الملاحظات';

  @override
  String get feedbackThankYou => '✅ شكرًا لملاحظاتك! 🎉';

  @override
  String get feedbackError => '❌ فشل في إرسال الملاحظات';

  @override
  String get feedbackPleaseSelect => 'يرجى اختيار تقييم! 🌟';

  @override
  String get giveFeedback => 'Give Feedback';
}
