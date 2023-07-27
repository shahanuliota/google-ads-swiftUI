//
//  FBBannerAds.swift
//  google_ads_check
//
//  Created by Shahanul on 18/7/23.
//

import SwiftUI

import FBAudienceNetwork

import UIKit

private struct FBBannerVC: UIViewControllerRepresentable {
    func makeCoordinator() -> Coordinator {
        return Coordinator()
    }
    
    var placementID: String
    var width: CGFloat
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let adView = FBAdView(placementID: placementID, adSize: kFBAdSizeHeight50Banner, rootViewController: viewController)
        adView.frame = CGRect(x: 0, y: 0, width: 320, height: 250)
        viewController.view.addSubview(adView)
        adView.delegate = context.coordinator
        return viewController
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
    
    
    
    class Coordinator: NSObject, FBAdViewDelegate{
        
        func adViewDidClick(_ adView: FBAdView) {
            print("Ad was clicked.")
        }
        
        func adViewDidFinishHandlingClick(_ adView: FBAdView) {
            print("Ad did finish click handling.")
        }
        
        func adViewWillLogImpression(_ adView: FBAdView) {
            print("Ad impression is being captured.")
        }
    }
}


struct FBBannerAds: View {
    var body: some View {
        
        FBBannerVC(placementID: "476505530989416_476507577655878", width:  UIScreen.main.bounds.width)
            .background(Color.red)
        Text("FB BANNER ADS")
    }
}

struct FBBannerAds_Previews: PreviewProvider {
    static var previews: some View {
        FBBannerAds()
    }
}
