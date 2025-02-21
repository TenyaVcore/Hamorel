//
//  AdCoodinator.swift
//  MusicSync
//
//  Created by 田川展也 on R 6/03/03.
//

import GoogleMobileAds

protocol AdProtocol {
    func loadAd()
    func presentAd()
}

class AdCoordinator: NSObject, AdProtocol {
  private var ad: GADInterstitialAd?

  func loadAd() {
#if DEBUG
      let adUnitID = "ca-app-pub-3940256099942544/4411468910"
#else
      let adUnitID = "ca-app-pub-5449942175714797/6669029673"
#endif
    GADInterstitialAd.load(
      withAdUnitID: adUnitID, request: GADRequest()
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
