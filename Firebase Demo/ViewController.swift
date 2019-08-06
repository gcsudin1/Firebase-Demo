//
//  ViewController.swift
//  Firebase Demo
//  Created by IMCS2 on 7/31/19.
//  Copyright © 2019 IMCS2. All rights reserved.

import UIKit
import Firebase
import FirebaseDatabase
var todoListItems = [String]()
class ViewController: UITableViewController {
    var ref : DatabaseReference!
    var infoArray:[String] = []
    
    override func viewDidAppear(_ animated: Bool) {
        tableView.reloadData()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchDataFromFirebase()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoListItems.count
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at: indexPath)
        if editingStyle == .delete{
            let name = infoArray[indexPath.row]
            ref = Database.database().reference().child("Student").child(name)
            ref.removeValue()
            tableView.reloadData()
            todoListItems.remove(at: indexPath.row)
            self.tableView.deleteRows(at:[indexPath],with:.automatic) //deleting the rows
        }
        self.infoArray.removeAll()
        }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        let todo: String = todoListItems[indexPath.row]
        cell.textLabel?.text = todo
        return cell
    }
    func fetchDataFromFirebase(){
        ref = Database.database().reference().child("Student")
        ref.observe(.value) { (snapshot:DataSnapshot) in
            todoListItems.removeAll()                         //for removing second loaded data
            for nameValue in snapshot.children {
                let snapshotContent = nameValue as? DataSnapshot
                let namedata = (snapshotContent?.value as? NSDictionary)!
                self.infoArray.append(snapshotContent!.key)
                todoListItems.append(namedata["List"] as! String!)
            }
            self.tableView.reloadData()
        }
        
    }
}
