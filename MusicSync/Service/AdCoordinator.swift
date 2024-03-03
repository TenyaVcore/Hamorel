//
//  AdCoordinator.swift
//  MusicSync
//
//  Created by 田川展也 on R 6/02/26.
//

import Foundation
import GoogleMobileAds

class AdCoordinator: NSObject {
  private var ad: GADInterstitialAd?

  func loadAd() {
    GADInterstitialAd.load(
      withAdUnitID: "/6499/example/interstitial", request: GADRequest()
    ) { ad, error in
      if let error = error {
        return print("Failed to load ad with error: \(error.localizedDescription)")
      }

      self.ad = ad
    }
  }

  func presentAd() {
    guard let fullScreenAd = ad else {
      return print("Ad wasn't ready")
    }
    fullScreenAd.present(fromRootViewController: nil)
  }
}
