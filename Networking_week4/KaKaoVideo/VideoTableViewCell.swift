//
//  VideoTableViewCell.swift
//  Networking_week4
//
//  Created by 염성필 on 2023/08/09.
//

import UIKit

class VideoTableViewCell: UITableViewCell {

    @IBOutlet var videoImage: UIImageView!
    @IBOutlet var videoname: UILabel!
    @IBOutlet var playtime: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        videoname.contentMode = .scaleToFill
        videoname.font = .boldSystemFont(ofSize: 15)
        videoname.numberOfLines = 0
        playtime.font = .systemFont(ofSize: 13)
        playtime.numberOfLines = 2
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        
    }

}
