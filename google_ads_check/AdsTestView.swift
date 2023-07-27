//
//  AdsTestView.swift
//  google_ads_check
//
//  Created by Shahanul on 18/7/23.
//

import SwiftUI

struct AdsTestView: View {

    @State var showRewardedAd: Bool = false
    @State var showIntersitialAd: Bool = false
    @State var rewardGranted: Bool = false
    
    var body: some View {
        ZStack {
            VStack {
                GoogleBannerAds(bannerID: "ca-app-pub-3940256099942544/6300978111", width: UIScreen.main.bounds.width)
                Button("Get a Reward") {
                    showRewardedAd.toggle()
                }
                
                Button("Show Interstitial Ad") {
                    showIntersitialAd.toggle()
                }
                .padding()
                .foregroundColor(Color(.systemPurple))
            }
            
          
        }
        .presentRewardedAd(isPresented: $showRewardedAd, adUnitId: "ca-app-pub-3940256099942544/1712485313") {
            print("Reward Granted")
            rewardGranted.toggle()
        }
        .presentInterstitialAd(isPresented: $showIntersitialAd, adUnitId: "ca-app-pub-3940256099942544/4411468910")
    }
}

struct AdsTestView_Previews: PreviewProvider {
    static var previews: some View {
        AdsTestView()
    }
}
