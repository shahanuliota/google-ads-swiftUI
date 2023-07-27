//
//  RewardedAd.swift
//  google_ads_check
//
//  Created by Shahanul on 18/7/23.
//

import Foundation
import GoogleMobileAds
import SwiftUI
import UIKit

class RewardedAd: NSObject {
    var rewardedAd: GADRewardedAd?
    
    static let shared = RewardedAd()
    
    func loadAd(withAdUnitId id: String) {
        let req = GADRequest()
        GADRewardedAd.load(withAdUnitID: id, request: req) { rewardedAd, err in
            if let err = err {
                print("Failed to load ad with error: \(err)")
                return
            }
            
            self.rewardedAd = rewardedAd
        }
    }
}

struct RewardedAdView:  UIViewControllerRepresentable {
    
    let rewardedAd = RewardedAd.shared.rewardedAd
    @Binding var isPresented: Bool
    let adUnitId: String
    
    //This is the variable for our reward function
    let rewardFunc: (() -> Void)
    
    init(isPresented: Binding<Bool>, adUnitId: String, rewardFunc: @escaping (() -> Void)) {
        self._isPresented = isPresented
        self.adUnitId = adUnitId
        self.rewardFunc = rewardFunc
        
        InterstitialAd.shared.loadAd(withAdUnitId: adUnitId)
        
       
    }
    
    func makeUIViewController(context: Context) -> UIViewController {
        let view = UIViewController()
        rewardedAd?.fullScreenContentDelegate = context.coordinator

        DispatchQueue.main.asyncAfter(deadline: .now() + .milliseconds(1)) {
            self.showAd(from: view)
        }
        
        return view
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
    
    
    func makeCoordinator() -> Coordinator {
        return Coordinator(isPresented: self.$isPresented,adUnitId: adUnitId )
    }
    
    
    class Coordinator: NSObject, GADFullScreenContentDelegate{
        
        @Binding var isPresented: Bool
        var adUnitId: String
        
        
        init(isPresented: Binding<Bool>, adUnitId: String) {
            self._isPresented = isPresented
            self.adUnitId = adUnitId
        }
        
        func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
            RewardedAd.shared.loadAd(withAdUnitId: adUnitId)
            
            isPresented.toggle()
        }
    }
    
    
    func showAd(from root: UIViewController) {
        
        if let ad = rewardedAd {
            ad.present(fromRootViewController: root) {
                //This calls the reward function once the ad has been played for long enough
                self.rewardFunc()
            }
        } else {
            print("Ad not ready")
            self.isPresented.toggle()
        }
    }
    
   
}
struct FullScreenModifier<Parent: View>: View {
    @Binding var isPresented: Bool
    @State var adType: AdType
    
    //Select adType
    enum AdType {
        case interstitial
        case rewarded
    }
    
    var rewardFunc: () -> Void
    var adUnitId: String
  
    //The parent is the view that you are presenting over
    //Think of this as your presenting view controller
    var parent: Parent
    
    var body: some View {
        ZStack {
            parent
            
            if isPresented {
                EmptyView()
                    .edgesIgnoringSafeArea(.all)
                
                if adType == .rewarded {
                    RewardedAdView(isPresented: $isPresented, adUnitId: adUnitId, rewardFunc: rewardFunc)
                        .edgesIgnoringSafeArea(.all)
                } else if adType == .interstitial {
                    InterstitialAdView(isPresented: $isPresented, adUnitId: adUnitId)
                }
            }
        }
        .onAppear {
            //Initialize the ads as soon as the view appears
            if adType == .rewarded {
                RewardedAd.shared.loadAd(withAdUnitId: adUnitId)
            } else if adType == .interstitial {
                InterstitialAd.shared.loadAd(withAdUnitId: adUnitId)
            }
        }
    }
}

extension View {
    public func presentRewardedAd(isPresented: Binding<Bool>, adUnitId: String, rewardFunc: @escaping (() -> Void)) -> some View {
        FullScreenModifier(isPresented: isPresented, adType: .rewarded, rewardFunc: rewardFunc, adUnitId: adUnitId, parent: self)
    }
    
    public func presentInterstitialAd(isPresented: Binding<Bool>, adUnitId: String) -> some View {
        FullScreenModifier(isPresented: isPresented, adType: .interstitial, rewardFunc: {}, adUnitId: adUnitId, parent: self)
    }
}
