//
//  MatchViewCell.swift
//  SoccerTracker
//
//  Created by EMIGDIO CAMACHO CALDERON on 11/14/18.
//  Copyright © 2018 interfell. All rights reserved.
//

import UIKit

class MatchViewCell: UITableViewCell {

    @IBOutlet weak var imageTeam2: UIImageView!
    @IBOutlet weak var imageTeam1: UIImageView!
    @IBOutlet weak var score: UILabel!
    @IBOutlet weak var labelTeam2: UILabel!
    @IBOutlet weak var labelTeam1: UILabel!
    @IBOutlet weak var labelMatch: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        self.imageTeam1.layer.cornerRadius = 25
        self.imageTeam1.layer.masksToBounds = true
        
        self.imageTeam2.layer.cornerRadius = 25
        self.imageTeam2.layer.masksToBounds = true
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
