//
//  Post.swift
//  tableViewApp
//
//  Created by Sebastian Scales on 8/23/17.
//  Copyright © 2017 Sebastian Scales. All rights reserved.
//

import UIKit

class Post: NSObject {
    
    var author: String!
    var likes: Int!
    var contents: String!
    var userID: String!
    var postID: String!
    var comments: [Comment] = [Comment]()
    var peopleWhoLike: [String] = [String]()
    
}
