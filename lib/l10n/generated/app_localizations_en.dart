// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Al-Mohamedia Compound';

  @override
  String get compoundName => 'Al-Mohamedia Compound';

  @override
  String get signOut => 'Sign Out';

  @override
  String get switchLanguage => 'Switch Language';

  @override
  String get languageToggleLabel => 'عربي';

  @override
  String get cancel => 'Cancel';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailHint => 'name@compound.demo';

  @override
  String get emailRequired => 'Please enter your email';

  @override
  String get password => 'Password';

  @override
  String get passwordRequired => 'Please enter your password';

  @override
  String get signInToResidence => 'Sign In to Residence';

  @override
  String get quickDemoIdentities => 'Quick Demo Identities (9 Roles)';

  @override
  String get instantDemoAccess => 'Instant Demo Access';

  @override
  String get instantDemoSubtitle =>
      'Select any predefined role below to test its dedicated dashboard immediately.';

  @override
  String get residentIdentities => 'RESIDENT IDENTITIES';

  @override
  String get departmentEmployeeIdentities => 'DEPARTMENT & EMPLOYEE IDENTITIES';

  @override
  String get residentFallbackName => 'Resident';

  @override
  String get ownerBadge => 'OWNER';

  @override
  String get tenantBadge => 'TENANT';

  @override
  String unitAuthorizedResidence(String unit) {
    return 'Unit $unit • Authorized Residence';
  }

  @override
  String get residentServices => 'Resident Services';

  @override
  String get visitorPass => 'Visitor Pass';

  @override
  String get visitorPassSubtitle => 'Expected guests & QR';

  @override
  String get maintenance => 'Maintenance';

  @override
  String get maintenanceSubtitle => 'AC, plumbing & repairs';

  @override
  String get recreation => 'Recreation';

  @override
  String get recreationSubtitle => 'Padel, gym & pool';

  @override
  String get housekeeping => 'Housekeeping';

  @override
  String get housekeepingSubtitle => 'Book certified cleaning';

  @override
  String get activeRequests => 'Active Requests';

  @override
  String get newRequest => 'New Request';

  @override
  String get noActiveRequests => 'No active service requests right now.';

  @override
  String get maintenanceWorkOrders => 'Maintenance Work Orders';

  @override
  String get maintenanceLeadFallback => 'Maintenance Lead';

  @override
  String get maintenanceOperationsSubtitle =>
      'Technical Operations • 4 Technicians on Duty';

  @override
  String get metricNew => 'New';

  @override
  String get metricAssigned => 'Assigned';

  @override
  String get metricInProgress => 'In Progress';

  @override
  String get metricCompleted => 'Completed';

  @override
  String filterAll(int count) {
    return 'All ($count)';
  }

  @override
  String get filterAc => 'AC ❄️';

  @override
  String get filterPlumbing => 'Plumbing 🚿';

  @override
  String get filterElectrical => 'Electrical ⚡';

  @override
  String workOrdersCount(int count) {
    return 'Work Orders ($count)';
  }

  @override
  String get noWorkOrdersFilter => 'No work orders matching this filter.';

  @override
  String get unitLabel => 'Unit';

  @override
  String unitWithNumber(String unit) {
    return 'Unit $unit';
  }

  @override
  String get unassigned => 'Unassigned';

  @override
  String get manageAndChat => 'Manage & Chat';

  @override
  String get newMaintenanceRequest => 'New Maintenance Request';

  @override
  String get selectCategory => 'Select Category';

  @override
  String get problemTitle => 'Problem Title';

  @override
  String get problemTitleHint => 'e.g. Master Bedroom AC Blowing Warm Air';

  @override
  String get problemTitleRequired => 'Please enter a title';

  @override
  String get detailedDescription => 'Detailed Description';

  @override
  String get detailedDescriptionHint =>
      'Describe the issue, location in the unit, and any sounds or leakages...';

  @override
  String get detailedDescriptionRequired => 'Please describe the problem';

  @override
  String get urgencyPriority => 'Urgency / Priority';

  @override
  String get preferredAppointmentSlot => 'Preferred Appointment Slot';

  @override
  String tomorrowDate(String date) {
    return 'Tomorrow ($date)';
  }

  @override
  String get submitRequestToMaintenance => 'Submit Request to Maintenance';

  @override
  String get assignTechnician => 'Assign Technician';

  @override
  String get techMahmoud => 'Technician Mahmoud (HVAC & AC)';

  @override
  String get techSalem => 'Technician Salem (Plumbing)';

  @override
  String get techHassan => 'Eng. Hassan Al-Najjar (Maintenance Lead)';

  @override
  String get rateCompletedService => 'Rate Completed Service';

  @override
  String get rateQuestion =>
      'How satisfied are you with this maintenance repair?';

  @override
  String get feedbackHint => 'Add feedback or notes (optional)...';

  @override
  String get submitRating => 'Submit Rating';

  @override
  String get updateStatus => 'Update Status';

  @override
  String get setUnderReview => 'Set: Under Review';

  @override
  String get setInProgress => 'Set: In Progress';

  @override
  String get setCompleted => 'Set: Completed';

  @override
  String get appointmentLabel => 'Appointment';

  @override
  String get priorityLabel => 'Priority';

  @override
  String assignedPrefix(String name) {
    return 'Assigned: $name';
  }

  @override
  String get markComplete => 'Mark Complete';

  @override
  String get residentFeedback => 'Resident Feedback';

  @override
  String get serviceCompletedTitle => 'Service Completed!';

  @override
  String get rateYourExperience => 'Rate your experience with our team';

  @override
  String get rateButton => 'Rate (1-5 ⭐)';

  @override
  String requestUpdatesAndChat(int count) {
    return 'Request Updates & Chat ($count)';
  }

  @override
  String get noCommentsYet =>
      'No comments yet. Send a message below to communicate directly.';

  @override
  String get typeUpdateOrQuestion => 'Type an update or question...';

  @override
  String get stepPending => 'Pending';

  @override
  String get stepReview => 'Review';

  @override
  String get stepAssigned => 'Assigned';

  @override
  String get stepInProgress => 'In Progress';

  @override
  String get stepDone => 'Done';

  @override
  String get securityGateOperations => 'Security & Gate Operations';

  @override
  String get officerOnDuty => 'Officer on Duty';

  @override
  String get gateShiftActive => 'Gate 1 (Main Entrance) • Shift Active';

  @override
  String get expectedToday => 'Expected Today';

  @override
  String get checkedIn => 'Checked In';

  @override
  String get onCompound => 'On Compound';

  @override
  String get searchPlateOrVisitor => 'Search Vehicle Plate or Visitor Name...';

  @override
  String get expectedVisitors => 'Expected Visitors';

  @override
  String hostPrefix(String unit) {
    return 'Host: $unit';
  }

  @override
  String get statusExpected => 'Expected';

  @override
  String get checkIn => 'Check In';

  @override
  String get todaySuffix => '(Today)';

  @override
  String get checkOut => 'Check Out';

  @override
  String get denyEntry => 'Deny';

  @override
  String get denyVisitorTitle => 'Deny Visitor Entry';

  @override
  String get denyReasonHint =>
      'Enter reason for denying entry (e.g. Unverified ID)...';

  @override
  String get confirmDeny => 'Confirm Denial';

  @override
  String get currentlyOnCompound => 'Currently on Compound';

  @override
  String get recentGateActivity => 'Gate History';

  @override
  String get noExpectedVisitors => 'No expected visitors matching your search.';

  @override
  String get noVisitorsOnCompound =>
      'No visitors currently checked in on the compound.';

  @override
  String get walkInPedestrian => 'Walk-in / No Vehicle';

  @override
  String get passCodeLabel => 'Pass Code';

  @override
  String get verifyQrCodeTitle => 'Verify Visitor Pass Code';

  @override
  String get verifyQrCodeHint =>
      'Enter pass code (e.g. VP-4823) or vehicle plate...';

  @override
  String get verifyButton => 'Search / Verify';

  @override
  String get myVisitorPasses => 'My Visitor Passes';

  @override
  String get createVisitorPassTitle => 'Create Visitor Pass';

  @override
  String get newVisitorPass => 'New Visitor Pass';

  @override
  String get noVisitorPassesYet =>
      'No visitor passes created yet. Tap + to invite a guest.';

  @override
  String get visitorFullName => 'Visitor Full Name';

  @override
  String get visitorFullNameHint => 'e.g. Khalid Al-Ghamdi';

  @override
  String get visitorFullNameRequired => 'Please enter the visitor\'s name';

  @override
  String get visitorPhone => 'Visitor Phone Number';

  @override
  String get visitorPhoneHint => '+966 5X XXX XXXX';

  @override
  String get visitorPhoneRequired => 'Please enter the visitor\'s phone number';

  @override
  String get visitDateLabel => 'Visit Date';

  @override
  String get expectedArrivalTimeLabel => 'Expected Arrival Time';

  @override
  String get vehiclePlateOptional => 'Vehicle Plate Number (Optional)';

  @override
  String get vehiclePlateHint => 'e.g. ABC 4567';

  @override
  String get securityNotesOptional => 'Notes for Gate Security (Optional)';

  @override
  String get securityNotesHint => 'e.g. Delivery driver, family guest...';

  @override
  String get generateQrPass => 'Generate Visitor QR Pass';

  @override
  String get digitalGatePass => 'DIGITAL GATE PASS';

  @override
  String get showQrAtGate =>
      'Present this QR pass at Al-Mohamedia Compound Main Gate';

  @override
  String get close => 'Close';

  @override
  String checkedInAt(String time) {
    return 'Checked in at $time';
  }

  @override
  String checkedOutAt(String time) {
    return 'Checked out at $time';
  }

  @override
  String get bookFacilityTitle => 'Book Recreation Facility';

  @override
  String get selectFacilityLabel => 'Select Facility';

  @override
  String get selectDateAndSlot => 'Select Date & Time Slot';

  @override
  String get durationHoursLabel => 'Duration';

  @override
  String hoursCount(int count) {
    return '$count hr(s)';
  }

  @override
  String get totalRateLabel => 'Total Reservation Fee';

  @override
  String get confirmFacilityBooking => 'Confirm Facility Reservation';

  @override
  String get myFacilityBookings => 'My Facility Reservations';

  @override
  String get noFacilityBookingsYet =>
      'No facility reservations yet. Select a facility above to book.';

  @override
  String get bookHousekeepingTitle => 'Book Housekeeping Service';

  @override
  String get selectCleaningPackage => 'Select Cleaning Package';

  @override
  String get selectDurationAndRate => 'Duration & Rate Calculator';

  @override
  String get specialCleaningNotes => 'Special Cleaning Instructions (Optional)';

  @override
  String get specialCleaningNotesHint =>
      'e.g. Focus on terrace glass, bring eco-friendly detergent...';

  @override
  String get confirmHousekeepingBooking => 'Confirm Housekeeping Booking';

  @override
  String get myHousekeepingBookings => 'My Cleaning Appointments';

  @override
  String get noHousekeepingBookingsYet =>
      'No housekeeping appointments booked yet.';

  @override
  String get cancelBooking => 'Cancel';

  @override
  String get confirmBookingAction => 'Confirm';

  @override
  String get assignCleaningTeamTitle => 'Dispatch Cleaning Staff';

  @override
  String get teamFatimaSunita =>
      'Team A: Fatima & Sunita (Deep Villa Specialists)';

  @override
  String get teamMariaElena => 'Team B: Maria & Elena (Standard Residence)';

  @override
  String get teamAminaGrace => 'Team C: Amina & Grace (Express Hospitality)';

  @override
  String get noFacilityBookingsStaff =>
      'No facility bookings in Cloud Firestore yet.';

  @override
  String get noHousekeepingBookingsStaff =>
      'No housekeeping appointments in Cloud Firestore yet.';

  @override
  String get totalBookingsMetric => 'Total';

  @override
  String get confirmedMetric => 'Confirmed';

  @override
  String get completedMetric => 'Completed';

  @override
  String ratePerHour(int amount) {
    return '$amount SAR/hr';
  }

  @override
  String get housekeepingAndCleaning => 'Housekeeping & Cleaning';

  @override
  String get housekeepingSupervisorFallback => 'Housekeeping Supervisor';

  @override
  String get housekeepingRateSubtitle =>
      'Standard Rate: 100 SAR/hr • 6 Cleaning Staff Active';

  @override
  String get todaysCleaningAppointments => 'Today\'s Cleaning Appointments';

  @override
  String get deepVillaCleaning => 'Deep Villa Cleaning';

  @override
  String get standardApartmentCleaning => 'Standard Apartment Cleaning';

  @override
  String hoursAndSar(int hours, int amount) {
    return '$hours Hours • $amount SAR';
  }

  @override
  String get staffUnassigned => 'Staff Unassigned';

  @override
  String get statusConfirmed => 'CONFIRMED';

  @override
  String get statusScheduled => 'SCHEDULED';

  @override
  String get dispatch => 'Dispatch';

  @override
  String get recreationAndFacilities => 'Recreation & Facilities';

  @override
  String get recreationManagerFallback => 'Recreation Manager';

  @override
  String get clubhouseSubtitle => 'Clubhouse, Gym & 2 Padel Courts Active';

  @override
  String get facilityBookingsToday => 'Facility Bookings Today';

  @override
  String get padelCourt1 => 'Padel Court 1 (Glass Court)';

  @override
  String get olympicSwimmingPool => 'Olympic Swimming Pool';

  @override
  String get complimentary => 'Complimentary';

  @override
  String slotPrefix(String time) {
    return 'Slot: $time';
  }

  @override
  String sarAmount(int amount) {
    return '$amount SAR';
  }

  @override
  String get itSmartSupport => 'IT & Smart Compound Support';

  @override
  String get itSupportFallback => 'IT Support Specialist';

  @override
  String get fiberNetworkSubtitle => 'Fiber Network & Smart Access Systems';

  @override
  String get activeTechnicalTickets => 'Active Technical Tickets';

  @override
  String get smartIntercomOffline => 'Smart Intercom Connection Offline';

  @override
  String get fiberSpeedDegradation => 'Fiber Internet Speed Degradation';

  @override
  String get statusInvestigating => 'INVESTIGATING';

  @override
  String get statusQueued => 'QUEUED';

  @override
  String get compoundAdministration => 'Compound Administration';

  @override
  String get administratorFallback => 'Administrator';

  @override
  String get executiveOpsSubtitle =>
      'Executive Operations & Resident Complaints';

  @override
  String get totalUnits => 'Total Units';

  @override
  String get occupancy => 'Occupancy';

  @override
  String get openRequests => 'Open Requests';

  @override
  String get escalatedComplaints => 'Escalated Complaints & Direct Requests';

  @override
  String get visitorGateDelayComplaint => 'Visitor Gate Access Delay Complaint';

  @override
  String hoursAgo(int count) {
    return '$count hours ago';
  }

  @override
  String get highPriorityBadge => 'HIGH PRIORITY';

  @override
  String get underReviewBadge => 'UNDER REVIEW';

  @override
  String get systemAdministration => 'System Administration';

  @override
  String get globalSystemOperations => 'Global System Operations';

  @override
  String get globalSystemSubtitle =>
      'Compounds, Security Rules & Master Seed Management';

  @override
  String get administrativeFunctions => 'Administrative Functions';

  @override
  String get compoundManagement => 'Compound Management';

  @override
  String get compoundManagementSubtitle =>
      'Manage Al-Mohamedia Compound & add new compounds';

  @override
  String get userRolesPermissions => 'User Roles & Permissions';

  @override
  String get userRolesPermissionsSubtitle =>
      'Manage RBAC across residents & staff';

  @override
  String get seedDemoDatabase => 'Seed Demo Database';

  @override
  String get seedDemoDatabaseSubtitle =>
      'Reset or re-seed sample requests and bookings';
}
