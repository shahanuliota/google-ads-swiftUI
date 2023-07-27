//
//  GoogleInterstitialAds .swift
//  google_ads_check
//
//  Created by Shahanul on 17/7/23.
//
import SwiftUI
import GoogleMobileAds
import UIKit

class InterstitialAd: NSObject {
    var interstitialAd: GADInterstitialAd?
    
    //Want to have one instance of the ad for the entire app
    //We can do this b/c you will never show more than 1 ad at once so only 1 ad needs to be loaded
    static let shared = InterstitialAd()
    
    func loadAd(withAdUnitId id: String) {
        let req = GADRequest()
        GADInterstitialAd.load(withAdUnitID: id, request: req) { interstitialAd, err in
            if let err = err {
                print("Failed to load ad with error: \(err)")
                return
            }
            
            self.interstitialAd = interstitialAd
        }
    }
}

struct InterstitialAdView:  UIViewControllerRepresentable {
    
    //Here's the Ad Object we just created
    let interstitialAd = InterstitialAd.shared.interstitialAd
    @Binding var isPresented: Bool
    var adUnitId: String
    
    init(isPresented: Binding<Bool>, adUnitId: String) {
        self._isPresented = isPresented
        self.adUnitId = adUnitId
        
        
      
        
        InterstitialAd.shared.loadAd(withAdUnitId: adUnitId)
    }
    
    //Make's a SwiftUI View from a UIViewController
    func makeUIViewController(context: Context) -> UIViewController {
        let view = UIViewController()
        interstitialAd?.fullScreenContentDelegate = context.coordinator //Set this view as the delegate for the ad
        //Show the ad after a slight delay to ensure the ad is loaded and ready to present
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
            //Prepares another ad for the next time view presented
            InterstitialAd.shared.loadAd(withAdUnitId: adUnitId)
            
            //Dismisses the view once ad dismissed
            isPresented.toggle()
        }
        
        func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
            InterstitialAd.shared.loadAd(withAdUnitId: adUnitId)
            //Dismisses the view once ad failed
            isPresented.toggle()
        }
    }
    
    //Presents the ad if it can, otherwise dismisses so the user's experience is not interrupted
    func showAd(from root: UIViewController) {
        
        if let ad = interstitialAd {
            ad.present(fromRootViewController: root)
        } else {
            print("Ad not ready")
            self.isPresented.toggle()
            
        }
    }
    
    
}
