import Foundation

let kDuration = 0.15


// DFP content path
let kDFPContentPath = "http://rmcdn.2mdn.net/Demo/html5/output.mp4";

// Android content path
let kAndroidContentPath = "https://s0.2mdn.net/instream/videoplayer/media/android.mp4";

// Big buck bunny content path
let kBigBuckBunnyContentPath = "http://googleimadev-vh.akamaihd.net/i/big_buck_bunny/" +
    "bbb-,480p,720p,1080p,.mov.csmil/master.m3u8";

// Bip bop content path
let kBipBopContentPath = "http://devimages.apple.com/iphone/samples/bipbop/bipbopall.m3u8";

// Standard pre-roll
let kPrerollTag =
    "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
    "iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&" +
    "output=vast&unviewed_position_start=1&cust_params=deployment%3Ddevsite%26sample_ct%3Dlinear&" +
    "correlator=";

// Skippable
let kSkippableTag =
    "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
    "iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&" +
    "output=vast&unviewed_position_start=1&" +
    "cust_params=deployment%3Ddevsite%26sample_ct%3Dskippablelinear&correlator=";

// Post-roll
let kPostrollTag =
    "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
    "iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&" +
    "output=vmap&unviewed_position_start=1&" +
    "cust_params=deployment%3Ddevsite%26sample_ar%3Dpostonly&cmsid=496&vid=short_onecue&" +
    "correlator=";

// Ad rues
let kAdRulesTag =
    "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
    "iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&" +
    "output=vast&unviewed_position_start=1&" +
    "cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpost&cmsid=496&vid=short_onecue&" +
    "correlator=";

// Ad rules pods
let kAdRulesPodsTag =
    "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
    "iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&" +
    "output=vast&unviewed_position_start=1&" +
    "cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostpod&cmsid=496&vid=short_onecue&" +
    "correlator=";

// VMAP pods
let kVMAPPodsTag =
    "https://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
    "iu=/124319096/external/ad_rule_samples&ciu_szs=300x250&ad_rule=1&impl=s&gdfp_req=1&env=vp&" +
    "output=vmap&unviewed_position_start=1&" +
    "cust_params=deployment%3Ddevsite%26sample_ar%3Dpremidpostpod&cmsid=496&vid=short_onecue&" +
    "correlator=";

// Wrapper
let kWrapperTag =
    "http://pubads.g.doubleclick.net/gampad/ads?sz=640x480&" +
    "iu=/124319096/external/single_ad_samples&ciu_szs=300x250&impl=s&gdfp_req=1&env=vp&" +
    "output=vast&unviewed_position_start=1&" +
    "cust_params=deployment%3Ddevsite%26sample_ct%3Dredirectlinear&correlator=";

// AdSense
let kAdSenseTag =
    "http://googleads.g.doubleclick.net/pagead/ads?client=ca-video-afvtest&ad_type=video";

let IPAddressUrl = "http://freegeoip.net/json"
//let GetChannalApiUrl = "http://128.199.118.56/Testwrk/videoapp/index.php/Video_api_c/Getvideo"
//let GetSearchResultsApiUrl = "http://128.199.118.56/Testwrk/videoapp/index.php/Video_api_c/Searchvideo?"
//let GetSearchListApiUrl = "http://128.199.118.56/Testwrk/videoapp/index.php/Video_api_c/Searchlist"
//let GetSearchListApiUrl = "http://128.199.118.56/Testwrk/videoapp/index.php/Video_api_c/Similarvideo?"

let GetChannalApiUrl = "http://128.199.118.56/Testwrk/poppo_tv/index.php/Video_api_c/Getvideo"
let GetSearchResultsApiUrl = "http://128.199.118.56/Testwrk/poppo_tv/index.php/Video_api_c/Searchvideo?"
let GetSearchListApiUrl = "http://128.199.118.56/Testwrk/poppo_tv/index.php/Video_api_c/Searchlist?"
let GetMoreVideosUrl = "http://128.199.118.56/Testwrk/poppo_tv/index.php/Video_api_c/Similarvideo?"
//let commonAPI = "https://poppo.tv/proxy/v2"
//let commonAPI = "https://poppo.tv/platform/dev/"
let commonBkAPI = "https://api.gizmott.com/api/v1/"
//let commonBkAPI = "https://staging.poppo.tv/test/api/"

let commonAPI = "https://poppo.tv/proxy/"
let tokenAPI = "https://poppo.tv/platform/bk/"

//let commonBkAPI = "https://staging.poppo.tv/platform/bk/"

let thumbNailPath = "http://128.199.118.56/Testwrk/videoapp/uploads/thumbnail"
let videoPath = "http://128.199.118.56/Testwrk/videoapp/uploads/video"
let publisherImagePath = "http://128.199.118.56/Testwrk/videoapp/uploads/picture"
let getHomeApiUrl = commonBkAPI + "api/Home?"
let GetvideoList = commonBkAPI + "api/GetVodtoLivevideos?"
let GetAllChannels = commonBkAPI + "channel/list"
let GetSearchChannel = commonBkAPI + "api/Searchchannel?"
let GetHomeSearch = commonBkAPI + "api/SearchVideo?"
let RegisterApi = commonBkAPI + "account/register?"
let verifyOtpFromEmail = commonBkAPI + "account/otp/verify?"
let resendOtp1 = commonBkAPI + "account/otp/resend?"
//let loginViaSocialMediaFb = commonBkAPI + "loginViaSocialMedia?"
//let linkSocialAccountFb = commonBkAPI + "linkSocialAccount?"
let loginViaSocialMediaApple = commonBkAPI + "loginViaSocialMedia?"
let GetSearchSuggestion = commonBkAPI + "search/suggestions?"




let LoginApi = commonBkAPI + "Login?"
let LoginNewApi = commonBkAPI + "account/login?"

let FBloginApi = commonBkAPI + "FBLogin?"

let LikeVideo = commonBkAPI + "api/LikeVideo?"
let GetWatchlist = commonBkAPI + "api/GetWatchlist?"
let GetWatchlistUpdated = commonBkAPI + "show/watchlist"
//let getPayperviewUrl = commonBkAPI + "api/getPayperview?"
let getPayperviewUrl = commonBkAPI + "api/getSubscribedVideos?"


let SetLanguagePriority = commonBkAPI + "api/SetLanguagePriority?"
let GenerateToken = commonAPI + "api/GenerateToken?"
let UpdateWatchList = commonBkAPI + "api/updateWatchlist?"
let GetFeaturedVideos = commonBkAPI + "video/featured?"
let GetLocationAndIP = "https://extreme-ip-lookup.com/json"
let GetToken = commonBkAPI + "account/authenticate?"
let GetPopularChannelApiUrl = commonBkAPI + "api/PopularChannels?"
let ForgotpasswordApiUrl = commonBkAPI + "account/passwordReset?"
let GetAutoPlayApi = commonBkAPI + "video/autoplay/"

let GetAllLiveVideos = commonBkAPI + "api/GetAllLiveVideos?"
let GetShows = commonBkAPI + "api/getShows?"
let GetShowVideos = commonBkAPI + "api/getShowVideos?"
let GetGustUserLogin = commonBkAPI + "account/register/guest"
let LoginRemoval = commonBkAPI + "api/LoginRemoval"
let GetHomeChannelvideo = commonBkAPI + "channel/"
let GenerateLiveToken = commonAPI + "api/GenerateTokenLive"
let getYoutubeVideo = commonBkAPI + "api/getYTVOD?"
let GetScheduleByDate = commonBkAPI + "api/getScheduleByDate?"
let GetUserSubscriptions = commonBkAPI + "subscription/user?"
let ActivateTvApi = commonBkAPI + "user/code/generate?"
let loginViaSocialMediaFb = commonBkAPI + "account/social/loginWithoutCode?"
let linkSocialAccountFb = commonBkAPI + "account/social/link?"

let CheckPhoneVerification = commonBkAPI + "api/checkPhoneVerification?"
//let GetvideoSubscriptions = commonAPI + "api/GetvideoSubscriptions?"
//let GetchannelSubscriptions = commonAPI + "api/GetchannelSubscriptions?"

let GetvideoSubscriptions = commonBkAPI + "subscription/active?video_id="
let GetchannelSubscriptions = commonBkAPI + "subscription/channel"

let VerifyPhoneNumber = commonBkAPI + "api/verifyPhoneNumber?"
let SubscriptionTransaction = commonBkAPI +  "subscription/updateTransaction"
let GetPubID = commonBkAPI +  "publisher/id?"

let GetSelectedVideo = commonBkAPI + "video/"
let getFilmUrl = commonBkAPI + "show/filmoftheweek/list?"
let getHomeNewArrivalsApiUrl = commonBkAPI + "show/newarrivals/list?"
let GetvideoByCategory = commonBkAPI + "category/id/shows/list?offset="
let GetvideoByCategoryWithoutOffset = commonBkAPI + "category/id/shows/list?"

let GetPartnerByCategory1 = commonBkAPI + "api/partnerVideosByShows?"

//let GetDianamicHome = "https://staging.poppo.tv/test/api/show/list?offset="
let GetDianamicHome = commonBkAPI + "show/list?offset="
let GetDianamicHomeWithoutOffset = commonBkAPI + "show/list?"

let GetNewsDetails = commonBkAPI + "show/id?"
let GetLinearEvents = commonBkAPI + "linearEvent/id?"


let GetSearchVideo = commonBkAPI + "search/shows?"
let GetSimilarVideos = commonBkAPI + "show/similar/"
let getHomePopularApiUrl = commonBkAPI + "api/PopularVideosUpdated?"
let GetCategories = commonBkAPI + "category/list?"
let partnerList = commonBkAPI + "api/partnerList?"
let getContinueWatchingVideoUrl =  commonBkAPI + "show/continueWatching/list"

let liveSchedule = commonBkAPI + "schedule/guide/"

let GetProducerBasedShows = commonBkAPI + "show/producer/name"
let GetFreeShows = commonBkAPI + "show/free/list?"
let GetUserLanguages = commonBkAPI + "api/GetUserLanguages?"
let GetLanguages = commonBkAPI + "api/GetallLanguagesAusflix?"
let GetShowNameData = commonBkAPI + "show/id?"

let GetWatchlistShows = commonBkAPI + "watchlist/show/"
let GetLikedtShows = commonBkAPI + "like/show/"
let GetdisLikedShows = commonBkAPI + "dislike/show/"

let GetLikeList = commonBkAPI + "like/show"
let getWatchListFlag = commonBkAPI + "watchlist/show/id"
   
let getLikedFlag = commonBkAPI + "like/show/id"
let getSchedulechannels = commonBkAPI + "api/GetSchedule?"

let GetLogOUtAllUrl = commonBkAPI +  "account/logoutall"
//let GetLogOUtUrl = commonBkAPI +  "Logoutuser?"

let GetLogOUtUrl = commonBkAPI +  "account/logout?"

// Fonts
let FontRegular = "Montserrat-Regular"
let FontLight = "Montserrat-Light"
let FontBold = "Montserrat-Bold"
let FontExtraBold = "Montserrat-ExtraBold"
let FontBlack = "Montserrat-Black"
let FontExtraLight = "Montserrat-ExtraLight"
let FontMedium = "Montserrat-Medium"
let FontSemiBold = "Montserrat-SemiBold"
let FontThin = "Montserrat-Thin"

////image
// let imageUrl = "http://54.172.215.215/poppo_tv/thumbnails/"
//let channelUrl  = "http://54.172.215.215/poppo_tv/images/"
//let languageUrl  = "http://54.172.215.215/poppo_tv/language_icons/"
//let showUrl = "http://54.172.215.215/poppo_tv/show_logo/"

//image
let imageUrl = "https://gizmeon.s.llnwi.net/vod/thumbnails/thumbnails/"
//let showUrl = "https://gizmeon.s.llnwi.net/vod/thumbnails/show_logo/"
let channelUrl  = "https://gizmeon.s.llnwi.net/vod/thumbnails/images/"
let languageUrl  = "https://gizmeon.s.llnwi.net/vod/thumbnails/language_icons/"
let showUrl1 = "https://gizmeon.s.llnwi.net/vod/thumbnails/show_logo/"
let showUrl = "https://gizmeon.s.llnwi.net/vod/thumbnails/thumbnails/"

let youtubeUrl = "https://gizmeon.s.llnwi.net/vod/thumbnails/images/"


let videoThumbUrl = "https://gizmeon.s.llnwi.net/vod/thumbnails/logo_thumb/"

//Analaytics

let APP_LAUNCH = "https://analytics.poppo.tv/device"
let eventAPI = "https://analytics.poppo.tv/event"
let GetDeleteUserApi = commonBkAPI + "user/delete/"
