//
//  Comment.swift
//  tableViewApp
//
//  Created by Sebastian Scales on 8/31/17.
//  Copyright © 2017 Sebastian Scales. All rights reserved.
//

import UIKit

class Comment: NSObject {
    
    var userID : String!
    var username : String!
    var postID : String!
    var commentID : String!
    var contents : String!
    var likes : Int!
    var peopleWhoLike: [String] = [String]()
    
}
