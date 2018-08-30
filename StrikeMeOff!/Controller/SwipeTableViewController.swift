//
//  SwipeTableViewController.swift
//  StrikeMeOff!
//
//  Created by Sidhant Chadha on 8/29/18.
//  Copyright © 2018 AMoDynamics, Inc. All rights reserved.
//

import UIKit
import SwipeCellKit

class SwipeTableViewController: UITableViewController, SwipeTableViewCellDelegate {

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.rowHeight = 80.0

    
    }
    
    //MARK: - TableView Data Source Methods
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! SwipeTableViewCell
        cell.delegate = self
        return cell
        
    }
    
    
        func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
            guard orientation == .right else { return nil }
            
            let deleteAction = SwipeAction(style: .destructive, title: "Delete") { action, indexPath in
                // handle action by updating model with deletion
                
                print("Delete Cell")
                self.updateModel(at: indexPath)

            }
            
            // customize the action appearance
            deleteAction.image = UIImage(named: "delete.png")
            
            return [deleteAction]
        }
        
        //Function to make cell deletion option expandable
        func tableView(_ tableView: UITableView, editActionsOptionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> SwipeOptions {
            var options = SwipeOptions()
            options.expansionStyle = .destructive
            return options
        }
        //Method to override in category and item
        func updateModel(at indexPath : IndexPath) {

        }
    
    
        
        


}
