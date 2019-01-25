//
//  ViewController.swift
//  NotificationView
//
//  Created by Michael Green on 25/01/2019.
//  Copyright © 2019 Michael Green. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

  private let bannerService = NotificationBannerService.shared
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view, typically from a nib.
  }

  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    //self.view.addSubview(banner)
  }
  
  @IBAction func showBanner() {
    self.bannerService.showBanner(ofType: .welcomeGift, forSeconds: 2)
  }
}

