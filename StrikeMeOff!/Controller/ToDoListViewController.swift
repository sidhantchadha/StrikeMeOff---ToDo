//
//  ViewController.swift
//  StrikeMeOff!
//
//  Created by Sidhant Chadha on 8/23/18.
//  Copyright © 2018 AMoDynamics, Inc. All rights reserved.
//

import UIKit
import RealmSwift
import ChameleonFramework

class ToDoListViewController: SwipeTableViewController {

    @IBOutlet weak var searchBar: UISearchBar!
    //Array to store items to be loaded onto tableview
    var todoItems : Results<Item>?
    let realm = try! Realm()
    
    //Category selection
    var selectedCategory : Category? {
        //didSet- To specify what should happen when variable gets initialized with new value
        didSet {
            loadItems()
            
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.separatorStyle = .none

    }
    
    override func viewWillAppear(_ animated: Bool) {
        title = selectedCategory?.name

        guard let colorHex = selectedCategory?.color else { return }
        guard let navBar = navigationController?.navigationBar else {return}
        guard let navBarColor = UIColor(hexString: colorHex) else { return }
            navBar.barTintColor = navBarColor
            navBar.tintColor = ContrastColorOf(navBarColor , returnFlat: true)
            navBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor : ContrastColorOf(navBarColor, returnFlat: true)]
            searchBar.barTintColor = navBarColor
        
    }
    
    //Return default color to navigation bar when we return back to categories
    override func viewWillDisappear(_ animated: Bool) {
        guard let originalColor = UIColor(hexString: "1D9BF6") else { return }
        navigationController?.navigationBar.barTintColor = originalColor
        navigationController?.navigationBar.tintColor = FlatWhite()
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedStringKey.foregroundColor: FlatWhite()]
    }
    
    //MARK: - TableView Data Source Methods
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItems?.count ?? 1
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = super.tableView(tableView, cellForRowAt: indexPath)
       if let item = todoItems?[indexPath.row] {
            
            cell.textLabel?.text = item.title
        if let color = UIColor(hexString: (selectedCategory!.color))?.darken(byPercentage:(CGFloat(indexPath.row)/CGFloat(todoItems!.count))){
            cell.backgroundColor = color
            //Set text to change color to white on darker background, chameleon framework
            cell.textLabel?.textColor = ContrastColorOf(color, returnFlat: true)
            }
        
        
        
        
            
            //Add checkmark to cell if selected. Use ternary operator make code look elegant
            cell.accessoryType = item.done ? .checkmark : .none
        } else {
            cell.textLabel?.text = "No items added!"
        }

        return cell
        
    }
    
    //MARK: - TableView Delegate Methods
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {

        if let item = todoItems?[indexPath.row] {
            do {
            try realm.write {
                item.done = !item.done
                }
            }catch {
                print("Error saving done status")
            }
        }
        tableView.reloadData()

        //Add fade effect to remove gray highlighted area on cell selection
        tableView.deselectRow(at: indexPath, animated: true)

    }
    
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        
        var textField = UITextField()
        let alert = UIAlertController(title: "Add new Strikey!", message: nil, preferredStyle: .alert)
        let action = UIAlertAction(title: "Add Strikey!", style: .default) { (action) in
            
            if let currentCategory = self.selectedCategory {
                do {
                try self.realm.write {
                    //What to do when Add Strikey! is pressed
                    let newItem = Item()
                    newItem.title = textField.text!
                    newItem.dateCreated = Date()
                    currentCategory.items.append(newItem)
                }
                } catch {
                    print("Error saving new items, \(error)")
                }
         
        }
            self.tableView.reloadData()
        }

    
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Create new Strikey!"
            //Capture input data into a global variable to be used outside scope
            textField = alertTextField
        }
        alert.addAction(action)
        present(alert,animated: true, completion: nil)
        
        }
    
    
    //MARK: - Model Manipulation Methods

    
    //Retreiving items from Realm
    func loadItems() {
        
        todoItems = selectedCategory?.items.sorted(byKeyPath: "title", ascending: true)
        tableView.reloadData()
    }
    
    //Deleting categories from Realm
    //Override to inherit from superclass
    override func updateModel(at indexPath : IndexPath) {
        if let itemToDelete = self.todoItems?[indexPath.row] {
            do {
                try self.realm.write {
                    self.realm.delete(itemToDelete)
                }
            } catch {
                print("Error deleting row")
            }
        }
    }

}


//MARK: - SearchBar methods
extension ToDoListViewController : UISearchBarDelegate {

    //Searchbar query functionality
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {

       todoItems = todoItems?.filter("title CONTAINS[cd] %@", searchBar.text!).sorted(byKeyPath: "dateCreated", ascending: true)
        tableView.reloadData()
    }

    //to get back to original list once we click on cross of search bar
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            loadItems()

            DispatchQueue.main.async {
                //dismiss keyboard by putting searchbar away from being first responder to background
                searchBar.resignFirstResponder()
            }

        }
    }
}


