//
//  AdCoodinator.swift
//  MusicSync
//
//  Created by 田川展也 on R 6/03/03.
//

import GoogleMobileAds

class AdCoordinator: NSObject {
  private var ad: GADInterstitialAd?

  func loadAd() {
    GADInterstitialAd.load(
      withAdUnitID: "ca-app-pub-3940256099942544/4411468910", request: GADRequest()
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

    // View controller is an optional parameter. Pass in nil.
    fullScreenAd.present(fromRootViewController: nil)
  }
}
