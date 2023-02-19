//
//  AcitivityViewController.swift
//  talkbbokki
//
//  Created by USER on 2023/02/20.
//

import Foundation
import SwiftUI
import UIKit

struct ActivityViewController: UIViewControllerRepresentable {
  var activityItems: [Any]
  var applicationActivities: [UIActivity]? = nil
  @Environment(\.presentationMode) var presentationMode
  
  func makeUIViewController(context: UIViewControllerRepresentableContext<ActivityViewController>
  ) -> UIActivityViewController {
    let controller = UIActivityViewController(
      activityItems: activityItems,
      applicationActivities: applicationActivities
    )

    controller.completionWithItemsHandler = { (activityType, completed, returnedItems, error) in
      self.presentationMode.wrappedValue.dismiss()
    }
    return controller
  }
  
  func updateUIViewController(
    _ uiViewController: UIActivityViewController,
    context: UIViewControllerRepresentableContext<ActivityViewController>
  ) {}
}
