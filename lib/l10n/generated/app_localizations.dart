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
/// import 'generated/app_localizations.dart';
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

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
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
  /// **'Al-Mohamedia Compound'**
  String get appTitle;

  /// No description provided for @compoundName.
  ///
  /// In en, this message translates to:
  /// **'Al-Mohamedia Compound'**
  String get compoundName;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @switchLanguage.
  ///
  /// In en, this message translates to:
  /// **'Switch Language'**
  String get switchLanguage;

  /// No description provided for @languageToggleLabel.
  ///
  /// In en, this message translates to:
  /// **'عربي'**
  String get languageToggleLabel;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @emailAddress.
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// No description provided for @emailHint.
  ///
  /// In en, this message translates to:
  /// **'name@compound.demo'**
  String get emailHint;

  /// No description provided for @emailRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get emailRequired;

  /// No description provided for @password.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// No description provided for @passwordRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get passwordRequired;

  /// No description provided for @signInToResidence.
  ///
  /// In en, this message translates to:
  /// **'Sign In to Residence'**
  String get signInToResidence;

  /// No description provided for @quickDemoIdentities.
  ///
  /// In en, this message translates to:
  /// **'Quick Demo Identities (9 Roles)'**
  String get quickDemoIdentities;

  /// No description provided for @instantDemoAccess.
  ///
  /// In en, this message translates to:
  /// **'Instant Demo Access'**
  String get instantDemoAccess;

  /// No description provided for @instantDemoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Select any predefined role below to test its dedicated dashboard immediately.'**
  String get instantDemoSubtitle;

  /// No description provided for @residentIdentities.
  ///
  /// In en, this message translates to:
  /// **'RESIDENT IDENTITIES'**
  String get residentIdentities;

  /// No description provided for @departmentEmployeeIdentities.
  ///
  /// In en, this message translates to:
  /// **'DEPARTMENT & EMPLOYEE IDENTITIES'**
  String get departmentEmployeeIdentities;

  /// No description provided for @residentFallbackName.
  ///
  /// In en, this message translates to:
  /// **'Resident'**
  String get residentFallbackName;

  /// No description provided for @ownerBadge.
  ///
  /// In en, this message translates to:
  /// **'OWNER'**
  String get ownerBadge;

  /// No description provided for @tenantBadge.
  ///
  /// In en, this message translates to:
  /// **'TENANT'**
  String get tenantBadge;

  /// No description provided for @unitAuthorizedResidence.
  ///
  /// In en, this message translates to:
  /// **'Unit {unit} • Authorized Residence'**
  String unitAuthorizedResidence(String unit);

  /// No description provided for @residentServices.
  ///
  /// In en, this message translates to:
  /// **'Resident Services'**
  String get residentServices;

  /// No description provided for @visitorPass.
  ///
  /// In en, this message translates to:
  /// **'Visitor Pass'**
  String get visitorPass;

  /// No description provided for @visitorPassSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Expected guests & QR'**
  String get visitorPassSubtitle;

  /// No description provided for @maintenance.
  ///
  /// In en, this message translates to:
  /// **'Maintenance'**
  String get maintenance;

  /// No description provided for @maintenanceSubtitle.
  ///
  /// In en, this message translates to:
  /// **'AC, plumbing & repairs'**
  String get maintenanceSubtitle;

  /// No description provided for @recreation.
  ///
  /// In en, this message translates to:
  /// **'Recreation'**
  String get recreation;

  /// No description provided for @recreationSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Padel, gym & pool'**
  String get recreationSubtitle;

  /// No description provided for @housekeeping.
  ///
  /// In en, this message translates to:
  /// **'Housekeeping'**
  String get housekeeping;

  /// No description provided for @housekeepingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Book certified cleaning'**
  String get housekeepingSubtitle;

  /// No description provided for @activeRequests.
  ///
  /// In en, this message translates to:
  /// **'Active Requests'**
  String get activeRequests;

  /// No description provided for @newRequest.
  ///
  /// In en, this message translates to:
  /// **'New Request'**
  String get newRequest;

  /// No description provided for @noActiveRequests.
  ///
  /// In en, this message translates to:
  /// **'No active service requests right now.'**
  String get noActiveRequests;

  /// No description provided for @maintenanceWorkOrders.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Work Orders'**
  String get maintenanceWorkOrders;

  /// No description provided for @maintenanceLeadFallback.
  ///
  /// In en, this message translates to:
  /// **'Maintenance Lead'**
  String get maintenanceLeadFallback;

  /// No description provided for @maintenanceOperationsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Technical Operations • 4 Technicians on Duty'**
  String get maintenanceOperationsSubtitle;

  /// No description provided for @metricNew.
  ///
  /// In en, this message translates to:
  /// **'New'**
  String get metricNew;

  /// No description provided for @metricAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get metricAssigned;

  /// No description provided for @metricInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get metricInProgress;

  /// No description provided for @metricCompleted.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get metricCompleted;

  /// No description provided for @filterAll.
  ///
  /// In en, this message translates to:
  /// **'All ({count})'**
  String filterAll(int count);

  /// No description provided for @filterAc.
  ///
  /// In en, this message translates to:
  /// **'AC ❄️'**
  String get filterAc;

  /// No description provided for @filterPlumbing.
  ///
  /// In en, this message translates to:
  /// **'Plumbing 🚿'**
  String get filterPlumbing;

  /// No description provided for @filterElectrical.
  ///
  /// In en, this message translates to:
  /// **'Electrical ⚡'**
  String get filterElectrical;

  /// No description provided for @workOrdersCount.
  ///
  /// In en, this message translates to:
  /// **'Work Orders ({count})'**
  String workOrdersCount(int count);

  /// No description provided for @noWorkOrdersFilter.
  ///
  /// In en, this message translates to:
  /// **'No work orders matching this filter.'**
  String get noWorkOrdersFilter;

  /// No description provided for @unitLabel.
  ///
  /// In en, this message translates to:
  /// **'Unit'**
  String get unitLabel;

  /// No description provided for @unitWithNumber.
  ///
  /// In en, this message translates to:
  /// **'Unit {unit}'**
  String unitWithNumber(String unit);

  /// No description provided for @unassigned.
  ///
  /// In en, this message translates to:
  /// **'Unassigned'**
  String get unassigned;

  /// No description provided for @manageAndChat.
  ///
  /// In en, this message translates to:
  /// **'Manage & Chat'**
  String get manageAndChat;

  /// No description provided for @newMaintenanceRequest.
  ///
  /// In en, this message translates to:
  /// **'New Maintenance Request'**
  String get newMaintenanceRequest;

  /// No description provided for @selectCategory.
  ///
  /// In en, this message translates to:
  /// **'Select Category'**
  String get selectCategory;

  /// No description provided for @problemTitle.
  ///
  /// In en, this message translates to:
  /// **'Problem Title'**
  String get problemTitle;

  /// No description provided for @problemTitleHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Master Bedroom AC Blowing Warm Air'**
  String get problemTitleHint;

  /// No description provided for @problemTitleRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get problemTitleRequired;

  /// No description provided for @detailedDescription.
  ///
  /// In en, this message translates to:
  /// **'Detailed Description'**
  String get detailedDescription;

  /// No description provided for @detailedDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the issue, location in the unit, and any sounds or leakages...'**
  String get detailedDescriptionHint;

  /// No description provided for @detailedDescriptionRequired.
  ///
  /// In en, this message translates to:
  /// **'Please describe the problem'**
  String get detailedDescriptionRequired;

  /// No description provided for @urgencyPriority.
  ///
  /// In en, this message translates to:
  /// **'Urgency / Priority'**
  String get urgencyPriority;

  /// No description provided for @preferredAppointmentSlot.
  ///
  /// In en, this message translates to:
  /// **'Preferred Appointment Slot'**
  String get preferredAppointmentSlot;

  /// No description provided for @tomorrowDate.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow ({date})'**
  String tomorrowDate(String date);

  /// No description provided for @submitRequestToMaintenance.
  ///
  /// In en, this message translates to:
  /// **'Submit Request to Maintenance'**
  String get submitRequestToMaintenance;

  /// No description provided for @assignTechnician.
  ///
  /// In en, this message translates to:
  /// **'Assign Technician'**
  String get assignTechnician;

  /// No description provided for @techMahmoud.
  ///
  /// In en, this message translates to:
  /// **'Technician Mahmoud (HVAC & AC)'**
  String get techMahmoud;

  /// No description provided for @techSalem.
  ///
  /// In en, this message translates to:
  /// **'Technician Salem (Plumbing)'**
  String get techSalem;

  /// No description provided for @techHassan.
  ///
  /// In en, this message translates to:
  /// **'Eng. Hassan Al-Najjar (Maintenance Lead)'**
  String get techHassan;

  /// No description provided for @rateCompletedService.
  ///
  /// In en, this message translates to:
  /// **'Rate Completed Service'**
  String get rateCompletedService;

  /// No description provided for @rateQuestion.
  ///
  /// In en, this message translates to:
  /// **'How satisfied are you with this maintenance repair?'**
  String get rateQuestion;

  /// No description provided for @feedbackHint.
  ///
  /// In en, this message translates to:
  /// **'Add feedback or notes (optional)...'**
  String get feedbackHint;

  /// No description provided for @submitRating.
  ///
  /// In en, this message translates to:
  /// **'Submit Rating'**
  String get submitRating;

  /// No description provided for @updateStatus.
  ///
  /// In en, this message translates to:
  /// **'Update Status'**
  String get updateStatus;

  /// No description provided for @setUnderReview.
  ///
  /// In en, this message translates to:
  /// **'Set: Under Review'**
  String get setUnderReview;

  /// No description provided for @setInProgress.
  ///
  /// In en, this message translates to:
  /// **'Set: In Progress'**
  String get setInProgress;

  /// No description provided for @setCompleted.
  ///
  /// In en, this message translates to:
  /// **'Set: Completed'**
  String get setCompleted;

  /// No description provided for @appointmentLabel.
  ///
  /// In en, this message translates to:
  /// **'Appointment'**
  String get appointmentLabel;

  /// No description provided for @priorityLabel.
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priorityLabel;

  /// No description provided for @assignedPrefix.
  ///
  /// In en, this message translates to:
  /// **'Assigned: {name}'**
  String assignedPrefix(String name);

  /// No description provided for @markComplete.
  ///
  /// In en, this message translates to:
  /// **'Mark Complete'**
  String get markComplete;

  /// No description provided for @residentFeedback.
  ///
  /// In en, this message translates to:
  /// **'Resident Feedback'**
  String get residentFeedback;

  /// No description provided for @serviceCompletedTitle.
  ///
  /// In en, this message translates to:
  /// **'Service Completed!'**
  String get serviceCompletedTitle;

  /// No description provided for @rateYourExperience.
  ///
  /// In en, this message translates to:
  /// **'Rate your experience with our team'**
  String get rateYourExperience;

  /// No description provided for @rateButton.
  ///
  /// In en, this message translates to:
  /// **'Rate (1-5 ⭐)'**
  String get rateButton;

  /// No description provided for @requestUpdatesAndChat.
  ///
  /// In en, this message translates to:
  /// **'Request Updates & Chat ({count})'**
  String requestUpdatesAndChat(int count);

  /// No description provided for @noCommentsYet.
  ///
  /// In en, this message translates to:
  /// **'No comments yet. Send a message below to communicate directly.'**
  String get noCommentsYet;

  /// No description provided for @typeUpdateOrQuestion.
  ///
  /// In en, this message translates to:
  /// **'Type an update or question...'**
  String get typeUpdateOrQuestion;

  /// No description provided for @stepPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get stepPending;

  /// No description provided for @stepReview.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get stepReview;

  /// No description provided for @stepAssigned.
  ///
  /// In en, this message translates to:
  /// **'Assigned'**
  String get stepAssigned;

  /// No description provided for @stepInProgress.
  ///
  /// In en, this message translates to:
  /// **'In Progress'**
  String get stepInProgress;

  /// No description provided for @stepDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get stepDone;

  /// No description provided for @securityGateOperations.
  ///
  /// In en, this message translates to:
  /// **'Security & Gate Operations'**
  String get securityGateOperations;

  /// No description provided for @officerOnDuty.
  ///
  /// In en, this message translates to:
  /// **'Officer on Duty'**
  String get officerOnDuty;

  /// No description provided for @gateShiftActive.
  ///
  /// In en, this message translates to:
  /// **'Gate 1 (Main Entrance) • Shift Active'**
  String get gateShiftActive;

  /// No description provided for @expectedToday.
  ///
  /// In en, this message translates to:
  /// **'Expected Today'**
  String get expectedToday;

  /// No description provided for @checkedIn.
  ///
  /// In en, this message translates to:
  /// **'Checked In'**
  String get checkedIn;

  /// No description provided for @onCompound.
  ///
  /// In en, this message translates to:
  /// **'On Compound'**
  String get onCompound;

  /// No description provided for @searchPlateOrVisitor.
  ///
  /// In en, this message translates to:
  /// **'Search Vehicle Plate or Visitor Name...'**
  String get searchPlateOrVisitor;

  /// No description provided for @expectedVisitors.
  ///
  /// In en, this message translates to:
  /// **'Expected Visitors'**
  String get expectedVisitors;

  /// No description provided for @hostPrefix.
  ///
  /// In en, this message translates to:
  /// **'Host: {unit}'**
  String hostPrefix(String unit);

  /// No description provided for @statusExpected.
  ///
  /// In en, this message translates to:
  /// **'Expected'**
  String get statusExpected;

  /// No description provided for @checkIn.
  ///
  /// In en, this message translates to:
  /// **'Check In'**
  String get checkIn;

  /// No description provided for @todaySuffix.
  ///
  /// In en, this message translates to:
  /// **'(Today)'**
  String get todaySuffix;

  /// No description provided for @checkOut.
  ///
  /// In en, this message translates to:
  /// **'Check Out'**
  String get checkOut;

  /// No description provided for @denyEntry.
  ///
  /// In en, this message translates to:
  /// **'Deny'**
  String get denyEntry;

  /// No description provided for @denyVisitorTitle.
  ///
  /// In en, this message translates to:
  /// **'Deny Visitor Entry'**
  String get denyVisitorTitle;

  /// No description provided for @denyReasonHint.
  ///
  /// In en, this message translates to:
  /// **'Enter reason for denying entry (e.g. Unverified ID)...'**
  String get denyReasonHint;

  /// No description provided for @confirmDeny.
  ///
  /// In en, this message translates to:
  /// **'Confirm Denial'**
  String get confirmDeny;

  /// No description provided for @currentlyOnCompound.
  ///
  /// In en, this message translates to:
  /// **'Currently on Compound'**
  String get currentlyOnCompound;

  /// No description provided for @recentGateActivity.
  ///
  /// In en, this message translates to:
  /// **'Gate History'**
  String get recentGateActivity;

  /// No description provided for @noExpectedVisitors.
  ///
  /// In en, this message translates to:
  /// **'No expected visitors matching your search.'**
  String get noExpectedVisitors;

  /// No description provided for @noVisitorsOnCompound.
  ///
  /// In en, this message translates to:
  /// **'No visitors currently checked in on the compound.'**
  String get noVisitorsOnCompound;

  /// No description provided for @walkInPedestrian.
  ///
  /// In en, this message translates to:
  /// **'Walk-in / No Vehicle'**
  String get walkInPedestrian;

  /// No description provided for @passCodeLabel.
  ///
  /// In en, this message translates to:
  /// **'Pass Code'**
  String get passCodeLabel;

  /// No description provided for @verifyQrCodeTitle.
  ///
  /// In en, this message translates to:
  /// **'Verify Visitor Pass Code'**
  String get verifyQrCodeTitle;

  /// No description provided for @verifyQrCodeHint.
  ///
  /// In en, this message translates to:
  /// **'Enter pass code (e.g. VP-4823) or vehicle plate...'**
  String get verifyQrCodeHint;

  /// No description provided for @verifyButton.
  ///
  /// In en, this message translates to:
  /// **'Search / Verify'**
  String get verifyButton;

  /// No description provided for @myVisitorPasses.
  ///
  /// In en, this message translates to:
  /// **'My Visitor Passes'**
  String get myVisitorPasses;

  /// No description provided for @createVisitorPassTitle.
  ///
  /// In en, this message translates to:
  /// **'Create Visitor Pass'**
  String get createVisitorPassTitle;

  /// No description provided for @newVisitorPass.
  ///
  /// In en, this message translates to:
  /// **'New Visitor Pass'**
  String get newVisitorPass;

  /// No description provided for @noVisitorPassesYet.
  ///
  /// In en, this message translates to:
  /// **'No visitor passes created yet. Tap + to invite a guest.'**
  String get noVisitorPassesYet;

  /// No description provided for @visitorFullName.
  ///
  /// In en, this message translates to:
  /// **'Visitor Full Name'**
  String get visitorFullName;

  /// No description provided for @visitorFullNameHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Khalid Al-Ghamdi'**
  String get visitorFullNameHint;

  /// No description provided for @visitorFullNameRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the visitor\'s name'**
  String get visitorFullNameRequired;

  /// No description provided for @visitorPhone.
  ///
  /// In en, this message translates to:
  /// **'Visitor Phone Number'**
  String get visitorPhone;

  /// No description provided for @visitorPhoneHint.
  ///
  /// In en, this message translates to:
  /// **'+966 5X XXX XXXX'**
  String get visitorPhoneHint;

  /// No description provided for @visitorPhoneRequired.
  ///
  /// In en, this message translates to:
  /// **'Please enter the visitor\'s phone number'**
  String get visitorPhoneRequired;

  /// No description provided for @visitDateLabel.
  ///
  /// In en, this message translates to:
  /// **'Visit Date'**
  String get visitDateLabel;

  /// No description provided for @expectedArrivalTimeLabel.
  ///
  /// In en, this message translates to:
  /// **'Expected Arrival Time'**
  String get expectedArrivalTimeLabel;

  /// No description provided for @vehiclePlateOptional.
  ///
  /// In en, this message translates to:
  /// **'Vehicle Plate Number (Optional)'**
  String get vehiclePlateOptional;

  /// No description provided for @vehiclePlateHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. ABC 4567'**
  String get vehiclePlateHint;

  /// No description provided for @securityNotesOptional.
  ///
  /// In en, this message translates to:
  /// **'Notes for Gate Security (Optional)'**
  String get securityNotesOptional;

  /// No description provided for @securityNotesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Delivery driver, family guest...'**
  String get securityNotesHint;

  /// No description provided for @generateQrPass.
  ///
  /// In en, this message translates to:
  /// **'Generate Visitor QR Pass'**
  String get generateQrPass;

  /// No description provided for @digitalGatePass.
  ///
  /// In en, this message translates to:
  /// **'DIGITAL GATE PASS'**
  String get digitalGatePass;

  /// No description provided for @showQrAtGate.
  ///
  /// In en, this message translates to:
  /// **'Present this QR pass at Al-Mohamedia Compound Main Gate'**
  String get showQrAtGate;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @checkedInAt.
  ///
  /// In en, this message translates to:
  /// **'Checked in at {time}'**
  String checkedInAt(String time);

  /// No description provided for @checkedOutAt.
  ///
  /// In en, this message translates to:
  /// **'Checked out at {time}'**
  String checkedOutAt(String time);

  /// No description provided for @bookFacilityTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Recreation Facility'**
  String get bookFacilityTitle;

  /// No description provided for @selectFacilityLabel.
  ///
  /// In en, this message translates to:
  /// **'Select Facility'**
  String get selectFacilityLabel;

  /// No description provided for @selectDateAndSlot.
  ///
  /// In en, this message translates to:
  /// **'Select Date & Time Slot'**
  String get selectDateAndSlot;

  /// No description provided for @durationHoursLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationHoursLabel;

  /// No description provided for @hoursCount.
  ///
  /// In en, this message translates to:
  /// **'{count} hr(s)'**
  String hoursCount(int count);

  /// No description provided for @totalRateLabel.
  ///
  /// In en, this message translates to:
  /// **'Total Reservation Fee'**
  String get totalRateLabel;

  /// No description provided for @confirmFacilityBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Facility Reservation'**
  String get confirmFacilityBooking;

  /// No description provided for @myFacilityBookings.
  ///
  /// In en, this message translates to:
  /// **'My Facility Reservations'**
  String get myFacilityBookings;

  /// No description provided for @noFacilityBookingsYet.
  ///
  /// In en, this message translates to:
  /// **'No facility reservations yet. Select a facility above to book.'**
  String get noFacilityBookingsYet;

  /// No description provided for @bookHousekeepingTitle.
  ///
  /// In en, this message translates to:
  /// **'Book Housekeeping Service'**
  String get bookHousekeepingTitle;

  /// No description provided for @selectCleaningPackage.
  ///
  /// In en, this message translates to:
  /// **'Select Cleaning Package'**
  String get selectCleaningPackage;

  /// No description provided for @selectDurationAndRate.
  ///
  /// In en, this message translates to:
  /// **'Duration & Rate Calculator'**
  String get selectDurationAndRate;

  /// No description provided for @specialCleaningNotes.
  ///
  /// In en, this message translates to:
  /// **'Special Cleaning Instructions (Optional)'**
  String get specialCleaningNotes;

  /// No description provided for @specialCleaningNotesHint.
  ///
  /// In en, this message translates to:
  /// **'e.g. Focus on terrace glass, bring eco-friendly detergent...'**
  String get specialCleaningNotesHint;

  /// No description provided for @confirmHousekeepingBooking.
  ///
  /// In en, this message translates to:
  /// **'Confirm Housekeeping Booking'**
  String get confirmHousekeepingBooking;

  /// No description provided for @myHousekeepingBookings.
  ///
  /// In en, this message translates to:
  /// **'My Cleaning Appointments'**
  String get myHousekeepingBookings;

  /// No description provided for @noHousekeepingBookingsYet.
  ///
  /// In en, this message translates to:
  /// **'No housekeeping appointments booked yet.'**
  String get noHousekeepingBookingsYet;

  /// No description provided for @cancelBooking.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelBooking;

  /// No description provided for @confirmBookingAction.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirmBookingAction;

  /// No description provided for @assignCleaningTeamTitle.
  ///
  /// In en, this message translates to:
  /// **'Dispatch Cleaning Staff'**
  String get assignCleaningTeamTitle;

  /// No description provided for @teamFatimaSunita.
  ///
  /// In en, this message translates to:
  /// **'Team A: Fatima & Sunita (Deep Villa Specialists)'**
  String get teamFatimaSunita;

  /// No description provided for @teamMariaElena.
  ///
  /// In en, this message translates to:
  /// **'Team B: Maria & Elena (Standard Residence)'**
  String get teamMariaElena;

  /// No description provided for @teamAminaGrace.
  ///
  /// In en, this message translates to:
  /// **'Team C: Amina & Grace (Express Hospitality)'**
  String get teamAminaGrace;

  /// No description provided for @noFacilityBookingsStaff.
  ///
  /// In en, this message translates to:
  /// **'No facility bookings in Cloud Firestore yet.'**
  String get noFacilityBookingsStaff;

  /// No description provided for @noHousekeepingBookingsStaff.
  ///
  /// In en, this message translates to:
  /// **'No housekeeping appointments in Cloud Firestore yet.'**
  String get noHousekeepingBookingsStaff;

  /// No description provided for @totalBookingsMetric.
  ///
  /// In en, this message translates to:
  /// **'Total'**
  String get totalBookingsMetric;

  /// No description provided for @confirmedMetric.
  ///
  /// In en, this message translates to:
  /// **'Confirmed'**
  String get confirmedMetric;

  /// No description provided for @completedMetric.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completedMetric;

  /// No description provided for @ratePerHour.
  ///
  /// In en, this message translates to:
  /// **'{amount} SAR/hr'**
  String ratePerHour(int amount);

  /// No description provided for @itSupportTile.
  ///
  /// In en, this message translates to:
  /// **'IT Support'**
  String get itSupportTile;

  /// No description provided for @itSupportTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fiber, intercom & smart home'**
  String get itSupportTileSubtitle;

  /// No description provided for @managementTile.
  ///
  /// In en, this message translates to:
  /// **'Management'**
  String get managementTile;

  /// No description provided for @managementTileSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Complaints & direct inquiries'**
  String get managementTileSubtitle;

  /// No description provided for @newItSupportTicket.
  ///
  /// In en, this message translates to:
  /// **'New IT Support Ticket'**
  String get newItSupportTicket;

  /// No description provided for @newManagementComplaint.
  ///
  /// In en, this message translates to:
  /// **'Direct Management Complaint'**
  String get newManagementComplaint;

  /// No description provided for @submitToItSupport.
  ///
  /// In en, this message translates to:
  /// **'Submit Ticket to IT Support'**
  String get submitToItSupport;

  /// No description provided for @submitToManagement.
  ///
  /// In en, this message translates to:
  /// **'Submit to Compound Management'**
  String get submitToManagement;

  /// No description provided for @noItTicketsYet.
  ///
  /// In en, this message translates to:
  /// **'No IT support tickets matching this filter.'**
  String get noItTicketsYet;

  /// No description provided for @noAdminComplaintsYet.
  ///
  /// In en, this message translates to:
  /// **'No complaints or requests found.'**
  String get noAdminComplaintsYet;

  /// No description provided for @adminFilterComplaints.
  ///
  /// In en, this message translates to:
  /// **'Direct Complaints ({count})'**
  String adminFilterComplaints(int count);

  /// No description provided for @adminFilterAllCompound.
  ///
  /// In en, this message translates to:
  /// **'All Departments ({count})'**
  String adminFilterAllCompound(int count);

  /// No description provided for @assignSpecialist.
  ///
  /// In en, this message translates to:
  /// **'Assign Specialist'**
  String get assignSpecialist;

  /// No description provided for @itSpecOmar.
  ///
  /// In en, this message translates to:
  /// **'Omar Al-Ghamdi (Senior Network & Fiber)'**
  String get itSpecOmar;

  /// No description provided for @itSpecTariq.
  ///
  /// In en, this message translates to:
  /// **'Tariq Al-Harbi (Smart Access & Intercom)'**
  String get itSpecTariq;

  /// No description provided for @adminMgrLaila.
  ///
  /// In en, this message translates to:
  /// **'Laila Al-Qahtani (Compound Director)'**
  String get adminMgrLaila;

  /// No description provided for @adminMgrKhalid.
  ///
  /// In en, this message translates to:
  /// **'Khalid Al-Dosari (Resident Relations)'**
  String get adminMgrKhalid;

  /// No description provided for @housekeepingAndCleaning.
  ///
  /// In en, this message translates to:
  /// **'Housekeeping & Cleaning'**
  String get housekeepingAndCleaning;

  /// No description provided for @housekeepingSupervisorFallback.
  ///
  /// In en, this message translates to:
  /// **'Housekeeping Supervisor'**
  String get housekeepingSupervisorFallback;

  /// No description provided for @housekeepingRateSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Standard Rate: 100 SAR/hr • 6 Cleaning Staff Active'**
  String get housekeepingRateSubtitle;

  /// No description provided for @todaysCleaningAppointments.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Cleaning Appointments'**
  String get todaysCleaningAppointments;

  /// No description provided for @deepVillaCleaning.
  ///
  /// In en, this message translates to:
  /// **'Deep Villa Cleaning'**
  String get deepVillaCleaning;

  /// No description provided for @standardApartmentCleaning.
  ///
  /// In en, this message translates to:
  /// **'Standard Apartment Cleaning'**
  String get standardApartmentCleaning;

  /// No description provided for @hoursAndSar.
  ///
  /// In en, this message translates to:
  /// **'{hours} Hours • {amount} SAR'**
  String hoursAndSar(int hours, int amount);

  /// No description provided for @staffUnassigned.
  ///
  /// In en, this message translates to:
  /// **'Staff Unassigned'**
  String get staffUnassigned;

  /// No description provided for @statusConfirmed.
  ///
  /// In en, this message translates to:
  /// **'CONFIRMED'**
  String get statusConfirmed;

  /// No description provided for @statusScheduled.
  ///
  /// In en, this message translates to:
  /// **'SCHEDULED'**
  String get statusScheduled;

  /// No description provided for @dispatch.
  ///
  /// In en, this message translates to:
  /// **'Dispatch'**
  String get dispatch;

  /// No description provided for @recreationAndFacilities.
  ///
  /// In en, this message translates to:
  /// **'Recreation & Facilities'**
  String get recreationAndFacilities;

  /// No description provided for @recreationManagerFallback.
  ///
  /// In en, this message translates to:
  /// **'Recreation Manager'**
  String get recreationManagerFallback;

  /// No description provided for @clubhouseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Clubhouse, Gym & 2 Padel Courts Active'**
  String get clubhouseSubtitle;

  /// No description provided for @facilityBookingsToday.
  ///
  /// In en, this message translates to:
  /// **'Facility Bookings Today'**
  String get facilityBookingsToday;

  /// No description provided for @padelCourt1.
  ///
  /// In en, this message translates to:
  /// **'Padel Court 1 (Glass Court)'**
  String get padelCourt1;

  /// No description provided for @olympicSwimmingPool.
  ///
  /// In en, this message translates to:
  /// **'Olympic Swimming Pool'**
  String get olympicSwimmingPool;

  /// No description provided for @complimentary.
  ///
  /// In en, this message translates to:
  /// **'Complimentary'**
  String get complimentary;

  /// No description provided for @slotPrefix.
  ///
  /// In en, this message translates to:
  /// **'Slot: {time}'**
  String slotPrefix(String time);

  /// No description provided for @sarAmount.
  ///
  /// In en, this message translates to:
  /// **'{amount} SAR'**
  String sarAmount(int amount);

  /// No description provided for @itSmartSupport.
  ///
  /// In en, this message translates to:
  /// **'IT & Smart Compound Support'**
  String get itSmartSupport;

  /// No description provided for @itSupportFallback.
  ///
  /// In en, this message translates to:
  /// **'IT Support Specialist'**
  String get itSupportFallback;

  /// No description provided for @fiberNetworkSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Fiber Network & Smart Access Systems'**
  String get fiberNetworkSubtitle;

  /// No description provided for @activeTechnicalTickets.
  ///
  /// In en, this message translates to:
  /// **'Active Technical Tickets'**
  String get activeTechnicalTickets;

  /// No description provided for @smartIntercomOffline.
  ///
  /// In en, this message translates to:
  /// **'Smart Intercom Connection Offline'**
  String get smartIntercomOffline;

  /// No description provided for @fiberSpeedDegradation.
  ///
  /// In en, this message translates to:
  /// **'Fiber Internet Speed Degradation'**
  String get fiberSpeedDegradation;

  /// No description provided for @statusInvestigating.
  ///
  /// In en, this message translates to:
  /// **'INVESTIGATING'**
  String get statusInvestigating;

  /// No description provided for @statusQueued.
  ///
  /// In en, this message translates to:
  /// **'QUEUED'**
  String get statusQueued;

  /// No description provided for @compoundAdministration.
  ///
  /// In en, this message translates to:
  /// **'Compound Administration'**
  String get compoundAdministration;

  /// No description provided for @administratorFallback.
  ///
  /// In en, this message translates to:
  /// **'Administrator'**
  String get administratorFallback;

  /// No description provided for @executiveOpsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Executive Operations & Resident Complaints'**
  String get executiveOpsSubtitle;

  /// No description provided for @totalUnits.
  ///
  /// In en, this message translates to:
  /// **'Total Units'**
  String get totalUnits;

  /// No description provided for @occupancy.
  ///
  /// In en, this message translates to:
  /// **'Occupancy'**
  String get occupancy;

  /// No description provided for @openRequests.
  ///
  /// In en, this message translates to:
  /// **'Open Requests'**
  String get openRequests;

  /// No description provided for @escalatedComplaints.
  ///
  /// In en, this message translates to:
  /// **'Escalated Complaints & Direct Requests'**
  String get escalatedComplaints;

  /// No description provided for @visitorGateDelayComplaint.
  ///
  /// In en, this message translates to:
  /// **'Visitor Gate Access Delay Complaint'**
  String get visitorGateDelayComplaint;

  /// No description provided for @hoursAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} hours ago'**
  String hoursAgo(int count);

  /// No description provided for @highPriorityBadge.
  ///
  /// In en, this message translates to:
  /// **'HIGH PRIORITY'**
  String get highPriorityBadge;

  /// No description provided for @underReviewBadge.
  ///
  /// In en, this message translates to:
  /// **'UNDER REVIEW'**
  String get underReviewBadge;

  /// No description provided for @systemAdministration.
  ///
  /// In en, this message translates to:
  /// **'System Administration'**
  String get systemAdministration;

  /// No description provided for @globalSystemOperations.
  ///
  /// In en, this message translates to:
  /// **'Global System Operations'**
  String get globalSystemOperations;

  /// No description provided for @globalSystemSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Compounds, Security Rules & Master Seed Management'**
  String get globalSystemSubtitle;

  /// No description provided for @administrativeFunctions.
  ///
  /// In en, this message translates to:
  /// **'Administrative Functions'**
  String get administrativeFunctions;

  /// No description provided for @compoundManagement.
  ///
  /// In en, this message translates to:
  /// **'Compound Management'**
  String get compoundManagement;

  /// No description provided for @compoundManagementSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage Al-Mohamedia Compound & add new compounds'**
  String get compoundManagementSubtitle;

  /// No description provided for @userRolesPermissions.
  ///
  /// In en, this message translates to:
  /// **'User Roles & Permissions'**
  String get userRolesPermissions;

  /// No description provided for @userRolesPermissionsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage RBAC across residents & staff'**
  String get userRolesPermissionsSubtitle;

  /// No description provided for @seedDemoDatabase.
  ///
  /// In en, this message translates to:
  /// **'Seed Demo Database'**
  String get seedDemoDatabase;

  /// No description provided for @seedDemoDatabaseSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Reset or re-seed sample requests and bookings'**
  String get seedDemoDatabaseSubtitle;
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
