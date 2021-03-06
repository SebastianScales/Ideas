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
    
    @IBOutlet weak var tableView1: UITableView!
    
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

    func updateTableValues() {
        
        let ref = Database.database().reference()
        
        ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
            
            let postsSnap = snapshot.value as! [String : AnyObject]
            self.posts.removeAll()
            for (_,post) in postsSnap {
                let pOST = Post()
                if let author = post["author"] as? String, let likes = post["likes"] as? Int, let contents = post["contents"] as? String, let userID = post["userID"] as? String, let postID = post["postID"] as? String {
                    pOST.author = author
                    pOST.likes = likes
                    pOST.contents = contents
                    pOST.userID = userID
                    pOST.postID = postID
                    if let people = post["peopleWhoLike"] as? [String : AnyObject] {
                        for (_,person) in people {
                            pOST.peopleWhoLike.append(person as! String)
                        }
                    }
                    
                    self.posts.append(pOST)
                }
                
            }
            self.posts = self.posts.sorted {
                $0.likes > $1.likes
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
                newPostReference.setValue(["userID": currentUser?.uid, "contents" : postTextField.text!, "likes" : 0, "author": currentUser?.displayName, "postID": key])
                
                let postsList = ref.child("posts").child(key)
                postsList.setValue(["userID": currentUser?.uid, "contents" : postTextField.text!, "likes" : 0, "author": currentUser?.displayName, "postID": key])
            }
            else {
               let anonymousPost = ref.child("posts").child(key)
                anonymousPost.setValue(["userID": "", "contents" : postTextField.text!, "likes" : 0, "author": "Anonymous", "postID": key])
            }

                
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
    
    @IBAction func newestPressed(_ sender: Any) {
    
//        let ref = Database.database().reference()
//
//        ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
//
//            let postsSnap = snapshot.value as! [String : AnyObject]
//            self.posts.removeAll()
//            for (_,post) in postsSnap {
//                let pOST = Post()
//                if let author = post["author"] as? String, let likes = post["likes"] as? Int, let contents = post["contents"] as? String, let userID = post["userID"] as? String, let postID = post["postID"] as? String {
//                    pOST.author = author
//                    pOST.likes = likes
//                    pOST.contents = contents
//                    pOST.userID = userID
//                    pOST.postID = postID
//                    if let people = post["peopleWhoLike"] as? [String : AnyObject] {
//                        for (_,person) in people {
//                            pOST.peopleWhoLike.append(person as! String)
//                        }
//                    }
//
//                    self.posts.append(pOST)
//                }
//
//            }
//            self.posts = self.posts.sorted {
//                $0.likes < $1.likes
//            }
//            self.tableView1.reloadData()
//
//        })
//        ref.removeAllObservers()
        
        createAlert(title: "Yoo", message: "Still developing this brobeans")

        
    }
    
    @IBAction func popularPressed(_ sender: Any) {
//        let ref = Database.database().reference()
//
//        ref.child("posts").observeSingleEvent(of: .value, with: { (snapshot) in
//
//            let postsSnap = snapshot.value as! [String : AnyObject]
//            self.posts.removeAll()
//            for (_,post) in postsSnap {
//                let pOST = Post()
//                if let author = post["author"] as? String, let likes = post["likes"] as? Int, let contents = post["contents"] as? String, let userID = post["userID"] as? String, let postID = post["postID"] as? String {
//                    pOST.author = author
//                    pOST.likes = likes
//                    pOST.contents = contents
//                    pOST.userID = userID
//                    pOST.postID = postID
//                    if let people = post["peopleWhoLike"] as? [String : AnyObject] {
//                        for (_,person) in people {
//                            pOST.peopleWhoLike.append(person as! String)
//                        }
//                    }
//
//                    self.posts.append(pOST)
//                }
//
//            }
//            self.posts = self.posts.sorted {
//                $0.likes > $1.likes
//            }
//            self.tableView1.reloadData()
//
//        })
//        ref.removeAllObservers()
        
        createAlert(title: "Yoo", message: "Still developing this brobeans")
        
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        let Storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        let DvC = Storyboard.instantiateViewController(withIdentifier: "ContentsViewController") as! ContentsViewController
        
        DvC.getText = posts[indexPath.row].contents
        DvC.getUsername = posts[indexPath.row].author
        DvC.getPostID = posts[indexPath.row].postID
        
        self.navigationController?.pushViewController(DvC, animated: true)
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! RandomTableViewCell
        
        cell.descriptionLabel?.text = self.posts[indexPath.row].contents
        cell.usernameLabel?.text = self.posts[indexPath.row].author
        cell.likeCount.text = "\(self.posts[indexPath.row].likes!) likes"
        cell.postID = self.posts[indexPath.row].postID
        
        for person in self.posts[indexPath.row].peopleWhoLike {
            if person == Auth.auth().currentUser?.uid {
                cell.likeButton.isHidden = true
                cell.unlikeButton.isHidden = false
                break
            }
        }
        
        return cell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = UIColor.green
        
        let label = UILabel()
        label.text = sections[section] as? String
        label.frame = CGRect(x: 45, y: 5, width: 100, height: 35)
        view.addSubview(label)
        
        return view
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func createAlert (title:String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "My b", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}

