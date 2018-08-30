//
//  CategoryViewController.swift
//  StrikeMeOff!
//
//  Created by Sidhant Chadha on 8/27/18.
//  Copyright © 2018 AMoDynamics, Inc. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class CategoryViewController: SwipeTableViewController  {
    
    //Initialize realm
    let realm = try! Realm()

    //No array in realms. Result collection type in Realm
    var categoryArray : Results<Category>?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadCategories()
        tableView.separatorStyle = .none
    }
    
    override func viewWillAppear(_ animated: Bool) {
        //navigationController?.navigationBar.tintColor = UIColor.blue
    }
    
    //MARK: - TableView Data Source methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //nil coalescing operator
        return categoryArray?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
        
        if let category = categoryArray?[indexPath.row] {
            cell.textLabel?.text = category.name
            guard let categoryColor = UIColor(hexString: category.color) else {fatalError()}
            cell.backgroundColor = categoryColor
            cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
        }
        return cell
        
    }
    
    //MARK: - TableView Delegate methods
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "goToItems", sender: self)
    }
    
    //Prepare for segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destVC = segue.destination as! ToDoListViewController
        if let indexPath = tableView.indexPathForSelectedRow {
            destVC.selectedCategory = categoryArray?[indexPath.row]
        }
    }
    

    //MARK: - Add new categories
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new category", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add category", style: .default) { (action) in
            
            //What to do when Add category is pressed
            let newCategory = Category()
            newCategory.name = textField.text!
            newCategory.color = UIColor.randomFlat.hexValue()
            self.save(category: newCategory)
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Add new category."
            //Capture input data into a global variable to be used outside scope
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
    }
    
    //MARK: - Data Manipulation Methods
    
    //Saving categories to Realm
    func save(category : Category) {
        
        do {
            try realm.write {
                realm.add(category)
            }
            
        } catch {
            print("Error saving categories \(error)")
        }
        self.tableView.reloadData()
    }
    
    //Retreiving categories from Realm
   func loadCategories() {

    categoryArray = realm.objects(Category.self)
    tableView.reloadData()
   }
    
    //Deleting categories from Realm
    //Override to inherit from superclass
    override func updateModel(at indexPath : IndexPath) {
        if let categoryToDelete = self.categoryArray?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(categoryToDelete)
                }
            } catch {
                print("Error deleting row")
            }
        }
    }
    
}


