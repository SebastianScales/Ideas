//
//  ContentsViewController.swift
//  tableViewApp
//
//  Created by Sebastian Scales on 8/16/17.
//  Copyright © 2017 Sebastian Scales. All rights reserved.
//

import UIKit

class ContentsViewController: UIViewController {

    @IBOutlet weak var labelTest: UILabel!
    @IBOutlet weak var likeButton: UIButton!
    @IBOutlet weak var unlikeButton: UIButton!
    
    @IBOutlet weak var usernameLabelz: UILabel!
    var getText = String()
    var getUsername = String()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        labelTest.text! = getText
        usernameLabelz.text! = getUsername
        labelTest.backgroundColor = UIColor.cyan
        labelTest.layer.borderWidth = 1
        labelTest.layer.masksToBounds = false
        labelTest.layer.cornerRadius = labelTest.frame.height/2
        labelTest.clipsToBounds = true
        labelTest.layer.borderWidth = 1
        labelTest.layer.borderColor = UIColor.white.cgColor
    }

    @IBAction func likePressed(_ sender: Any) {
        self.likeButton.isHidden = true
        self.unlikeButton.isHidden = false
        labelTest.backgroundColor = UIColor.green
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
    
    

}
