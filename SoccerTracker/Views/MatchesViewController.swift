//
//  MatchesViewController.swift
//  SoccerTracker
//
//  Created by EMIGDIO CAMACHO CALDERON on 11/14/18.
//  Copyright © 2018 interfell. All rights reserved.
//

import UIKit
import Firebase

class MatchesViewController: UIViewController {
    
    var matches = [Match]()
    var matchesFiltered = [Match]()
    
    @IBOutlet var pickerViewContent: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    var pickerTeamsData: [String] = [String]()
    @IBOutlet weak var filterField: UITextField!
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "App"
        
        tableView.delegate = self
        tableView.dataSource = self as UITableViewDataSource
        tableView.register(UINib(nibName: "MatchViewCell", bundle: nil), forCellReuseIdentifier: "MatchViewCell")
        
        self.filterField.inputView = self.pickerViewContent
        self.filterField.text = "Todos"
        
        self.spinner.startAnimating()
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        (ref?.child("matches").queryOrderedByKey().observe(.value, with: { matchesData in
            
            self.spinner.stopAnimating()
            
            self.matches = [Match]()
            
            if matchesData.hasChildren() {
                
                // Found teams
                for matcheData in matchesData.children {
                    
                    let match = Match()
                    
                    let data = (matcheData as! DataSnapshot).value as! NSDictionary
                    
                    print("data \(matcheData)")
                    print("data \(data)")
                    
                    match.scoreTeam1 = data["scoreTeam1"] as? String
                    match.scoreTeam2 = data["scoreTeam2"] as? String
                    
                    let team1 = Team()
                    let team2 = Team()
                    
                    let team1data = data["team1"]  as! NSDictionary
                    let team2data = data["team2"]  as! NSDictionary
                    
                    team1.name = team1data["name"] as? String
                    team2.name = team2data["name"] as? String
                    
                    match.team1 = team1
                    match.team2 = team2
                    
                    self.matches.append(match)
  
                }
                
                self.matchesFiltered = self.matches
                
                self.tableView.reloadData()
       
                (ref?.child("teams").queryOrderedByKey().observe(.value, with: { teamsData in
                    
                    self.spinner.stopAnimating()
                    self.pickerTeamsData = [String]()
                    self.pickerTeamsData.append("Todos")
                    
                    if teamsData.hasChildren() {
                        // Found teams
                        for teamData in teamsData.children {
                            
                            let team = Team()
                            
                            let data = (teamData as! DataSnapshot).value as! NSDictionary
                            
                            print("data \(teamData)")
                            print("data \(data)")
                            
                            team.name = data["name"] as? String
                            
                            self.pickerTeamsData.append(team.name ?? "")
 
                        }

                        self.pickerView.reloadAllComponents()
                        
                    } else {
                        // No Children
                        print("No children found.")
                    }
                    
                }))
                
                
            } else {
                // No Children
                print("No children found.")
            }
            
        }))
        
        
    }
    
    @IBAction func doneAction(_ sender: Any) {
        
        self.filterField.resignFirstResponder()
        
        if self.pickerTeamsData.count > 0{
            
            self.filterField.text = self.pickerTeamsData[self.pickerView.selectedRow(inComponent: 0)]
            
            self.filterMatches(name: filterField.text ?? "")
  
        }
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        self.filterField.resignFirstResponder()
        
    }
    
    
    func filterMatches(name:String){
        
        if self.filterField.text == "Todos" {
            
            self.matchesFiltered = self.matches
            self.tableView.reloadData()
            return
            
        }
        
        self.matchesFiltered = [Match]()
        
        for match in self.matches {
        
            if match.team1?.name == name || match.team2?.name == name{
                
                 self.matchesFiltered.append(match)
                
            }

        }
        
        self.tableView.reloadData()

    }
    

}

extension MatchesViewController : UIPickerViewDelegate, UIPickerViewDataSource{
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerTeamsData.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return pickerTeamsData[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        
        if self.pickerTeamsData.count > 0{
            
            
            
        }
        
    }
    
}


extension MatchesViewController: UITableViewDelegate, UITableViewDataSource{
    
    public func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return self.matchesFiltered.count
        
    }
    
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 90
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier:"MatchViewCell", for: indexPath) as! MatchViewCell
        
        cell.labelMatch.text = "Partido \(indexPath.row + 1)"
        
        let match = self.matchesFiltered[indexPath.row]

        cell.labelTeam1.text = match.team1?.name
        cell.labelTeam2.text = match.team2?.name
        
        cell.score.text = "\(match.scoreTeam1 ?? "0") - \(match.scoreTeam2 ?? "0")"
     
        return cell
        
    }
    
}
