//
//  MusicPlayerViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/26/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

private let cellID = "cellID"
private let songID = "songID"
private let artistID = "artistID"
private let albumID = "albumID"
private let playlistID = "playlistID"


class AMusicPlayerViewController: UICollectionViewController, UICollectionViewDelegateFlowLayout, QuickBarDelegate {

    var menuBar: MenuBar = MenuBar()
    var quickBar: NowPlayingQuickBar?
    let slideDownInteractor = SlideDownInteractor()
    var musicManager = MusicManager.sharedManager
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        setUpCollectionView()
//        setUpMenuBar()
//        setUpQuickBar()
        quickBar?.delegate = self
//        setUpGradient()
        collectionView?.reloadData()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        switch menuBar.index {
        case 0:
            let cell = collectionView?.cellForItem(at: IndexPath(item: 0, section: 0)) as! PlaylistsCollectionCell
            cell.tableView.reloadData()
            break
        case 1:
            let cell = collectionView?.cellForItem(at: IndexPath(item: 1, section: 0)) as! SongsCollectionCell
            (cell.indexView as? UITableView)?.reloadData()
            break
        case 2:
            let cell = collectionView?.cellForItem(at: IndexPath(item: 2, section: 0)) as! ArtistsCollectionCell
            (cell.indexView as? UITableView)?.reloadData()
            break
        case 3:
            let cell = collectionView?.cellForItem(at: IndexPath(item: 3, section: 0)) as! AlbumCollectionCell
            (cell.indexView as? UICollectionView)?.reloadData()
            break
        default:
            break
        }
    }
    
    func scrollToMenuIndex(index: Int) {
        let path = IndexPath(item: index, section: 0)
        collectionView?.scrollToItem(at: path, at: .centeredHorizontally, animated: true)
    }
    
    override func scrollViewDidScroll(_ scrollView: UIScrollView) {
        menuBar.horizontalBarLeadingConstraint?.constant = scrollView.contentOffset.x/4 + view.frame.width/16
    }
    
    override func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let currentPageIndex = targetContentOffset.pointee.x / view.frame.width
        menuBar.selectItemAtIndex(index: Int(currentPageIndex))
    }
    
    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let colors = [UIColor.red, UIColor.orange, UIColor.yellow, UIColor.green]
        if indexPath.row == 0 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: playlistID, for: indexPath) as! PlaylistsCollectionCell
            cell.viewController = self
            cell.backgroundColor = UIColor.clear
            return cell
        }

        if indexPath.row == 1 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: songID, for: indexPath) as! SongsCollectionCell
            cell.viewController = self
            cell.backgroundColor = UIColor.clear
            return cell
        }
        if indexPath.row == 2 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: artistID, for: indexPath) as! ArtistsCollectionCell
            cell.viewController = self
            cell.backgroundColor = UIColor.clear
            return cell
        }
        if indexPath.row == 3 {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: albumID, for: indexPath) as! AlbumCollectionCell
            cell.viewController = self
            cell.backgroundColor = UIColor.clear
            return cell
        }
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellID, for: indexPath)
        cell.backgroundColor = colors[indexPath.row]
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: view.frame.height - FauxBarHeight - quickBarHeight)
    }

    func quickBarWasTapped(sender: NowPlayingQuickBar) {
        if musicManager.itemNowPlaying == nil {
            return
        }
        if let nowPlayingVC = storyboard!.instantiateViewController(withIdentifier: "NowPlayingViewController") as? NowPlayingViewController {
//            nowPlayingVC.transitioningDelegate = self
            nowPlayingVC.interactor = slideDownInteractor
            present(nowPlayingVC, animated: true, completion: nil)
        }
        
        
    }
    
    
}