//
//  Constants.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 9/22/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit

// Todo: Capitalize the first two constants or have all constants start with k. Need to be consistent.
// Todo: Replace all magic numbers with constants

public let PlaylistName = "PlaylistName"
public let SavedPlaylists = "SavedPlaylists"
public let tabBarHeight: CGFloat = 49
public let quickBarHeight: CGFloat = 70
public let FauxBarHeight: CGFloat = 70
public let QuickBarBackgroundColor: UIColor = UIColor(red: 42/255.0, green: 44/255.0, blue: 56/255.0, alpha: 1.0)
public let SongCellHeight: CGFloat = 75
public let HorizontalBarHeight: CGFloat = 2
public let TimeOutDuration = 5.0

public func getDocumentsDirectory() -> URL {
    let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
    let documentsDirectory = paths[0]
    return documentsDirectory
}
