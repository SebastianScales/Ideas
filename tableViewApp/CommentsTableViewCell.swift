//
//  CommentsTableViewCell.swift
//  tableViewApp
//
//  Created by Sebastian Scales on 8/31/17.
//  Copyright © 2017 Sebastian Scales. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase

class CommentsTableViewCell: UITableViewCell {

    @IBOutlet weak var likeLabel: UILabel!
    @IBOutlet weak var commentLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var unlikeButton: UIButton!
    
    var commentID = ""
    var postID: String!
    
    let ref = Database.database().reference()
    
    var getCommentID = String()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        commentID = getCommentID
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        self.likeButton.isEnabled = false
        let ref = Database.database().reference()
        
        let keyToPost = ref.child("posts").child(postID).child("comments").child(self.commentID).childByAutoId().key
        if Auth.auth().currentUser?.uid != nil {
            ref.child("posts").child(self.postID).child("comments").child("commentID").observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let comment = snapshot.value as? [String : AnyObject] {
                    let updateLikes: [String: Any] = ["peopleWhoLike/\(keyToPost)" : Auth.auth().currentUser!.uid]
                    ref.child("posts").child(self.postID).child("comments").child(self.commentID).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                        
                        if error == nil {
                            ref.child("posts").child(self.postID).child("comments").child(self.commentID).observeSingleEvent(of: .value, with: { (snap) in
                                
                                if let properties = snap.value as? [String: AnyObject] {
                                    if let likes = properties["peopleWhoLike"] as? [String : AnyObject] {
                                        let count = likes.count
                                        self.likeLabel.text = "\(count) likes"
                                        
                                        let update = ["likes" : count]
                                        ref.child("posts").child(self.postID).child("comments").child(self.commentID).updateChildValues(update)
                                        
                                        self.likeButton.isHidden = true
                                        self.unlikeButton.isHidden = false
                                        self.likeButton.isEnabled = true
                                    }
                                }
                            })
                        }
                    })
                }
                
            })
            ref.removeAllObservers()
        }
        else {
            createAlert(title: "Chillllll", message: "Gotta sign in before you like homie")
            print("You need to login in order to like and comment!")
        }
    }
    @IBAction func unlikeButtonPressed(_ sender: Any) {
        
    }
    
    func createAlert (title:String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
    
}
