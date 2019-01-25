//
//  NotificationBannerView.swift
//  NotificationView
//
//  Created by Michael Green on 25/01/2019.
//  Copyright © 2019 Michael Green. All rights reserved.
//

import UIKit

protocol NotificationBannerViewProtocol {
  func notificationBannerView(_ banner: NotificationBannerView, wasDismissed dismissed: Bool)
}

class NotificationBannerView: UIView, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

  @IBOutlet weak var contentView: UIView!
  @IBOutlet weak var backgroundView: UIView!
  @IBOutlet weak var collectionView: UICollectionView!
  
  private let secondsShown: Double
  private let delegate: NotificationBannerViewProtocol
  private let defaultHeight: CGFloat
  private var dismissTimer: Timer?
  
  var isShown: Bool {
    return self.superview != nil
  }
  
  init(frame: CGRect, secondsShown: Double, delegate: NotificationBannerViewProtocol) {
    self.delegate = delegate
    self.secondsShown = secondsShown
    self.defaultHeight = frame.height
    super.init(frame: frame)
    self.initView()
  }
  
  required init?(coder aDecoder: NSCoder) {
    fatalError("init(coder:) has not been implemented")
  }
  
  private func initView() {
    Bundle(for: NotificationBannerView.self).loadNibNamed("NotificationBannerView", owner: self, options: nil)
    self.addSubview(self.contentView)
    self.contentView.frame = self.bounds
    self.contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
    self.collectionView.register(UINib(nibName: "WelcomeGiftCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "WelcomeGiftCollectionViewCell")
    self.collectionView.register(UINib(nibName: "EmptyBannerCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "EmptyBannerCollectionViewCell")
    self.collectionView.clipsToBounds = false
    self.collectionView.contentInset = UIEdgeInsets(top: -20, left: 0, bottom: 0, right: 0)
    self.layer.shadowColor = UIColor.black.cgColor
    self.layer.shadowOpacity = 0.3
    self.layer.shadowOffset = CGSize(width: 0, height: 1)
    self.layer.shadowRadius = 2
    self.clipsToBounds = false
  }
  
  func show(on view: UIView) {
    self.collectionView.reloadData()
    self.frame.origin = CGPoint(x: 0, y: -self.defaultHeight)
    view.addSubview(self)
    UIView.animate(withDuration: 0.3) {
      self.frame.origin = CGPoint(x: 0, y: 0)
    }
    self.resetDismissTimer()
  }
  
  private func resetDismissTimer() {
    self.dismissTimer = Timer.scheduledTimer(withTimeInterval: self.secondsShown < 0.3 ? 0.3 : self.secondsShown, repeats: false, block: { (timer) in
      UIView.animate(withDuration: 0.3, animations: {
        self.frame.origin = CGPoint(x: 0, y: -self.defaultHeight)
      }, completion: { (finished) in
        self.invalidateBannerView()
      })
    })
  }
  
  private func invalidateBannerView() {
    self.removeFromSuperview()
    self.delegate.notificationBannerView(self, wasDismissed: true)
  }
  
  private func invalidateDismissTimer() {
    self.dismissTimer?.invalidate()
    self.dismissTimer = nil
  }
  
  // MARK: - UIScrollViewDelegate
  func scrollViewDidScroll(_ scrollView: UIScrollView) {
    var frame = self.backgroundView.frame
    let height = self.defaultHeight - scrollView.contentOffset.y
    frame.size.height = height
    self.backgroundView.frame = frame
    if height <= 0 {
      self.invalidateBannerView()
      self.invalidateDismissTimer()
    }
  }
  
  func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
    self.invalidateDismissTimer()
  }
  
  func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
    // Restart timer
    self.resetDismissTimer()
  }
  
  // MARK: - UICollectionViewDelegate, UICollectionViewDataSource
  func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
  }
  
  func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    return 2
  }
  
  func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    return CGSize(width: collectionView.bounds.width, height: self.contentView.bounds.size.height)
  }
  
  func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    switch indexPath.row {
    case 0:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "WelcomeGiftCollectionViewCell", for: indexPath)
      return cell
    default:
      let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "EmptyBannerCollectionViewCell", for: indexPath)
      return cell
    }
  }
}
