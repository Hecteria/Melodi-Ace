import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_tr.dart';

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
    Locale('en'),
    Locale('tr'),
  ];

  /// No description provided for @onboardingTitle.
  ///
  /// In en, this message translates to:
  /// **'Create the\nSoundtrack of\nYour Life'**
  String get onboardingTitle;

  /// No description provided for @onboardingSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Experience AI-powered music tailored to your mood, style, and every unique moment.'**
  String get onboardingSubtitle;

  /// No description provided for @getStarted.
  ///
  /// In en, this message translates to:
  /// **'Get Started'**
  String get getStarted;

  /// No description provided for @connectionError.
  ///
  /// In en, this message translates to:
  /// **'Connection Error'**
  String get connectionError;

  /// No description provided for @somethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong.'**
  String get somethingWentWrong;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @greetingMorning.
  ///
  /// In en, this message translates to:
  /// **'Good Morning'**
  String get greetingMorning;

  /// No description provided for @greetingAfternoon.
  ///
  /// In en, this message translates to:
  /// **'Good Afternoon'**
  String get greetingAfternoon;

  /// No description provided for @greetingEvening.
  ///
  /// In en, this message translates to:
  /// **'Good Evening'**
  String get greetingEvening;

  /// No description provided for @continueListening.
  ///
  /// In en, this message translates to:
  /// **'Continue Listening'**
  String get continueListening;

  /// No description provided for @madeForYou.
  ///
  /// In en, this message translates to:
  /// **'Made for You'**
  String get madeForYou;

  /// No description provided for @yourRecentCreations.
  ///
  /// In en, this message translates to:
  /// **'Your Recent Creations'**
  String get yourRecentCreations;

  /// No description provided for @createFirstTrack.
  ///
  /// In en, this message translates to:
  /// **'Create your first AI track'**
  String get createFirstTrack;

  /// No description provided for @createFirstTrackDesc.
  ///
  /// In en, this message translates to:
  /// **'Describe a mood and let AI compose for you'**
  String get createFirstTrackDesc;

  /// No description provided for @startCreating.
  ///
  /// In en, this message translates to:
  /// **'Start Creating'**
  String get startCreating;

  /// No description provided for @dayAgo.
  ///
  /// In en, this message translates to:
  /// **'1 day ago'**
  String get dayAgo;

  /// No description provided for @daysAgo.
  ///
  /// In en, this message translates to:
  /// **'{count} days ago'**
  String daysAgo(int count);

  /// No description provided for @timeLeft.
  ///
  /// In en, this message translates to:
  /// **'{time} left'**
  String timeLeft(String time);

  /// No description provided for @explore.
  ///
  /// In en, this message translates to:
  /// **'Explore'**
  String get explore;

  /// No description provided for @searchPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Search genres, moods, AI models...'**
  String get searchPlaceholder;

  /// No description provided for @voice.
  ///
  /// In en, this message translates to:
  /// **'Voice'**
  String get voice;

  /// No description provided for @trendingNow.
  ///
  /// In en, this message translates to:
  /// **'Trending Now'**
  String get trendingNow;

  /// No description provided for @browseByMood.
  ///
  /// In en, this message translates to:
  /// **'Browse by Mood'**
  String get browseByMood;

  /// No description provided for @aiSoundEngines.
  ///
  /// In en, this message translates to:
  /// **'AI Sound Engines'**
  String get aiSoundEngines;

  /// No description provided for @genreWorlds.
  ///
  /// In en, this message translates to:
  /// **'Genre Worlds'**
  String get genreWorlds;

  /// No description provided for @topCommunityCreations.
  ///
  /// In en, this message translates to:
  /// **'Top Community Creations'**
  String get topCommunityCreations;

  /// No description provided for @curatedCollections.
  ///
  /// In en, this message translates to:
  /// **'Curated Collections'**
  String get curatedCollections;

  /// No description provided for @tracksCount.
  ///
  /// In en, this message translates to:
  /// **'{count} tracks'**
  String tracksCount(int count);

  /// No description provided for @aiCreationSuite.
  ///
  /// In en, this message translates to:
  /// **'AI Creation Suite'**
  String get aiCreationSuite;

  /// No description provided for @createMasterpiece.
  ///
  /// In en, this message translates to:
  /// **'Create a Masterpiece'**
  String get createMasterpiece;

  /// No description provided for @describeAtmosphere.
  ///
  /// In en, this message translates to:
  /// **'Describe the atmosphere of your track'**
  String get describeAtmosphere;

  /// No description provided for @trackDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your track description...'**
  String get trackDescriptionHint;

  /// No description provided for @selectGenre.
  ///
  /// In en, this message translates to:
  /// **'Select Genre'**
  String get selectGenre;

  /// No description provided for @musicalMood.
  ///
  /// In en, this message translates to:
  /// **'Musical Mood'**
  String get musicalMood;

  /// No description provided for @trackDuration.
  ///
  /// In en, this message translates to:
  /// **'Track Duration'**
  String get trackDuration;

  /// No description provided for @bpmTempo.
  ///
  /// In en, this message translates to:
  /// **'BPM / Tempo'**
  String get bpmTempo;

  /// No description provided for @generateMusic.
  ///
  /// In en, this message translates to:
  /// **'Generate Music'**
  String get generateMusic;

  /// No description provided for @yourLibrary.
  ///
  /// In en, this message translates to:
  /// **'Your Library'**
  String get yourLibrary;

  /// No description provided for @creations.
  ///
  /// In en, this message translates to:
  /// **'Creations'**
  String get creations;

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @playingNow.
  ///
  /// In en, this message translates to:
  /// **'Playing Now'**
  String get playingNow;

  /// No description provided for @upgradeToPro.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro'**
  String get upgradeToPro;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @chooseSoundExperience.
  ///
  /// In en, this message translates to:
  /// **'Choose Your\nSound Experience'**
  String get chooseSoundExperience;

  /// No description provided for @unlockPremium.
  ///
  /// In en, this message translates to:
  /// **'Unlock premium AI models and high-fidelity streaming.'**
  String get unlockPremium;

  /// No description provided for @monthly.
  ///
  /// In en, this message translates to:
  /// **'Monthly'**
  String get monthly;

  /// No description provided for @yearlyWithDiscount.
  ///
  /// In en, this message translates to:
  /// **'Yearly (Save 20%)'**
  String get yearlyWithDiscount;

  /// No description provided for @perMonth.
  ///
  /// In en, this message translates to:
  /// **'/month'**
  String get perMonth;

  /// No description provided for @startFreeTrial.
  ///
  /// In en, this message translates to:
  /// **'Start 7-Day Free Trial'**
  String get startFreeTrial;

  /// No description provided for @thenCancelAnytime.
  ///
  /// In en, this message translates to:
  /// **'Then {price}/mo. Cancel anytime.'**
  String thenCancelAnytime(String price);

  /// No description provided for @terms.
  ///
  /// In en, this message translates to:
  /// **'Terms'**
  String get terms;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @subscriptionRenewsNote.
  ///
  /// In en, this message translates to:
  /// **'Subscription automatically renews unless canceled at least 24 hours before the end of the current period. Manage in Account Settings.'**
  String get subscriptionRenewsNote;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @guestName.
  ///
  /// In en, this message translates to:
  /// **'Guest'**
  String get guestName;

  /// No description provided for @guestAccount.
  ///
  /// In en, this message translates to:
  /// **'Guest Account'**
  String get guestAccount;

  /// No description provided for @tracksCreated.
  ///
  /// In en, this message translates to:
  /// **'Tracks\nCreated'**
  String get tracksCreated;

  /// No description provided for @hoursListened.
  ///
  /// In en, this message translates to:
  /// **'Hours\nListened'**
  String get hoursListened;

  /// No description provided for @aiCredits.
  ///
  /// In en, this message translates to:
  /// **'AI\nCredits'**
  String get aiCredits;

  /// No description provided for @planLabel.
  ///
  /// In en, this message translates to:
  /// **'{plan} Plan'**
  String planLabel(String plan);

  /// No description provided for @freeBadge.
  ///
  /// In en, this message translates to:
  /// **'Free'**
  String get freeBadge;

  /// No description provided for @unlimitedActiveDesc.
  ///
  /// In en, this message translates to:
  /// **'Unlimited AI generation active'**
  String get unlimitedActiveDesc;

  /// No description provided for @upgradeForUnlimited.
  ///
  /// In en, this message translates to:
  /// **'Upgrade to Pro for unlimited AI generation'**
  String get upgradeForUnlimited;

  /// No description provided for @accountSection.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountSection;

  /// No description provided for @preferencesSection.
  ///
  /// In en, this message translates to:
  /// **'Preferences'**
  String get preferencesSection;

  /// No description provided for @supportSection.
  ///
  /// In en, this message translates to:
  /// **'Support'**
  String get supportSection;

  /// No description provided for @signOut.
  ///
  /// In en, this message translates to:
  /// **'Sign Out'**
  String get signOut;

  /// No description provided for @appVersion.
  ///
  /// In en, this message translates to:
  /// **'Melodi v1.0.0'**
  String get appVersion;

  /// No description provided for @browsingAsGuest.
  ///
  /// In en, this message translates to:
  /// **'You\'re browsing as Guest'**
  String get browsingAsGuest;

  /// No description provided for @signInToSave.
  ///
  /// In en, this message translates to:
  /// **'Sign in to save your music across devices'**
  String get signInToSave;

  /// No description provided for @continueWithGoogle.
  ///
  /// In en, this message translates to:
  /// **'Continue with Google'**
  String get continueWithGoogle;

  /// No description provided for @menuEditProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get menuEditProfile;

  /// No description provided for @menuSubscription.
  ///
  /// In en, this message translates to:
  /// **'Subscription'**
  String get menuSubscription;

  /// No description provided for @menuNotifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get menuNotifications;

  /// No description provided for @menuPrivacyAndSecurity.
  ///
  /// In en, this message translates to:
  /// **'Privacy & Security'**
  String get menuPrivacyAndSecurity;

  /// No description provided for @menuAudioQuality.
  ///
  /// In en, this message translates to:
  /// **'Audio Quality'**
  String get menuAudioQuality;

  /// No description provided for @menuAiModel.
  ///
  /// In en, this message translates to:
  /// **'AI Model'**
  String get menuAiModel;

  /// No description provided for @menuStorageDownloads.
  ///
  /// In en, this message translates to:
  /// **'Storage & Downloads'**
  String get menuStorageDownloads;

  /// No description provided for @menuLanguage.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get menuLanguage;

  /// No description provided for @menuHelpCenter.
  ///
  /// In en, this message translates to:
  /// **'Help Center'**
  String get menuHelpCenter;

  /// No description provided for @menuAboutMelodi.
  ///
  /// In en, this message translates to:
  /// **'About Melodi'**
  String get menuAboutMelodi;

  /// No description provided for @menuRateUs.
  ///
  /// In en, this message translates to:
  /// **'Rate Us'**
  String get menuRateUs;

  /// No description provided for @menuShareWithFriends.
  ///
  /// In en, this message translates to:
  /// **'Share with Friends'**
  String get menuShareWithFriends;

  /// No description provided for @nowPlaying.
  ///
  /// In en, this message translates to:
  /// **'Now Playing'**
  String get nowPlaying;

  /// No description provided for @navHome.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get navHome;

  /// No description provided for @navDiscover.
  ///
  /// In en, this message translates to:
  /// **'Discover'**
  String get navDiscover;

  /// No description provided for @navGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get navGenerate;

  /// No description provided for @navLibrary.
  ///
  /// In en, this message translates to:
  /// **'Library'**
  String get navLibrary;

  /// No description provided for @navProfile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get navProfile;

  /// No description provided for @tabSimple.
  ///
  /// In en, this message translates to:
  /// **'Simple'**
  String get tabSimple;

  /// No description provided for @tabCustom.
  ///
  /// In en, this message translates to:
  /// **'Custom'**
  String get tabCustom;

  /// No description provided for @tabRemix.
  ///
  /// In en, this message translates to:
  /// **'Remix'**
  String get tabRemix;

  /// No description provided for @tabEdit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get tabEdit;

  /// No description provided for @lyricsLabel.
  ///
  /// In en, this message translates to:
  /// **'Lyrics'**
  String get lyricsLabel;

  /// No description provided for @lyricsHint.
  ///
  /// In en, this message translates to:
  /// **'Write lyrics for the song, or leave blank for instrumental...'**
  String get lyricsHint;

  /// No description provided for @promptLabel.
  ///
  /// In en, this message translates to:
  /// **'Prompt'**
  String get promptLabel;

  /// No description provided for @promptHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the prompt of the song...'**
  String get promptHint;

  /// No description provided for @advanceOptions.
  ///
  /// In en, this message translates to:
  /// **'Advance Options'**
  String get advanceOptions;

  /// No description provided for @resetAll.
  ///
  /// In en, this message translates to:
  /// **'Reset All'**
  String get resetAll;

  /// No description provided for @sectionGeneral.
  ///
  /// In en, this message translates to:
  /// **'General'**
  String get sectionGeneral;

  /// No description provided for @sectionThinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking'**
  String get sectionThinking;

  /// No description provided for @durationLabel.
  ///
  /// In en, this message translates to:
  /// **'Duration'**
  String get durationLabel;

  /// No description provided for @durationRange.
  ///
  /// In en, this message translates to:
  /// **'(10s-240s)'**
  String get durationRange;

  /// No description provided for @tempoLabel.
  ///
  /// In en, this message translates to:
  /// **'Tempo'**
  String get tempoLabel;

  /// No description provided for @tempoRange.
  ///
  /// In en, this message translates to:
  /// **'(30bpm-200bpm)'**
  String get tempoRange;

  /// No description provided for @timeSignatureLabel.
  ///
  /// In en, this message translates to:
  /// **'Time signature'**
  String get timeSignatureLabel;

  /// No description provided for @timeSignatureRange.
  ///
  /// In en, this message translates to:
  /// **'(2 or 3 or 4 or 6)'**
  String get timeSignatureRange;

  /// No description provided for @keyLabel.
  ///
  /// In en, this message translates to:
  /// **'Key'**
  String get keyLabel;

  /// No description provided for @negativeTags.
  ///
  /// In en, this message translates to:
  /// **'Add negative tags (e.g. Ballad, Slow, Jazz)...'**
  String get negativeTags;

  /// No description provided for @uploadReferenceAudio.
  ///
  /// In en, this message translates to:
  /// **'Upload Reference Audio'**
  String get uploadReferenceAudio;

  /// No description provided for @uploadAudio.
  ///
  /// In en, this message translates to:
  /// **'Upload Audio'**
  String get uploadAudio;

  /// No description provided for @uploadAudioSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Or drag from library (recommend)'**
  String get uploadAudioSubtitle;

  /// No description provided for @clearLabel.
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clearLabel;

  /// No description provided for @creativeLabel.
  ///
  /// In en, this message translates to:
  /// **'Creative'**
  String get creativeLabel;

  /// No description provided for @robustLabel.
  ///
  /// In en, this message translates to:
  /// **'Robust'**
  String get robustLabel;

  /// No description provided for @editTabPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Edit feature coming soon'**
  String get editTabPlaceholder;

  /// No description provided for @songDescription.
  ///
  /// In en, this message translates to:
  /// **'Song Description'**
  String get songDescription;

  /// No description provided for @songDescriptionHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the styles of the song...'**
  String get songDescriptionHint;

  /// No description provided for @instrumental.
  ///
  /// In en, this message translates to:
  /// **'Instrumental'**
  String get instrumental;

  /// No description provided for @uploadOptions.
  ///
  /// In en, this message translates to:
  /// **'Select Audio'**
  String get uploadOptions;

  /// No description provided for @pickFromDevice.
  ///
  /// In en, this message translates to:
  /// **'Pick from Device'**
  String get pickFromDevice;

  /// No description provided for @pickFromLibrary.
  ///
  /// In en, this message translates to:
  /// **'Pick from Library'**
  String get pickFromLibrary;

  /// No description provided for @pickFromLibraryDesc.
  ///
  /// In en, this message translates to:
  /// **'Choose a track from your creations'**
  String get pickFromLibraryDesc;
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
      <String>['en', 'tr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'tr':
      return AppLocalizationsTr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
