//
//  ApiCallManager.swift
//  OfferCloud_Swift
//
//  Created by Rukmini KR on 26/11/17.
//  Copyright © 2017 Rukmini KR. All rights reserved.
//

import Foundation
public class ApiCallManager {
    //  MARK: normal API call REST
    static func apiCallREST(mainUrl : String, httpMethod: String, headers:Dictionary<String,String>!, postData:Data!, callback:@escaping (Dictionary<String,AnyObject>) -> Void) -> Void {
        let request = NSMutableURLRequest(url: NSURL(string: mainUrl)! as URL,
                                          cachePolicy: NSURLRequest.CachePolicy.reloadIgnoringLocalAndRemoteCacheData,
                                          timeoutInterval: 10.0)
        
        request.httpMethod = httpMethod
        if headers != nil {
            request.allHTTPHeaderFields = headers
        }
        if postData != nil {
            request.httpBody = postData
        }
        let session = URLSession.shared
        let dataTask = session.dataTask(with: request as URLRequest, completionHandler: { (data, response, error) -> Void in
            if error != nil {
            } else {
                do {
                    let jsonArray = try JSONSerialization.jsonObject(with: data!, options:[])
                    callback(jsonArray as! Dictionary<String, AnyObject>)
                } catch {
                    print("Error: \(error)")
                }
                
            }
        })
        dataTask.resume()
    }
}
    //  MARK: API call with file upload

