
//  ApiRESTUrlString.swift
//  AlimonySwift
//
//  Created by Firoze Moosakutty on 09/02/18.
//  Copyright © 2018 Firoze Moosakutty. All rights reserved.
//

import Foundation

public class ApiRESTUrlString {
    let defaults = UserDefaults.standard
    
    func getLocatiionAndIp(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@", GetLocationAndIP)
        return urlString
    }
    func GetAutoPlayAPI(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:GetAutoPlayApi + "%@",parameterDictionary["vid"]!)
       
        print("GetAutoPlayAPI",urlString)
        return urlString
    }
    func getToken(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@fcm_token=%@&app_bundle_id=%@&app_key=%@", GetToken,parameterDictionary["fcmToken"]!,parameterDictionary["app_bundle_id"]!,parameterDictionary["app_key"]!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
      print("GetToken",urlString)
        return urlString
    }
    
    func getChannels(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@", GetChannalApiUrl)
        return urlString
    }
    
    func getPopularChannels(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&pubid=%@", GetPopularChannelApiUrl,parameterDictionary["pubid"]!
        )
        return urlString
    }
    func registerWithFB() -> String!{
        let urlString = loginViaSocialMediaFb
        let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

        return escapedString
        
        }
    func linkSocialMediaAccount() -> String!{
        let urlString = linkSocialAccountFb
        return urlString
        
        }
    func getCategories(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = GetCategories
        print("GetCategories",urlString)
        return urlString
    }
    func getContinueWatchingVideos(parameterDictionary:Dictionary<String,String>!) -> String! {
     
     let urlString =  getContinueWatchingVideoUrl
     print("getContinueWatchingVideoUrl",urlString)
     return urlString
     
    }
    func getPartnerList(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&country_code=%@&pubid=%@", partnerList,parameterDictionary["country_code"]!,parameterDictionary["pubid"]!)
        
//        let urlString = String(format:"%@&pubid=%@", partnerList,parameterDictionary["pubid"]!)
        return urlString
    }
   
    func getvideoByCategory(parameterDictionary:Dictionary<String,String>!) -> String! {
        if parameterDictionary["offset"] == "0"{
            let urlString = GetvideoByCategoryWithoutOffset
            let replacedUrl = urlString.replacingOccurrences(of: "id", with: parameterDictionary["key"]!)

            print("GetvideoByCategoryWithoutOffset",replacedUrl)
            return replacedUrl

        }
        else{
            let urlString = String(format:GetvideoByCategory + "%@",parameterDictionary["offset"]!)
            let replacedUrl = urlString.replacingOccurrences(of: "id", with: parameterDictionary["key"]!)
            print("GetvideoByCategory",replacedUrl)
            return replacedUrl
        }
    }
    
    func GetPartnerByCategory(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@partner_id=%@&uid=%@&pubid=%@&country_code=%@", GetPartnerByCategory1,parameterDictionary["key"]!,parameterDictionary["user_id"]!,parameterDictionary["pubid"]!,parameterDictionary["country_code"]!)
        print("url string", urlString)
        return urlString
    }
    func getHome(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&country_code=%@", getHomeApiUrl,parameterDictionary["country_code"]!)
        return urlString
    }
    
    func getHomePopularVideos(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@uid=%@&pubid=%@", getHomePopularApiUrl,parameterDictionary["user_id"]!,parameterDictionary["pubid"]!)
        return urlString
    }
   func getHomeNewArrivals(parameterDictionary:Dictionary<String,String>!) -> String! {
    
    let urlString = String(format:"%@type=%@", getHomeNewArrivalsApiUrl,parameterDictionary["type"]!)
    print("HomeNewArrivals",urlString)
    return urlString
    
   }
    func getFilmOfTheDayVideos(parameterDictionary:Dictionary<String,String>!) -> String! {
     
     let urlString = getFilmUrl
     print("Film Url",urlString)
     return urlString
     
    }
    func getvideoList(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@key=%@&uid=%@&pubid=%@", GetvideoList,parameterDictionary["channel_id"]!,parameterDictionary["user_id"]!,parameterDictionary["pubid"]!

        )
        return urlString
    }
    
    func getSimilarVideos(parameterDictionary:Dictionary<String,String>!) -> String! {
      
        let urlString = String(format:GetSimilarVideos + "%@",parameterDictionary["video_id"]!)
       
//        let replacedUrl = urlString.replacingOccurrences(of: "id", with: parameterDictionary["vid"]!)
        print("GetSimilarVideos",urlString)
        return urlString
    }
    
    func getAllChannels(parameterDictionary:Dictionary<String,String>!) -> String! {
      
        let urlString = GetAllChannels
        print("live url",urlString)
        return urlString
    }
    
    func getFBLogin(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@facebook_id=%@", FBloginApi,parameterDictionary["facebook_id"]!)
        return urlString
    }
    func Register(parameterDictionary:Dictionary<String,String>!) -> String! {
        if parameterDictionary["ipaddress"] == nil{
            let urlString = String(format:"%@user_email=%@&password=%@&first_name=%@&last_name=%@&device_id=%@&device_type=%@&login_type=%@&facebook_id=%@&verified=%@&c_code=%@&pubid=%@", RegisterApi,parameterDictionary["user_email"]!,parameterDictionary["password"]!,parameterDictionary["first_name"]!,parameterDictionary["last_name"]!,parameterDictionary["device_id"]!,parameterDictionary["device_type"]!,parameterDictionary["login_type"]!,parameterDictionary["facebook_id"]!,parameterDictionary["verified"]!,parameterDictionary["c_code"]!,parameterDictionary["pubid"]!)
                   return urlString
        }
        else{
            let urlString = String(format:"%@user_email=%@&password=%@&first_name=%@&last_name=%@&device_id=%@&device_type=%@&login_type=%@&facebook_id=%@&verified=%@&c_code=%@&pubid=%@&ipaddress=%@", RegisterApi,parameterDictionary["user_email"]!,parameterDictionary["password"]!,parameterDictionary["first_name"]!,parameterDictionary["last_name"]!,parameterDictionary["device_id"]!,parameterDictionary["device_type"]!,parameterDictionary["login_type"]!,parameterDictionary["facebook_id"]!,parameterDictionary["verified"]!,parameterDictionary["c_code"]!,parameterDictionary["pubid"]!,parameterDictionary["ipaddress"]!)
            return urlString
        }
       
    }
    func getlogOUtUrl(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = GetLogOUtUrl
     
        return urlString
    }
  
    func loginViaSocialMedia(parameterDictionary:Dictionary<String,String>!) -> String! {
         let urlString = String(format:"%@fb_email=%@&loginType=%@&facebook_id=%@&device_id=%@&pubid=%@&ipaddress=%@&country_code=%@", loginViaSocialMediaFb,parameterDictionary["fb_email"]!,parameterDictionary["loginType"]!,parameterDictionary["facebook_id"]!,parameterDictionary["device_id"]!,parameterDictionary["pubid"]!,parameterDictionary["ipaddress"]!,parameterDictionary["country_code"]!)
         let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)


          print("loginFb",escapedString)
         return escapedString
     }
    func Login(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@user_email=%@&password=%@&pubid=%@", LoginApi,parameterDictionary["user_email"]!,parameterDictionary["password"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    func LoginNew(parameterDictionary:Dictionary<String,String>!) -> String! {
        if parameterDictionary["ipaddress"] == nil{
            let urlString = String(format:"%@user_email=%@&password=%@", LoginNewApi,parameterDictionary["user_email"]!,parameterDictionary["password"]!)
            let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)


            print("loginnew",urlString)
             print("loginnewEncoded",escapedString)
            return escapedString
        }
        else{
      let urlString = String(format:"%@user_email=%@&password=%@", LoginNewApi,parameterDictionary["user_email"]!,parameterDictionary["password"]!)
             print("loginnew",urlString)
            let escapedString = urlString.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)

                       print("loginnew",urlString)
                        print("loginnewEncoded",escapedString)
             return escapedString
        }
      
    }
    func ForgotPassword(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@user_email=%@",  ForgotpasswordApiUrl,parameterDictionary["user_email"]!)
        print("forgotassword",urlString)
        return urlString
    }
    
    func getHomeSearchResults(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@key=%@", GetSearchVideo,parameterDictionary["key"]!)
        print("searchUrl",urlString)
        return urlString
    }
    
    func getSearchResults(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@key=%@", GetSearchChannel,parameterDictionary["key"]!)
        return urlString
    }

    func getSearchSuggestion(parameterDictionary:Dictionary<String,String>!) -> String! {
      let urlString = String(format:"%@key=%@", GetSearchSuggestion,parameterDictionary["key"]!)
      return urlString
    }

    
    func getSearchlist(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&country_code=%@", GetSearchListApiUrl,parameterDictionary["country_code"]!)
        return urlString
    }
    
    func getMoreVideos(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@uid=%@&vid=%@", GetMoreVideosUrl,parameterDictionary["publisher_id"]!,parameterDictionary["video_id"]!)
        return urlString
        
    }
    
    func getVideoByID(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@video_id=%@&video_title=%@&video_description=%@&video_name=%@", GetChannalApiUrl, parameterDictionary["video_id"]!, parameterDictionary["video_title"]!,parameterDictionary["video_description"]!,parameterDictionary["video_name"]!)
        return urlString
    }
    
    func likeDislikeVideo(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@vid=%@&uid=%@&liked=%@&device_type=%@&device_type=%@", LikeVideo,parameterDictionary["vid"]!,parameterDictionary["uid"]!,parameterDictionary["liked"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func getWatchlist(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = GetWatchlistUpdated
        print("getwatchlist",urlString)
        return urlString
    }
  func getPayperview(parameterDictionary:Dictionary<String,String>!) -> String! {
         let urlString = String(format:"%@uid=%@&pubid=%@", getPayperviewUrl,parameterDictionary["user_id"]!,parameterDictionary["pubid"]!)
         return urlString
     }
    
    func getIPAddressURL(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@/%@", IPAddressUrl,parameterDictionary["ip_address"]!)
        return urlString
    }
    
    func getLanguages(parameterDictionary:Dictionary<String,String>!) -> String! {
      let urlString = String(format:"%@pubid=%@",GetLanguages,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func setLanguagePriority(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@uid=%@&lang_list=%@", SetLanguagePriority,parameterDictionary["uid"]!,parameterDictionary["lang_list"]!)
        return urlString
    }
    
    func generateToken(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&pubid=%@", GenerateToken,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func updateWatchList(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@vid=%@&uid=%@&pubid=%@", UpdateWatchList,parameterDictionary["video_id"]!,parameterDictionary["user_id"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func getFeaturedVideos(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@type=%@", GetFeaturedVideos,parameterDictionary["type"]!)

        print("GetFeaturedVideos",urlString)
        return urlString
        
    }
    func getLiveGuide(parameterDictionary:Dictionary<String,String>!) -> String! {
//        let urlString = GetFeaturedVideos
        let urlString = String(format:liveSchedule + "%@",parameterDictionary["channel_id"]!)
       
       
        print("GetFeaturedVideos",urlString)
        return urlString
        
    }
    func getDianamicHomeVideos(parameterDictionary:Dictionary<String,String>!) -> String! {
        if parameterDictionary["offset"] == "0"{
            let urlString = GetDianamicHomeWithoutOffset
            print("dynmaicHomeVideo",urlString)
            return urlString
        }
        else{
            let urlString = String(format:GetDianamicHome + "%@",parameterDictionary["offset"]!)
            print("dynmaicHomeVideo",urlString)
            return urlString
        }

        
    }
    
    func getUserLanguages(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@uid=%@&pubid=%@", GetUserLanguages,parameterDictionary["user_id"]!,parameterDictionary["pubid"]!)
        return urlString
        
    }
    
    func getAllLiveVideos(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&country_code=%@&device_type=%@@&pubid=%@", GetAllLiveVideos,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func getShows(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&pubid=%@&country_code=%@", GetShows,parameterDictionary["pubid"]!,parameterDictionary["country_code"]!)
        return urlString
    }
  func getFreeShows(parameterDictionary:Dictionary<String,String>!) -> String! {
      let urlString = String(format:"%@type=%@", GetFreeShows,parameterDictionary["type"]!)

    print("GetFreeShows",GetFreeShows)
    return urlString
  }
  func getProducerBasedShows(parameterDictionary:Dictionary<String,String>!) -> String! {
    let urlString = GetProducerBasedShows
    let replacedUrl = urlString.replacingOccurrences(of: "name", with:parameterDictionary["producer"]!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    
    print("GetProducerBasedShows",replacedUrl)
//    let urlString = String(format:"%@country_code=%@&device_type=%@&pubid=%@&producer=%@&uid=%@", GetProducerBasedShows,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!,parameterDictionary["producer"]!,parameterDictionary["user_id"]!).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
    return replacedUrl
  }
    
    func getShowVideos(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@show_id=%@&country_code=%@&device_type=%@&pubid=%@", GetShowVideos,parameterDictionary["show-id"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!)
        return urlString
    }
    
    func getSelectedVideo(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:GetSelectedVideo + "%@",parameterDictionary["vid"]!)
        print("GetSelectedVideo",urlString)
        return urlString
    }
    func getNewsDetails(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = GetNewsDetails
        let replacedUrl = urlString.replacingOccurrences(of: "id", with: parameterDictionary["news-id"]!)
        print("getNewsDetails",replacedUrl)
        return replacedUrl
    }
    func getLinearEvent(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = GetLinearEvents
        let replacedUrl = urlString.replacingOccurrences(of: "id", with: parameterDictionary["event-id"]!)
        print("GetLinearEvents",replacedUrl)
        return replacedUrl
    }
    func getChannelhome(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:GetHomeChannelvideo + "%@",parameterDictionary["channel_id"]!)
        print("get channel home",urlString)
        return urlString
    }
    
    func generateLiveToken(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@", GenerateLiveToken)
        return urlString
        
    }
    func getYTVOD(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&uid=%@&country_code=%@&device_type=%@", getYoutubeVideo,parameterDictionary["uid"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!)
        return urlString
        
    }
    func getScheduleByDate(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = (String(format:"%@&start_utc=%@&end_utc=%@&country_code=%@&device_id=%@&channel_id=%@", GetScheduleByDate,parameterDictionary["start_utc"]!,parameterDictionary["end_utc"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["channel_id"]!)).addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed)
        return urlString
        
    }
    func getUserSubscriptions(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = GetUserSubscriptions

        return urlString
    }
    func getvideoSubscriptions(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:GetvideoSubscriptions + "%@",parameterDictionary["vid"]!)
       
       
        print("getvideoSubscriptions url ",urlString)
        return urlString
    }
    func verifyOtp(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@otp=%@",verifyOtpFromEmail,parameterDictionary["otp"]!)
//
//        return urlString
       
        print("verifyOtpFromEmail",urlString)
        return urlString
    }
   func resendOtp(parameterDictionary:Dictionary<String,String>!) -> String! {
       let urlString =  resendOtp1

       return urlString
   }
    func getchannelSubscriptions(parameterDictionary:Dictionary<String,String>!) -> String! {
       
        let urlString = String(format:"%@", GetchannelSubscriptions)

        return urlString
    }
    func checkPhoneVerification(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&uid=%@&device_id=%@&pubid=%@&country_code=%@", CheckPhoneVerification,parameterDictionary["user_id"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!,parameterDictionary["country_code"]!)
        return urlString
    }
    func verifyPhoneNumber(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&uid=%@&device_id=%@&pubid=%@&country_code=%@&phone=%@&c_code=%@", VerifyPhoneNumber,parameterDictionary["uid"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!,parameterDictionary["country_code"]!,parameterDictionary["phone"]!,parameterDictionary["c_code"]!)
        return urlString
    }
    func subscriptionTransaction(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@&uid=%@&device_type=%@&pubid=%@&country_code=%@&subscription_id=%@&transaction_type=%@&status=%@&amount=%@&mode_of_payment=%@&purchase_token=%@&product_id=%@", SubscriptionTransaction,parameterDictionary["uid"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!,parameterDictionary["country_code"]!,parameterDictionary["subscription_id"]!,parameterDictionary["transaction_type"]!,parameterDictionary["status"]!,parameterDictionary["amount"]!,parameterDictionary["mode_of_payment"]!,parameterDictionary["purchase_token"]!,parameterDictionary["product_id"]!)
        return urlString
    }
    func getPubID(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@app_bundle_id=%@&app_key=%@", GetPubID,parameterDictionary["app_publisher_bundle_id"]!,parameterDictionary["app_key"]!)
        print("pubid url",urlString)
        return urlString
    }
    
    func getlogOUtAllUrl(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = GetLogOUtAllUrl
     
        return urlString
    }
    func getShowData(parameterDictionary:Dictionary<String,String>!) -> String! {
    let urlString = GetShowNameData
    let replacedUrl = urlString.replacingOccurrences(of: "id", with: parameterDictionary["show-id"]!)
    print("GetShowNameData",replacedUrl)
    return replacedUrl
  }
    func getWatchlistShows(parameterDictionary:Dictionary<String,String>!) -> String! {

        let urlString = String(format:GetWatchlistShows + "%@/%@",parameterDictionary["show-id"]!,parameterDictionary["watchlistflag"]!)
        print("GetWatchlistShows",urlString)
        return urlString
        
        

//       let urlString = String(format:"%@watchlistflag=%@&deletestatus=%@", GetWatchlistShows,parameterDictionary["show-id"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!,parameterDictionary["watchlistflag"]!,parameterDictionary["userId"]!,parameterDictionary["deletestatus"]!)
//       return urlString
     }
    func getLikedShows(parameterDictionary:Dictionary<String,String>!) -> String! {
       
        let urlString = String(format:GetLikedtShows + "%@/%@",parameterDictionary["show-id"]!,parameterDictionary["likeflag"]!)
        print("GetLikedShows",urlString)
        return urlString
      }
    func getdisLikedShows(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:GetdisLikedShows + "%@/%@",parameterDictionary["show-id"]!,parameterDictionary["dislikFlag"]!)
        print("GetdisLikedShows",urlString)
        return urlString
//           let urlString = String(format:"%@show_id=%@&country_code=%@&device_type=%@&pubid=%@&disliked=%@&uid=%@&version=%@", GetLikedtShows,parameterDictionary["show-id"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!,parameterDictionary["dislikFlag"]!,parameterDictionary["userId"]!,parameterDictionary["version"]!
//           )
//           return urlString
         }
    func getLikeList(parameterDictionary:Dictionary<String,String>!) -> String! {
           let urlString =  GetLikeList
           return urlString
       }
    func getLikeFlag(parameterDictionary:Dictionary<String,String>!) -> String! {
           
        let urlString = getLikedFlag
        
        let replacedUrl = urlString.replacingOccurrences(of: "id", with: parameterDictionary["show-id"]!)
        print("getLikedFlag",replacedUrl)
        return replacedUrl
        }
    func getWatchFlag(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = getWatchListFlag
        
        let replacedUrl = urlString.replacingOccurrences(of: "id", with: parameterDictionary["show-id"]!)
        print("getWatchListFlag",replacedUrl)
        return replacedUrl
//             let urlString = String(format:"%@uid=%@&country_code=%@&device_type=%@&pubid=%@&show_id=%@", getWatchListFlag,parameterDictionary["userId"]!,parameterDictionary["country_code"]!,parameterDictionary["device_type"]!,parameterDictionary["pubid"]!,parameterDictionary["show-id"]!)
//             return urlString
         }
    func getSchedule(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = String(format:"%@country_code=%@&pubid=%@&channelid=%@&date=%@", getSchedulechannels,parameterDictionary["country_code"]!,parameterDictionary["pubid"]!,parameterDictionary["channel_id"]!,parameterDictionary["date"]!)
        return urlString
    }
  func getUserDeleteApi(parameterDictionary:Dictionary<String,String>!) -> String! {
        let urlString = GetDeleteUserApi
    print("user delete url",urlString)
        return urlString
    }
}

