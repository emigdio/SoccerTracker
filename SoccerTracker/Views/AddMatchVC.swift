//
//  AddMatchVC.swift
//  SoccerTracker
//
//  Created by EMIGDIO CAMACHO CALDERON on 11/15/18.
//  Copyright © 2018 interfell. All rights reserved.
//

import UIKit
import Firebase

class AddMatchVC: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var scoreTeam2Field: UITextField!
    @IBOutlet weak var team2Field: UITextField!
    @IBOutlet weak var scoreTeam1Field: UITextField!
    @IBOutlet weak var team1Field: UITextField!
    
    @IBOutlet var pickerViewContent: UIView!
    @IBOutlet weak var pickerView: UIPickerView!
    
    var pickerTeamsData: [String] = [String]()
    var teams: [DataSnapshot] = [DataSnapshot]()

    
    var team1: DataSnapshot = DataSnapshot()
    var team2: DataSnapshot = DataSnapshot()
    
    enum select:Int {
        case Team1Selected = 1, Team2Selected = 2
    }

    var currentTextField = UITextField()
    
    var selectCurrent:select = .Team1Selected
    
    override func viewDidLoad() {
       
        super.viewDidLoad()
        
        self.navigationItem.title = "Agregar Partido"
        
        self.team1Field.inputView = self.pickerViewContent
        self.team2Field.inputView = self.pickerViewContent
        self.team1Field.delegate = self
        self.team2Field.delegate = self
        
        self.spinner.startAnimating()
        
        var ref: DatabaseReference!
        
        ref = Database.database().reference()
        
        (ref?.child("teams").queryOrderedByKey().observe(.value, with: { teamsData in
            
            self.spinner.stopAnimating()
            
            if teamsData.hasChildren() {
                // Found teams
                for teamData in teamsData.children {
                    
                    let team = Team()
                    
                    let data = (teamData as! DataSnapshot).value as! NSDictionary
                    
                    print("data \(teamData)")
                    print("data \(data)")
                    
                    team.name = data["name"] as? String
                    
                    self.pickerTeamsData.append(team.name ?? "")
                    self.teams.append((teamData as! DataSnapshot))
                
                    
                }
                
               
                
                self.pickerView.reloadAllComponents()
                
            } else {
                // No Children
                print("No children found.")
            }
            
        }))

    }

    @IBAction func doneAction(_ sender: Any) {
        
        self.currentTextField.resignFirstResponder()
        
        if self.pickerTeamsData.count > 0{
            
            self.currentTextField.text = self.pickerTeamsData[self.pickerView.selectedRow(inComponent: 0)]
            
            if selectCurrent == .Team1Selected{
                
                self.team1 = self.teams[self.pickerView.selectedRow(inComponent: 0)]
                
            } else if selectCurrent == .Team2Selected {
                
                self.team2 = self.teams[self.pickerView.selectedRow(inComponent: 0)]
                
            }

        }
        
    }
    
    @IBAction func cancelAction(_ sender: Any) {
        
        self.currentTextField.resignFirstResponder()
        
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        if self.team2Field.hasText && self.team1Field.hasText {
            
            var ref: DatabaseReference!
            
            ref = Database.database().reference()
            
            self.spinner.startAnimating()
            
            ref.child("matches").childByAutoId().setValue(["team1": (team1).value as! NSDictionary,"team2": (team2).value as! NSDictionary,"scoreTeam1": self.scoreTeam1Field.text ?? "0","scoreTeam2": self.scoreTeam2Field.text ?? "0"]) {
                (error:Error?, ref:DatabaseReference) in
                
                self.spinner.stopAnimating()
                
                if let error = error {
                    print("Data could not be saved: \(error).")
                } else {
                    print("Data saved successfully!")
                    self.navigationController?.popViewController(animated: true)
                }
            }
            
        }

    }
    
}

extension AddMatchVC : UIPickerViewDelegate, UIPickerViewDataSource{
    
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

extension AddMatchVC: UITextFieldDelegate{
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        self.currentTextField = textField
        
        switch textField {
            
        case team1Field:
            
            selectCurrent = .Team1Selected
            
        case team2Field:
            
            selectCurrent = .Team2Selected
            
        default:
            break
        }

    }

}
