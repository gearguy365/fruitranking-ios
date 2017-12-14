//
//  FruitsViewModel.swift
//  firebasemanual
//
//  Created by Admin on 14/12/17.
//  Copyright © 2017 home. All rights reserved.
//

import Foundation
import FirebaseDatabase
import Bond
import ReactiveKit

class FruitsViewModel {
    
    let fruitsDictionary: Observable<NSDictionary>?
    var fruitsArray: MutableObservableArray<NSDictionary>?
    var databaseRef: DatabaseReference!
    
    init() {
        fruitsDictionary = Observable<NSDictionary>([:])
        fruitsArray = MutableObservableArray<NSDictionary>([])
        
        databaseRef = Database.database().reference()
        databaseRef.child("fruits").observe(DataEventType.value) { (DataSnapShot) in
            let fruitsDictionary = (DataSnapShot.value as? NSDictionary)!
            self.fruitsDictionary?.next(fruitsDictionary)
            
            self.fruitsArray?.removeAll()
            for (fruitName, fruitDetails) in fruitsDictionary {
                var fruitDetails = fruitDetails as? [String : Any]
                fruitDetails!["name"] = fruitName
                self.fruitsArray?.insert(fruitDetails as! NSDictionary, at: 0)
            }
        }
    }
}
