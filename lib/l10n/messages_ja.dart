// DO NOT EDIT. This is code generated via package:intl/generate_localized.dart
// This is a library that provides messages for a ja locale. All the
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
  String get localeName => 'ja';

  static m0(value) => "保有ポイント：${value}";

  static m1(value) => "${value}pt必要";

  static m2(param1, param2) => "https://docs.google.com/forms/d/e/1FAIpQLSf1_8XO1a5IOabL-_1qX2TYrs1sjY8ArYQxfRS33IFjdmgp-A/viewform?usp=pp_url&entry.1250428367=${param1}&entry.721189786=${param2}";

  static m3(point) => "${point}ポイント獲得しました！";

  static m4(value) => "${value}位";

  static m5(value) => "${value}人中";

  static m6(value) => "${value}pt必要";

  static m7(value) => "保有ポインvalue}";

  static m8(value) => "${value} posts";

  static m9(value) => "${value}を入力して下さい";

  static m10(value) => "${value}は必須です";

  static m11(name) => "作成者: ${name}";

  static m12(value) => "${value}に招待されてます";

  static m13(value) => "${value} に参加";

  static m14(themeTitle) => "タイムライン - ${themeTitle}";

  static m15(count) => "${count}コメント";

  static m16(dayCount) => "${dayCount}日前";

  static m17(hoursCount) => "${hoursCount}時間前";

  static m18(minutesCount) => "${minutesCount}分前";

  static m19(secondsCount) => "${secondsCount}秒前";

  final messages = _notInlinedMessages(_notInlinedMessages);
  static _notInlinedMessages(_) => <String, Function> {
    "commentPlaceholder" : MessageLookupByLibrary.simpleMessage("コメント..."),
    "commentTitle" : MessageLookupByLibrary.simpleMessage("コメント"),
    "consentAgree" : MessageLookupByLibrary.simpleMessage("同意する"),
    "consentDialogMessage" : MessageLookupByLibrary.simpleMessage("同意しないとアプリケーションは使用できません"),
    "consentDialogOk" : MessageLookupByLibrary.simpleMessage("OK"),
    "consentDialogTitle" : MessageLookupByLibrary.simpleMessage("確認"),
    "consentReject" : MessageLookupByLibrary.simpleMessage("同意しない"),
    "consentText" : MessageLookupByLibrary.simpleMessage("「利用規約および実験説明書」\n\n第二版 (2021年5月19日)\n\n慶應義塾大学環境情報学部中澤研究室 (以下「本研究主催者」とする) が主催する本研究のアプリケーション (以下「本アプリ」という) を利用するすべてのユーザの皆様（以下「実験参加者」という）は、以下の「利用規約および実験説明書」（以下「本規約」という）をよくお読みになり、同意をお願いいたします。(本アプリは、本規約内容への同意操作を完了すると利用可能になります)\n\n■研究の目的\n本研究では、ユーザのプライバシを守りながら、「都市でのできごと」と「それをレポートしたユーザの感情状態」を共有できる参加型センシングの有効性を明らかにすることを目的としています。\n本研究は、下記の研究プロジェクトにおける実証実験として行うものです。\n\n　　助成金名称：課題（#183）欧州との連携によるハイパーコネクテッド社会のためのセキュリティ技術の研究開発\n　　研究テーマ：「ブロックチェーン・ビッグデータ・クラウド及びIoTを使用したハイパーコネクテッドスマートシティを実現するマルチレイヤセキュリティ技術」(“Multi-layered Security technologies to ensure hyperconnected smart cities with Blockchain, Big Data, Cloud and IoT”) (略称: “M-SEC”)\n\n　　参加研究機関\n　　　［代表提案者］東日本電信電話株式会社（NTTE）\n\n　　　［共同提案者］\n　　　　学校法人慶應義塾 慶應義塾大学SFC研究所\n　　　　大学共同利用機関法人 情報・システム研究機構\n　　　　国立大学法人　横浜国立大学\n　　　　学校法人早稲田大学\n　　　　株式会社エヌ・ティ・ティ・データ経営研究所\n\n　　　［欧州側代表提案者］\n　　　　ATOS – Worldline Iberia (スペイン)\n　　　　National Technical University of Athens（ICCS／NTUA）(イタリア)\n　　　　COMMISSARIAT A L ENERGIE ATOMIQUE ET AUX ENERGIES ALTERNATIVES（CEA）(フランス)\n　　　　F6S Network Ltd（F6S） (アイルランド)\n　　　　TST Sistemas（TST） (スペイン)\n　　　　Ayuntamiento de Santander（AYTOSAN） (スペイン)\n\n■実験方法\n本研究では、本研究システムのフロントエンド部分であるスマートフォンアプリケーション「SmileCityReport App」を、対象者の皆様に(ご自身のスマートフォンに)インストールして頂き、アプリ上で主催者側から提示される「お題」(テーマ) に則って、街の様子を、写真やコメント／センサデータ／写真から抽出される笑顔度などから構成されるデータ一式による「投稿」としてアップロードしていただきます。本アプリは、デバイスに搭載されたセンサおよびカメラ画像、ユーザからの入力データを収集します。\n\n　　(1)プラットフォーム\n　　　　センシングアプリケーションは、Android、iOSといった各種モバイルデバイスプラットフォーム上で動作します。\n\n　　(2)データの収集\n　　　　本アプリケーションが収集する活動データは下記の通りです。\n　　　・外側カメラで撮影した画像\n　　　・内側カメラで撮影した画像\n　　　　　(ユーザ設定によってはマスク処理された画像)\n　　　・内側カメラで撮影された画像から推定されたユーザの感情状態情報(笑顔度等)\n　　　　・現在の位置情報 (スマートフォン内位置情報API使用)\n　　　　・直近数分のスマートフォンセンサデータ (Activity Recognition, 加速度、照度、ジャイロスコープ、地磁気等)\n\n■実験参加者\n本研究の対象者は、本研究の主旨に賛同するユーザとします。(加えて日本における20歳未満 (未成年) のユーザは自己申告の上、保護者の同意が必要です)\n\n■通知・公表または同意取得の方法\n本規約は、本アプリの初回起動時に提示され、この提示をもって公表したものとします。本規約の内容に同意頂いた方は、「同意する」タップして利用を開始し本研究へ参加をお願いいたします。同意いただけない場合には、本アプリの利用および研究への参加を行えません。\n\n■本規約の改定\n本研究主催者は、主催者の都合により、本規約の内容を必要に応じ予告なくして改定することができます。その場合、すでに本規約に同意いただいた実験参加者へ通知を行い、実験参加者は改定された本規約の内容を確認し、改定された規約へあらためて同意を行うものとします。\n\n■実験対象者の権利について\nこの研究に参加するか否かは自由意志で決定してください。また、一度同意した後でいつでも同意を取り消すことができ、それによる不利益はありません。実験参加者が希望する場合は、同意取り消しの時点で匿名化番号を破棄するとともに、それまでに得られたデータや解析結果を破棄し、それ以降の研究に一切使用いたしません。但し、取り消しが要求された時点で公表済みの解析結果がある場合は、このデータを破棄できませんのでご承知おきください。\n\n■実験に参加することによる利益と不利益\n本研究に参加することによる費用の負担はありません。また、本研究に参加されなくても不利益を受けることはありません。\n\n■個人情報とデータの取り扱い\n本実験から取得したデータは慶應義塾大学中澤研究室の管理するサーバに暗号化した状態で保存します。取得したデータや個人情報は、研究目的以外には使用しません。データには番号付けを行うとともに匿名化しますので、専門学会、学術専門誌、学内研究会等を通じて研究発表をする際も個人情報は守秘されます。\nサーバに保存されたデータは、研究が終了してから10年後までに破棄します。なお、研究上新たな課題が生じ、取得データの有用性が追加的に認められ、かつ倫理委員会の許可が得られた場合にはその限りではありません。\nデータの共有は、秘密保持契約（NDA）を結んだ他研究機関 (具体的には上記M-SECプロジェクト参加研究機関) とのみ行います。\n\n■保証の否認について\n本研究主催者は、本アプリが提供するサービス（以下「本サービス」という）及び情報の内容等の正確性に対する保証行為を一切しておりません。また、本研究主催者は、実験参加者が本サービスを利用したことに起因する直接的又は間接的な損害に関して一切責任を負わないものとします。\n本研究主催者は、本アプリ内のすべての情報、記事、画像等に、ウイルスなどの有害物が含まれていないこと、および第三者からの不正なアクセスのないこと、その他本アプリの安全性に関して一切の保証をしないものとします。\n\n■実験参加者の行為\n本研究主催者は、本アプリおよびサービスを、実験参加者にインターネットを経由して提供します。インターネットに接続するためのあらゆる機器、通信手段、ソフトウェア等は、実験参加者が自らの責任と費用において、適切に設置及び操作しなければなりません。同操作等について本研究主催者は一切の責任を負いません。\n実験参加者は、実験参加者のインターネット接続環境等によって、本サービスを利用又は閲覧するために通信費等が別途必要となることに同意し、同通信費等の一切を同実験参加者が負担するものとします。\n実験参加者は、実験参加者のインターネット接続環境等によって、本サービスの一部を閲覧又は利用できない可能性があることを予め了承するものとします。\n\n■留意事項・禁止事項等\n　実験参加者は、以下の行為を行ってはならないものとします。\n（１）個人使用目的のために本アプリをインストールする場合を除き、本アプリの一部又は全部を複製する行為\n（２）本アプリを修正、変更、逆アセンブル、逆コンパイル、リバースエンジニアリング等の改変をする行為\n（３）本アプリ及びその使用権を第三者に販売・貸与・譲渡・配布、又は再許諾権の設定若しくは担保に供する行為\n（４）本研究主催者又は第三者の知的財産権を含む法的権利を侵害する行為\n（５）本アプリの提供に支障をきたす行為\n（６）他人の権利の侵害や他人の誹謗中傷を行うコンテンツを含む、公序良俗に反する行為その他法令に違反する行為\n（７）本規約に違反する行為その他本研究主催者が不適当と判断する行為\n実験参加者が本規約に違反し、本研究主催者が損害を被った場合、その損害の全部又は一部を実験参加者に負担していただくことがあります。\n\n■投稿やアカウントの規制\n実験参加者による下記の様な内容を含む投稿は、サービス運営側の判断により規制 (非表示化、削除など) される場合があります。またそのような投稿を繰り返し行うアカウントについて、規制 (非表示化、削除など)が行われる場合があります。\n\n・暴力: 個人または集団に向けた暴力をほのめかす脅迫。\n・テロ行為/暴力的過激主義: テロ行為または暴力的過激主義をほのめかすことや助長すること。\n・攻撃的な行為/嫌がらせ: 特定の人物を標的とした嫌がらせに関与したり、他の人にそうするよう扇動したりすること。(誰かが身体的危害を被ることを願う、または望むことも含みます)\n・ヘイト行為: 人種、民族、出身地、社会的地位、性的指向、性別、性同一性、信仰している宗教、年齢、障碍、深刻な疾患を理由にして他者への暴力を助長したり、脅迫または嫌がらせを行ったりする投稿。\n・自殺または自傷行為: 自殺や自傷行為の助長や扇動。\n・写実的な暴力描写や成人向けコンテンツを含むセンシティブな画像/動画: 過度にグロテスクな、暴力を共有する、または成人向けコンテンツを含む投稿。\n・児童の性的搾取\n・違法または特定の規制対象商品・サービス\n・その他サービス運営側が不適切だと判断する投稿。\n\n■損害賠償\n実験参加者が本規約、又は各ガイドライン及び法令の定めに違反したことにより、本研究主催者及び第三者に損害を及ぼした場合、同実験参加者は、当該損害を賠償する責任を負い、いかなる場合も本研究主催者及び第三者を免責するものとします。\n\n■本サービスの一時的な停止\n　本研究主催者は、以下の事由により、実験参加者に事前の通知なく、一時的に本サービスの提供を停止することができるものとします。本サービスの停止による直接又は間接に生じた実験参加者又は第三者の損失や損害について、本研究主催者は、その内容、態様の如何に係わらず一切の責任を負わないものとします。\n（１）本サービスの稼動状態を良好に保つため、本研究主催者のシステム保守、点検、修理などを行う場合\n（２）火災、停電による本サービスの提供ができなくなった場合\n（３）天変地異などにより、本サービスの提供ができなくなった場合\n（４）その他、運用上または技術上、本サービス提供の一時的な停止を必要とした場合\n　本研究主催者は、前項の理由により本サービスの一時停止を行った場合において、本サービスの継続的な提供が困難だと判断した場合、実験参加者に対して通知を行わず本サービスを終了することができるものとします。\n\n■アプリケーション提供の終了\n本研究主催者は、理由の如何に関わらず、本アプリケーションおよびその機能の提供を終了することができるものとします。終了によって直接又は間接的に生じた、実験参加者又は第三者の損失や損害について、その内容、態様、責任の如何に係わらず、本研究主催者は、同実験参加者又は第三者に対して一切の損害の責任を負いません。\n\n■知的財産権について\n研究の進展によっては、特許などの知的財産権が生ずる可能性がありますが、知的財産権の帰属は、研究者または慶應義塾、あるいは慶應義塾外の共同研究者と協議のうえ決定され、データ提供者に帰属することはありません。\n\n■合意管轄等\n本規約に関連して、実験参加者と本研究主催者との間で紛争が生じた場合には、双方は、ともに誠意をもって協議するものとします。協議をしても解決しない場合は、東京地方裁判所を第一審の専属管轄裁判所とします。本規約の準拠法は、日本国法とします。\n\n■研究倫理\n本研究は、慶應義塾大学SFC実験・調査倫理委員会で承認された研究であり、実験・調査について、生命倫理、プライバシー保護、人権保護等の面で必要な倫理的考慮を確保しているかについての確認を受け、助言を受けています。\n\n■問い合わせ窓口\n本アプリケーションと実験における実験参加者情報の取扱いに関するお問い合わせ、ご相談は以下の窓口でお受けします。何かご不明な点がありましたら遠慮なくお尋ねください。\n本研究に参加している方の権利が守られていないと思われた場合や、担当者以外の意見や情報が欲しい場合は以下の連絡先へご連絡ください。\n\n　（連絡先）〒252-0882\n　　神奈川県藤沢市遠藤5322\n　　慶應義塾大学SFC実験・倫理委員会\n　　事務局：SFC事務室総務担当\n　　Mail：rinri@sfc.keio.ac.jp\n　（研究代表者）\n　　慶應義塾大学　環境情報学部　教授\n　　中澤 仁\n"),
    "consentTitle" : MessageLookupByLibrary.simpleMessage("利用規約"),
    "couponLackPoint" : MessageLookupByLibrary.simpleMessage("ポイントが不足しています"),
    "couponPointBalance" : m0,
    "couponRequiredPoint" : m1,
    "couponTitle" : MessageLookupByLibrary.simpleMessage("クーポン"),
    "couponUse" : MessageLookupByLibrary.simpleMessage("クーポンを使用する"),
    "couponUseDialogCancel" : MessageLookupByLibrary.simpleMessage("キャンセル"),
    "couponUseDialogMessage" : MessageLookupByLibrary.simpleMessage("一度使用するとこのクーポンは使用できなくなります"),
    "couponUseDialogOk" : MessageLookupByLibrary.simpleMessage("使用"),
    "couponUseDialogTitle" : MessageLookupByLibrary.simpleMessage("本当にこのクーポンを使用しますか？"),
    "couponUsed" : MessageLookupByLibrary.simpleMessage("このクーポンは使用済みです"),
    "detailTitle" : MessageLookupByLibrary.simpleMessage("投稿"),
    "iconFromAlbum" : MessageLookupByLibrary.simpleMessage("アルバムから選択"),
    "iconFromCamera" : MessageLookupByLibrary.simpleMessage("カメラで撮影"),
    "iconTitleProfile" : MessageLookupByLibrary.simpleMessage("プロフィールアイコン"),
    "iconTitleTheme" : MessageLookupByLibrary.simpleMessage("テーマアイコン"),
    "loginErrorMessage" : MessageLookupByLibrary.simpleMessage("ユーザ名もしくはパスワードが間違っています"),
    "loginNickname" : MessageLookupByLibrary.simpleMessage("ニックネーム"),
    "loginPassword" : MessageLookupByLibrary.simpleMessage("パスワード"),
    "loginSignup" : MessageLookupByLibrary.simpleMessage("アカウントをお持ちでない方はこちら"),
    "loginTitle" : MessageLookupByLibrary.simpleMessage("ログイン"),
    "mapTitle" : MessageLookupByLibrary.simpleMessage("地図"),
    "photoTitle" : MessageLookupByLibrary.simpleMessage("カメラ"),
    "pointCouponViewMore" : MessageLookupByLibrary.simpleMessage("もっとみる"),
    "pointCouponViewTitle" : MessageLookupByLibrary.simpleMessage("クーポン"),
    "pointManagerAchiveDialogAction" : MessageLookupByLibrary.simpleMessage("応募する"),
    "pointManagerAchiveDialogMessage" : MessageLookupByLibrary.simpleMessage("キャンペーン特典へお申し込みいただけます。下のボタンから応募フォームを開いて下さい"),
    "pointManagerAchiveDialogTitle" : MessageLookupByLibrary.simpleMessage("おめでとうございます! 3000ポイント達成しました"),
    "pointManagerAchiveDialogURL" : m2,
    "pointManagerNotificationDescription" : m3,
    "pointManagerReasonGanonymize" : MessageLookupByLibrary.simpleMessage("背景画像の匿名化"),
    "pointManagerReasonLogin" : MessageLookupByLibrary.simpleMessage("ユーザ登録"),
    "pointManagerReasonPost" : MessageLookupByLibrary.simpleMessage("投稿"),
    "pointManagerReasonPostComment" : MessageLookupByLibrary.simpleMessage("コメントの投稿"),
    "pointManagerReasonPostSmile" : MessageLookupByLibrary.simpleMessage("笑顔写真の投稿"),
    "pointManagerReasonReactSmile" : MessageLookupByLibrary.simpleMessage("投稿に笑顔で反応"),
    "pointNoData" : MessageLookupByLibrary.simpleMessage("データがありません"),
    "pointProfileViewPoint" : MessageLookupByLibrary.simpleMessage("獲得ポイント"),
    "pointProfileViewRanking" : m4,
    "pointProfileViewRankingMemberCount" : m5,
    "pointProfileViewRankingTitle" : MessageLookupByLibrary.simpleMessage("ランキング"),
    "pointProfileViewToday" : MessageLookupByLibrary.simpleMessage("今日"),
    "pointRequiredPoint" : m6,
    "pointRivalViewTitle" : MessageLookupByLibrary.simpleMessage("ライバル"),
    "pointRivalViewToday" : MessageLookupByLibrary.simpleMessage("今日："),
    "pointTitle" : MessageLookupByLibrary.simpleMessage("ポイント"),
    "pointUseHistoryPointBalance" : m7,
    "pointUseHistoryTitle" : MessageLookupByLibrary.simpleMessage("ポイント利用履歴"),
    "postBackPhoto" : MessageLookupByLibrary.simpleMessage("風景写真"),
    "postBackPhotoGanonymize" : MessageLookupByLibrary.simpleMessage("風景写真を匿名化"),
    "postCaption" : MessageLookupByLibrary.simpleMessage("キャプション"),
    "postDeleteDialogDelete" : MessageLookupByLibrary.simpleMessage("削除"),
    "postDeleteFrontPhoto" : MessageLookupByLibrary.simpleMessage("笑顔写真を削除"),
    "postDeleteFrontPhotoDialogMessage" : MessageLookupByLibrary.simpleMessage("笑顔写真を削除します。よろしいですか？"),
    "postDiscardDialogCancel" : MessageLookupByLibrary.simpleMessage("キャンセル"),
    "postDiscardDialogDiscard" : MessageLookupByLibrary.simpleMessage("破棄"),
    "postDiscardDialogMessage" : MessageLookupByLibrary.simpleMessage("写真および編集内容を破棄します。よろしいですか？"),
    "postDiscardDialogTitle" : MessageLookupByLibrary.simpleMessage("投稿の破棄"),
    "postGanonymizing" : MessageLookupByLibrary.simpleMessage("風景写真を匿名化しています"),
    "postSmilePhoto" : MessageLookupByLibrary.simpleMessage("笑顔写真"),
    "postTitle" : MessageLookupByLibrary.simpleMessage("投稿"),
    "profileEditIcon" : MessageLookupByLibrary.simpleMessage("プロフィール画像の変更"),
    "profileEditIconDialog" : MessageLookupByLibrary.simpleMessage("プロフィール写真を変更しますか？"),
    "profileEditIconDialogCancel" : MessageLookupByLibrary.simpleMessage("キャンセル"),
    "profileEditIconDialogOk" : MessageLookupByLibrary.simpleMessage("OK"),
    "profileEditIconSuccess" : MessageLookupByLibrary.simpleMessage("プロフィール画像が変更されました"),
    "profileFromAlbum" : MessageLookupByLibrary.simpleMessage("アルバムから選択"),
    "profileFromCamera" : MessageLookupByLibrary.simpleMessage("カメラで撮影"),
    "profilePostCount" : m8,
    "profileTitle" : MessageLookupByLibrary.simpleMessage("プロフィール"),
    "signupAge" : MessageLookupByLibrary.simpleMessage("年齢"),
    "signupArea" : MessageLookupByLibrary.simpleMessage("地域"),
    "signupGender" : MessageLookupByLibrary.simpleMessage("性別"),
    "signupGenderFemale" : MessageLookupByLibrary.simpleMessage("女性"),
    "signupGenderMale" : MessageLookupByLibrary.simpleMessage("男性"),
    "signupGenderOther" : MessageLookupByLibrary.simpleMessage("その他"),
    "signupJob" : MessageLookupByLibrary.simpleMessage("職業"),
    "signupJobBusinessOwner" : MessageLookupByLibrary.simpleMessage("会社役員"),
    "signupJobBusinessProfessional" : MessageLookupByLibrary.simpleMessage("会社員"),
    "signupJobGovernment" : MessageLookupByLibrary.simpleMessage("公務員"),
    "signupJobHomemaker" : MessageLookupByLibrary.simpleMessage("専業主婦(夫)"),
    "signupJobOtherSectors" : MessageLookupByLibrary.simpleMessage("その他の業種"),
    "signupJobOthers" : MessageLookupByLibrary.simpleMessage("その他"),
    "signupJobSelfEmployed" : MessageLookupByLibrary.simpleMessage("自営業"),
    "signupJobStudent" : MessageLookupByLibrary.simpleMessage("学生"),
    "signupLogin" : MessageLookupByLibrary.simpleMessage("すでにアカウントをお持ちの方はこちら"),
    "signupMarketplacePublicKey" : MessageLookupByLibrary.simpleMessage("マーケットプレイス パブリックキー（オプション）"),
    "signupMarketplaceUser" : MessageLookupByLibrary.simpleMessage("マーケットプレイス ユーザの作成はこちらから"),
    "signupMarketplaceUsername" : MessageLookupByLibrary.simpleMessage("マーケットプレイス ユーザ名（オプション）"),
    "signupNickname" : MessageLookupByLibrary.simpleMessage("ニックネーム"),
    "signupPassword" : MessageLookupByLibrary.simpleMessage("パスワード"),
    "signupPasswordConfirm" : MessageLookupByLibrary.simpleMessage("パスワード（確認）"),
    "signupPasswordNotMatch" : MessageLookupByLibrary.simpleMessage("パスワードが一致しません"),
    "signupRequired" : m9,
    "signupTitle" : MessageLookupByLibrary.simpleMessage("ユーザ登録"),
    "smileTitle" : MessageLookupByLibrary.simpleMessage("Smile"),
    "themeCreateBackPhoto" : MessageLookupByLibrary.simpleMessage("風景写真"),
    "themeCreateBackPhotoGanonymize" : MessageLookupByLibrary.simpleMessage("匿名化処理"),
    "themeCreateBackPhotoNoEdit" : MessageLookupByLibrary.simpleMessage("加工しない"),
    "themeCreateCreate" : MessageLookupByLibrary.simpleMessage("作成"),
    "themeCreateDescription" : MessageLookupByLibrary.simpleMessage("説明"),
    "themeCreateIcon" : MessageLookupByLibrary.simpleMessage("アイコン"),
    "themeCreateInvite" : MessageLookupByLibrary.simpleMessage("招待"),
    "themeCreateInvitePrivate" : MessageLookupByLibrary.simpleMessage("管理者のみ招待可能"),
    "themeCreateInvitePublic" : MessageLookupByLibrary.simpleMessage("テーマに所属してる人は招待可能"),
    "themeCreateName" : MessageLookupByLibrary.simpleMessage("タイトル"),
    "themeCreateNameHint" : MessageLookupByLibrary.simpleMessage("15文字程度"),
    "themeCreateRequired" : m10,
    "themeCreateSmilePhoto" : MessageLookupByLibrary.simpleMessage("笑顔写真"),
    "themeCreateSmilePhotoFacing" : MessageLookupByLibrary.simpleMessage("加工しない"),
    "themeCreateSmilePhotoMasking" : MessageLookupByLibrary.simpleMessage("マスキング処理"),
    "themeCreateTitle" : MessageLookupByLibrary.simpleMessage("新しいテーマ"),
    "themeDetailNoData" : MessageLookupByLibrary.simpleMessage("まだ投稿がありません"),
    "themeDetailOwner" : m11,
    "themeDetailTitle" : MessageLookupByLibrary.simpleMessage("課題の詳細"),
    "themeInviteCreateQR" : MessageLookupByLibrary.simpleMessage("招待QRを作成"),
    "themeInviteCreateURL" : MessageLookupByLibrary.simpleMessage("招待URLを作成"),
    "themeInviteQR" : MessageLookupByLibrary.simpleMessage("QRコード"),
    "themeInviteShareQR" : MessageLookupByLibrary.simpleMessage("招待QRを共有する"),
    "themeInviteShareURL" : MessageLookupByLibrary.simpleMessage("招待URLを共有する"),
    "themeInviteTitle" : MessageLookupByLibrary.simpleMessage("招待"),
    "themeInviteURL" : MessageLookupByLibrary.simpleMessage("招待URL"),
    "themeInvitedInvalidLink" : MessageLookupByLibrary.simpleMessage("このアプリリンクは使用できません"),
    "themeInvitedTitle" : MessageLookupByLibrary.simpleMessage("招待されたテーマ"),
    "themeListViewInvite" : MessageLookupByLibrary.simpleMessage("招待"),
    "themeListViewInviteDialog" : MessageLookupByLibrary.simpleMessage("招待方法を選択"),
    "themeListViewInviteDialogAllUsers" : MessageLookupByLibrary.simpleMessage("全ユーザを招待"),
    "themeListViewInviteDialogChooseUsers" : MessageLookupByLibrary.simpleMessage("招待するユーザを選択"),
    "themeListViewInvited" : m12,
    "themeListViewJoin" : MessageLookupByLibrary.simpleMessage("参加"),
    "themeListViewPost" : MessageLookupByLibrary.simpleMessage("投稿"),
    "themeMemberInvite" : MessageLookupByLibrary.simpleMessage("ユーザの招待"),
    "themeMemberInvited" : MessageLookupByLibrary.simpleMessage("招待中"),
    "themeMemberJoin" : m13,
    "themeMemberJoining" : MessageLookupByLibrary.simpleMessage("参加中"),
    "themeMemberOwner" : MessageLookupByLibrary.simpleMessage("管理者"),
    "themeMemberTitle" : MessageLookupByLibrary.simpleMessage("メンバー"),
    "themeNoInvitedTheme" : MessageLookupByLibrary.simpleMessage("招待されてる課題はありません"),
    "themeNoJoiningTheme" : MessageLookupByLibrary.simpleMessage("参加している課題はありません"),
    "themeTabInvited" : MessageLookupByLibrary.simpleMessage("招待"),
    "themeTabJoining" : MessageLookupByLibrary.simpleMessage("参加中"),
    "themeTitle" : MessageLookupByLibrary.simpleMessage("テーマ"),
    "themeUsersInvite" : MessageLookupByLibrary.simpleMessage("Invite"),
    "themeUsersNext" : MessageLookupByLibrary.simpleMessage("Next"),
    "themeUsersNoData" : MessageLookupByLibrary.simpleMessage("該当するユーザが存在しません"),
    "themeUsersTitle" : MessageLookupByLibrary.simpleMessage("招待するユーザを選択"),
    "timelineBlockUser" : MessageLookupByLibrary.simpleMessage("ブロック"),
    "timelineBlockUserDialogMessage" : MessageLookupByLibrary.simpleMessage("このユーザをブロックします。よろしいですか？"),
    "timelineNoTheme" : MessageLookupByLibrary.simpleMessage("参加しているテーマはありません"),
    "timelineReportPost" : MessageLookupByLibrary.simpleMessage("報告"),
    "timelineReportPostDialogMessage" : MessageLookupByLibrary.simpleMessage("この投稿を報告します。よろしいですか？"),
    "timelineThemeSelectionDialogTitle" : MessageLookupByLibrary.simpleMessage("表示するタイムライン"),
    "timelineTitle" : MessageLookupByLibrary.simpleMessage("タイムライン"),
    "timelineTitleWithTheme" : m14,
    "translateText" : MessageLookupByLibrary.simpleMessage("翻訳する"),
    "utilsCommentCount" : m15,
    "utilsCommentPlaceholder" : MessageLookupByLibrary.simpleMessage("コメント..."),
    "utilsDiffInDays" : m16,
    "utilsDiffInHours" : m17,
    "utilsDiffInMinutes" : m18,
    "utilsDiffInSeconds" : m19,
    "utilsSmileListViewNoData" : MessageLookupByLibrary.simpleMessage("まだ投稿がありません")
  };
}
