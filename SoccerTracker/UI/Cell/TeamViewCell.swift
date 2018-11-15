//
//  TeamViewCell.swift
//  SoccerTracker
//
//  Created by EMIGDIO CAMACHO CALDERON on 11/14/18.
//  Copyright © 2018 interfell. All rights reserved.
//

import UIKit

class TeamViewCell: UITableViewCell {

    @IBOutlet weak var labelTeam: UILabel!
    @IBOutlet weak var imageTeam: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.imageTeam.layer.cornerRadius = 25
        self.imageTeam.layer.masksToBounds = true
      
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

    }
    
}
