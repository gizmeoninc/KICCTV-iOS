//
//  VersionCheckApi.swift
//  Justwatchme.tv
//
//  Created by GIZMEON on 22/09/21.
//  Copyright © 2021 Gizmeon. All rights reserved.
//

import Foundation

import UIKit
enum VersionError: Error {
    case invalidBundleInfo, invalidResponse
}

class LookupResult: Decodable {
    var results: [AppInfo]
}

class AppInfo: Decodable {
    var version: String
    var trackViewUrl: String
}

public class CheckAppstoreUpdate{
    
    
    
    static func getAppInfo(completion: @escaping (AppInfo?, Error?) -> Void) -> URLSessionDataTask? {
        
        guard let identifier = self.getBundle(key: "CFBundleIdentifier"),
              let url = URL(string: "http://itunes.apple.com/lookup?bundleId=\(identifier)") else {
            DispatchQueue.main.async {
                completion(nil, VersionError.invalidBundleInfo)
            }
            return nil
        }
        print("appstore url",url)
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            
            
            do {
                if let error = error { throw error }
                guard let data = data else { throw VersionError.invalidResponse }
                
                let result = try JSONDecoder().decode(LookupResult.self, from: data)
                print(result.results)
                guard let info = result.results.first else {
                    throw VersionError.invalidResponse
                }
                
                completion(info, nil)
            } catch {
                completion(nil, error)
            }
        }
        
        task.resume()
        return task
        
    }
    
    static func getBundle(key: String) -> String? {
        
        guard let filePath = Bundle.main.path(forResource: "Info", ofType: "plist") else {
            fatalError("Couldn't find file 'Info.plist'.")
        }
        // 2 - Add the file to a dictionary
        let plist = NSDictionary(contentsOfFile: filePath)
        // Check if the variable on plist exists
        guard let value = plist?.object(forKey: key) as? String else {
            fatalError("Couldn't find key '\(key)' in 'Info.plist'.")
        }
        return value
    }
}

