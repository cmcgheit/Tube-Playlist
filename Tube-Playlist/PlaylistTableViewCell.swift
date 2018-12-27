//
//  PlaylistTableViewCell.swift
//  Tube-Playlist
//
//  Created by C McGhee on 2/25/17.
//  Copyright © 2017 C McGhee. All rights reserved.
//

import UIKit
import Kingfisher

class PlaylistTableViewCell: UITableViewCell {
    
    var playlist = YouTubeModel()
    
    @IBOutlet weak var playlistDescriptionLabel: UILabel!
    @IBOutlet weak var playlistTitleLabel: UILabel!
    @IBOutlet weak var thumbnailImgView: UIImageView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configurePlaylistInfo(_ playlist : YouTubeModel) {
        self.playlist = playlist
        
        if let playlistTitle = self.playlist.title {
            playlistTitleLabel.text = playlistTitle
        }
        
        if let playlistDescription = self.playlist.descr {
            playlistDescriptionLabel.text = playlistDescription
        }
        
        if let playlistThumbnail = self.playlist.thumbnail {
            thumbnailImgView.kf.setImage(with: URL(string: playlistThumbnail))
        }
    }
    
}

