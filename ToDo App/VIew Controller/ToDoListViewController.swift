//
//  ViewController.swift
//  ToDo App
//
//  Created by Partheepan Shiyamsunthar on 11/6/20.
//

import UIKit

class ToDoListViewController: UITableViewController {
    
    var toDoArray = [Item]()
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadData()
        
//        if let items = defaults.array(forKey: "ToDoListArray") as? [Item]{
//            toDoArray = items
//        }
        
    }

    //MARK: - TableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return toDoArray.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ToDoItemCell", for: indexPath)
        
        let item = toDoArray[indexPath.row]
        
        cell.textLabel?.text = item.title
        
        cell.accessoryType = item.done == true ? .checkmark : .none
        
        return cell
    }
    
    //MARK: - TableViewDelegateMethods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
       
        toDoArray[indexPath.row].done = !toDoArray[indexPath.row].done
        
        saveData()
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    //MARK: - Add new items
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add New ToDo Item", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Item", style: .default) { (action) in
            let newItem = Item()
            
            newItem.title = textField.text!
            
            self.toDoArray.append(newItem)
            
            self.saveData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new ToDo item"
            textField = alertTextField
        }
        
        alert.addAction(action)
       
        
        present(alert, animated: true, completion: nil)
    }
    
    //MARK: - Functions

    func saveData(){
        let encoder = PropertyListEncoder()
        
        do{
            let data = try encoder.encode(toDoArray)
            try data.write(to: dataFilePath! )
        }catch{
            print ("Error encoding item array \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData(){
        let decoder = PropertyListDecoder()
        
        do{
        let data = try Data(contentsOf: dataFilePath!)
            toDoArray = try decoder.decode([Item].self, from: data)
        } catch {
            print ("Error decoding item array \(error)")
        }
    }
    
}



