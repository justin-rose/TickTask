//
//  ViewController.swift
//  TickTask
//
//  Created by Justin Rose on 7/27/19.
//  Copyright © 2019 Justin Rose. All rights reserved.
//

import UIKit
import ChameleonFramework
import SwipeCellKit

class CategoryTableViewController: BaseTableViewController {
  
  let categoryVM = CategoryViewModel()
  weak var delegate: ModifyRealmViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    delegate = categoryVM
  }
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Category", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Category", style: .default) { (action) in
      
      let newCategory = Category()
      
      newCategory.title = textField.text!
      newCategory.color = RandomFlatColor().hexValue()
      
      self.delegate?.addItemToRealm(self, didFinishAdding: newCategory, to: nil)
      
      self.tableView.reloadData()
    }
    
    alert.addTextField { (alertTextField) in
      
      alertTextField.placeholder = "Enter Category"
      textField = alertTextField
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
    
  }
  
  //MARK: Table View Delegate Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return categoryVM.categories?.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    let cell = categoryVM.preparedCell(tableView, for: indexPath)
    cell.delegate = self
    
    return cell
  }
  
  //Called from BaseTableViewController and overridden here to create the delete action
  override func updateModelBySwipe(for indexPath: IndexPath) -> [SwipeAction]? {
    
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { _, indexPath in
      
      if let categoryToDelete = self.categoryVM.categories?[indexPath.row] {
      
        self.delegate?.deleteItemFromRealm(self, didFinishDeleting: categoryToDelete)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
    
    return [deleteAction]
  }
  
  //MARK: Navigation
  
  override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
    performSegue(withIdentifier: "goToTasks", sender: self)
  }
  
  override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
    let destinationTaskVM = TaskViewModel()
    let destinationVC = segue.destination as! TaskTableViewController
    
    if let indexPath = tableView.indexPathForSelectedRow {
      
      destinationTaskVM.selectedCategory = categoryVM.categories?[indexPath.row]
      destinationVC.taskVM = destinationTaskVM
    }
  }
}

