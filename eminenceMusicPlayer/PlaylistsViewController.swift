//
//  PlaylistsViewController.swift
//  eminenceMusicPlayer
//
//  Created by Magfurul Abeer on 10/3/16.
//  Copyright © 2016 Magfurul Abeer. All rights reserved.
//

import UIKit
import MediaPlayer

// TODO: Share setUpIndexView code between the menuviewcontrollers


/// View controller that shows the quick queue and a table of all the playlists
class PlaylistsViewController: MenuViewController, UITableViewDelegate, UITableViewDataSource {

    
    
    // MARK: Properties
    
    
    
    /// Reference to the MusicManager singleton instance.
    let musicManager = MusicManager.sharedManager
    
    /// Allows base class methods to have access to indexView
    var indexView: IndexView = UITableView(frame: .zero, style: .grouped)
    
    /// Allows base class methods to have access to indexView
    override var storedIndexView: IndexView? {  get { return indexView }    }
    
    
    
    // MARK: View Management Method

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.clear
        setUpIndexView()
    }
    
    
    
    // MARK: Setup Methods

    
    
    /**
     Constrain index view. Sets its delegates, color, constraints, and gestures. Then reloads it.
     */
    func setUpIndexView() {
        guard let indexView = indexView as? UITableView else { return }
        
        indexView.delegate = self
        indexView.dataSource = self
        indexView.backgroundColor = UIColor.clear
        indexView.separatorStyle = UITableViewCellSeparatorStyle.none
        indexView.register(QuickQueueCell.self, forCellReuseIdentifier: "QuickQueueCell")
        indexView.register(UINib(nibName: "BasicCell", bundle: Bundle.main), forCellReuseIdentifier: "BasicCell")
        
        constrainIndexView()
        
        indexView.reloadData()
    }
    
    
    
    // MARK: UITableViewDataSource
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return musicManager.originalPlaylistList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "QuickQueueCell", for: indexPath) as! QuickQueueCell
            cell.viewController = viewController
            return cell
        } else {

            let playlist = musicManager.playlistList[indexPath.row]
            
            let cell =  tableView.dequeueReusableCell(withIdentifier: "BasicCell", for: indexPath) as! BasicCell
            cell.selectionStyle = UITableViewCellSelectionStyle.none
            cell.backgroundColor = UIColor.clear
            cell.textLabel?.text = playlist.value(forProperty: MPMediaPlaylistPropertyName) as? String
            cell.detailTextLabel?.text = "\(playlist.count)"
            return cell
        }
    }
    
    
    
    // MARK: UITableViewDelegate
    
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 0 {
            return view.frame.height/2 - FauxBarHeight - quickBarHeight
        } else {
            return SongCellHeight
        }
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        if section == 0 {
            return "Quick Queue"
        }
        return "Playlists"
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        guard let header = view as? UITableViewHeaderFooterView else {
            return
        }
        header.backgroundView?.backgroundColor = UIColor.clear
        header.textLabel?.textColor = UIColor.white
        header.textLabel?.font = UIFont(name: "Avenir", size: 25)

    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.section != 0 else { return }
        
        let playlist = musicManager.playlistList[indexPath.row]
        
        if playlist.count > 0 {
            let size = view.frame.size
            let rect = CGRect(x: topPadding, y: 0, width: size.width, height: size.height - topPadding - bottomPadding)
            let playlistDetails = PlaylistDetailsView(frame: rect)
            playlistDetails.playlist = playlist
            playlistDetails.viewController = viewController
            view.addSubview(playlistDetails)
            playlistDetails.translatesAutoresizingMaskIntoConstraints = false
            playlistDetails.topAnchor.constraint(equalTo: view.topAnchor, constant: topPadding).isActive = true
            playlistDetails.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: bottomPadding).isActive = true
            playlistDetails.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
            playlistDetails.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        } else {
            let alertController = UIAlertController(title: "Playlist is Empty", message: "This playlist is empty", preferredStyle: .alert)
            let ok = UIAlertAction(title: "OK", style: .default, handler: nil)
            alertController.addAction(ok)
            viewController!.present(alertController, animated: true, completion: nil)
            return
        }
        
        NotificationCenter.default.addObserver(self, selector: #selector(self.moveViewUp(notification:)), name: NSNotification.Name.UIKeyboardWillShow, object: nil)
    }
    
    func moveViewUp(notification: NSNotification) {
        let userInfo = notification.userInfo
        let keyboardSize = userInfo![UIKeyboardFrameEndUserInfoKey] as! NSValue
        let keyboardHeight = keyboardSize.cgRectValue.height
        
        view.frame.origin.y -= keyboardHeight
    }
    
}
