//
//  ViewController.swift
//  ToDo App
//
//  Created by Partheepan Shiyamsunthar on 11/6/20.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var toDoArray = [Item]()
    
    var selectedCategory : Category?{
        didSet{
            loadData()
        }
    }
    
    let defaults = UserDefaults.standard
    
    let dataFilePath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first?.appendingPathComponent("Items.plist")
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
//        print (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
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
           
            
            
            let newItem = Item(context: self.context)
            
            newItem.title = textField.text!
            
            newItem.done = false
            
            newItem.parentCategory = self.selectedCategory
            
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
        
        
        do{
            try context.save()
            
        }catch{
            print ("Error saving context\(error)")
        }
        
        self.tableView.reloadData()
    }
    
    
//    func loadData(){
//          let decoder = PropertyListDecoder()
//
//        do{
//            let data = try Data(contentsOf: dataFilePath!)
//            toDoArray = try decoder.decode([Item].self, from: data)
//        } catch {
//            print ("Error writing data\(error)")
//        }
//    }
    
    func loadData(with request : NSFetchRequest<Item> = Item.fetchRequest(), with predicate : NSPredicate? = nil) {
        
        let catagoryPredicate  = NSPredicate(format: "parentCategory.name MATCHES %@", selectedCategory!.name!)
        
        if let additionalPredicate = predicate{
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: [catagoryPredicate, additionalPredicate])
        } else {
            request.predicate = catagoryPredicate
        }
        
        do {
        toDoArray = try context.fetch(request)
        } catch {
            print ("Error fetching data \(error)")
        }
        tableView.reloadData()
    }
    
}


extension ToDoListViewController : UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        let request : NSFetchRequest<Item> = Item.fetchRequest()
        
        let searchItem = searchBar.text!
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", searchItem)
        
        request.sortDescriptors  = [NSSortDescriptor(key: "title", ascending: true)]
        
        loadData(with: request, with: predicate)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0{
            loadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
            
        }
    }
    
}
