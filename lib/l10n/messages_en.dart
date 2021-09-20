// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a en locale. All the
// messages from the main program should be duplicated here with the same
// function name.

// Ignore issues from commonly used lints in this file.
// ignore_for_file:unnecessary_brace_in_string_interps, unnecessary_new
// ignore_for_file:prefer_single_quotes,comment_references, directives_ordering
// ignore_for_file:annotate_overrides,prefer_generic_function_type_aliases
// ignore_for_file:unused_import, file_names

import 'package:intl/intl.dart';
import 'package:intl/message_lookup_by_library.dart';

final messages = new MessageLookup();

typedef String MessageIfAbsent(String messageStr, List<dynamic> args);

class MessageLookup extends MessageLookupByLibrary {
  String get localeName => 'en';

  static m0(value) => "Coupon balance: ${value}";

  static m1(value) => "${value}pt required";

  static m2(param1, param2) => "https://docs.google.com/forms/d/e/1FAIpQLSeH0RtwaAHNHFtVnqus1lxpk6-rOzVcSlo8pCrWyI5Q_zqfAw/viewform?usp=pp_url&entry.599124620=${param1}&entry.1644757972=${param2}";

  static m3(point) => "You\'ve earned ${point} points!";

  static m4(value) => "${value} place";

  static m5(value) => "Out of ${value}";

  static m6(value) => "${value}pt required";

  static m7(value) => "Point balance: ${value}";

  static m8(value) => "${value} reports";

  static m9(value) => "${value} is requied.";

  static m10(value) => "${value} is required.";

  static m11(name) => "Created by: ${name}";

  static m12(value) => "You are invited to ${value}.";

  static m13(value) => "Join ${value}";

  static m14(themeTitle) => "Timeline - ${themeTitle}";

  static m15(count) => "${count} comments";

  static m16(dayCount) => "${dayCount} day(s) ago";

  static m17(hoursCount) => "${hoursCount} hour(s) ago";

  static m18(minutesCount) => "${minutesCount} minute(s) ago";

  static m19(secondsCount) => "${secondsCount} second(s) ago";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "commentPlaceholder" : MessageLookupByLibrary.simpleMessage("Comments..."),
    "commentTitle" : MessageLookupByLibrary.simpleMessage("Comments"),
    "consentAgree" : MessageLookupByLibrary.simpleMessage("Agree"),
    "consentDialogMessage" : MessageLookupByLibrary.simpleMessage("You cannot use this application if you do not agree."),
    "consentDialogOk" : MessageLookupByLibrary.simpleMessage("OK"),
    "consentDialogTitle" : MessageLookupByLibrary.simpleMessage("Confirm"),
    "consentReject" : MessageLookupByLibrary.simpleMessage("Disagree"),
    "consentText" : MessageLookupByLibrary.simpleMessage("Version 1 (November 4, 2020)\n\nAll users (hereinafter referred to as \'experiment participants\') of this research application (hereinafter referred to as \'the application\') hosted by the Nakazawa Laboratory in the Faculty of Environment and Information Studies at Keio University (hereinafter referred to as \'the research organizer\') are requested to carefully read and agree to the following \'Terms of Use and Experiment Instructions\' (hereinafter referred to as \'the Terms\'). Please read the following \'Terms of Use and Experiment Instructions\' (hereinafter referred to as the \'Terms\') carefully and agree to them. (This application can be used after completing the operation of agreeing to the contents of the Terms of Use)\n\n*Purpose of the Research\nThe purpose of this research is to clarify the effectiveness of participatory sensing that can share \'events in the city\' and \'the emotional state of the user who reported it\' while protecting the user\'s privacy.\nThis research will be conducted as a demonstration experiment in the following research project.\n\nGrant title: Project (#183) Research and Development of Security Technologies for a Hyperconnected Society in Collaboration with Europe\nResearch theme: \'Multi-layered security technologies to ensure hyperconnected smart cities with Blockchain, Big Data, Cloud and IoT\' (\'Multi-layered Security technologies to ensure Multi-layered Security technologies to ensure hyperconnected smart cities with Blockchain, Big Data, Cloud and IoT\') (abbreviation: \'M-SEC\')\n\nParticipating Research Organizations\nRepresentative Proposer] Nippon Telegraph and Telephone East Corporation (NTTE)\n\nCo-proposer\nKeio University Keio Research Institute, Keio University SFC\nInter-University Research Institute, National Institute of Information and Systems\nNational University Corporation Yokohama National University\nWaseda University Educational Corporation\nNTT Data Management Institute, Inc.\n\n[European Representative Proposer].\nATOS - Worldline Iberia (Spain)\nNational Technical University of Athens (ICCS/NTUA) (Italy)\nCOMMISSARIAT A L ENERGIE ATOMIQUE ET AUX ENERGIES ALTERNATIVES (CEA) (France)\nF6S Network Ltd (F6S) (Ireland)\nTST Sistemas (TST) (Spain)\nAyuntamiento de Santander (AYTOSAN) (Spain)\n\n*Experimental Method\nIn this study, we asked the participants to install the smartphone application \'SmileCityReport App,\' which is the front-end part of our research system, on their own smartphones, and to report on the state of the city according to the \'theme\' presented by the organizer on the app. The app will be installed on the device (on your own smartphone), and you will be asked to upload a \'post\' with a set of data consisting of photos, comments, sensor data, and the degree of smiles extracted from the photos. The application collects sensor and camera images mounted on the device and input data from the user.\n\n(1) Platform\nThe sensing application runs on various mobile device platforms such as Android and iOS.\n\n(2) Data collection\nThe activity data to be collected by this application are as follows\nImages captured by the outer camera\nImages taken by the inner camera\nImages taken by the inner camera (masked images depending on the user setting)\nInformation on the user\'s emotional state (e.g., smile level) estimated from the images taken by the inner camera\nCurrent location information (using location information API in smartphone)\nSmartphone sensor data for the last few minutes (Activity Recognition, acceleration, illumination, gyroscope, geomagnetism, etc.)\n\n*Participants of the experiment\nThe target audience for this research is users who agree with the purpose of this research. (In addition, users under the age of 20 (minors) in Japan are required to self-report and obtain the consent of their guardians.)\n\nMethod of notification, publication, or obtaining consent\nThis Agreement will be presented at the time of the first launch of this application, and will be deemed to have been published with this presentation. If you agree to the terms of this agreement, please tap \'Agree\' to start using the application and participate in this study. If you do not agree, you will not be able to use this application or participate in the study.\n\n*Revision of this Agreement\nThe organizer of this research may revise the contents of these Terms of Use as necessary without prior notice for the convenience of the organizer. In that case, the organizer will notify the experimental participants who have already agreed to the terms and conditions of this agreement, and the experimental participants must confirm the contents of the revised agreement and agree to the revised agreement.\n\n*Rights of Experimental Subjects\nWhether or not to participate in this research is a decision of your own free will. You may withdraw your consent at any time after you have given it, without any disadvantage. If the participant wishes, the anonymization number will be destroyed at the time of the withdrawal of consent, and the data and analysis results obtained up to that point will be destroyed and will not be used in any further research. However, if there are analysis results that have already been published at the time the revocation is requested, please be aware that this data cannot be destroyed.\n\n*Benefits and Disadvantages of Participating in the Experiment\nThere is no cost to you for participating in this research. There are no costs associated with participation in this research, and there are no disadvantages associated with not participating in this research.\n\n*Handling of personal information and data\nThe data obtained from this experiment will be stored in encrypted form on a server managed by the Nakazawa Laboratory of Keio University. The acquired data and personal information will be used only for research purposes. The data will be numbered and anonymized, so that personal information will be kept confidential even when the research is published in professional societies, academic journals, or on-campus research meetings.\nThe data stored on the server will be destroyed by 10 years after the completion of the research. This does not apply to cases where new issues arise in the research, the usefulness of the acquired data is additionally recognized, and the permission of the Ethics Committee is obtained.\nData will only be shared with other research institutions (specifically, those participating in the M-SEC project described above) that have signed a non-disclosure agreement (NDA).\n\n*Disclaimer of Warranty\nThe research organizer does not guarantee the accuracy of the service provided by this application(hereinafter referred to as the \'Service\') or the content of the information. In addition, the research organizer shall not be liable for any direct or indirect damages resulting from the use of the Service by the experiment participants.\nThis research organizer does not guarantee that all information, articles, images, etc. in this application do not contain viruses or other harmful materials, that there is no unauthorized access from third parties, or that this application is safe in any other way.\n\n*Conduct of Experiment Participants\nThe research organizer will provide the Application and services to the experiment participants via the Internet. All equipment, communication means, software, etc. used to connect to the Internet must be properly installed and operated by the experimental participants at their own responsibility and expense. The organizers of this research are not responsible for the operation of the equipment.\nThe experimental participant agrees that communication fees, etc. will be required separately to use or view the service depending on the experimental participant\'s Internet connection environment, etc. The experimental participant is responsible for all communication fees, etc.\nThe experimental participants agree in advance that they may not be able to view or use some parts of the service depending on their Internet connection environment.\n\n*Notes and Prohibited Items\nThe following actions are prohibited for experiment participants.\n(1) Duplication of all or part of this application, except when installing this application for personal use.\n(2) Modifying, changing, disassembling, decompiling, reverse engineering, or otherwise altering this application.\n(3) Selling, lending, transferring, or distributing the Application or its usage rights to a third party, or establishing sublicensing rights or offering them as collateral.\n(4) Acts that infringe on the legal rights, including intellectual property rights, of the Research Organizer or a third party.\n(5) Actions that interfere with the provision of this application.\n(6) Actions that violate public order and morals, including content that infringes on the rights of others or defames others, and other actions that violate laws and regulations\n(7) Any act that violates these rules or any other act that the research organizer deems inappropriate.\nIn the event that the researcher suffers damage due to a violation of these rules by an experiment participant, the experiment participant may be required to bear all or part of the damage.\n\n*Compensation for Damages\nIn the event that an experimental participant causes damage to the research organizer or a third party due to a violation of these rules, guidelines, or laws and regulations, the experimental participant shall be responsible for compensating the research organizer and the third party for such damage, and in no event shall the research organizer or the third party be held harmless.\n\n*Temporary suspension of this service\nThe research organizer may temporarily suspend the provision of the Service without prior notice to experimental participants for the following reasons The research project sponsors will not be held responsible for any direct or indirect losses or damages incurred by the experimental participants or third parties due to the suspension of the service, regardless of the nature or manner of such losses or damages.\n(1) When the research organizer performs system maintenance, inspection, or repair in order to keep the service in good working condition.\n(2) When the provision of this service becomes impossible due to fire or power failure.\n(3) When the provision of this service becomes impossible due to natural disasters, etc.\n(4) When a temporary suspension of the provision of this service is required for other operational or technical reasons.\n\n*Termination of Application Provision\nThe research organizer may terminate the provision of this application and its functions for any reason. Regardless of the content, manner, or responsibility for any loss or damage incurred directly or indirectly by the experiment participants or third parties as a result of the termination, the research organizer shall not be liable for any damage to the experiment participants or third parties.\n\n*Intellectual Property Rights\nDepending on the progress of the research, intellectual property rights such as patents may arise, but the ownership of intellectual property rights will be determined through consultation with the researcher, Keio University, or collaborators outside Keio University, and will not belong to the data provider.\n\n*Jurisdiction of Agreement\nIf a dispute arises between an experimental participant and the organizer of this research in relation to this agreement, both parties shall consult in good faith. If the dispute cannot be resolved through consultations, the Tokyo District Court shall be the court of exclusive jurisdiction in the first instance. This Agreement shall be governed by the laws of Japan.\n\n*Research Ethics\nThis research has been approved by the Keio University SFC Ethics Committee for Experiments and Research, and has received confirmation and advice as to whether or not the necessary ethical considerations in terms of bioethics, privacy protection, human rights protection, etc. have been secured for the experiments and research.\n\n*Contact for inquiries\nIf you have any questions or concerns about this application or the handling of experimental participant information, please contact the following office. If you have any questions, please do not hesitate to ask.\nIf you feel that the rights of participants in this research are not being protected, or if you want opinions or information from someone other than the person in charge, please contact us at the following address.\n\n(Contact address)\n5322 Endo, Fujisawa, Kanagawa, Japan\nKeio University SFC, Experiment and Ethics Committee\nSecretariat: General Affairs, SFC Office\nE-Mail: rinri@sfc.keio.ac.jp\n\n(Principal Investigator)\nProfessor, Faculty of Environment and Information Studies, Keio University\nJin Nakazawa\n"),
    "consentTitle" : MessageLookupByLibrary.simpleMessage("End User License Agreement"),
    "couponLackPoint" : MessageLookupByLibrary.simpleMessage("You don\'t have enough points"),
    "couponPointBalance" : m0,
    "couponRequiredPoint" : m1,
    "couponTitle" : MessageLookupByLibrary.simpleMessage("Coupon"),
    "couponUse" : MessageLookupByLibrary.simpleMessage("Use this coupon"),
    "couponUseDialogCancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "couponUseDialogMessage" : MessageLookupByLibrary.simpleMessage("Once you use this coupon now, it cannot be used again."),
    "couponUseDialogOk" : MessageLookupByLibrary.simpleMessage("Use"),
    "couponUseDialogTitle" : MessageLookupByLibrary.simpleMessage("Are you sure to use this coupon?"),
    "couponUsed" : MessageLookupByLibrary.simpleMessage("This coupon is already used."),
    "detailTitle" : MessageLookupByLibrary.simpleMessage("Post"),
    "iconFromAlbum" : MessageLookupByLibrary.simpleMessage("Choose from photo album"),
    "iconFromCamera" : MessageLookupByLibrary.simpleMessage("Take a photo by camera"),
    "iconTitleProfile" : MessageLookupByLibrary.simpleMessage("Profile icon"),
    "iconTitleTheme" : MessageLookupByLibrary.simpleMessage("Theme icon"),
    "loginErrorMessage" : MessageLookupByLibrary.simpleMessage("Incorrect email address and / or password."),
    "loginNickname" : MessageLookupByLibrary.simpleMessage("Nickname"),
    "loginPassword" : MessageLookupByLibrary.simpleMessage("Password"),
    "loginSignup" : MessageLookupByLibrary.simpleMessage("Don\'t have your account? Click here."),
    "loginTitle" : MessageLookupByLibrary.simpleMessage("Login"),
    "mapTitle" : MessageLookupByLibrary.simpleMessage("Map"),
    "photoTitle" : MessageLookupByLibrary.simpleMessage("Camera"),
    "pointCouponViewMore" : MessageLookupByLibrary.simpleMessage("View more"),
    "pointCouponViewTitle" : MessageLookupByLibrary.simpleMessage("Coupon"),
    "pointManagerAchiveDialogAction" : MessageLookupByLibrary.simpleMessage("Apply"),
    "pointManagerAchiveDialogMessage" : MessageLookupByLibrary.simpleMessage("You can apply to the promotion award! Open the form now."),
    "pointManagerAchiveDialogTitle" : MessageLookupByLibrary.simpleMessage("Congratulations! You\'ve reached 3000 points!"),
    "pointManagerAchiveDialogURL" : m2,
    "pointManagerNotificationDescription" : m3,
    "pointManagerReasonGanonymize" : MessageLookupByLibrary.simpleMessage("Ganonymizing photo"),
    "pointManagerReasonLogin" : MessageLookupByLibrary.simpleMessage("Signup"),
    "pointManagerReasonPost" : MessageLookupByLibrary.simpleMessage("Post"),
    "pointManagerReasonPostComment" : MessageLookupByLibrary.simpleMessage("Posting comment"),
    "pointManagerReasonPostSmile" : MessageLookupByLibrary.simpleMessage("Posting smily selfie"),
    "pointManagerReasonReactSmile" : MessageLookupByLibrary.simpleMessage("Reacting to post with smile"),
    "pointNoData" : MessageLookupByLibrary.simpleMessage("No Data"),
    "pointProfileViewPoint" : MessageLookupByLibrary.simpleMessage("Earned point"),
    "pointProfileViewRanking" : m4,
    "pointProfileViewRankingMemberCount" : m5,
    "pointProfileViewRankingTitle" : MessageLookupByLibrary.simpleMessage("Ranking"),
    "pointProfileViewToday" : MessageLookupByLibrary.simpleMessage("Today"),
    "pointRequiredPoint" : m6,
    "pointRivalViewTitle" : MessageLookupByLibrary.simpleMessage("Rival"),
    "pointRivalViewToday" : MessageLookupByLibrary.simpleMessage("Today: "),
    "pointTitle" : MessageLookupByLibrary.simpleMessage("Point"),
    "pointUseHistoryPointBalance" : m7,
    "pointUseHistoryTitle" : MessageLookupByLibrary.simpleMessage("Point use history"),
    "postBackPhoto" : MessageLookupByLibrary.simpleMessage("Scene photo"),
    "postBackPhotoGanonymize" : MessageLookupByLibrary.simpleMessage("Ganonymize the scene photo"),
    "postCaption" : MessageLookupByLibrary.simpleMessage("Caption"),
    "postDeleteDialogDelete" : MessageLookupByLibrary.simpleMessage("Delete"),
    "postDeleteFrontPhoto" : MessageLookupByLibrary.simpleMessage("Delete smily selfie"),
    "postDeleteFrontPhotoDialogMessage" : MessageLookupByLibrary.simpleMessage("Are you sure to delete your smily selfie?"),
    "postDiscardDialogCancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "postDiscardDialogDiscard" : MessageLookupByLibrary.simpleMessage("Discard"),
    "postDiscardDialogMessage" : MessageLookupByLibrary.simpleMessage("Are you sure to discard this report?"),
    "postDiscardDialogTitle" : MessageLookupByLibrary.simpleMessage("Discard the report"),
    "postGanonymizing" : MessageLookupByLibrary.simpleMessage("Ganonymizing the scene photo..."),
    "postSmilePhoto" : MessageLookupByLibrary.simpleMessage("Smily selfie"),
    "postTitle" : MessageLookupByLibrary.simpleMessage("Report"),
    "profileEditIcon" : MessageLookupByLibrary.simpleMessage("Change the profile image"),
    "profileEditIconDialog" : MessageLookupByLibrary.simpleMessage("Are you sure to change the profile photo?"),
    "profileEditIconDialogCancel" : MessageLookupByLibrary.simpleMessage("Cancel"),
    "profileEditIconDialogOk" : MessageLookupByLibrary.simpleMessage("OK"),
    "profileEditIconSuccess" : MessageLookupByLibrary.simpleMessage("Succesfully updated profile icon."),
    "profileFromAlbum" : MessageLookupByLibrary.simpleMessage("Choose from photo album"),
    "profileFromCamera" : MessageLookupByLibrary.simpleMessage("Take a photo by camera"),
    "profilePostCount" : m8,
    "profileTitle" : MessageLookupByLibrary.simpleMessage("Profile"),
    "signupAge" : MessageLookupByLibrary.simpleMessage("Age"),
    "signupArea" : MessageLookupByLibrary.simpleMessage("Residential Area"),
    "signupGender" : MessageLookupByLibrary.simpleMessage("Gender"),
    "signupGenderFemale" : MessageLookupByLibrary.simpleMessage("Female"),
    "signupGenderMale" : MessageLookupByLibrary.simpleMessage("Male"),
    "signupGenderOther" : MessageLookupByLibrary.simpleMessage("Other"),
    "signupJob" : MessageLookupByLibrary.simpleMessage("Occupation"),
    "signupJobBusinessOwner" : MessageLookupByLibrary.simpleMessage("Business Owner"),
    "signupJobBusinessProfessional" : MessageLookupByLibrary.simpleMessage("Business Professional"),
    "signupJobGovernment" : MessageLookupByLibrary.simpleMessage("Government / Civil Services"),
    "signupJobHomemaker" : MessageLookupByLibrary.simpleMessage("Homemaker / Retired"),
    "signupJobOtherSectors" : MessageLookupByLibrary.simpleMessage("Other Sectors"),
    "signupJobOthers" : MessageLookupByLibrary.simpleMessage("Others"),
    "signupJobSelfEmployed" : MessageLookupByLibrary.simpleMessage("Self-employed"),
    "signupJobStudent" : MessageLookupByLibrary.simpleMessage("Student"),
    "signupLogin" : MessageLookupByLibrary.simpleMessage("I already have an account."),
    "signupMarketplacePublicKey" : MessageLookupByLibrary.simpleMessage("MarketPlace PublicKey (option)"),
    "signupMarketplaceUser" : MessageLookupByLibrary.simpleMessage("Sign up MarketPlace. Click here!"),
    "signupMarketplaceUsername" : MessageLookupByLibrary.simpleMessage("MarketPlace Username (option)"),
    "signupNickname" : MessageLookupByLibrary.simpleMessage("Nickname"),
    "signupPassword" : MessageLookupByLibrary.simpleMessage("Password"),
    "signupPasswordConfirm" : MessageLookupByLibrary.simpleMessage("Password (confirmation)"),
    "signupPasswordNotMatch" : MessageLookupByLibrary.simpleMessage("Passwords do not match!"),
    "signupRequired" : m9,
    "signupTitle" : MessageLookupByLibrary.simpleMessage("User Registration"),
    "smileTitle" : MessageLookupByLibrary.simpleMessage("Smile"),
    "themeCreateBackPhoto" : MessageLookupByLibrary.simpleMessage("Scene photo"),
    "themeCreateBackPhotoGanonymize" : MessageLookupByLibrary.simpleMessage("With ganonymization"),
    "themeCreateBackPhotoNoEdit" : MessageLookupByLibrary.simpleMessage("No processing"),
    "themeCreateCreate" : MessageLookupByLibrary.simpleMessage("Create"),
    "themeCreateDescription" : MessageLookupByLibrary.simpleMessage("Description"),
    "themeCreateIcon" : MessageLookupByLibrary.simpleMessage("Icon"),
    "themeCreateInvite" : MessageLookupByLibrary.simpleMessage("Invite"),
    "themeCreateInvitePrivate" : MessageLookupByLibrary.simpleMessage("Only the theme owner can invite others"),
    "themeCreateInvitePublic" : MessageLookupByLibrary.simpleMessage("All the theme members can invite others"),
    "themeCreateName" : MessageLookupByLibrary.simpleMessage("Title"),
    "themeCreateNameHint" : MessageLookupByLibrary.simpleMessage("Up to 15 characters"),
    "themeCreateRequired" : m10,
    "themeCreateSmilePhoto" : MessageLookupByLibrary.simpleMessage("Smily Selfie"),
    "themeCreateSmilePhotoFacing" : MessageLookupByLibrary.simpleMessage("No masking"),
    "themeCreateSmilePhotoMasking" : MessageLookupByLibrary.simpleMessage("With masking"),
    "themeCreateTitle" : MessageLookupByLibrary.simpleMessage("New Theme"),
    "themeDetailNoData" : MessageLookupByLibrary.simpleMessage("No report posted yet."),
    "themeDetailOwner" : m11,
    "themeDetailTitle" : MessageLookupByLibrary.simpleMessage("Theme detail"),
    "themeInviteCreateQR" : MessageLookupByLibrary.simpleMessage("Create a publiv invitation QR code"),
    "themeInviteCreateURL" : MessageLookupByLibrary.simpleMessage("Create a public invitation URL"),
    "themeInviteQR" : MessageLookupByLibrary.simpleMessage("QR code"),
    "themeInviteShareQR" : MessageLookupByLibrary.simpleMessage("Share the public invitation QR code"),
    "themeInviteShareURL" : MessageLookupByLibrary.simpleMessage("Share the public invitation URL"),
    "themeInviteTitle" : MessageLookupByLibrary.simpleMessage("Invite"),
    "themeInviteURL" : MessageLookupByLibrary.simpleMessage("Public Invitaion URL"),
    "themeInvitedInvalidLink" : MessageLookupByLibrary.simpleMessage("This link is not valid to be used."),
    "themeInvitedTitle" : MessageLookupByLibrary.simpleMessage("Invited thems"),
    "themeListViewInvite" : MessageLookupByLibrary.simpleMessage("Invite"),
    "themeListViewInviteDialog" : MessageLookupByLibrary.simpleMessage("Select an invitation method"),
    "themeListViewInviteDialogAllUsers" : MessageLookupByLibrary.simpleMessage("Invite all"),
    "themeListViewInviteDialogChooseUsers" : MessageLookupByLibrary.simpleMessage("Select users to invite"),
    "themeListViewInvited" : m12,
    "themeListViewJoin" : MessageLookupByLibrary.simpleMessage("Join"),
    "themeListViewPost" : MessageLookupByLibrary.simpleMessage("Report"),
    "themeMemberInvite" : MessageLookupByLibrary.simpleMessage("Invite other users"),
    "themeMemberInvited" : MessageLookupByLibrary.simpleMessage("Invited"),
    "themeMemberJoin" : m13,
    "themeMemberJoining" : MessageLookupByLibrary.simpleMessage("Joining"),
    "themeMemberOwner" : MessageLookupByLibrary.simpleMessage("Owner"),
    "themeMemberTitle" : MessageLookupByLibrary.simpleMessage("Members"),
    "themeNoInvitedTheme" : MessageLookupByLibrary.simpleMessage("You don\'t have any invitation received."),
    "themeNoJoiningTheme" : MessageLookupByLibrary.simpleMessage("You haven\'t joinned any themes yet."),
    "themeTabInvited" : MessageLookupByLibrary.simpleMessage("Invited"),
    "themeTabJoining" : MessageLookupByLibrary.simpleMessage("Joining"),
    "themeTitle" : MessageLookupByLibrary.simpleMessage("Theme"),
    "themeUsersInvite" : MessageLookupByLibrary.simpleMessage("Invite"),
    "themeUsersNext" : MessageLookupByLibrary.simpleMessage("Next"),
    "themeUsersNoData" : MessageLookupByLibrary.simpleMessage("No users can be invited."),
    "themeUsersTitle" : MessageLookupByLibrary.simpleMessage("Select users to invite"),
    "timelineBlockUser" : MessageLookupByLibrary.simpleMessage("Block"),
    "timelineBlockUserDialogMessage" : MessageLookupByLibrary.simpleMessage("Are you sure to block this user?"),
    "timelineNoTheme" : MessageLookupByLibrary.simpleMessage("No joined theme yet."),
    "timelineReportPost" : MessageLookupByLibrary.simpleMessage("Report"),
    "timelineReportPostDialogMessage" : MessageLookupByLibrary.simpleMessage("Are you sure to report this post?"),
    "timelineThemeSelectionDialogTitle" : MessageLookupByLibrary.simpleMessage("Timeline to show"),
    "timelineTitle" : MessageLookupByLibrary.simpleMessage("Timeline"),
    "timelineTitleWithTheme" : m14,
    "translateText" : MessageLookupByLibrary.simpleMessage("Translate"),
    "utilsCommentCount" : m15,
    "utilsCommentPlaceholder" : MessageLookupByLibrary.simpleMessage("Comments..."),
    "utilsDiffInDays" : m16,
    "utilsDiffInHours" : m17,
    "utilsDiffInMinutes" : m18,
    "utilsDiffInSeconds" : m19,
    "utilsSmileListViewNoData" : MessageLookupByLibrary.simpleMessage("There is no report posted yet.")
  };
}
