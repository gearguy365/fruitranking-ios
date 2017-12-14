//
//  ViewController.swift
//  firebasemanual
//
//  Created by Admin on 1/12/17.
//  Copyright © 2017 home. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Bond
import ReactiveKit

class ViewController: UIViewController {
    @IBOutlet weak var secondTable: UITableView!
    @IBOutlet weak var firstTable: UITableView!
    let fruits = ["bananna", "apple", "orange"]
    
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return (fruits.count)
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        print("cell is being loaded")
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
//        cell.fruitName.text = fruits[indexPath.row]
//        return cell
//    }
    
    @IBOutlet weak var labelOne: UILabel!
    @IBOutlet weak var textOne: UITextField!
    var databaseRef: DatabaseReference!
    private var viewModel: FruitsViewModel?
    
    @IBAction func buttonClick(_ sender: Any) {
        //observableString?.next("whats up!")
        //databaseRef.child("tasks").child("-KgT6osvXyEyUl8RZbZw").setValue(["title": "bamboo", "priority": 0])
//            .observeSingleEvent(of: .value) { (data) in
//            var task = data.value as? NSDictionary
//            print(task)
//        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FruitsViewModel()
        viewModel?.fruitsDictionary?.observeNext(with: { (fd) in
            print("change observed in fruit dictionary")
            print(fd)
        })
//        viewModel?.fruitsArray?.observeNext(with: { (farray) in
//            print("change observed in fruit array")
//            print(farray.source)
//        })
        viewModel?.fruitsArray?.bind(to: firstTable) { dataSource, indexPath, tableView in
            print("loading dynamic cell")
            print(dataSource)
            print(indexPath)
            print("============================")
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
            cell.fruitName.text = dataSource.item(at: 0).value(forKey: "name") as! String
            let likesCount: Int = dataSource.item(at: 0).value(forKey: "upvotes") as! Int
            cell.likeCount = likesCount
            cell.likes.text = String(likesCount)
            cell.databaseRef = self.databaseRef
            return cell
        }
        
//        viewModel?.fruitsDictionary?.bind(to: secondTable) { dataSource, indexPath, tableView in
//            //do something
//        }
        
        databaseRef = Database.database().reference()
//        observableString = Observable<String>("hello man")
//        observableString?.bind(to: labelOne)
//        textOne.reactive.text.bind(to: labelOne)
//        databaseRef.child("tasks").child("-KgT6osvXyEyUl8RZbZw").observe(DataEventType.value) { (data) in
//            print(data.value)
//        }
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

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
//            self.fruitsArray?.insert(contentsOf: (DataSnapShot.value as? Array)!, at: 0)
            
        }
    }
}

class ViewControllerTableViewCell: UITableViewCell {
    
    @IBOutlet weak var fruitName: UITextField!
    @IBOutlet weak var likes: UITextField!
    @IBOutlet weak var likeButton: UIButton!
    var databaseRef: DatabaseReference!
    var likeCount: Int!
    
    @IBAction func likeClicked(_ sender: Any) {
        print("like clicked")
        let fruitNameText: String = fruitName.text!
        print(fruitNameText)
        databaseRef.child("fruits/\(fruitNameText)/upvotes").setValue(likeCount + 1)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}



