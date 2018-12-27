//
//  HomeViewController.swift
//  Tube-Playlist
//
//  Created by C McGhee on 2/12/17.
//  Copyright © 2017 C McGhee. All rights reserved.
//

import UIKit
import youtube_ios_player_helper
import SwiftyJSON

class HomeViewController: UIViewController {
    
    var ytManager = YouTubeManager()
    var videosOnChannel = YouTube()
    var playlistsOnChannel = YouTube()
    var videosOnPlaylist = YouTube()
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var videosTableView: UITableView!
    @IBOutlet weak var playlistOrVideoSegmentedControl: CustomSegmentedControl!
    @IBOutlet weak var waitingView: UIView!
    
    var searchingPlaylist: Bool = false
    
    var filteredVideos = [String]()
    var isSearching = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Youtube Playlists"
        
        searchingPlaylist = false
        
        fetchVideos()
        
    }
    
    func fetchVideos() {
        ytManager.fetchYouTubeData(urlAPI: .allPlaylists, videoType: .playlistOnChannel, parameters: .allPlaylists, pageToken: "", playlist: "") { (result) in
            if let modelResult = result as? YouTube {
                self.playlistsOnChannel = modelResult
                
                self.ytManager.fetchYouTubeData(urlAPI: .allVideos, videoType: .videoOnChannel, parameters: .allVideos, pageToken: "", playlist: "", completion: { (result2) in
                    if let modelResult2 = result2 as? YouTube {
                        self.videosOnChannel = modelResult2
                        self.videosTableView.reloadData()
                        self.waitingView.isHidden = true
                    }
                })
            }
        }
    }
    
    // MARK : - Segmented Controls
    
    @IBAction func segmentedControlValueChange(_ sender: Any) {
        
        if playlistOrVideoSegmentedControl.selectedSegmentIndex == 0 {
            print("load playlists")
            searchingPlaylist = false
        }
        else {
            print("load videos")
        }
        
        self.videosTableView.reloadData()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

//MARK: - TableView Delegate Methods
extension HomeViewController : UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        if playlistOrVideoSegmentedControl .selectedSegmentIndex == 0 {
            let selectedCell = tableView.cellForRow(at: indexPath) as! PlaylistTableViewCell
            
            
            self.searchingPlaylist = true
            self.waitingView.isHidden = false
            self.videosOnPlaylist.items?.removeAll()
            
            ytManager.fetchYouTubeData(urlAPI: .allVideosOnPlaylist, videoType: .videoOnPlaylist, parameters: .allVideosOnPlaylist, pageToken: "", playlist: selectedCell.playlist.playlistID!, completion: { (result) in
                if let modelResult = result as? YouTube {
                    self.videosOnPlaylist = modelResult
                }
                self.playlistOrVideoSegmentedControl.selectedSegmentIndex = 1
                self.waitingView.isHidden = true
                self.videosTableView.reloadData()
            })
        }
            
        else {
            let selectedCell = tableView.cellForRow(at: indexPath) as! VideoTableViewCell
            
            selectedCell.ytIndicatorView.startAnimating()
            selectedCell.playerView.load(withVideoId: selectedCell.video.videoID!)
            print("Selected Video: \(selectedCell.video.videoID)")
        }
    }
}

//MARK: - TableView Datasource Methods
extension HomeViewController : UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if playlistOrVideoSegmentedControl.selectedSegmentIndex == 0 {
            let playlistCell = tableView.dequeueReusableCell(withIdentifier: "playlistCell") as! PlaylistTableViewCell
            playlistCell.configurePlaylistInfo((playlistsOnChannel.items?[indexPath.row])!)
            return playlistCell
        }
        else {
            let videoCell = tableView.dequeueReusableCell(withIdentifier: "videoCell") as! VideoTableViewCell
            if searchingPlaylist {
                videoCell.configureVideoInfo((videosOnPlaylist.items?[indexPath.row])!)
            }
            else {
                videoCell.configureVideoInfo((videosOnChannel.items?[indexPath.row])!)
            }
            return videoCell
        }
    }
    
    //        if isSearching {
    //            text = filteredVideos[indexPath.row]
    //        } else {
    //            videoCell.configureVideoInfo((videosOnPlaylist.items?[indexPath.row])!) && videoCell.configureVideoInfo((videosOnChannel.items?[indexPath.row])!)
    //        }
    //    }
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if playlistOrVideoSegmentedControl.selectedSegmentIndex == 0 {
            return playlistsOnChannel.items!.count
        }
        else {
            if searchingPlaylist {
                return videosOnPlaylist.items!.count
            }
            else{
                
                return videosOnChannel.items!.count
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 116
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let totalRows = tableView.numberOfRows(inSection: indexPath.section)
        if indexPath.row == (totalRows - 1) {
            if playlistOrVideoSegmentedControl.selectedSegmentIndex == 0 {
                if (self.playlistsOnChannel.nextPageToken != "") {
                    ytManager.fetchYouTubeData(urlAPI: .allPlaylists, videoType: .playlistOnChannel, parameters: .allPlaylists, pageToken: self.playlistsOnChannel.nextPageToken!, playlist: "", completion: { (playlistResult) in
                        if let result = playlistResult as? YouTube {
                            self.playlistsOnChannel.nextPageToken =  result.nextPageToken
                            
                            for playlist in result.items! {
                                self.playlistsOnChannel.items?.append(playlist)
                            }
                            self.videosTableView.reloadData()
                        }
                    })
                }
            }
            else {
                if searchingPlaylist {
                    if (self.videosOnPlaylist.nextPageToken != "") {
                        ytManager.fetchYouTubeData(urlAPI: .allVideosOnPlaylist, videoType: .videoOnPlaylist, parameters: .allVideosOnPlaylist, pageToken: self.videosOnPlaylist.nextPageToken!, playlist: (self.videosOnPlaylist.items?[indexPath.row].playlistID!)!, completion: { (videosOnPlaylistResult) in
                            if let result = videosOnPlaylistResult as? YouTube {
                                self.videosOnPlaylist.nextPageToken = result.nextPageToken
                                
                                for video in result.items! {
                                    if video.videoID != nil {
                                        self.videosOnPlaylist.items?.append(video)
                                    }
                                }
                                self.videosTableView.reloadData()
                            }
                        })
                    }
                }
                else {
                    if (self.videosOnChannel.nextPageToken != "") {
                        ytManager.fetchYouTubeData(urlAPI: .allVideos, videoType: .videoOnChannel, parameters: .allVideos, pageToken: self.videosOnChannel.nextPageToken!, playlist: "", completion: { (videosResult) in
                            if let result = videosResult as? YouTube {
                                self.videosOnChannel.nextPageToken = result.nextPageToken
                                
                                for video in result.items! {
                                    if video.videoID != nil {
                                        self.videosOnChannel.items?.append(video)
                                    }
                                }
                                self.videosTableView.reloadData()
                            }
                        })
                    }
                }
            }
        }
        
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }
    }
}

extension HomeViewController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        guard let text = searchController.searchBar.text else { return }
    }
    
    func makeSearch() {
        let search = UISearchController(searchResultsController: nil)
        search.searchResultsUpdater = self
        search.obscuresBackgroundDuringPresentation = false
        search.searchBar.placeholder = "Type to search videos"
        search.hidesNavigationBarDuringPresentation = true
        search.dimsBackgroundDuringPresentation = false
        search.searchBar.barStyle = .default
        search.searchBar.sizeToFit()
        if #available(iOS 11.0, *) {
            navigationItem.searchController = search
        } else {
            //searchBar outlet
        }
    }
    
    
    // MARK : SearchBar Methods
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text == nil || searchBar.text == "" {
            isSearching = false
            view.endEditing(true)
            videosTableView.reloadData()
        } else {
            isSearching = true
            // filteredVideos = modelResult2.filter({$0 == searchBar.text})
            
            videosTableView.reloadData()
        }
    }
}






// MARK: - TTSegmentedControl prog
//let segmentedControl = TTSegmentedControl()
//segmentedControl.allowChangeThumbWidth = false
//segmentedControl.frame = CGRect(x: 50, y: 200, width: 100, height: 50)
//segmentedControl.didSelectItemWith = { (index, title) -> () in
//    print("Selected item \(index)")
//}
//view.addSubview(segmentedControl)
