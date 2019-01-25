//
//  NotificationBannerService.swift
//  NotificationView
//
//  Created by Michael Green on 25/01/2019.
//  Copyright © 2019 Michael Green. All rights reserved.
//

import Foundation
import UIKit

class NotificationBannerService: NotificationBannerViewProtocol {
  
  static let shared = NotificationBannerService()
  private var queue = [NotificationBannerView]()
  private var window: UIView? {
    return UIApplication.shared.delegate?.window ?? nil
  }
  private var notificationHeight: CGFloat {
    return 96
  }
  
  private init() {
    
  }
  
  func showBanner(ofType type: NotificationBannerType, forSeconds seconds: Double) {
    if let window = self.window {
      let banner = NotificationBannerView(frame: CGRect(x: 0, y: 0, width: window.bounds.width, height: self.notificationHeight), secondsShown: seconds, delegate: self)
      self.queue.append(banner)
      self.processBannerQueue()
    }
  }
  
  private func processBannerQueue() {
    let bannerCurrentlyShown = self.queue.filter( { $0.isShown } ).first != nil
    if let bannerView = self.queue.first, let window = self.window, !bannerCurrentlyShown {
      bannerView.show(on: window)
    }
  }
  
  // MARK: - NotificationBannerViewProtocol
  func notificationBannerView(_ banner: NotificationBannerView, wasDismissed dismissed: Bool) {
    if let index = self.queue.firstIndex(of: banner), self.queue.count > index {
      self.queue.remove(at: index)
      self.processBannerQueue()
    }
  }
}

enum NotificationBannerType {
  case welcomeGift
  case crate
  case quest
}
