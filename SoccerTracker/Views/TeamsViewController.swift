//
//  TeamsViewController.swift
//  SoccerTracker
//
//  Created by EMIGDIO CAMACHO CALDERON on 11/14/18.
//  Copyright © 2018 interfell. All rights reserved.
//

import UIKit
import Firebase

class TeamsViewController: UIViewController {

    var teams = [Team]()
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        
        super.viewDidLoad()

        self.navigationItem.title = "App"
        
        tableView.delegate = self
        tableView.dataSource = self as UITableViewDataSource
        tableView.register(UINib(nibName: "TeamViewCell", bundle: nil), forCellReuseIdentifier: "TeamViewCell")
        
        self.spinner.startAnimating()
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        (ref?.child("teams").queryOrderedByKey().observe(.value, with: { teamsData in
            
            self.spinner.stopAnimating()
            
            self.teams = [Team]()
            
            if teamsData.hasChildren() {
                // Found teams
                for teamData in teamsData.children {
                    
                    let team = Team()
                    
                    let data = (teamData as! DataSnapshot).value as! NSDictionary
                    
                    print("data \(teamData)")
                    print("data \(data)")
                    
                    team.name = data["name"] as? String
                    
                    self.teams.append(team)
  
                }
                
                self.tableView.reloadData()
                
            } else {
                // No Children
                print("No children found.")
            }
            
        }))
        
    }
    
}

extension TeamsViewController: UITableViewDelegate, UITableViewDataSource{
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {

        return teams.count
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"TeamViewCell", for: indexPath) as! TeamViewCell
        
        let team = self.teams[indexPath.row]
        
        cell.labelTeam.text = team.name
  
        return cell
        
    }
    
}
