//
//  GoogleBannerAds.swift
//  google_ads_check
//
//  Created by Shahanul on 18/7/23.
//

import SwiftUI

import GoogleMobileAds
import UIKit

private struct GoogleBannerVC: UIViewControllerRepresentable {
    var bannerID: String
    var width: CGFloat

    func makeUIViewController(context: Context) -> UIViewController {
        let view = GADBannerView(adSize: GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width))

        let viewController = UIViewController()
        #if DEBUG
        view.adUnitID = "ca-app-pub-3940256099942544/6300978111"
        #else
        view.adUnitID = bannerID
        #endif
        view.rootViewController = viewController
        viewController.view.addSubview(view)
        view.load(GADRequest())

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}


struct GoogleBannerAds: View {
    var bannerID: String
        var width: CGFloat

        var size: CGSize {
            return GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(width).size
        }

        var body: some View {
            GoogleBannerVC(bannerID: bannerID, width: width)
                .frame(width: size.width, height: size.height)
        }
}

struct GoogleBannerAds_Previews: PreviewProvider {
    static var previews: some View {
        GoogleBannerAds(bannerID: "ca-app-pub-3940256099942544/6300978111", width: UIScreen.main.bounds.width)
    }
}
