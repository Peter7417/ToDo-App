//
//  ViewController.swift
//  ToDo App
//
//  Created by Partheepan Shiyamsunthar on 11/6/20.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    let toDoArray = ["Open Bank Account", "Setup Mobile Plan", "Review Flat details"]

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }

    //MARK: - TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        cell.textLabel?.text = toDoArray[indexPath.row]
        
        return cell
    }
    
    
}

