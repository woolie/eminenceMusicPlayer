//
//  NowPlayingQuickBar.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/22/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

protocol QuickBarDelegate {
    func quickBarWasTapped(sender: NowPlayingQuickBar)
}

let timerInterval = 0.01
class NowPlayingQuickBar: UIView {

    var border = UIView()
    var musicManager = MusicManager.sharedManager
    var delegate: QuickBarDelegate?
    var albumThumbnail = UIImageView()
    var songTitleLabel = UILabel()
    var artistLabel = UILabel()
    var playButton = UIButton(type: UIButtonType.custom)
    var pauseButton = UIButton(type: UIButtonType.custom)
    var lastLocation: CGPoint = CGPoint(x: 0, y: 0)
    var initialDragBumpOver = false
    var fullHeightConstraint = NSLayoutConstraint()
    
    var volume: UISlider {
        get {
            return self.musicManager.volume
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setUpAlbumThumbnail()
        setUpPlayButton()
        setUpPauseButton()
        setUpSongTitleLabel()
        setUpArtistLabel()
        displayPlaybackButton()

        NotificationCenter.default.addObserver(self, selector: #selector(NowPlayingQuickBar.displayNowPlayingItemChanged), name: NSNotification.Name.MPMusicPlayerControllerNowPlayingItemDidChange, object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(NowPlayingQuickBar.displayPlaybackButton), name:NSNotification.Name.MPMusicPlayerControllerPlaybackStateDidChange, object: nil)

        isUserInteractionEnabled = true

        let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(NowPlayingQuickBar.didTap(sender:)))
        addGestureRecognizer(tapGestureRecognizer)
        
        let leftGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(NowPlayingQuickBar.swipeLeft(sender:)))
        leftGestureRecognizer.direction = .left
        addGestureRecognizer(leftGestureRecognizer)
        
        let rightGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(NowPlayingQuickBar.swipeRight(sender:)))
        rightGestureRecognizer.direction = .right
        addGestureRecognizer(rightGestureRecognizer)
        
        setUpShadow()
        setUpTopBorder()
    }

    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func displayPlaybackButton() {
        guard musicManager.itemNowPlaying != nil else {
            playButton.isHidden = true
            pauseButton.isHidden = true
            albumThumbnail.image = UIImage()
            return
        }
        if musicManager.currentlyPreviewing == false {
            if musicManager.player.playbackState == MPMusicPlaybackState.playing {
                playButton.isHidden = true
                pauseButton.isHidden = false
            } else {
                playButton.isHidden = false
                pauseButton.isHidden = true
            }
        }
    }

    func displayNowPlayingItemChanged() {
        if musicManager.currentlyPreviewing == false {
            songTitleLabel.text = musicManager.itemNowPlaying?.title ?? ""
            artistLabel.text = musicManager.itemNowPlaying?.artist ?? ""
            let artwork = musicManager.itemNowPlaying?.artwork?.image(at: CGSize(width: self.bounds.height, height: self.bounds.height))
            let backupImage = musicManager.itemNowPlaying == nil ? UIImage() : #imageLiteral(resourceName: "NoAlbumImage")
            albumThumbnail.image = musicManager.itemNowPlaying?.artwork != nil ? artwork! : backupImage
        }
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        let touch = touches[touches.startIndex]
        self.lastLocation = touch.preciseLocation(in: self)
    }
}
