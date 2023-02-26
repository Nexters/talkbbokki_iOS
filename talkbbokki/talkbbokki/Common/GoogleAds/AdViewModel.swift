//
//  AdCoordinator.swift
//  talkbbokki
//
//  Created by USER on 2023/02/23.
//
import GoogleMobileAds
import Foundation
import SwiftUI

class AdViewModel: NSObject, ObservableObject {
    @Published var ad: GADInterstitialAd?
    @Published var notReadyAds: Bool = false
    @Published var dismissAd: Bool = false

    private let testAdID = "ca-app-pub-3940256099942544/4411468910"
    private let readADID = "ca-app-pub-3769988488950055/1200265941"
    private lazy var ADID = readADID
    func loadAd() {
        let request = GADRequest()
        GADInterstitialAd.load(withAdUnitID: ADID,
                               request: request,
                               completionHandler: { [self] ad, error in
            if let error = error {
                print("Failed to load interstitial ad: \(error.localizedDescription)")
                notReadyAds.toggle()
                dismissAd.toggle()
                return
            }
            self.ad = ad
            ad?.fullScreenContentDelegate = self
        })
    }
    
    func presentAd(from viewController: UIViewController) {
        guard let fullScreenAd = ad else {
            return print("Ad wasn't ready")
        }
        
        fullScreenAd.present(fromRootViewController: viewController)
    }
}

extension AdViewModel: GADFullScreenContentDelegate {
    // MARK: - GADFullScreenContentDelegate methods
    func adDidRecordImpression(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func adDidRecordClick(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func ad(_ ad: GADFullScreenPresentingAd, didFailToPresentFullScreenContentWithError error: Error) {
        print("\(#function) called")
        dismissAd.toggle()
    }
    
    func adWillPresentFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    
    func adWillDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
    }
    
    func adDidDismissFullScreenContent(_ ad: GADFullScreenPresentingAd) {
        print("\(#function) called")
        dismissAd.toggle()
    }
}
