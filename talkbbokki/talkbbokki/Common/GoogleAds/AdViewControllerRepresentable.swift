//
//  AdViewControllerRepresentable.swift
//  talkbbokki
//
//  Created by USER on 2023/02/23.
//

import SwiftUI
import UIKit

struct AdViewControllerRepresentable: UIViewControllerRepresentable {
  let viewController = UIViewController()

  func makeUIViewController(context: Context) -> some UIViewController {
    return viewController
  }

  func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
    // No implementation needed. Nothing to update.
  }
}
