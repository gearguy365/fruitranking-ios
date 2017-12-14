//
//  FruitCell.swift
//  firebasemanual
//
//  Created by Admin on 14/12/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import FirebaseDatabase

class ViewControllerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fruitName: UITextField!
    @IBOutlet weak var likes: UITextField!
    @IBOutlet weak var likeButton: UIButton!
    public var databaseRef: DatabaseReference = Database.database().reference()
//    public var likeCount: Int!
    
    @IBAction func likeClicked(_ sender: Any) {
        print("like clicked")
        let fruitNameText: String = fruitName.text!
        print(fruitNameText)
        let likeCount: Int = Int(likes.text!)!
        databaseRef.child("fruits/\(fruitNameText)/upvotes").setValue(likeCount + 1)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
