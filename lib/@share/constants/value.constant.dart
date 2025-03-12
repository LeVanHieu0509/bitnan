const kBearer = 'Bearer';
const kAuthorization = 'Authorization';
const kApiVersion = 'X-API-Version';
const kAuthorizationGame = 'X-Authentication-Token';

/// Is running with Production or UAT API
const kIsEnvProd = String.fromEnvironment('BITBACK_ENV') == 'PROD';

const kContentType = 'application/json; charset=utf-8';
const kContentTypeMultipart = 'multipart/form-data';
const kUrlVndc = 'https://signup.goonus.io/6277729707018590110';
const kUrlGame = 'http://bitplay.bitback.community/';

const prodServer = 'https://api.bitback.community/';
const uatServer = 'https://api-uat.bitback.community/';

const kDefaultHeightAlphabet = 14.0;
const kTypeSignInApple = 'kTypeSignInApple';

const kMaxSizeVideo = 20 * 1024 * 1024;

const kTimeOut = 20;
const kAuthRetry = 1;
const kSuccessApi = 200;

const kMaxPhoneNumber = 10;
const kMaxPassword = 6;
const kMaxTimeOutOtp = 120;
const kMaxTimeOutOtpEmail = 60 * 3; // 3 min

const kNullTab = -1;
const kTabHome = 0;
const kTabHistory = 1;
const kTabPlay = 2;
const kTabAbout = 3;
const kTabGiftBag = 4;
const kTabLaunchpad = 5;

const kTabMain = 0;
const kTabFarm = 1;
const kTabMarket = 2;
const kTabHistoryFarm = 3;
const kTabFarmRanking = 4;
const kTabFarmOther = 5;

// const kTabCollect = 4;
// const kTabEvent = 5;

const kFirstStep = 1;
const kSecondStep = 2;
const kTypeBalance = 0;
const kTypeReward = 1;
const kTypeAvailablePromo = 0;
const kTypeExpirePromo = 1;

const kTypeKycLoading = -1;
const kTypeKycEmpty = 0;
const kTypeKycPending = 1;
const kTypeKycApproved = 2;
const kTypeKycReject = 3;
const kTypeKycRejectPhoto = 4;
const kTypeKycRejectVideo = 5;

//detail transaction
const kTypeConfirmOffChain = 0;
const kTypeDetailOffChain = 1;

const kTypeConfirmOnChain = 2;
const kTypeDetailOnChain = 3;

const kNotifyWithdrawal = 0;
const kNotifyRecharge = 1;
const kNotifyPayment = 2;
const kNotifyBuyVoucher = 3;
const kNotifyTransfers = 4;
const kNotifyTransferCoin = 5;
const kNotifyEkycIdentifier = 6;
const kNotifyDeposit = 7;
const kNotifyDailyReward = 8;
const kNotifyEventGame = 13;
const kNotifyRechargePayme = 10;

//Check KYC
const kTypePending = 1;
const kTypeApproved = 2;

const kCameraBack = '0';
const kCameraFront = '1';

const kTypeSignUpSuccess = 'kTypeSignInSuccess';
const kTypeSendInfoSuccess = 'kTypeSendInfoSuccess';
const kTypeGiveCoin = 'kTypeGiveCoin';
const kTypeChangePass = 'kTypeChangePass';
const kTypeVoucher = 'kTypeVoucher';
const kTypeCreateCart = 'kTypeCreateCart';
const kTypeSlowlyButSurely = 'kTypeSlowlyButSurely';

const kTypeSignUpPass = 'kTypeCreatePass';
const kTypeForgotPass = 'kTypeResetPass';

const kTypeIdentityCard = 'kTypeIdentityCard';
const kTypeCitizenIdentity = 'kTypeCitizenIdentity';
const kTypePassport = 'kTypePassport';

const kTypeSendOn = 'kTypeSendOn';
const kTypeSendOff = 'kTypeSendOff';

const kTypeDepositByMyCard = 'kTypeDepositByMyCard';
const kTypeDepositByATM = 'kTypeDepositByATM';
const kTypeDepositByMoMoPay = 'kTypeDepositByMoMoPay';
const kTypeDepositByZaLoPay = 'kTypeDepositByZaLoPay';
const kTypeDepositByBank = 'kTypeDepositByBank';
const kTypePayme = 'kTypePayme';
const kTypeWithdrawalByMyCard = 'kTypeWithdrawalByMyCard';
const kTypeWithdrawalByATM = 'kTypeWithdrawalByATM';
const kTypeWithdrawalByBank = 'kTypeWithdrawalByBank';
const kTypeTransferContact = 'kTypeTransferContact';
const kTypeTransferBank = 'kTypeTransferBank';
const kTypeTransactionByQR = 'kTypeTransactionByQR';
const kTypeTransactionByScan = 'kTypeTransactionByScan';
const kTypeVNDC = 'VNDC';
const kTypeKai = 'KAI';

//screenType
const kTypeIdentifyScreen = 'kTypeIdentifyScreen';
const kTypeIdentifyConfirmScreen = 'kTypeIdentifyConfirmScreen';
const kTypeVerifyEkycScreen = 'kTypeVerifyEkycScreen';
const kTypeRewardScreen = 'kTypeRewardScreen';

const kTypeSignInScreen = 'kTypeSignInScreen';
const kTypeSignUpScreen = 'kTypeSignUpScreen';
const kTypeBlockChainDetailScreen = 'kTypeBlockChainDetailScreen';
const kTypeVerifyScreen = 'kTypeVerifyScreen';
const kTypeVerifyEmailScreen = 'kTypeVerifyEmailScreen';
const kTypeTransferScreen = 'kTypeTransferScreen';
const kTypePersonScreen = 'kTypePersonScreen';

//
const kTypeAssociateCard = 'kTypeAssociateCard';
const kTypeCancelAssociateCard = 'kTypeCancelAssociateCard';
const kTypeSelectForAssociate = 'kTypeSelectForAssociate';
const kTypeSelectForSendViaBank = 'kTypeSendViaBank';

//Type Share
const kTypeShareNormal = 'kTypeShareNormal';
const kTypeShareFaceBook = 'kTypeShareFaceBook';

//type image
const kImageAssets = 'assets';
const kImageNetwork = 'http';

//type card detail
const kTypeCardTrustPayDetail = 'kTypeCardTrustPayDetail';
const kTypeCardAssociateDetail = 'kTypeCardAssociateDetail';

// format
const kZero = '0';
const kFormatThousand = '000';
const kFormat10000 = '0000';
const kFormat100000 = '00000';
const kFormatMillion = '000000';
const minAmount = 200000.00;
const minTransferAmount = 20000;
const kMinAmount = '200,000 VNDC';
const kMaxAmount = '2000.000.000 VNDC';
const kFee = '0 VNDC';

const kHistorySuccess = 0;
const kHistoryPending = 1;
const kHistoryError = -1;
const kTypeOnChain = 1;
const kTypeOffChain = 2;
const kTypePayment = 3;
const kTypeReferFrom = 4;
const kTypeReferBy = 5;
const kTypeKYC = 6;
const kTypeTransaction = '1';
const kTypeCashBack = '2';
const kTransferDeposit = 1;
const kTransferPayment = 2;
const kTransferWithdraw = 3;
const kTypeProcessing = 1;
const kTypeSuccess = 2;
const kTypeFailure = 3;
const kTypeRejected = 4;
const kApproved = 5;

//type upload
const kUploadProfile = 1;
const kUploadKYC = 2;

//type Category
const kTypeAll = '0';
const kTypeMarket = '1';
const kTypeStudy = '2';
const kTypeHotel = '3';
const kTypeTour = '4';
const kTypeTicket = '5';
const kTypeFashion = '6';
const kTypeTechnical = '7';
const kTypeMakeUp = '8';
const kTypeFood = '9';
const kTypeBook = '10';
const kTypeOnline = '11';

//type sort
const kTypePopular = '1';
const kTypeUp = '2';
const kTypeDown = '3';
const kTypeHighCashBack = '4';

//type otp request
const kTypeApiSignUp = '1';
const kTypeApiCashBack = '2';
const kTypeApiPayment = '3';
const kTypeApiResetPassword = '4';
const kTypeApiVerifyEmail = '5';

//PayMe

const kKycApproved = 'KYC_APPROVED';
const kNotKYC = 'NOT_KYC';
const kUnActivated = 'NOT_ACTIVATED';
const kKycReview = 'KYC_REVIEW';
const kKYCReject = 'KYC_REJECTED';
const kLOCK_KYC = 'LOCK_KYC';

const kKycStatus = 2;
const kKycReject = 3;
const kApprovedUser = 'APPROVED';
const kRejectUser = 'REJECTED';
const kTypeOther = 'kTypeOther';
const kTypeHome = 'kTypeHome';
const KPaymeConfig = 'PAYME_CONFIG';
const kPayAmount = 'kPayAmount';
const kTranfersAmount = 'kTranfersAmount';
const kExchangeAmount = 'kExchangeAmount';

const SYSTEM_MAINTAIN = 'system_maintain';
const CHANGE_SYSTEM = 'change_system';
const SUPPORT_FANPAGE = 'support_fanpage';
const SUPPORT_ZALO = 'support_zalo';
const SUPPORT_TELE = 'support_telegram';
const SUPPORT_TW = 'support_twitter';
const SUPPORT_YT = 'support_youtube';
const SUPPORT_TT = 'support_tiktok';
const SUPPORT_BR = 'support_browser';
const BASE_URL = 'base_url';
const BASE_URL_GAME = 'base_url_game';
const SUPPORT_LEADER_BOARD = 'referral_leaderboard';

const ANDROID_AD_UNIT_ID = 'android_ad_unit_id';
const IOS_AD_UNIT_ID = 'ios_ad_unit_id';

const kTransferSat = '1';
const kTransferVNDC = '2';
const kTransferFAM = '3';
const kTransferBami = '4';
const kTransferKardiaChain = '5';
const kTransferAttlas = '6';

const kTypeEgg = 0;
const kTypeRooster = 1;
const kTypeChicken = 2;
const kTypeBreed = 3;

const kIndexEgg = 0;
const kIndexEggRooster = 1;
const kIndexChicken = 2;
const kIndexRooster = 3;
const kIndexBreed = 4;

const kBuyTypeEgg = 1;
const kBuyTypeRoosterEgg = 2;

const kNotiSystem = 21;

const kMinimumDeposit = 100000;
const kMaximumDeposit = 50000000;

const kHeightButton = 48.0;
const kPaddingTopButton = 32.0;
const kHalfTopButton = 16.0;

const kTitlePayme = 'Payme';
const kTitleCreditCard = 'Internet Banking';
const kTitleLockAccount = 'Tài khoản hiện đã bị khoá';
const SessionGameEnd = 'Your session had been ended';
const InsufficientBBCBalance =
    'Insufficient BBC balance. Please come to BitBack Wallet to topup before playing!';

const NEW = 'NEW';
const PROCESSING = 'PROCESSING';
const FINISH = 'FINISH';
const CANCELED = 'CANCELED';

const bitlotError = {
  'LUCKY_NUMBER_ALREADY_USED':
      'Rất tiếc, số này đã được sử dụng, vui lòng chọn số ngẫu nhiên khác.',
  'EVENT_TIME_END_INVALID': 'Sự kiện hiện tại đã kết thúc',
  'CANNOT_CLAIM_LUCK_NUMBER': 'Không thể nhận thêm vé',
  'CANNOT_CLAIM_BUY_TICKET': 'Bạn đã hết lượt mua vé',
  'CANNOT_CLAIM_FREE_TICKET': 'Bạn đã hết lượt nhận vé miễn phí',
  'CANNOT_CLAIM_ADS_TICKET': 'Bạn đã hết lượt nhận vé thông qua xem quảng cáo',
  'BALANCE_CANNOT_CLAIM_LUCK_NUMBER': 'Bạn không đủ BBC để mua vé'
};
