//
//  SignInViewController.swift
//  tableViewApp
//
//  Created by Sebastian Scales on 8/14/17.
//  Copyright © 2017 Sebastian Scales. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignInViewController: UIViewController {
    
    var ref: DatabaseReference?
    
    @IBOutlet weak var username: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var signInButton: UIButton!
    @IBOutlet weak var segControl: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.green
        navigationController?.navigationBar.barTintColor = UIColor.green
    }
    
    @IBAction func signInPressed(_ sender: Any) {
        
        ref = Database.database().reference()
        
        if email.text != "" && password.text != "" {
            
            if segControl.selectedSegmentIndex == 0 {//Sign in User
                
                Auth.auth().signIn(withEmail: email.text!, password: password.text!, completion: { (user, error) in
                    if user != nil {
                        self.performSegue(withIdentifier: "signInToFeedSegue", sender: nil)
                        
                    }
                    else {
                        if let myError = error?.localizedDescription{
                            print(myError)
                        }
                        else {
                        print("ERROR")
                        }
                    }
                    
                })
            }
            else{ //Sign up User
                Auth.auth().createUser(withEmail: email.text!, password: password.text!, completion: { ( user, error) in
  
                    
                    if user == nil {
                        if let myError = error?.localizedDescription{
                            print(myError)
                        }
                        else {
                            print("ERROR")
                        }
                    }
                    else {
                        let userReference = self.ref?.child("users")
                        let uid = user?.uid
                        let newUserReference = userReference?.child(uid!)
                        let changeRequest = Auth.auth().currentUser!.createProfileChangeRequest()
                        changeRequest.displayName = self.username.text!
                        changeRequest.commitChanges(completion: nil)
                        newUserReference?.setValue(["username": self.username.text!, "email": self.email.text!, "password": self.password.text!])
                    }
                })
            }
        }
    }
    @IBAction func signInLaterPressed(_ sender: Any) {
        self.performSegue(withIdentifier: "signInToFeedSegue", sender: nil)
    }
    
}
