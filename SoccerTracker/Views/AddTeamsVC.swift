//
//  AddTeamsVC.swift
//  SoccerTracker
//
//  Created by EMIGDIO CAMACHO CALDERON on 11/14/18.
//  Copyright © 2018 interfell. All rights reserved.
//

import UIKit
import Firebase

class AddTeamsVC: UIViewController {

    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var nameTeam: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "Agregar Equipo"
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
      
    }
    
    @IBAction func saveAction(_ sender: Any) {
        
        if self.nameTeam.hasText {
            
            var ref: DatabaseReference!
            
            ref = Database.database().reference()
            
            self.spinner.startAnimating()
            
            ref.child("teams").childByAutoId().setValue(["name": nameTeam.text]) {
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
