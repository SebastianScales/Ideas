//
//  ContentsViewController.swift
//  tableViewApp
//
//  Created by Sebastian Scales on 8/16/17.
//  Copyright © 2017 Sebastian Scales. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class ContentsViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    @IBOutlet weak var labelTest: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var unlikeButton: UIButton!
    
    @IBOutlet weak var commentsTableView: UITableView!
    
    @IBOutlet weak var commentTextField: UITextField!
    
    @IBOutlet weak var usernameLabelz: UILabel!
    
    var ref: DatabaseReference!
    var handle: DatabaseHandle!
    var comments = [Comment]()
    
    var postID = ""
    var getPostID = String()
    var getText = String()
    var getUsername = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        ref = Database.database().reference()
        
        let tapped: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(ViewController.dismissKeyboard))
        tapped.cancelsTouchesInView = false
        
        view.addGestureRecognizer(tapped)
        
        self.unlikeButton.isHidden = true
        
        
        labelTest.text! = getText
        usernameLabelz.text! = getUsername
        postID = getPostID
        updateTableValues()
        
        
        
        labelTest.backgroundColor = UIColor.cyan
        labelTest.layer.borderWidth = 1
        labelTest.layer.masksToBounds = false
        labelTest.layer.cornerRadius = labelTest.frame.height/2
        labelTest.clipsToBounds = true
        labelTest.layer.borderWidth = 1
        labelTest.layer.borderColor = UIColor.white.cgColor
        
        handle = ref?.child("posts").child(postID).child("comments").observe(.childAdded, with: { (snapshot) in
            if let item = snapshot.value as? Comment {
                self.comments.append(item)
            }
            self.commentsTableView.reloadData()
            
        })
    }
    
    @objc func dismissKeyboard() {
        //Causes the view (or one of its embedded text fields) to resign the first responder status.
        view.endEditing(true)
    }

    @IBAction func likePressed(_ sender: Any) {
       
    }
    
    @IBAction func unlikePressed(_ sender: Any) {
        self.likeButton.isHidden = false
        self.unlikeButton.isHidden = true
        labelTest.backgroundColor = UIColor.red
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func postButtonPressed(_ sender: Any) {
        
            let ref = Database.database().reference()
            
                if Auth.auth().currentUser?.uid != nil && commentTextField.text != "" {
                    let uid = Auth.auth().currentUser?.uid
                    let commentKey = ref.child("posts").child(postID).child("comments").childByAutoId().key
                    let userCommentKey = ref.child("users").child(uid!).child("comments").childByAutoId().key
                    
                    
                    let commentsReference = ref.child("posts").child(postID).child("comments")
                    let userCommentsReference = ref.child("users").child(uid!).child("comments")
                    
                    commentsReference.child(commentKey).setValue(["userID": uid!, "username" : Auth.auth().currentUser?.displayName as String!, "contents" : commentTextField.text!, "likes" : 0,  "commentID": commentKey, "postID" : postID, "peopleWhoLike" : [""]])
                }
                    
                else {
                    
                    createAlert(title: "Chillllll", message: "Gotta sign in before you like homie")
                    print("You need to login in order to like and comment!")
                    
//                    let anonymousPost = ref.child("posts").child(postID).child("comments")
//                    let commentKey = ref.child("posts").child(postID).child("comments").childByAutoId().key
//
//                    anonymousPost.setValue(["userID": nil, "username" : "Anonymous", "contents" : commentTextField.text!, "likes" : 0,  "commentID": commentKey, "postID" : postID, "peopleWhoLike" : [""]])
                }
            
                updateTableValues()
            
                commentTextField.text = ""
                self.commentsTableView.reloadData()
        }
    
    func createAlert (title:String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
    func updateTableValues() {
        
        let ref = Database.database().reference()
        let postID = self.postID
        ref.child("posts").child(postID).child("comments").observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let commentsSnap = snapshot.value as? [String : AnyObject] {
            
            self.comments.removeAll()
            for (_,comment) in commentsSnap {
                let cOMMENT = Comment()
                if let userID = comment["userID"] as? String, let likes = comment["likes"] as? Int, let contents = comment["contents"] as? String, let username = comment["username"] as? String, let postID = comment["postID"], let commentID = comment["commentID"] as? String {
                    
                    cOMMENT.userID = userID
                    cOMMENT.likes = likes
                    cOMMENT.contents = contents
                    cOMMENT.username = username
                    cOMMENT.postID = postID as! String
                    cOMMENT.commentID = commentID
                    cOMMENT.peopleWhoLike = [""]
                    if let people = comment["peopleWhoLike"] as? [String : AnyObject] {
                        for (_,person) in people {
                            cOMMENT.peopleWhoLike.append(person as! String)
                        }
                    }
                    
                    self.comments.append(cOMMENT)
                }
                
                
            }
            self.commentsTableView.reloadData()
        }
        })
        ref.removeAllObservers()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return comments.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "commentsCell") as! CommentsTableViewCell
        
        cell.backgroundColor = UIColor.green
        cell.usernameLabel.text! = self.comments[indexPath.row].username
        cell.likeLabel.text! = "\(self.comments[indexPath.row].likes!) likes"
        cell.commentLabel.text! = self.comments[indexPath.row].contents
        cell.commentID = self.comments[indexPath.row].commentID
        return cell
    }
    
}

