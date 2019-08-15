//
//  TaskTableViewController.swift
//  TickTask
//
//  Created by Justin Rose on 7/27/19.
//  Copyright © 2019 Justin Rose. All rights reserved.
//

import UIKit
import SwipeCellKit

class TaskTableViewController: BaseTableViewController {
  
  var taskVM: TaskViewModel?
  weak var delegate: ModifyRealmViewControllerDelegate?
  
  override func viewDidLoad() {
    super.viewDidLoad()
    
    delegate = taskVM
  }
  
  @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
    
    var textField = UITextField()
    
    let alert = UIAlertController(title: "Add New Task", message: "", preferredStyle: .alert)
    let action = UIAlertAction(title: "Add Task", style: .default) { (action) in
      
      let newTask = Task()
      
      newTask.title = textField.text!
      newTask.dateCreated = Date()
      
      self.delegate?.addItemToRealm(self, didFinishAdding: newTask, to: nil)
      self.taskVM?.taskArray.append(TaskViewModel.TaskType.task(newTask))
      
      self.tableView.reloadData()
    }
    
    alert.addTextField { (alertTextField) in
      
      alertTextField.placeholder = "Enter Task"
      textField = alertTextField
    }
    
    alert.addAction(action)
    
    present(alert, animated: true, completion: nil)
  }
  
  //MARK: Table View Delegate Methods
  
  override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
    
    return taskVM?.taskArray.count ?? 0
  }
  
  override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
    
    guard let taskViewModel = taskVM else { fatalError() }
    
    let cell = taskViewModel.taskArray[indexPath.row].preparedCell(tableView, for: indexPath)
    cell.delegate = self
    
    return cell
  }

  //Overridden to customize swipe actions for this controller
  override func updateModelBySwipe(for indexPath: IndexPath) -> [SwipeAction]? {
    
    var swipeActions = [SwipeAction]()
    
    let deleteAction = SwipeAction(style: .destructive, title: "Delete") { _, indexPath in
      
      if let itemToDelete = self.taskVM?.taskArray[indexPath.row].returnType() {
        
        self.delegate?.deleteItemFromRealm(self, didFinishDeleting: itemToDelete)
        self.taskVM?.taskArray.remove(at: indexPath.row)
        self.tableView.deleteRows(at: [indexPath], with: .automatic)
      }
    }
    
    swipeActions.append(deleteAction)
    
    if let task = taskVM?.taskArray[indexPath.row].returnType() as? Task {
      let addSubTaskAction = SwipeAction(style: .default, title: "Add") { _, indexPath in
        
        var textField = UITextField()
        let newIndexPath = IndexPath(row: (self.taskVM?.taskArray.index(after: indexPath.row))!, section: 0)
        
        let alert = UIAlertController(title: "Add New Sub Task", message: "", preferredStyle: .alert)
        
        let alertAction = UIAlertAction(title: "Add Sub Task", style: .default) { action in
          
          let subTask = SubTask()
          subTask.title = textField.text!
          
          self.taskVM?.setTaskHasSubTaskStatus(for: task)
          
          self.delegate?.addItemToRealm(self, didFinishAdding: subTask, to: task)
          self.taskVM?.taskArray.insert(TaskViewModel.TaskType.subTask(subTask), at: newIndexPath.row)
          self.tableView.insertRows(at: [newIndexPath], with: .top)
        }
        
        alert.addTextField { (alertTextField) in
          
          alertTextField.placeholder = "Create new sub task"
          
          textField = alertTextField
        }
        
        alert.addAction(alertAction)
        
        self.present(alert, animated: true, completion: nil)
      }
      swipeActions.append(addSubTaskAction)
    }
    
    return swipeActions
  }
}
