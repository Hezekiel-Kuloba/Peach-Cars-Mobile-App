import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_fr.dart';
import 'app_localizations_sw.dart';

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
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

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
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates = <LocalizationsDelegate<dynamic>>[
    delegate,
    GlobalMaterialLocalizations.delegate,
    GlobalCupertinoLocalizations.delegate,
    GlobalWidgetsLocalizations.delegate,
  ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('fr'),
    Locale('sw')
  ];

  /// No description provided for @appName.
  ///
  /// In en, this message translates to:
  /// **'Peach Cars'**
  String get appName;

  /// No description provided for @tagline.
  ///
  /// In en, this message translates to:
  /// **'Find Your Dream Car'**
  String get tagline;

  /// No description provided for @login.
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// No description provided for @register.
  ///
  /// In en, this message translates to:
  /// **'Register'**
  String get register;

  /// No description provided for @signIn.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// No description provided for @signUp.
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// No description provided for @logout.
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @confirmPassword.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// No description provided for @firstName.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get firstName;

  /// No description provided for @lastName.
  ///
  /// In en, this message translates to:
  /// **'Last Name'**
  String get lastName;

  /// No description provided for @username.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get username;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// No description provided for @signInToContinue.
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// No description provided for @createAccount.
  ///
  /// In en, this message translates to:
  /// **'Create an Account'**
  String get createAccount;

  /// No description provided for @alreadyHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// No description provided for @dontHaveAccount.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get emailRequired;

  /// No description provided for @emailInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get emailInvalid;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get passwordRequired;

  /// No description provided for @passwordMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 8 characters'**
  String get passwordMinLength;

  /// No description provided for @passwordsDontMatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDontMatch;

  /// No description provided for @firstNameRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get firstNameRequired;

  /// No description provided for @lastNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Last name is required'**
  String get lastNameRequired;

  /// No description provided for @usernameRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get usernameRequired;

  /// No description provided for @phoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Phone number is required'**
  String get phoneRequired;

  /// No description provided for @phoneInvalid.
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid phone number'**
  String get phoneInvalid;

  /// No description provided for @fullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Full name is required'**
  String get fullNameRequired;

  /// No description provided for @termsRequired.
  ///
  /// In en, this message translates to:
  /// **'You must accept the Terms & Conditions'**
  String get termsRequired;

  /// No description provided for @termsAccept.
  ///
  /// In en, this message translates to:
  /// **'I agree to the Terms & Conditions and Privacy Policy'**
  String get termsAccept;

  /// No description provided for @forgotPassword.
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// No description provided for @rememberMe.
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @wishlist.
  ///
  /// In en, this message translates to:
  /// **'Wishlist'**
  String get wishlist;

  /// No description provided for @buyCar.
  ///
  /// In en, this message translates to:
  /// **'Buy Car'**
  String get buyCar;

  /// No description provided for @sellCar.
  ///
  /// In en, this message translates to:
  /// **'Sell Car'**
  String get sellCar;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @findYourDreamCar.
  ///
  /// In en, this message translates to:
  /// **'Find your dream car'**
  String get findYourDreamCar;

  /// No description provided for @allCars.
  ///
  /// In en, this message translates to:
  /// **'All Cars'**
  String get allCars;

  /// No description provided for @freshImports.
  ///
  /// In en, this message translates to:
  /// **'Fresh Imports'**
  String get freshImports;

  /// No description provided for @locallyUsed.
  ///
  /// In en, this message translates to:
  /// **'Locally Used'**
  String get locallyUsed;

  /// No description provided for @make.
  ///
  /// In en, this message translates to:
  /// **'Make'**
  String get make;

  /// No description provided for @model.
  ///
  /// In en, this message translates to:
  /// **'Model'**
  String get model;

  /// No description provided for @year.
  ///
  /// In en, this message translates to:
  /// **'Year'**
  String get year;

  /// No description provided for @selectMake.
  ///
  /// In en, this message translates to:
  /// **'Select Car Make'**
  String get selectMake;

  /// No description provided for @selectModel.
  ///
  /// In en, this message translates to:
  /// **'Select Model'**
  String get selectModel;

  /// No description provided for @selectYear.
  ///
  /// In en, this message translates to:
  /// **'Select Year'**
  String get selectYear;

  /// No description provided for @pleaseSelectMakeFirst.
  ///
  /// In en, this message translates to:
  /// **'Please select a make first'**
  String get pleaseSelectMakeFirst;

  /// No description provided for @easterDeals.
  ///
  /// In en, this message translates to:
  /// **'Easter Deals'**
  String get easterDeals;

  /// No description provided for @financingAvailable.
  ///
  /// In en, this message translates to:
  /// **'Financing Available'**
  String get financingAvailable;

  /// No description provided for @viewInspectionReport.
  ///
  /// In en, this message translates to:
  /// **'View Inspection Report'**
  String get viewInspectionReport;

  /// No description provided for @freshImport.
  ///
  /// In en, this message translates to:
  /// **'Fresh Import'**
  String get freshImport;

  /// No description provided for @noCarsFound.
  ///
  /// In en, this message translates to:
  /// **'No cars found'**
  String get noCarsFound;

  /// No description provided for @tryAdjustingFilters.
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters'**
  String get tryAdjustingFilters;

  /// No description provided for @sellerVerified.
  ///
  /// In en, this message translates to:
  /// **'Seller verified'**
  String get sellerVerified;

  /// No description provided for @logbookConfirmed.
  ///
  /// In en, this message translates to:
  /// **'Logbook information confirmed'**
  String get logbookConfirmed;

  /// No description provided for @vehicleAvailableOnRequest.
  ///
  /// In en, this message translates to:
  /// **'Vehicle available upon request'**
  String get vehicleAvailableOnRequest;

  /// No description provided for @carIsOffTheYard.
  ///
  /// In en, this message translates to:
  /// **'Car is off the yard'**
  String get carIsOffTheYard;

  /// No description provided for @requestViewing.
  ///
  /// In en, this message translates to:
  /// **'Request Viewing'**
  String get requestViewing;

  /// No description provided for @makeAnEnquiry.
  ///
  /// In en, this message translates to:
  /// **'Make an Enquiry'**
  String get makeAnEnquiry;

  /// No description provided for @basicFeatures.
  ///
  /// In en, this message translates to:
  /// **'Basic Features'**
  String get basicFeatures;

  /// No description provided for @engine.
  ///
  /// In en, this message translates to:
  /// **'Engine'**
  String get engine;

  /// No description provided for @fuel.
  ///
  /// In en, this message translates to:
  /// **'Fuel'**
  String get fuel;

  /// No description provided for @transmission.
  ///
  /// In en, this message translates to:
  /// **'Transmission'**
  String get transmission;

  /// No description provided for @bodyType.
  ///
  /// In en, this message translates to:
  /// **'Body Type'**
  String get bodyType;

  /// No description provided for @drive.
  ///
  /// In en, this message translates to:
  /// **'Drive'**
  String get drive;

  /// No description provided for @yom.
  ///
  /// In en, this message translates to:
  /// **'YOM'**
  String get yom;

  /// No description provided for @usedStatus.
  ///
  /// In en, this message translates to:
  /// **'Used Status'**
  String get usedStatus;

  /// No description provided for @color.
  ///
  /// In en, this message translates to:
  /// **'Color'**
  String get color;

  /// No description provided for @duty.
  ///
  /// In en, this message translates to:
  /// **'Duty'**
  String get duty;

  /// No description provided for @seats.
  ///
  /// In en, this message translates to:
  /// **'Seats'**
  String get seats;

  /// No description provided for @numberOfSeats.
  ///
  /// In en, this message translates to:
  /// **'No. of Seats'**
  String get numberOfSeats;

  /// No description provided for @similarOptions.
  ///
  /// In en, this message translates to:
  /// **'Similar Options'**
  String get similarOptions;

  /// No description provided for @location.
  ///
  /// In en, this message translates to:
  /// **'Location'**
  String get location;

  /// No description provided for @talkToAgent.
  ///
  /// In en, this message translates to:
  /// **'Talk to a customer care agent'**
  String get talkToAgent;

  /// No description provided for @startChat.
  ///
  /// In en, this message translates to:
  /// **'Start Chat'**
  String get startChat;

  /// No description provided for @nearestBranch.
  ///
  /// In en, this message translates to:
  /// **'Nearest Branch'**
  String get nearestBranch;

  /// No description provided for @selectLocation.
  ///
  /// In en, this message translates to:
  /// **'Select Location'**
  String get selectLocation;

  /// No description provided for @interestedInFinancing.
  ///
  /// In en, this message translates to:
  /// **'I\'m interested in car financing'**
  String get interestedInFinancing;

  /// No description provided for @submit.
  ///
  /// In en, this message translates to:
  /// **'Submit'**
  String get submit;

  /// No description provided for @back.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get back;

  /// No description provided for @next.
  ///
  /// In en, this message translates to:
  /// **'Next'**
  String get next;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @requestViewingTitle.
  ///
  /// In en, this message translates to:
  /// **'Request a Viewing'**
  String get requestViewingTitle;

  /// No description provided for @viewingSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Your viewing request has been submitted! Our team will be in touch.'**
  String get viewingSubmitted;

  /// No description provided for @yourWishlist.
  ///
  /// In en, this message translates to:
  /// **'Your Wishlist'**
  String get yourWishlist;

  /// No description provided for @favouriteCars.
  ///
  /// In en, this message translates to:
  /// **'Favourite Cars'**
  String get favouriteCars;

  /// No description provided for @exploreMoreCars.
  ///
  /// In en, this message translates to:
  /// **'Explore more cars'**
  String get exploreMoreCars;

  /// No description provided for @findMoreCars.
  ///
  /// In en, this message translates to:
  /// **'Find More Cars to Buy Today'**
  String get findMoreCars;

  /// No description provided for @noWishlistItems.
  ///
  /// In en, this message translates to:
  /// **'Your wishlist is empty'**
  String get noWishlistItems;

  /// No description provided for @addCarsToWishlist.
  ///
  /// In en, this message translates to:
  /// **'Browse cars and tap the heart to save them here'**
  String get addCarsToWishlist;

  /// No description provided for @addedToWishlist.
  ///
  /// In en, this message translates to:
  /// **'Added to Wishlist'**
  String get addedToWishlist;

  /// No description provided for @removedFromWishlist.
  ///
  /// In en, this message translates to:
  /// **'Removed from Wishlist'**
  String get removedFromWishlist;

  /// No description provided for @viewWishlist.
  ///
  /// In en, this message translates to:
  /// **'View Wishlist'**
  String get viewWishlist;

  /// No description provided for @sellYourCar.
  ///
  /// In en, this message translates to:
  /// **'Sell your car'**
  String get sellYourCar;

  /// No description provided for @sellYourCarDesc.
  ///
  /// In en, this message translates to:
  /// **'Selling your car is now easy. We handle everything for you from vetting buyers, test drives, handling payments, logbook transfers, and everything in between. A hassle-free experience guaranteed!'**
  String get sellYourCarDesc;

  /// No description provided for @carDetails.
  ///
  /// In en, this message translates to:
  /// **'Car Details'**
  String get carDetails;

  /// No description provided for @aboutYourCar.
  ///
  /// In en, this message translates to:
  /// **'About your car'**
  String get aboutYourCar;

  /// No description provided for @contactDetails.
  ///
  /// In en, this message translates to:
  /// **'Contact Details'**
  String get contactDetails;

  /// No description provided for @howToReachYou.
  ///
  /// In en, this message translates to:
  /// **'How to reach you'**
  String get howToReachYou;

  /// No description provided for @carRegistration.
  ///
  /// In en, this message translates to:
  /// **'Enter Car Registration'**
  String get carRegistration;

  /// No description provided for @carRegistrationHint.
  ///
  /// In en, this message translates to:
  /// **'Car Registration'**
  String get carRegistrationHint;

  /// No description provided for @mileage.
  ///
  /// In en, this message translates to:
  /// **'Mileage'**
  String get mileage;

  /// No description provided for @enterMileage.
  ///
  /// In en, this message translates to:
  /// **'Enter Mileage'**
  String get enterMileage;

  /// No description provided for @askingPrice.
  ///
  /// In en, this message translates to:
  /// **'Asking Price'**
  String get askingPrice;

  /// No description provided for @enterAskingPrice.
  ///
  /// In en, this message translates to:
  /// **'Enter the asking price'**
  String get enterAskingPrice;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @confirmTerms.
  ///
  /// In en, this message translates to:
  /// **'By continuing, I confirm that I have read, understood, and consented to the Terms & Conditions and Privacy Policy'**
  String get confirmTerms;

  /// No description provided for @sellRequestSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Your sell request has been submitted! Our team will contact you within 24 hours.'**
  String get sellRequestSubmitted;

  /// No description provided for @myProfile.
  ///
  /// In en, this message translates to:
  /// **'My Profile'**
  String get myProfile;

  /// No description provided for @personalDetails.
  ///
  /// In en, this message translates to:
  /// **'Personal Details'**
  String get personalDetails;

  /// No description provided for @editPersonalDetails.
  ///
  /// In en, this message translates to:
  /// **'Edit Personal Details'**
  String get editPersonalDetails;

  /// No description provided for @setPreference.
  ///
  /// In en, this message translates to:
  /// **'Set Preference'**
  String get setPreference;

  /// No description provided for @tailorExperience.
  ///
  /// In en, this message translates to:
  /// **'We\'ve introduced a new way to tailor your experience!'**
  String get tailorExperience;

  /// No description provided for @tailorExperienceDesc.
  ///
  /// In en, this message translates to:
  /// **'Let us know your preferences to help us provide better recommendations.'**
  String get tailorExperienceDesc;

  /// No description provided for @recentlyViewedCars.
  ///
  /// In en, this message translates to:
  /// **'Recently Viewed Cars'**
  String get recentlyViewedCars;

  /// No description provided for @customCarRequests.
  ///
  /// In en, this message translates to:
  /// **'Custom Car Requests'**
  String get customCarRequests;

  /// No description provided for @noCarRequests.
  ///
  /// In en, this message translates to:
  /// **'You don\'t have any car requests yet.'**
  String get noCarRequests;

  /// No description provided for @helpAndSupport.
  ///
  /// In en, this message translates to:
  /// **'Help and Support'**
  String get helpAndSupport;

  /// No description provided for @supportHours.
  ///
  /// In en, this message translates to:
  /// **'Monday to Saturday 9AM — 5PM'**
  String get supportHours;

  /// No description provided for @verifiedCars.
  ///
  /// In en, this message translates to:
  /// **'Verified Cars'**
  String get verifiedCars;

  /// No description provided for @verifiedCarsDesc.
  ///
  /// In en, this message translates to:
  /// **'Cars go through multiple levels of screening and inspection to protect our customers and match their quality expectations.'**
  String get verifiedCarsDesc;

  /// No description provided for @clearProcesses.
  ///
  /// In en, this message translates to:
  /// **'Clear Processes'**
  String get clearProcesses;

  /// No description provided for @clearProcessesDesc.
  ///
  /// In en, this message translates to:
  /// **'Our team takes on the purchasing and ownership process for you, step-by-step.'**
  String get clearProcessesDesc;

  /// No description provided for @teamDiversity.
  ///
  /// In en, this message translates to:
  /// **'Team Diversity'**
  String get teamDiversity;

  /// No description provided for @teamDiversityDesc.
  ///
  /// In en, this message translates to:
  /// **'Peach Cars comprises both locals and expats who are experienced in every level of the car value chain.'**
  String get teamDiversityDesc;

  /// No description provided for @referAFriend.
  ///
  /// In en, this message translates to:
  /// **'Refer a Friend'**
  String get referAFriend;

  /// No description provided for @referAndEarn.
  ///
  /// In en, this message translates to:
  /// **'Refer & Earn'**
  String get referAndEarn;

  /// No description provided for @referEarnAmount.
  ///
  /// In en, this message translates to:
  /// **'KES 10,000'**
  String get referEarnAmount;

  /// No description provided for @referDesc.
  ///
  /// In en, this message translates to:
  /// **'Know someone who is Buying or Selling a car? Refer them to Peach Cars and get KES 10,000 when the deal goes through.'**
  String get referDesc;

  /// No description provided for @yourName.
  ///
  /// In en, this message translates to:
  /// **'Your Name'**
  String get yourName;

  /// No description provided for @yourNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your full name'**
  String get yourNameHint;

  /// No description provided for @yourPhone.
  ///
  /// In en, this message translates to:
  /// **'Your Phone Number'**
  String get yourPhone;

  /// No description provided for @yourPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Your phone number'**
  String get yourPhoneHint;

  /// No description provided for @friendName.
  ///
  /// In en, this message translates to:
  /// **'Friend\'s Name'**
  String get friendName;

  /// No description provided for @friendNameHint.
  ///
  /// In en, this message translates to:
  /// **'Your friend\'s full name'**
  String get friendNameHint;

  /// No description provided for @friendPhone.
  ///
  /// In en, this message translates to:
  /// **'Friend\'s Phone Number'**
  String get friendPhone;

  /// No description provided for @friendPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'Your friend\'s phone number'**
  String get friendPhoneHint;

  /// No description provided for @friendLocation.
  ///
  /// In en, this message translates to:
  /// **'Your Friend\'s Location'**
  String get friendLocation;

  /// No description provided for @isFriendBuyingOrSelling.
  ///
  /// In en, this message translates to:
  /// **'Is your friend buying or selling?'**
  String get isFriendBuyingOrSelling;

  /// No description provided for @selling.
  ///
  /// In en, this message translates to:
  /// **'Selling'**
  String get selling;

  /// No description provided for @buying.
  ///
  /// In en, this message translates to:
  /// **'Buying'**
  String get buying;

  /// No description provided for @both.
  ///
  /// In en, this message translates to:
  /// **'Both'**
  String get both;

  /// No description provided for @referralSubmitted.
  ///
  /// In en, this message translates to:
  /// **'Referral submitted! Thank you.'**
  String get referralSubmitted;

  /// No description provided for @peachProcesses.
  ///
  /// In en, this message translates to:
  /// **'Peach Processes'**
  String get peachProcesses;

  /// No description provided for @buyingACar.
  ///
  /// In en, this message translates to:
  /// **'Buying a Car'**
  String get buyingACar;

  /// No description provided for @sellingACar.
  ///
  /// In en, this message translates to:
  /// **'Selling a Car'**
  String get sellingACar;

  /// No description provided for @carFinancing.
  ///
  /// In en, this message translates to:
  /// **'Car Financing'**
  String get carFinancing;

  /// No description provided for @settings.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// No description provided for @darkMode.
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// No description provided for @language.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @french.
  ///
  /// In en, this message translates to:
  /// **'Français'**
  String get french;

  /// No description provided for @swahili.
  ///
  /// In en, this message translates to:
  /// **'Kiswahili'**
  String get swahili;

  /// No description provided for @theme.
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// No description provided for @lightTheme.
  ///
  /// In en, this message translates to:
  /// **'Light'**
  String get lightTheme;

  /// No description provided for @darkTheme.
  ///
  /// In en, this message translates to:
  /// **'Dark'**
  String get darkTheme;

  /// No description provided for @systemTheme.
  ///
  /// In en, this message translates to:
  /// **'System'**
  String get systemTheme;

  /// No description provided for @welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Peach Cars'**
  String get welcome;

  /// No description provided for @welcomeDesc.
  ///
  /// In en, this message translates to:
  /// **'Buy and sell cars the easy, convenient and secure way.'**
  String get welcomeDesc;

  /// No description provided for @slide2Title.
  ///
  /// In en, this message translates to:
  /// **'Verified Cars Only'**
  String get slide2Title;

  /// No description provided for @slide2Desc.
  ///
  /// In en, this message translates to:
  /// **'Every car goes through a 288-point inspection so you buy with confidence.'**
  String get slide2Desc;

  /// No description provided for @slide3Title.
  ///
  /// In en, this message translates to:
  /// **'Hassle-Free Selling'**
  String get slide3Title;

  /// No description provided for @slide3Desc.
  ///
  /// In en, this message translates to:
  /// **'We handle everything — viewings, payments, logbook transfers. Just sit back.'**
  String get slide3Desc;

  /// No description provided for @skip.
  ///
  /// In en, this message translates to:
  /// **'Skip'**
  String get skip;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @error.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// No description provided for @success.
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// No description provided for @ok.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get ok;

  /// No description provided for @loading.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get somethingWentWrong;

  /// No description provided for @noInternetConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// No description provided for @loginSuccess.
  ///
  /// In en, this message translates to:
  /// **'Login successful. Welcome back!'**
  String get loginSuccess;

  /// No description provided for @registerSuccess.
  ///
  /// In en, this message translates to:
  /// **'Account created successfully!'**
  String get registerSuccess;

  /// No description provided for @invalidCredentials.
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password'**
  String get invalidCredentials;

  /// No description provided for @emailAlreadyRegistered.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered'**
  String get emailAlreadyRegistered;

  /// No description provided for @callUs.
  ///
  /// In en, this message translates to:
  /// **'Call: 0709 726900'**
  String get callUs;

  /// No description provided for @peachCarsPhone.
  ///
  /// In en, this message translates to:
  /// **'0709726900'**
  String get peachCarsPhone;

  /// No description provided for @shareLocation.
  ///
  /// In en, this message translates to:
  /// **'Share Location'**
  String get shareLocation;

  /// No description provided for @makeEnquiry.
  ///
  /// In en, this message translates to:
  /// **'Make an Enquiry'**
  String get makeEnquiry;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en', 'fr', 'sw'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {


  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en': return AppLocalizationsEn();
    case 'fr': return AppLocalizationsFr();
    case 'sw': return AppLocalizationsSw();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.'
  );
}
