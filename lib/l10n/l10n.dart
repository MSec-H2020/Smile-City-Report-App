import 'package:flutter/widgets.dart';
import 'package:intl/intl.dart';
import 'messages_all.dart';

class L10n {
  L10n(this.localeName);

  static Future<L10n> load(Locale locale) {
    final name = locale.countryCode == null || locale.countryCode.isEmpty ? locale.languageCode : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      return L10n(localeName);
    });
  }

  static L10n of(BuildContext context) {
    return Localizations.of<L10n>(context, L10n);
  }

  final String localeName;

  // いずれはデフォルト（Intl.messageの第一引数）を英語にしておきたい
  // TimelineController
  String get timelineTitle {
    return Intl.message(
      'タイムライン',
      name: 'timelineTitle',
    );
  }

  String timelineTitleWithTheme(String themeTitle) {
    return Intl.message(
      'タイムライン - $themeTitle',
      name: 'timelineTitleWithTheme',
      args: [themeTitle],
    );
  }

  String get timelineNoTheme {
    return Intl.message(
      '参加しているテーマはありません',
      name: 'timelineNoTheme',
    );
  }

  String get timelineThemeSelectionDialogTitle {
    return Intl.message(
      '表示するタイムライン',
      name: 'timelineThemeSelectionDialogTitle',
    );
  }

  String get timelineReportPost {
    return Intl.message(
      '報告',
      name: 'timelineReportPost',
    );
  }

  String get timelineReportPostDialogMessage {
    return Intl.message(
      'この投稿を報告します。よろしいですか？',
      name: 'timelineReportPostDialogMessage',
    );
  }

  String get timelineBlockUser {
    return Intl.message(
      'ブロック',
      name: 'timelineBlockUser',
    );
  }

  String get timelineBlockUserDialogMessage {
    return Intl.message(
      'このユーザをブロックします。よろしいですか？',
      name: 'timelineBlockUserDialogMessage',
    );
  }

  // DetailController
  String get detailTitle {
    return Intl.message(
      '投稿',
      name: 'detailTitle',
    );
  }

  // PointManager
  String get pointManagerReasonLogin {
    return Intl.message(
      'ユーザ登録',
      name: 'pointManagerReasonLogin',
    );
  }

  String get pointManagerReasonPost {
    return Intl.message(
      '投稿',
      name: 'pointManagerReasonPost',
    );
  }

  String get pointManagerReasonPostSmile {
    return Intl.message(
      '笑顔写真の投稿',
      name: 'pointManagerReasonPostSmile',
    );
  }

  String get pointManagerReasonGanonymize {
    return Intl.message(
      '背景画像の匿名化',
      name: 'pointManagerReasonGanonymize',
    );
  }

  String get pointManagerReasonPostComment {
    return Intl.message(
      'コメントの投稿',
      name: 'pointManagerReasonPostComment',
    );
  }

  String get pointManagerReasonReactSmile {
    return Intl.message(
      '投稿に笑顔で反応',
      name: 'pointManagerReasonReactSmile',
    );
  }

  String pointManagerNotificationDescription(String point) {
    return Intl.message(
      '$pointポイント獲得しました！',
      name: 'pointManagerNotificationDescription',
      args: [point],
    );
  }

  String get pointManagerAchiveDialogTitle {
    return Intl.message(
      'おめでとうございます! 10000ポイント達成しました',
      name: 'pointManagerAchiveDialogTitle',
    );
  }

  String get pointManagerAchiveDialogMessage {
    return Intl.message(
      'キャンペーン特典へお申し込みいただけます。下のボタンから応募フォームを開いて下さい',
      name: 'pointManagerAchiveDialogMessage',
    );
  }

  String pointManagerAchiveDialogURL(String param1, String param2) {
    return Intl.message(
      'https://docs.google.com/forms/d/e/1FAIpQLSfV9XvQt7zKR8QwnxACOA6eFqSxKkH_PfPEWrJrAnIarPCNEQ/viewform?usp=pp_url&entry.599124620=$param1&entry.1644757972=$param2',
      name: 'pointManagerAchiveDialogURL',
      args: [param1, param2],
    );
  }

  String get pointManagerAchiveDialogAction {
    return Intl.message(
      '応募する',
      name: 'pointManagerAchiveDialogAction',
    );
  }

  // Utils
  String utilsDiffInDays(String dayCount) {
    return Intl.message(
      '$dayCount日前',
      name: 'utilsDiffInDays',
      args: [dayCount],
    );
  }

  String utilsDiffInHours(String hoursCount) {
    return Intl.message(
      '$hoursCount時間前',
      name: 'utilsDiffInHours',
      args: [hoursCount],
    );
  }

  String utilsDiffInMinutes(String minutesCount) {
    return Intl.message(
      '$minutesCount分前',
      name: 'utilsDiffInMinutes',
      args: [minutesCount],
    );
  }

  String utilsDiffInSeconds(String secondsCount) {
    return Intl.message(
      '$secondsCount秒前',
      name: 'utilsDiffInSeconds',
      args: [secondsCount],
    );
  }

  String get utilsSmileListViewNoData {
    return Intl.message(
      'まだ投稿がありません',
      name: "utilsSmileListViewNoData",
    );
  }

  String utilsSmiledCount(String count) {
    return Intl.message(
      '$count人がこの投稿を見て笑顔になりました！',
      name: 'utilsSmiledCount',
      args: [count],
    );
  }

  String utilsCommentCount(String count) {
    return Intl.message(
      '$countコメント',
      name: 'utilsCommentCount',
      args: [count],
    );
  }

  String get utilsCommentPlaceholder {
    return Intl.message(
      'コメント...',
      name: 'utilsCommentPlaceholder',
    );
  }

  // ConsentController
  String get consentTitle {
    return Intl.message(
      '利用規約',
      name: 'consentTitle',
    );
  }

  String get consentText {
    return Intl.message(
      '「利用規約および実験説明書」\n\n第二版 (2021年5月19日)\n\n慶應義塾大学環境情報学部中澤研究室 (以下「本研究主催者」とする) が主催する本研究のアプリケーション (以下「本アプリ」という) を利用するすべてのユーザの皆様（以下「実験参加者」という）は、以下の「利用規約および実験説明書」（以下「本規約」という）をよくお読みになり、同意をお願いいたします。(本アプリは、本規約内容への同意操作を完了すると利用可能になります)\n\n■研究の目的\n本研究では、ユーザのプライバシを守りながら、「都市でのできごと」と「それをレポートしたユーザの感情状態」を共有できる参加型センシングの有効性を明らかにすることを目的としています。\n本研究は、下記の研究プロジェクトにおける実証実験として行うものです。\n\n　　助成金名称：課題（#183）欧州との連携によるハイパーコネクテッド社会のためのセキュリティ技術の研究開発\n　　研究テーマ：「ブロックチェーン・ビッグデータ・クラウド及びIoTを使用したハイパーコネクテッドスマートシティを実現するマルチレイヤセキュリティ技術」(“Multi-layered Security technologies to ensure hyperconnected smart cities with Blockchain, Big Data, Cloud and IoT”) (略称: “M-SEC”)\n\n　　参加研究機関\n　　　［代表提案者］東日本電信電話株式会社（NTTE）\n\n　　　［共同提案者］\n　　　　学校法人慶應義塾 慶應義塾大学SFC研究所\n　　　　大学共同利用機関法人 情報・システム研究機構\n　　　　国立大学法人　横浜国立大学\n　　　　学校法人早稲田大学\n　　　　株式会社エヌ・ティ・ティ・データ経営研究所\n\n　　　［欧州側代表提案者］\n　　　　ATOS – Worldline Iberia (スペイン)\n　　　　National Technical University of Athens（ICCS／NTUA）(イタリア)\n　　　　COMMISSARIAT A L ENERGIE ATOMIQUE ET AUX ENERGIES ALTERNATIVES（CEA）(フランス)\n　　　　F6S Network Ltd（F6S） (アイルランド)\n　　　　TST Sistemas（TST） (スペイン)\n　　　　Ayuntamiento de Santander（AYTOSAN） (スペイン)\n\n■実験方法\n本研究では、本研究システムのフロントエンド部分であるスマートフォンアプリケーション「SmileCityReport App」を、対象者の皆様に(ご自身のスマートフォンに)インストールして頂き、アプリ上で主催者側から提示される「お題」(テーマ) に則って、街の様子を、写真やコメント／センサデータ／写真から抽出される笑顔度などから構成されるデータ一式による「投稿」としてアップロードしていただきます。本アプリは、デバイスに搭載されたセンサおよびカメラ画像、ユーザからの入力データを収集します。\n\n　　(1)プラットフォーム\n　　　　センシングアプリケーションは、Android、iOSといった各種モバイルデバイスプラットフォーム上で動作します。\n\n　　(2)データの収集\n　　　　本アプリケーションが収集する活動データは下記の通りです。\n　　　・外側カメラで撮影した画像\n　　　・内側カメラで撮影した画像\n　　　　　(ユーザ設定によってはマスク処理された画像)\n　　　・内側カメラで撮影された画像から推定されたユーザの感情状態情報(笑顔度等)\n　　　　・現在の位置情報 (スマートフォン内位置情報API使用)\n　　　　・直近数分のスマートフォンセンサデータ (Activity Recognition, 加速度、照度、ジャイロスコープ、地磁気等)\n\n■実験参加者\n本研究の対象者は、本研究の主旨に賛同するユーザとします。(加えて日本における20歳未満 (未成年) のユーザは自己申告の上、保護者の同意が必要です)\n\n■通知・公表または同意取得の方法\n本規約は、本アプリの初回起動時に提示され、この提示をもって公表したものとします。本規約の内容に同意頂いた方は、「同意する」タップして利用を開始し本研究へ参加をお願いいたします。同意いただけない場合には、本アプリの利用および研究への参加を行えません。\n\n■本規約の改定\n本研究主催者は、主催者の都合により、本規約の内容を必要に応じ予告なくして改定することができます。その場合、すでに本規約に同意いただいた実験参加者へ通知を行い、実験参加者は改定された本規約の内容を確認し、改定された規約へあらためて同意を行うものとします。\n\n■実験対象者の権利について\nこの研究に参加するか否かは自由意志で決定してください。また、一度同意した後でいつでも同意を取り消すことができ、それによる不利益はありません。実験参加者が希望する場合は、同意取り消しの時点で匿名化番号を破棄するとともに、それまでに得られたデータや解析結果を破棄し、それ以降の研究に一切使用いたしません。但し、取り消しが要求された時点で公表済みの解析結果がある場合は、このデータを破棄できませんのでご承知おきください。\n\n■実験に参加することによる利益と不利益\n本研究に参加することによる費用の負担はありません。また、本研究に参加されなくても不利益を受けることはありません。\n\n■個人情報とデータの取り扱い\n本実験から取得したデータは慶應義塾大学中澤研究室の管理するサーバに暗号化した状態で保存します。取得したデータや個人情報は、研究目的以外には使用しません。データには番号付けを行うとともに匿名化しますので、専門学会、学術専門誌、学内研究会等を通じて研究発表をする際も個人情報は守秘されます。\nサーバに保存されたデータは、研究が終了してから10年後までに破棄します。なお、研究上新たな課題が生じ、取得データの有用性が追加的に認められ、かつ倫理委員会の許可が得られた場合にはその限りではありません。\nデータの共有は、秘密保持契約（NDA）を結んだ他研究機関 (具体的には上記M-SECプロジェクト参加研究機関) とのみ行います。\n\n■保証の否認について\n本研究主催者は、本アプリが提供するサービス（以下「本サービス」という）及び情報の内容等の正確性に対する保証行為を一切しておりません。また、本研究主催者は、実験参加者が本サービスを利用したことに起因する直接的又は間接的な損害に関して一切責任を負わないものとします。\n本研究主催者は、本アプリ内のすべての情報、記事、画像等に、ウイルスなどの有害物が含まれていないこと、および第三者からの不正なアクセスのないこと、その他本アプリの安全性に関して一切の保証をしないものとします。\n\n■実験参加者の行為\n本研究主催者は、本アプリおよびサービスを、実験参加者にインターネットを経由して提供します。インターネットに接続するためのあらゆる機器、通信手段、ソフトウェア等は、実験参加者が自らの責任と費用において、適切に設置及び操作しなければなりません。同操作等について本研究主催者は一切の責任を負いません。\n実験参加者は、実験参加者のインターネット接続環境等によって、本サービスを利用又は閲覧するために通信費等が別途必要となることに同意し、同通信費等の一切を同実験参加者が負担するものとします。\n実験参加者は、実験参加者のインターネット接続環境等によって、本サービスの一部を閲覧又は利用できない可能性があることを予め了承するものとします。\n\n■留意事項・禁止事項等\n　実験参加者は、以下の行為を行ってはならないものとします。\n（１）個人使用目的のために本アプリをインストールする場合を除き、本アプリの一部又は全部を複製する行為\n（２）本アプリを修正、変更、逆アセンブル、逆コンパイル、リバースエンジニアリング等の改変をする行為\n（３）本アプリ及びその使用権を第三者に販売・貸与・譲渡・配布、又は再許諾権の設定若しくは担保に供する行為\n（４）本研究主催者又は第三者の知的財産権を含む法的権利を侵害する行為\n（５）本アプリの提供に支障をきたす行為\n（６）他人の権利の侵害や他人の誹謗中傷を行うコンテンツを含む、公序良俗に反する行為その他法令に違反する行為\n（７）本規約に違反する行為その他本研究主催者が不適当と判断する行為\n実験参加者が本規約に違反し、本研究主催者が損害を被った場合、その損害の全部又は一部を実験参加者に負担していただくことがあります。\n\n■投稿やアカウントの規制\n実験参加者による下記の様な内容を含む投稿は、サービス運営側の判断により規制 (非表示化、削除など) される場合があります。またそのような投稿を繰り返し行うアカウントについて、規制 (非表示化、削除など)が行われる場合があります。\n\n・暴力: 個人または集団に向けた暴力をほのめかす脅迫。\n・テロ行為/暴力的過激主義: テロ行為または暴力的過激主義をほのめかすことや助長すること。\n・攻撃的な行為/嫌がらせ: 特定の人物を標的とした嫌がらせに関与したり、他の人にそうするよう扇動したりすること。(誰かが身体的危害を被ることを願う、または望むことも含みます)\n・ヘイト行為: 人種、民族、出身地、社会的地位、性的指向、性別、性同一性、信仰している宗教、年齢、障碍、深刻な疾患を理由にして他者への暴力を助長したり、脅迫または嫌がらせを行ったりする投稿。\n・自殺または自傷行為: 自殺や自傷行為の助長や扇動。\n・写実的な暴力描写や成人向けコンテンツを含むセンシティブな画像/動画: 過度にグロテスクな、暴力を共有する、または成人向けコンテンツを含む投稿。\n・児童の性的搾取\n・違法または特定の規制対象商品・サービス\n・その他サービス運営側が不適切だと判断する投稿。\n\n■損害賠償\n実験参加者が本規約、又は各ガイドライン及び法令の定めに違反したことにより、本研究主催者及び第三者に損害を及ぼした場合、同実験参加者は、当該損害を賠償する責任を負い、いかなる場合も本研究主催者及び第三者を免責するものとします。\n\n■本サービスの一時的な停止\n　本研究主催者は、以下の事由により、実験参加者に事前の通知なく、一時的に本サービスの提供を停止することができるものとします。本サービスの停止による直接又は間接に生じた実験参加者又は第三者の損失や損害について、本研究主催者は、その内容、態様の如何に係わらず一切の責任を負わないものとします。\n（１）本サービスの稼動状態を良好に保つため、本研究主催者のシステム保守、点検、修理などを行う場合\n（２）火災、停電による本サービスの提供ができなくなった場合\n（３）天変地異などにより、本サービスの提供ができなくなった場合\n（４）その他、運用上または技術上、本サービス提供の一時的な停止を必要とした場合\n　本研究主催者は、前項の理由により本サービスの一時停止を行った場合において、本サービスの継続的な提供が困難だと判断した場合、実験参加者に対して通知を行わず本サービスを終了することができるものとします。\n\n■アプリケーション提供の終了\n本研究主催者は、理由の如何に関わらず、本アプリケーションおよびその機能の提供を終了することができるものとします。終了によって直接又は間接的に生じた、実験参加者又は第三者の損失や損害について、その内容、態様、責任の如何に係わらず、本研究主催者は、同実験参加者又は第三者に対して一切の損害の責任を負いません。\n\n■知的財産権について\n研究の進展によっては、特許などの知的財産権が生ずる可能性がありますが、知的財産権の帰属は、研究者または慶應義塾、あるいは慶應義塾外の共同研究者と協議のうえ決定され、データ提供者に帰属することはありません。\n\n■合意管轄等\n本規約に関連して、実験参加者と本研究主催者との間で紛争が生じた場合には、双方は、ともに誠意をもって協議するものとします。協議をしても解決しない場合は、東京地方裁判所を第一審の専属管轄裁判所とします。本規約の準拠法は、日本国法とします。\n\n■研究倫理\n本研究は、慶應義塾大学SFC実験・調査倫理委員会で承認された研究であり、実験・調査について、生命倫理、プライバシー保護、人権保護等の面で必要な倫理的考慮を確保しているかについての確認を受け、助言を受けています。\n\n■問い合わせ窓口\n本アプリケーションと実験における実験参加者情報の取扱いに関するお問い合わせ、ご相談は以下の窓口でお受けします。何かご不明な点がありましたら遠慮なくお尋ねください。\n本研究に参加している方の権利が守られていないと思われた場合や、担当者以外の意見や情報が欲しい場合は以下の連絡先へご連絡ください。\n\n　（連絡先）〒252-0882\n　　神奈川県藤沢市遠藤5322\n　　慶應義塾大学SFC実験・倫理委員会\n　　事務局：SFC事務室総務担当\n　　Mail：rinri@sfc.keio.ac.jp\n　（研究代表者）\n　　慶應義塾大学　環境情報学部　教授\n　　中澤 仁\n',
      name: 'consentText',
    );
  }

  String get consentAgree {
    return Intl.message(
      '同意する',
      name: 'consentAgree',
    );
  }

  String get consentReject {
    return Intl.message(
      '同意しない',
      name: 'consentReject',
    );
  }

  String get consentDialogTitle {
    return Intl.message(
      '確認',
      name: 'consentDialogTitle',
    );
  }

  String get consentDialogMessage {
    return Intl.message(
      '同意しないとアプリケーションは使用できません',
      name: 'consentDialogMessage',
    );
  }

  String get consentDialogOk {
    return Intl.message(
      'OK',
      name: 'consentDialogOk',
    );
  }

  // SignUpController
  String get signupTitle {
    return Intl.message(
      'ユーザ登録',
      name: 'signupTitle',
    );
  }

  String get signupNickname {
    return Intl.message(
      'ニックネーム',
      name: 'signupNickname',
    );
  }

  String get signupPassword {
    return Intl.message(
      'パスワード',
      name: 'signupPassword',
    );
  }

  String get signupPasswordConfirm {
    return Intl.message(
      'パスワード（確認）',
      name: 'signupPasswordConfirm',
    );
  }

  String get signupPasswordNotMatch {
    return Intl.message(
      'パスワードが一致しません',
      name: 'signupPasswordNotMatch',
    );
  }

  String get signupMarketplaceUsername {
    return Intl.message(
      'マーケットプレイス ユーザ名（オプション）',
      name: 'signupMarketplaceUsername',
    );
  }

  String get signupMarketplacePublicKey {
    return Intl.message(
      'マーケットプレイス パブリックキー（オプション）',
      name: 'signupMarketplacePublicKey',
    );
  }

  String get signupMarketplaceUser {
    return Intl.message(
      'マーケットプレイス ユーザの作成はこちらから',
      name: 'signupMarketplaceUser',
    );
  }

  String get signupGender {
    return Intl.message(
      '性別',
      name: 'signupGender',
    );
  }

  String get signupGenderMale {
    return Intl.message(
      '男性',
      name: 'signupGenderMale',
    );
  }

  String get signupGenderFemale {
    return Intl.message(
      '女性',
      name: 'signupGenderFemale',
    );
  }

  String get signupGenderOther {
    return Intl.message(
      'その他',
      name: 'signupGenderOther',
    );
  }

  String get signupAge {
    return Intl.message(
      '年齢',
      name: 'signupAge',
    );
  }

  String get signupJob {
    return Intl.message(
      '職業',
      name: 'signupJob',
    );
  }

  String get signupJobBusinessProfessional {
    return Intl.message(
      '会社員',
      name: 'signupJobBusinessProfessional',
    );
  }

  String get signupJobBusinessOwner {
    return Intl.message(
      '会社役員',
      name: 'signupJobBusinessOwner',
    );
  }

  String get signupJobSelfEmployed {
    return Intl.message(
      '自営業',
      name: 'signupJobSelfEmployed',
    );
  }

  String get signupJobGovernment {
    return Intl.message(
      '公務員',
      name: 'signupJobGovernment',
    );
  }

  String get signupJobOtherSectors {
    return Intl.message(
      'その他の業種',
      name: 'signupJobOtherSectors',
    );
  }

  String get signupJobStudent {
    return Intl.message(
      '学生',
      name: 'signupJobStudent',
    );
  }

  String get signupJobHomemaker {
    return Intl.message(
      '専業主婦(夫)',
      name: 'signupJobHomemaker',
    );
  }

  String get signupJobOthers {
    return Intl.message(
      'その他',
      name: 'signupJobOthers',
    );
  }

  String get signupArea {
    return Intl.message(
      '地域',
      name: 'signupArea',
    );
  }

  String signupRequired(String value) {
    return Intl.message(
      '$valueは必須です',
      name: 'signupRequired',
      args: [value],
    );
  }

  String get signupLogin {
    return Intl.message(
      'すでにアカウントお持ちの方はこちら',
      name: 'signupLogin',
    );
  }

  // LoginController

  String get loginTitle {
    return Intl.message(
      'ログイン',
      name: 'loginTitle',
    );
  }

  String get loginNickname {
    return Intl.message(
      'ニックネーム',
      name: 'loginNickname',
    );
  }

  String get loginPassword {
    return Intl.message(
      'パスワード',
      name: 'loginPassword',
    );
  }

  String get loginErrorMessage {
    return Intl.message(
      'ユーザ名もしくはパスワードが間違っています',
      name: 'loginErrorMessage',
    );
  }

  String get loginSignup {
    return Intl.message(
      'アカウントを作成',
      name: 'loginSignup',
    );
  }

  // CommentListController
  String get commentTitle {
    return Intl.message(
      'コメント',
      name: 'commentTitle',
    );
  }

  String get commentPlaceholder {
    return Intl.message(
      'コメント...',
      name: 'commentPlaceholder',
    );
  }

  // IconController
  String get iconTitleProfile {
    return Intl.message(
      'プロフィールアイコン',
      name: 'iconTitleProfile',
    );
  }

  String get iconTitleTheme {
    return Intl.message(
      'テーマアイコン',
      name: 'iconTitleTheme',
    );
  }

  String get iconFromCamera {
    return Intl.message(
      'カメラで撮影',
      name: 'iconFromCamera',
    );
  }

  String get iconFromAlbum {
    return Intl.message(
      'アルバムから選択',
      name: 'iconFromAlbum',
    );
  }

  // MapController
  String get mapTitle {
    return Intl.message(
      'マップ',
      name: 'mapTitle',
    );
  }

  // PointController
  String get pointTitle {
    return Intl.message(
      'ポイント',
      name: 'pointTitle',
    );
  }

  String get pointNoData {
    return Intl.message(
      'データがありません',
      name: 'pointNoData',
    );
  }

  String get pointCouponViewTitle {
    return Intl.message(
      'クーポン',
      name: 'pointCouponViewTitle',
    );
  }

  String get pointCouponViewMore {
    return Intl.message(
      'もっとみる',
      name: 'pointCouponViewMore',
    );
  }

  String get pointRivalViewTitle {
    return Intl.message(
      'ライバル',
      name: 'pointRivalViewTitle',
    );
  }

  String get pointRivalViewToday {
    return Intl.message(
      '今日：',
      name: 'pointRivalViewToday',
    );
  }

  String get pointProfileViewRankingTitle {
    return Intl.message(
      'ランキング',
      name: 'pointProfileViewRankingTitle',
    );
  }

  String pointProfileViewRanking(String value) {
    return Intl.message(
      '$value位',
      name: 'pointProfileViewRanking',
      args: [value],
    );
  }

  String pointProfileViewRankingMemberCount(String value) {
    return Intl.message(
      '$value人中',
      name: 'pointProfileViewRankingMemberCount',
      args: [value],
    );
  }

  String get pointProfileViewPoint {
    return Intl.message(
      '獲得ポイント',
      name: 'pointProfileViewPoint',
    );
  }

  String get pointProfileViewToday {
    return Intl.message(
      '今日',
      name: 'pointProfileViewToday',
    );
  }

  String pointRequiredPoint(String value) {
    return Intl.message(
      '${value}p必要',
      name: 'pointRequiredPoint',
      args: [value],
    );
  }

  // PhotoController
  String get photoTitle {
    return Intl.message(
      'カメラ',
      name: 'photoTitle',
    );
  }

  // PostController
  String get postTitle {
    return Intl.message(
      '投稿',
      name: 'postTitle',
    );
  }

  String get postGanonymizing {
    return Intl.message(
      '背景写真を匿名化しています',
      name: 'postGanonymizing',
    );
  }

  String get postCaption {
    return Intl.message(
      'キャプション',
      name: 'postCaption',
    );
  }

  String get translateText {
    return Intl.message(
      '翻訳する',
      name: 'translateText',
    );
  }

  String get postBackPhoto {
    return Intl.message(
      '背景写真',
      name: 'postBackPhoto',
    );
  }

  String get postBackPhotoGanonymize {
    return Intl.message(
      '背景写真を匿名化',
      name: 'postBackPhotoGanonymize',
    );
  }

  String get postSmilePhoto {
    return Intl.message(
      '笑顔写真',
      name: 'postSmilePhoto',
    );
  }

  String get postDeleteFrontPhoto {
    return Intl.message(
      '笑顔写真を削除',
      name: 'postDeleteFrontPhoto',
    );
  }

  String get postDeleteFrontPhotoDialogMessage {
    return Intl.message(
      '笑顔写真を削除します。よろしいですか？',
      name: 'postDeleteFrontPhotoDialogMessage',
    );
  }

  String get postDeleteDialogDelete {
    return Intl.message(
      '削除',
      name: 'postDeleteDialogDelete',
    );
  }

  String get postDiscardDialogTitle {
    return Intl.message(
      '投稿の破棄',
      name: 'postDiscardDialogTitle',
    );
  }

  String get postDiscardDialogMessage {
    return Intl.message(
      '写真および編集内容を破棄します。よろしいですか？',
      name: 'postDiscardDialogMessage',
    );
  }

  String get postDiscardDialogCancel {
    return Intl.message(
      'キャンセル',
      name: 'postDiscardDialogCancel',
    );
  }

  String get postDiscardDialogDiscard {
    return Intl.message(
      '破棄',
      name: 'postDiscardDialogDiscard',
    );
  }

  // ProfileController
  String get profileTitle {
    return Intl.message(
      'プロフィール',
      name: 'profileTitle',
    );
  }

  String profilePostCount(String value) {
    return Intl.message(
      '$value posts',
      name: 'profilePostCount',
      args: [value],
    );
  }

  String get profileEditIcon {
    return Intl.message(
      'プロフィール画像の変更',
      name: 'profileEditIcon',
    );
  }

  String get profileFromCamera {
    return Intl.message(
      'カメラで撮影',
      name: 'profileFromCamera',
    );
  }

  String get profileFromAlbum {
    return Intl.message(
      'アルバムから選択',
      name: 'profileFromAlbum',
    );
  }

  String get profileEditIconDialog {
    return Intl.message(
      'プロフィール写真を変更しますか？',
      name: 'profileEditIconDialog',
    );
  }

  String get profileEditIconDialogCancel {
    return Intl.message(
      'キャンセル',
      name: 'profileEditIconDialogCancel',
    );
  }

  String get profileEditIconDialogOk {
    return Intl.message(
      'OK',
      name: 'profileEditIconDialogOk',
    );
  }

  String get profileEditIconSuccess {
    return Intl.message(
      'プロフィール画像が変更されました',
      name: 'profileEditIconSuccess',
    );
  }

  // SmileController
  String get smileTitle {
    return Intl.message(
      'Smile',
      name: 'smileTitle',
    );
  }

  // ThemeCreateController
  String get themeCreateTitle {
    return Intl.message(
      '新しいテーマ',
      name: 'themeCreateTitle',
    );
  }

  String get themeCreateCreate {
    return Intl.message(
      '作成',
      name: 'themeCreateCreate',
    );
  }

  String get themeCreateName {
    return Intl.message(
      'タイトル',
      name: 'themeCreateName',
    );
  }

  String get themeCreateNameHint {
    return Intl.message(
      '15文字程度',
      name: 'themeCreateNameHint',
    );
  }

  String themeCreateRequired(String value) {
    return Intl.message(
      '$valueは必須です',
      name: 'themeCreateRequired',
      args: [value],
    );
  }

  String get themeCreateDescription {
    return Intl.message(
      '説明',
      name: 'themeCreateDescription',
    );
  }

  String get themeCreateIcon {
    return Intl.message(
      'アイコン',
      name: 'themeCreateIcon',
    );
  }

  String get themeCreateSmilePhoto {
    return Intl.message(
      '笑顔写真',
      name: 'themeCreateSmilePhoto',
    );
  }

  String get themeCreateSmilePhotoFacing {
    return Intl.message(
      '無加工',
      name: 'themeCreateSmilePhotoFacing',
    );
  }

  String get themeCreateSmilePhotoMasking {
    return Intl.message(
      'マスキング処理',
      name: 'themeCreateSmilePhotoMasking',
    );
  }

  String get themeCreateBackPhoto {
    return Intl.message(
      '背景写真',
      name: 'themeCreateBackPhoto',
    );
  }

  String get themeCreateBackPhotoNoEdit {
    return Intl.message(
      '無加工',
      name: 'themeCreateBackPhotoNoEdit',
    );
  }

  String get themeCreateBackPhotoGanonymize {
    return Intl.message(
      '匿名化処理',
      name: 'themeCreateBackPhotoGanonymize',
    );
  }

  String get themeCreateInvite {
    return Intl.message(
      '招待',
      name: 'themeCreateInvite',
    );
  }

  String get themeCreateInvitePublic {
    return Intl.message(
      'テーマに所属してる人は招待可能',
      name: 'themeCreateInvitePublic',
    );
  }

  String get themeCreateInvitePrivate {
    return Intl.message(
      '管理者のみ招待可能',
      name: 'themeCreateInvitePrivate',
    );
  }

  // ThemeDetailController
  String get themeDetailTitle {
    return Intl.message(
      '課題の詳細',
      name: 'themeDetailTitle',
    );
  }

  String themeDetailOwner(String name) {
    return Intl.message(
      '作成者: $name',
      name: 'themeDetailOwner',
      args: [name],
    );
  }

  String get themeDetailNoData {
    return Intl.message(
      'まだ投稿がありません',
      name: 'themeDetailNoData',
    );
  }

  // ThemeInviteController
  String get themeInviteTitle {
    return Intl.message(
      '招待',
      name: 'themeInviteTitle',
    );
  }

  String get themeInviteCreateURL {
    return Intl.message(
      '招待URLを作成',
      name: 'themeInviteCreateURL',
    );
  }

  String get themeInviteShareURL {
    return Intl.message(
      '招待URLを共有する',
      name: 'themeInviteShareURL',
    );
  }

  String get themeInviteURL {
    return Intl.message(
      '招待URL',
      name: 'themeInviteURL',
    );
  }

  String get themeInviteCreateQR {
    return Intl.message(
      '招待QRを作成',
      name: 'themeInviteCreateQR',
    );
  }

  String get themeInviteShareQR {
    return Intl.message(
      '招待QRを共有する',
      name: 'themeInviteShareQR',
    );
  }

  String get themeInviteQR {
    return Intl.message(
      'QRコード',
      name: 'themeInviteQR',
    );
  }

  // ThemeInvitedController
  String get themeInvitedTitle {
    return Intl.message(
      '招待されたテーマ',
      name: 'themeInvitedTitle',
    );
  }

  String get themeInvitedInvalidLink {
    return Intl.message(
      'このアプリリンクは使用できません',
      name: 'themeInvitedInvalidLink',
    );
  }

  // ThemeMemberController
  String get themeMemberTitle {
    return Intl.message(
      'メンバー',
      name: 'themeMemberTitle',
    );
  }

  String get themeMemberOwner {
    return Intl.message(
      '管理者',
      name: 'themeMemberOwner',
    );
  }

  String get themeMemberJoining {
    return Intl.message(
      '参加中',
      name: 'themeMemberJoining',
    );
  }

  String get themeMemberInvited {
    return Intl.message(
      '招待中',
      name: 'themeMemberInvited',
    );
  }

  String get themeMemberInvite {
    return Intl.message(
      'ユーザの招待',
      name: 'themeMemberInvite',
    );
  }

  String themeMemberJoin(String value) {
    return Intl.message(
      '$value に参加',
      name: 'themeMemberJoin',
      args: [value],
    );
  }

  // ThemeController
  String get themeTitle {
    return Intl.message(
      'テーマ',
      name: 'themeTitle',
    );
  }

  String get themeTabJoining {
    return Intl.message(
      '参加中',
      name: 'themeTabJoining',
    );
  }

  String get themeTabInvited {
    return Intl.message(
      '招待',
      name: 'themeTabInvited',
    );
  }

  String get themeNoJoiningTheme {
    return Intl.message(
      '参加している課題はありません',
      name: 'themeNoJoiningTheme',
    );
  }

  String get themeNoInvitedTheme {
    return Intl.message(
      '招待されてる課題はありません',
      name: 'themeNoInvitedTheme',
    );
  }

  // ThemeUsersController
  String get themeUsersTitle {
    return Intl.message(
      '招待するユーザを選択',
      name: 'themeUsersTitle',
    );
  }

  String get themeUsersNoData {
    return Intl.message(
      '該当するユーザが存在しません',
      name: 'themeUsersNoData',
    );
  }

  String get themeUsersInvite {
    return Intl.message(
      'Invite',
      name: 'themeUsersInvite',
    );
  }

  String get themeUsersNext {
    return Intl.message(
      'Next',
      name: 'themeUsersNext',
    );
  }

  // themeListView
  String themeListViewInvited(String value) {
    return Intl.message(
      '$valueに招待されてます',
      name: 'themeListViewInvited',
      args: [value],
    );
  }

  String get themeListViewPost {
    return Intl.message(
      '投稿',
      name: 'themeListViewPost',
    );
  }

  String get themeListViewInvite {
    return Intl.message(
      '招待',
      name: 'themeListViewInvite',
    );
  }

  String get themeListViewJoin {
    return Intl.message(
      '参加',
      name: 'themeListViewJoin',
    );
  }

  String get themeListViewInviteDialog {
    return Intl.message(
      '招待方法を選択',
      name: 'themeListViewInviteDialog',
    );
  }

  String get themeListViewInviteDialogChooseUsers {
    return Intl.message(
      '招待するユーザを選択',
      name: 'themeListViewInviteDialogChooseUsers',
    );
  }

  String get themeListViewInviteDialogAllUsers {
    return Intl.message(
      '全ユーザを招待',
      name: 'themeListViewInviteDialogAllUsers',
    );
  }

  // CouponController
  String get couponTitle {
    return Intl.message(
      'クーポン',
      name: 'couponTitle',
    );
  }

  String couponPointBalance(String value) {
    return Intl.message(
      '保有ポイント：$value',
      name: 'couponPointBalance',
      args: [value],
    );
  }

  String couponRequiredPoint(String value) {
    return Intl.message(
      '${value}p必要',
      name: 'couponRequiredPoint',
      args: [value],
    );
  }

  String get couponUsed {
    return Intl.message(
      'このクーポンは使用済みです',
      name: 'couponUsed',
    );
  }

  String get couponUse {
    return Intl.message(
      'クーポンを使用する',
      name: 'couponUse',
    );
  }

  String get couponUseDialogTitle {
    return Intl.message(
      '本当にこのクーポンを使用しますか？',
      name: 'couponUseDialogTitle',
    );
  }

  String get couponUseDialogMessage {
    return Intl.message(
      '一度使用するとこのクーポンは使用できなくなります',
      name: 'couponUseDialogMessage',
    );
  }

  String get couponUseDialogCancel {
    return Intl.message(
      'キャンセル',
      name: 'couponUseDialogCancel',
    );
  }

  String get couponUseDialogOk {
    return Intl.message(
      '使用',
      name: 'couponUseDialogOk',
    );
  }

  String get couponLackPoint {
    return Intl.message(
      'ポイントが不足しています',
      name: 'couponLackPoint',
    );
  }

  // PointUseHistoryController
  String get pointUseHistoryTitle {
    return Intl.message(
      'ポイント利用履歴',
      name: 'pointUseHistoryTitle',
    );
  }

  String pointUseHistoryPointBalance(String value) {
    return Intl.message(
      '保有ポイント：$value',
      name: 'pointUseHistoryPointBalance',
      args: [value],
    );
  }
}

class L10nDelegate extends LocalizationsDelegate<L10n> {
  const L10nDelegate();

  @override
  bool isSupported(Locale locale) => ['ja', 'en', 'es'].contains(locale.languageCode);

  @override
  Future<L10n> load(Locale locale) => L10n.load(locale);

  @override
  bool shouldReload(L10nDelegate old) => false;
}
