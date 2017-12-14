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
    @IBOutlet weak var firstTable: UITableView!
    
    var databaseRef: DatabaseReference!
    private var viewModel: FruitsViewModel?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = FruitsViewModel()
        viewModel?.fruitsDictionary?.observeNext(with: { (fd) in
            print("change observed in fruit dictionary")
            print(fd)
        })
        viewModel?.fruitsArray?.bind(to: firstTable) { dataSource, indexPath, tableView in
            print("loading dynamic cell")
            print(dataSource)
            print(indexPath)
            print("============================")
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ViewControllerTableViewCell
            cell.fruitName.text = dataSource.item(at: 0).value(forKey: "name") as! String
            let likesCount: Int = dataSource.item(at: 0).value(forKey: "upvotes") as! Int
            cell.likes.text = String(likesCount)
            return cell
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}



