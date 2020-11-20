//
//  CategoryViewController.swift
//  ToDo App
//
//  Created by Partheepan Shiyamsunthar on 11/20/20.
//

import UIKit
import CoreData

class CategoryViewController: UITableViewController {
    
    var itemName = [Category]()
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    }
    
    //MARK: - TableView DataSource Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemName.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath)
        
        cell.textLabel?.text = itemName[indexPath.row].name
        
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    //MARK: - TableVIew Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    //MARK: - Add New Categories
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Add new Category", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
            let newCategory = Category(context: self.context)
            newCategory.name = textField.text!
            self.itemName.append(newCategory)
            self.saveData()
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create a new Category"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    //MARK: - Functions
    
    func saveData() {
        do{
            try context.save()
        }catch{
            print ("Error saving data \(error)")
        }
        
        tableView.reloadData()
    }
    
    func loadData(with request : NSFetchRequest<Category> = Category.fetchRequest()) {
        do{
            itemName = try context.fetch(request)
        }catch{
            print ("Error loading data \(error)")
        }
        
        tableView.reloadData()
    }
}
