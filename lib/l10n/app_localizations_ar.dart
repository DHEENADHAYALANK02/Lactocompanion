// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Arabic (`ar`).
class AppLocalizationsAr extends AppLocalizations {
  AppLocalizationsAr([String locale = 'ar']) : super(locale);

  @override
  String get appTitle => 'LactoCompanion';

  @override
  String get welcome => 'مرحبًا';

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
  String get doctor => 'طبيب';

  @override
  String get hospital => 'مستشفى';

  @override
  String get date => 'تاريخ';

  @override
  String get time => 'وقت';

  @override
  String get fullName => 'الاسم الكامل';

  @override
  String get mobileNumber => 'رقم الجوال';

  @override
  String get age => 'العمر';

  @override
  String get email => 'البريد الإلكتروني';

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
  String get bookAppointment => 'احجز موعدًا';

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
  String get noVideosFound => 'لم يتم العثور على فيديوهات';

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
  String get unknown => 'غير معروف';

  @override
  String get privacyPolicyTitle => 'سياسة الخصوصية';

  @override
  String get privacyIntro =>
      'مرحبًا بك في Lactocompanion! خصوصيتك مهمة بالنسبة لنا. توضح سياسة الخصوصية هذه كيفية جمع واستخدام وحماية معلوماتك الشخصية وفقًا لقوانين حماية البيانات، بما في ذلك قانون تكنولوجيا المعلومات الهندي ومعايير GDPR. باستخدامك للتطبيق، فإنك توافق على هذه السياسة.';

  @override
  String get infoCollectTitle => '1. المعلومات التي نجمعها';

  @override
  String get infoCollect1 =>
      'قد نقوم بجمع المعلومات التالية منك عند استخدامك للخدمات:';

  @override
  String get infoCollect2 =>
      '• المعلومات الشخصية: الاسم، البريد الإلكتروني، رقم الهاتف المحمول، والعمر.';

  @override
  String get infoCollect3 =>
      '• بيانات الاستخدام: نشاط التطبيق، معلومات الجهاز، وبيانات التحليل.';

  @override
  String get infoCollect4 =>
      '• بيانات الاستشارة: الرسائل أو النماذج التي يتم مشاركتها أثناء الاستشارات المجانية، تُستخدم لأغراض السلامة والجودة.';

  @override
  String get infoCollect5 =>
      '• البيانات التقنية: سجلات الأخطاء وإحصاءات الأداء وأنماط التفاعل لتحسين تجربة المستخدم.';

  @override
  String get infoCollect6 =>
      '• لا يجمع التطبيق عناوين IP لأغراض بيانات الموقع الجغرافي.';

  @override
  String get infoUseTitle => '2. كيفية استخدام معلوماتك';

  @override
  String get infoUse1 => 'نستخدم بياناتك من أجل:';

  @override
  String get infoUse2 => '• إنشاء وإدارة حساب المستخدم الخاص بك.';

  @override
  String get infoUse3 => '• جدولة وإدارة الاستشارات.';

  @override
  String get infoUse4 => '• تقديم محتوى تعليمي وإرشادي وتوعوي.';

  @override
  String get infoUse5 => '• التواصل بالتحديثات والنصائح الصحية والتذكيرات.';

  @override
  String get infoUse6 =>
      '• ضمان الأمان، منع الاحتيال، والامتثال للالتزامات القانونية.';

  @override
  String get infoShareTitle => '3. مشاركة المعلومات والكشف عنها';

  @override
  String get infoShare1 =>
      'نحن نحترم خصوصيتك. لا نقوم ببيع أو تأجير أو تداول معلوماتك الشخصية.';

  @override
  String get infoShare2 =>
      'قد نشارك معلومات محدودة مع خدمات موثوقة من أطراف ثالثة مثل Google Firebase للمصادقة والتحليل.';

  @override
  String get infoShare3 =>
      'قد نكشف عن المعلومات إذا تطلب القانون أو أمر المحكمة أو السلطة الحكومية ذلك.';

  @override
  String get infoShare4 =>
      'جميع الشركاء من الأطراف الثالثة ملتزمون باتفاقيات السرية وحماية البيانات.';

  @override
  String get dataSecurityTitle => '4. أمان البيانات';

  @override
  String get dataSecurity1 =>
      'نطبق إجراءات أمنية صارمة بما في ذلك التشفير والخوادم الآمنة والوصول المحدود للموظفين.';

  @override
  String get dataSecurity2 =>
      'يتم تشفير جميع نقلات البيانات وتخزينها على خوادم آمنة.';

  @override
  String get dataSecurity3 =>
      'ومع ذلك، لا يمكن لأي نظام عبر الإنترنت ضمان أمان 100٪. أنت تستخدم التطبيق على مسؤوليتك الخاصة.';

  @override
  String get dataRetentionTitle => '5. الاحتفاظ بالبيانات';

  @override
  String get dataRetention1 =>
      'نحتفظ ببياناتك فقط طالما كان ذلك ضروريًا لتقديم الخدمات أو كما يتطلب القانون.';

  @override
  String get dataRetention2 =>
      'عند حذف حسابك، نقوم بإزالة البيانات القابلة للتحديد خلال إطار زمني معقول.';

  @override
  String get thirdPartyTitle => '6. خدمات الجهات الخارجية';

  @override
  String get thirdParty1 =>
      'نستخدم أدوات موثوقة مثل Google Firebase وخدمات التحليل لتعزيز الوظائف.';

  @override
  String get thirdParty2 =>
      'تعمل هذه الخدمات تحت سياسات الخصوصية الخاصة بها، والتي تنطبق جنبًا إلى جنب مع هذه السياسة.';

  @override
  String get yourRightsTitle => '7. حقوقك';

  @override
  String get yourRights1 =>
      'يمكنك طلب الوصول إلى بياناتك الشخصية أو مراجعتها أو تصحيحها.';

  @override
  String get yourRights2 =>
      'يمكنك أيضًا طلب حذف حسابك أو سحب موافقتك على معالجة البيانات.';

  @override
  String get yourRights3 =>
      'لممارسة هذه الحقوق، اتصل بنا على lactocompanion@gmail.com.';

  @override
  String get childrenPrivacyTitle => '8. خصوصية الأطفال';

  @override
  String get childrenPrivacy1 => 'تطبيقنا غير مخصص للأطفال دون سن 13 عامًا.';

  @override
  String get childrenPrivacy2 =>
      'إذا اكتشفنا بيانات تم جمعها من مستخدمين تقل أعمارهم عن 13 عامًا، فإننا نحذفها على الفور.';

  @override
  String get internationalTransferTitle => '9. نقل البيانات الدولي';

  @override
  String get internationalTransfer1 =>
      'قد تتم معالجة بعض البيانات على خوادم دولية من خلال مزودي التكنولوجيا لدينا. نضمن حماية جميع عمليات النقل من خلال آليات نقل البيانات القانونية.';

  @override
  String get termsTitle => 'الشروط والأحكام';

  @override
  String get termsIntro =>
      'مرحبًا بك في Lactocompanion! يرجى قراءة هذه الشروط والأحكام بعناية قبل استخدام تطبيقنا. من خلال الوصول إلى تطبيق Lactocompanion أو استخدامه، فإنك توافق على الالتزام بهذه الشروط.';

  @override
  String get termsSection1Title => '1. حول التطبيق';

  @override
  String get termsSection1_1 =>
      'Lactocompanion هو تطبيق جوال متاح على أنظمة Android و iOS.';

  @override
  String get termsSection1_2 =>
      'يوفر التطبيق إرشادات تعليمية وتوعوية حول حليب الثدي والرضاعة.';

  @override
  String get termsSection1_3 =>
      'يقدم التطبيق استشارات مجانية وميزة دردشة مباشرة مع خبراء الرضاعة المعتمدين، متاحة باللغتين الإنجليزية والعربية، لتقديم الدعم والإرشاد الشخصي.';

  @override
  String get termsSection1_4 =>
      'تطبيق Lactocompanion مملوك وتشغله Lactocompanion وتم تطويره تقنيًا بواسطة Rategle Technologies.';

  @override
  String get termsSection2Title => '2. إخلاء المسؤولية الطبية';

  @override
  String get termsSection2_1 =>
      'المعلومات والاستشارات المقدمة من خلال تطبيق Lactocompanion هي لأغراض تعليمية وتوعوية فقط.';

  @override
  String get termsSection2_2 =>
      'التطبيق ليس بديلاً عن التشخيص الطبي المهني أو العلاج في حالات الطوارئ.';

  @override
  String get termsSection2_3 =>
      'استشر دائمًا مقدم الرعاية الصحية المؤهل لمشاكلك الطبية الخطيرة أو العاجلة.';

  @override
  String get termsSection2_4 =>
      'يتم تقديم جميع الاستشارات من قبل متخصصين طبيين مرخصين.';

  @override
  String get termsSection2_5 =>
      'في حالات الطوارئ الطبية، اتصل بخدمات الطوارئ المحلية على الفور.';

  @override
  String get termsSection3Title => '3. أهلية المستخدم';

  @override
  String get termsSection3_1 =>
      'يجب أن يكون عمرك 13 عامًا على الأقل لاستخدام التطبيق.';

  @override
  String get termsSection3_2 =>
      'إذا كان عمرك أقل من 18 عامًا، فيجب عليك استخدام التطبيق تحت إشراف ولي الأمر.';

  @override
  String get termsSection3_3 =>
      'باستخدامك للتطبيق، فإنك تؤكد أن جميع المعلومات التي تقدمها دقيقة وكاملة.';

  @override
  String get termsSection4Title => '4. تسجيل الحساب والأمان';

  @override
  String get termsSection4_1 =>
      'يمكن للمستخدمين التسجيل باستخدام البريد الإلكتروني أو المصادقة من Google.';

  @override
  String get termsSection4_2 =>
      'أنت مسؤول عن الحفاظ على أمان بيانات اعتماد تسجيل الدخول الخاصة بك.';

  @override
  String get termsSection4_3 =>
      'يُحظر إساءة الاستخدام أو انتحال الشخصية أو مشاركة الحسابات وقد يؤدي إلى إنهاء الخدمة.';

  @override
  String get termsSection5Title => '5. الملكية الفكرية';

  @override
  String get termsSection5_1 =>
      'جميع المحتويات، بما في ذلك مقاطع الفيديو والصور والأدلة ومواد الاستشارة، هي ملك لتطبيق Lactocompanion.';

  @override
  String get termsSection5_2 =>
      'يمكنك استخدام محتوى التطبيق للأغراض الشخصية وغير التجارية فقط.';

  @override
  String get acknowledgmentTitle => 'إقرار';

  @override
  String get acknowledgment1 =>
      'باستخدامك لتطبيق Lactocompanion، فإنك تقر بأنك قد قرأت وفهمت ووافقت على سياسة الخصوصية والشروط والأحكام هذه.';

  @override
  String get enterName => 'الرجاء إدخال اسمك';

  @override
  String get noName => 'لا يوجد اسم';

  @override
  String get enterEmail => 'أدخل البريد الإلكتروني';

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
      'في LactoCompanion، نسهل رعاية الأم والطفل بتوجيه موثوق ودعم صحي ذكي.\n\nتم التصميم والتطوير بواسطة Rategle Technologies.';

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
  String get nameTooShort => 'يجب أن يكون الاسم على الأقل 2 حرف';

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
  String get phone => 'الهاتف';

  @override
  String get patients => 'المرضى';

  @override
  String get experience => 'الخبرة';

  @override
  String get rating => 'التقييم';

  @override
  String get bookingConfirmationSent => 'تم إرسال تأكيد الحجز. نراك قريبًا!';

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
  String get giveFeedback => 'أعطِ ملاحظاتك';

  @override
  String get deleteAccount => 'حذف الحساب';

  @override
  String get deleteAccountConfirmation => 'هل أنت متأكد أنك تريد حذف حسابك؟';

  @override
  String get deleteAccountWarning =>
      'هذا الإجراء نهائي ولا يمكن التراجع عنه. سيتم حذف جميع بياناتك ومقاطع الفيديو وتقدمك بشكل دائم.';

  @override
  String get deleteAccountConfirm => 'نعم، احذف الحساب';

  @override
  String get accountDeleted => 'تم حذف الحساب بنجاح';
}
