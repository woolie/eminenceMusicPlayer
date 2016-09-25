//
//  MusicViewController+Sampling.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/23/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

extension MusicViewController {
    func handleLongPress(sender: UILongPressGestureRecognizer) {
        if sender.state == UIGestureRecognizerState.began {
            // Will be needed at the end
            savedPlayerIsPlaying = musicManager.player.playbackState
            musicManager.player.pause()
            let point = sender.location(in: tableView)
            let indexPath = tableView.indexPathForRow(at: point)!
            startSamplingMusic(atIndexPath: indexPath)
        }
        if sender.state == UIGestureRecognizerState.changed {
            let point = sender.location(in: tableView)
            let indexPath = tableView.indexPathForRow(at: point)!
            if indexPath != selectedIndexPath {
                musicManager.player.pause()
                selectedCell?.backgroundColor = UIColor.clear
                selectedCell?.contentView.backgroundColor = UIColor.clear
                changeSamplingMusic(atIndexPath: indexPath)
            }
        }
        if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            endSamplingMusic()
        }
        
    }
    
    func startSamplingMusic(atIndexPath indexPath: IndexPath) {
        //This is needed if touch moves to another cell
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SamplingDidBegin"), object: nil)
        musicManager.currentlySampling = true
        selectedIndexPath = indexPath
        
        // These will be needed when the touch ends
        savedSong = musicManager.player.nowPlayingItem
        savedTime = musicManager.player.currentPlaybackTime
        savedRepeatMode = musicManager.player.repeatMode
        
        
        
        // Visuals
        selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.backgroundColor = UIColor.black
        
        // Audio
        let song = musicManager.songList[indexPath.row]
        musicManager.player.shuffleMode = MPMusicShuffleMode.off
        musicManager.player.repeatMode = MPMusicRepeatMode.one // In case held till end of song
        musicManager.player.nowPlayingItem = song
        musicManager.player.currentPlaybackTime = song.playbackDuration/2
        musicManager.player.prepareToPlay()
        musicManager.player.play()
    }
    
    func changeSamplingMusic(atIndexPath indexPath: IndexPath) {
        //This is needed if touch moves to another cell
        selectedIndexPath = indexPath
        
        // Visuals
        selectedCell = tableView.cellForRow(at: indexPath)
        selectedCell?.backgroundColor = UIColor.black
        
        // Audio
        let song = musicManager.songList[indexPath.row]
        musicManager.player.nowPlayingItem = song
        musicManager.player.currentPlaybackTime = song.playbackDuration/2
        musicManager.player.prepareToPlay()
        musicManager.player.play()
        
    }
    
    func endSamplingMusic() {
        musicManager.currentlySampling = false
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: "SamplingDidEnd"), object: nil)
        // Return visual to normal
        selectedCell?.backgroundColor = UIColor.clear
        
        // Return audio to normal
        musicManager.player.pause()
        musicManager.player.shuffleMode = musicManager.shuffleIsOn ? .songs : .off
        musicManager.player.repeatMode = savedRepeatMode!
        musicManager.player.nowPlayingItem = savedSong
        musicManager.player.currentPlaybackTime = savedTime!
        if savedPlayerIsPlaying == MPMusicPlaybackState.playing {
            musicManager.player.play()
        } else if savedPlayerIsPlaying == MPMusicPlaybackState.stopped {
            musicManager.player.stop()
        }
        
        // Release all saved properties
        savedPlayerIsPlaying = nil
        savedRepeatMode = nil
        savedTime = nil
        savedSong = nil
        selectedIndexPath = nil
        selectedCell = nil
        savedPlayerIsPlaying = nil
    }
}