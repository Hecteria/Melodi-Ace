// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get onboardingTitle => 'Create the\nSoundtrack of\nYour Life';

  @override
  String get onboardingSubtitle =>
      'Experience AI-powered music tailored to your mood, style, and every unique moment.';

  @override
  String get getStarted => 'Get Started';

  @override
  String get connectionError => 'Connection Error';

  @override
  String get somethingWentWrong => 'Something went wrong.';

  @override
  String get retry => 'Retry';

  @override
  String get seeAll => 'See All';

  @override
  String get greetingMorning => 'Good Morning';

  @override
  String get greetingAfternoon => 'Good Afternoon';

  @override
  String get greetingEvening => 'Good Evening';

  @override
  String get continueListening => 'Continue Listening';

  @override
  String get madeForYou => 'Made for You';

  @override
  String get yourRecentCreations => 'Your Recent Creations';

  @override
  String get createFirstTrack => 'Create your first AI track';

  @override
  String get createFirstTrackDesc =>
      'Describe a mood and let AI compose for you';

  @override
  String get startCreating => 'Start Creating';

  @override
  String get dayAgo => '1 day ago';

  @override
  String daysAgo(int count) {
    return '$count days ago';
  }

  @override
  String timeLeft(String time) {
    return '$time left';
  }

  @override
  String get explore => 'Explore';

  @override
  String get searchPlaceholder => 'Search genres, moods, AI models...';

  @override
  String get voice => 'Voice';

  @override
  String get trendingNow => 'Trending Now';

  @override
  String get browseByMood => 'Browse by Mood';

  @override
  String get aiSoundEngines => 'AI Sound Engines';

  @override
  String get genreWorlds => 'Genre Worlds';

  @override
  String get topCommunityCreations => 'Top Community Creations';

  @override
  String get curatedCollections => 'Curated Collections';

  @override
  String tracksCount(int count) {
    return '$count tracks';
  }

  @override
  String get aiCreationSuite => 'AI Creation Suite';

  @override
  String get createMasterpiece => 'Create a Masterpiece';

  @override
  String get describeAtmosphere => 'Describe the atmosphere of your track';

  @override
  String get trackDescriptionHint => 'Enter your track description...';

  @override
  String get selectGenre => 'Select Genre';

  @override
  String get musicalMood => 'Musical Mood';

  @override
  String get trackDuration => 'Track Duration';

  @override
  String get bpmTempo => 'BPM / Tempo';

  @override
  String get generateMusic => 'Generate Music';

  @override
  String get yourLibrary => 'Your Library';

  @override
  String get creations => 'Creations';

  @override
  String get saved => 'Saved';

  @override
  String get playingNow => 'Playing Now';

  @override
  String get upgradeToPro => 'Upgrade to Pro';

  @override
  String get restore => 'Restore';

  @override
  String get chooseSoundExperience => 'Choose Your\nSound Experience';

  @override
  String get unlockPremium =>
      'Unlock premium AI models and high-fidelity streaming.';

  @override
  String get monthly => 'Monthly';

  @override
  String get yearlyWithDiscount => 'Yearly (Save 20%)';

  @override
  String get perMonth => '/month';

  @override
  String get startFreeTrial => 'Start 7-Day Free Trial';

  @override
  String thenCancelAnytime(String price) {
    return 'Then $price/mo. Cancel anytime.';
  }

  @override
  String get terms => 'Terms';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get subscriptionRenewsNote =>
      'Subscription automatically renews unless canceled at least 24 hours before the end of the current period. Manage in Account Settings.';

  @override
  String get profile => 'Profile';

  @override
  String get guestName => 'Guest';

  @override
  String get guestAccount => 'Guest Account';

  @override
  String get tracksCreated => 'Tracks\nCreated';

  @override
  String get hoursListened => 'Hours\nListened';

  @override
  String get aiCredits => 'AI\nCredits';

  @override
  String planLabel(String plan) {
    return '$plan Plan';
  }

  @override
  String get freeBadge => 'Free';

  @override
  String get unlimitedActiveDesc => 'Unlimited AI generation active';

  @override
  String get upgradeForUnlimited =>
      'Upgrade to Pro for unlimited AI generation';

  @override
  String get accountSection => 'Account';

  @override
  String get preferencesSection => 'Preferences';

  @override
  String get supportSection => 'Support';

  @override
  String get signOut => 'Sign Out';

  @override
  String get appVersion => 'Melodi v1.0.0';

  @override
  String get browsingAsGuest => 'You\'re browsing as Guest';

  @override
  String get signInToSave => 'Sign in to save your music across devices';

  @override
  String get continueWithGoogle => 'Continue with Google';

  @override
  String get menuEditProfile => 'Edit Profile';

  @override
  String get menuSubscription => 'Subscription';

  @override
  String get menuNotifications => 'Notifications';

  @override
  String get menuPrivacyAndSecurity => 'Privacy & Security';

  @override
  String get menuAudioQuality => 'Audio Quality';

  @override
  String get menuAiModel => 'AI Model';

  @override
  String get menuStorageDownloads => 'Storage & Downloads';

  @override
  String get menuLanguage => 'Language';

  @override
  String get menuHelpCenter => 'Help Center';

  @override
  String get menuAboutMelodi => 'About Melodi';

  @override
  String get menuRateUs => 'Rate Us';

  @override
  String get menuShareWithFriends => 'Share with Friends';

  @override
  String get nowPlaying => 'Now Playing';

  @override
  String get navHome => 'Home';

  @override
  String get navDiscover => 'Discover';

  @override
  String get navGenerate => 'Generate';

  @override
  String get navLibrary => 'Library';

  @override
  String get navProfile => 'Profile';
}
