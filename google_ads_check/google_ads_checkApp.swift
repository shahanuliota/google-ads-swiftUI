//
//  google_ads_checkApp.swift
//  google_ads_check
//
//  Created by Shahanul on 16/7/23.
//

import SwiftUI
import GoogleMobileAds
import FBAudienceNetwork

import AppTrackingTransparency

@main
struct google_ads_checkApp: App {
    let persistenceController = PersistenceController.shared
    
  
    
    var body: some Scene {
        WindowGroup {
            AdsTestView().task {
                //getData()
            }
            // .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
    
    init() {
            if ATTrackingManager.trackingAuthorizationStatus == .notDetermined {
                //User has not indicated their choice for app tracking
                //You may want to show a pop-up explaining why you are collecting their data
                //Toggle any variables to do this here
            } else {
                ATTrackingManager.requestTrackingAuthorization { status in
                    //Whether or not user has opted in initialize GADMobileAds here it will handle the rest
                                                                
                    GADMobileAds.sharedInstance().start(completionHandler: nil)
                    FBAdSettings.setAdvertiserTrackingEnabled(true)
                }
            }
        }
    
    func getData() {
        
        Task
        {
            do{
                
                print("calling api")
                
                let baseURL = URL(string: "https://jsonplaceholder.typicode.com/")
                guard let baseURL = baseURL else{
                    return
                }
                
                let client: IHttpConnect = DefaultHttpConnect(baseURL: baseURL)
                
                
                let query:  [String: String] = [
                    "hello": "ok",
                    "masud": "valona"
                    
                ]
                print("query count => \(query.count)")
                
                let res: AppResponse<[Post]> = try await client.get("/posts" , headers: [:],
                                                                    query:query
                                                                    
                )
                print(res.statusCode)
                print(res.payload)
                
                //                for item in res.payload ?? []
                //                {
                //                    print(item)
                //                }
                
                
            }catch{
                
                print(error)
                print(Thread.callStackSymbols)
                
              
            
            }
            
            
        }
        
    }
    
}

struct Post : Codable, CustomStringConvertible {
    let userID, id: Int?
    let title, body: String?
    
    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
    
    var description: String {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            let jsonData = try encoder.encode(self)
            
            if let jsonString = String(data: jsonData, encoding: .utf8) {
                return jsonString
            }
        } catch {
            print("Error encoding to JSON: \(error)")
        }
        
        return ""
    }
}
