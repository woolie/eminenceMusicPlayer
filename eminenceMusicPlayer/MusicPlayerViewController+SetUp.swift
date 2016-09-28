//
//  MusicPlayerViewController+SetUp.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/26/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

private let cellID = "cellID"
private let songID = "songID"
private let artistID = "artistID"

extension MusicPlayerViewController {
    func setUpMenuBar() {
        menuBar = MenuBar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: FauxBarHeight))
        view.addSubview(menuBar)
        menuBar.viewController = self
        menuBar.translatesAutoresizingMaskIntoConstraints = false
        menuBar.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        menuBar.heightAnchor.constraint(equalToConstant: FauxBarHeight).isActive = true
        menuBar.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        menuBar.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        menuBar.backgroundColor = QuickBarBackgroundColor
        
        menuBar.layer.shadowColor = UIColor.black.cgColor
        menuBar.layer.shadowOpacity = 1
        menuBar.layer.shadowOffset = CGSize.zero
        menuBar.layer.shadowRadius = 10
        let rect = CGRect(x: 0, y: 0, width: view.frame.width, height: 70)
        menuBar.layer.shadowPath = UIBezierPath(rect: rect).cgPath
        
        let border = UIView()
        border.backgroundColor = UIColor.white.withAlphaComponent(0.1)
        menuBar.addSubview(border)
        border.translatesAutoresizingMaskIntoConstraints = false
        border.bottomAnchor.constraint(equalTo: menuBar.bottomAnchor).isActive = true
        border.leadingAnchor.constraint(equalTo: menuBar.leadingAnchor).isActive = true
        border.trailingAnchor.constraint(equalTo: menuBar.trailingAnchor).isActive = true
        border.heightAnchor.constraint(equalToConstant: 1).isActive = true
    }
    
    func setUpGradient() {
        let gradient = CAGradientLayer()
        let startColor = UIColor(red: 92/255.0, green: 46/255.0, blue: 46/255.0, alpha: 1)
        let endColor = UIColor(red: 54/255.0, green: 49/255.0, blue: 58/255.0, alpha: 1)
        gradient.colors = [startColor.cgColor, endColor.cgColor]
        gradient.frame = self.view.frame
        let points = (CGPoint(x: 0, y: 0), CGPoint(x: 1, y: 1))
        gradient.startPoint = points.0
        gradient.endPoint = points.1
        view.layer.addSublayer(gradient)
        gradient.zPosition = -5
    }
    
    func setUpCollectionView() {
        
        if let flowLayout = collectionView?.collectionViewLayout as? UICollectionViewFlowLayout {
            flowLayout.scrollDirection = .horizontal
            flowLayout.minimumLineSpacing = 0
        }
        collectionView?.backgroundColor = UIColor.clear
        collectionView?.register(UICollectionViewCell.self, forCellWithReuseIdentifier: cellID)
        collectionView?.register(SongsCollectionCell.self, forCellWithReuseIdentifier: songID)
        collectionView?.register(ArtistsCollectionCell.self, forCellWithReuseIdentifier: artistID)
        collectionView?.contentInset = UIEdgeInsets(top: FauxBarHeight, left: 0, bottom: quickBarHeight, right: 0)
        collectionView?.scrollIndicatorInsets = UIEdgeInsets(top: FauxBarHeight, left: 0, bottom: quickBarHeight, right: 0)
        collectionView?.isPagingEnabled = true
        collectionView?.scrollToItem(at: IndexPath(item: 1, section: 0), at: .centeredHorizontally, animated: false)
    }
    
    func setUpQuickBar() {
        quickBar = NowPlayingQuickBar(frame: CGRect(x: 0, y: view.frame.height - tabBarHeight - quickBarHeight, width: view.frame.width, height: quickBarHeight))
        quickBar!.backgroundColor = QuickBarBackgroundColor // UIColor.red.withAlphaComponent(0.5)
        view.addSubview(quickBar!)
        quickBar!.translatesAutoresizingMaskIntoConstraints = false
        quickBar!.bottomAnchor.constraint(equalTo: bottomLayoutGuide.topAnchor).isActive = true
        quickBar!.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        quickBar!.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        quickBar!.fullHeightConstraint.isActive = true
        
    }
}