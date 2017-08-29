//
//  ViewController.swift
//  tableViewApp
//
//  Created by Sebastian Scales on 8/14/17.
//  Copyright © 2017 Sebastian Scales. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var sections:NSArray = []
    
    @IBOutlet weak var logoutButton: UIBarButtonItem!
    var myList: [String] = []
    var usernameList: [String] = []
    
    @IBOutlet weak var tableView1: UITableView!
    var activeField: UITextField?
    
    
    var ref: DatabaseReference!
    var handle: DatabaseHandle?
    
    var posts = [Post]()
    
    
    @IBOutlet weak var postTextField: UITextField!
    @IBOutlet weak var postButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        handle = ref?.child("posts").observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.value as? Post {
                self.posts.append(item)
            }
            self.tableView1.reloadData()

        })
        
        updateTableValues()
        //Looks for single or multiple taps.
        let tapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tapped.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tapped)
        
        sections = ["Newest", "Popular", "Funny"]
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }
    
    func fetchPosts(){
        let ref = Database.database().reference()
        
        ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
            
            let postsSnap = snapshot.value as! [String : AnyObject]
            
            for (_,post) in postsSnap {
                let pOST = Post()
                if let author = post["author"] as? String, let likes = post["likes"] as? Int, let contents = post["contents"] as? String, let userID = post["userID"] as? String {
                    pOST.author = author
                    pOST.likes = likes
                    pOST.contents = contents
                    pOST.userID = userID
                    
                    self.posts.append(pOST)
                }
                
            }
            self.tableView1.reloadData()
            
        })
        ref.removeAllObservers()
    }
    
    func updateTableValues() {
        
        let ref = Database.database().reference()
        
        ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let postsSnap = snapshot.value as! [String : AnyObject]
            self.posts.removeAll()
            for (_,post) in postsSnap {
                let pOST = Post()
                if let author = post["author"] as? String, let likes = post["likes"] as? Int, let contents = post["contents"] as? String, let userID = post["userID"] as? String {
                    pOST.author = author
                    pOST.likes = likes
                    pOST.contents = contents
                    pOST.userID = userID
                    
                    self.posts.append(pOST)
                }
                
            }
            self.tableView1.reloadData()
            
        })
        ref.removeAllObservers()
        
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        let uid = Auth.auth().currentUser?.uid
        let ref = Database.database().reference()
        let key = ref.child("posts").childByAutoId().key
        
        if postTextField.text != "" {
            let currentUser = Auth.auth().currentUser
            if uid != nil {
                
                let userPost = ref.child("users").child((currentUser?.uid)!).child("Posts")
                let newPostReference = userPost.child(key)
                newPostReference.setValue(["post ID": key, "post contents" : postTextField.text!])
                
                let postsList = ref.child("posts").child(key)
                    postsList.setValue(["userID": currentUser?.uid, "contents" : postTextField.text!, "likes" : 0, "author": currentUser?.displayName])
            }
            else {
               let anonymousPost = ref.child("posts").child(key)
                anonymousPost.setValue(["userID": "", "contents" : postTextField.text!, "likes" : 0, "author": "Anonyms"])
            }
            
          //  ref.child("posts").queryOrderedByKey().observeSingleEvent(of: .value, with: { (snapshot) in
                
                
         //   })
                
            updateTableValues()
            
            postTextField.text = ""
            self.tableView1.reloadData()
            
        }
    }
    
    
    @IBAction func logoutButtonPressed(_ sender: Any) {
        do {
            try Auth.auth().signOut()
        }
        catch let logoutError {
            print(logoutError)
        }
        self.performSegue(withIdentifier: "feedToSignInSegue", sender: nil)
    }
    
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let DvC = Storyboard.instantiateViewController(withIdentifier: "ContentsViewController") as! ContentsViewController
        
        DvC.getText = posts[indexPath.row].contents
        DvC.getUsername = posts[indexPath.row].author
        self.navigationController?.pushViewController(DvC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RandomTableViewCell
        
        
        cell.descriptionLabel?.text = self.posts[indexPath.row].contents
        cell.usernameLabel?.text = self.posts[indexPath.row].author
        var number = self.posts[indexPath.row].likes
        cell.likeCount?.text = String(describing: number)
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return sections.count
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.green
        
        let label = UILabel()
        label.text = sections[section] as! String
        label.frame = CGRect(x: 45, y: 5, width: 100, height: 35)
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
}

