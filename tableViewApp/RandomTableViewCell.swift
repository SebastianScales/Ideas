//
//  RandomTableViewCell.swift
//  tableViewApp
//
//  Created by Sebastian Scales on 8/16/17.
//  Copyright © 2017 Sebastian Scales. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth



class RandomTableViewCell: UITableViewCell {
    
    @IBOutlet weak var likeCount: UILabel!
    @IBOutlet weak var likeCountImage: UIImageView!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var unlikeButton: UIButton!
    
    
    var postID: String!
    
    let ref = Database.database().reference()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        likeCountImage.backgroundColor = UIColor.green
        
        likeCountImage.layer.borderWidth = 1
        likeCountImage.layer.masksToBounds = false
        likeCountImage.layer.cornerRadius = likeCountImage.frame.height/2
        likeCountImage.clipsToBounds = true
        likeCountImage.layer.borderWidth = 1
        likeCountImage.layer.borderColor = UIColor.white.cgColor
        
        self.unlikeButton.isHidden = true
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
    }
    
    @IBAction func likeButtonPressed(_ sender: Any) {
        self.likeButton.isEnabled = false
        let ref = Database.database().reference()
        
        let keyToPost = ref.child("posts").childByAutoId().key
        if Auth.auth().currentUser?.uid != nil {
            ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
                
                if let post = snapshot.value as? [String : AnyObject] {
                    let updateLikes: [String: Any] = ["peopleWhoLike/\(keyToPost)" : Auth.auth().currentUser!.uid]
                    ref.child("posts").child(self.postID).updateChildValues(updateLikes, withCompletionBlock: { (error, reff) in
                        
                        if error == nil {
                            ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                                
                                if let properties = snap.value as? [String: AnyObject] {
                                    if let likes = properties["peopleWhoLike"] as? [String : AnyObject] {
                                        let count = likes.count
                                        self.likeCount.text = "\(count) likes"
                                        
                                        let update = ["likes" : count]
                                        ref.child("posts").child(self.postID).updateChildValues(update)
                                        
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
        self.unlikeButton.isEnabled = false
        let ref = Database.database().reference()
        
        ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snapshot) in
            
            if let properties = snapshot.value as? [String: AnyObject] {
                if let peopleWhoLike = properties["peopleWhoLike"] as? [String : AnyObject] {
                    for (id,person) in peopleWhoLike {
                        if person as? String == Auth.auth().currentUser?.uid {
                            ref.child("posts").child(self.postID).child("peopleWhoLike").child(id).removeValue(completionBlock: { (error, reff) in
                                if error == nil {
                                    ref.child("posts").child(self.postID).observeSingleEvent(of: .value, with: { (snap) in
                                        
                                        if let prop = snap.value as? [String: AnyObject] {
                                            if let likes = prop["peopleWhoLike"] as? [String : AnyObject] {
                                                let count = likes.count
                                                self.likeCount.text = "\(count) Likes"
                                                ref.child("posts").child(self.postID).updateChildValues(["likes":count])
                                                
                                            }
                                            else {
                                                self.likeCount.text = "0 Likes"
                                                ref.child("posts").child(self.postID).updateChildValues(["likes":0])
                                                
                                            }
                                        }
                                    })
                                }
                            })
                            
                            self.likeButton.isHidden = false
                            self.unlikeButton.isHidden = true
                            self.unlikeButton.isEnabled = true
                            break
                            
                        }
                    }
                }
            }
            
            
        })
        ref.removeAllObservers()
    }
    
    func createAlert (title:String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Okay", style: UIAlertActionStyle.default, handler: {(action) in
            alert.dismiss(animated: true, completion: nil)
        }))
        UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
    }
}
