//
//  TaskViewModel.swift
//  TickTask
//
//  Created by Justin Rose on 7/31/19.
//  Copyright © 2019 Justin Rose. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift
import ChameleonFramework

class TaskViewModel: ModifyRealmViewControllerDelegate {
  
  let realm = try! Realm()
  
  var selectedCategory: Category?
  var tasks: Results<Task>?
  var subTasks: Results<SubTask>?
  var taskArray = [TaskType]()
  
  enum TaskType {
    case task(Task), subTask(SubTask)
    
    func preparedCell(_ tableView: UITableView, for indexPath: IndexPath) -> SwipeTableViewCell {
      
      switch self {
      case .task(let task):
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TaskCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = task.title
        
        return cell
        
      case .subTask(let subTask):
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "SubTaskCell", for: indexPath) as! SwipeTableViewCell
        
        cell.textLabel?.text = subTask.title
        
        return cell
      }
    }
    
    func returnType() -> Object {
      
      switch self {
      case .task(let task):
        
        return task
        
      case .subTask(let subTask):
        
        return subTask
      }
    }
  }
  
  init() {
    
    tasks = realm.objects(Task.self)
    
    for task in tasks! {
      taskArray.append(TaskType.task(task))
    }
  }
  
  //MARK: Realm Modification Delegate Methods
  
  func addItemToRealm(_ controller: UITableViewController, didFinishAdding item: Object, to parent: Object?) {
    
    switch item {
    case is Task:
      do {
        try realm.write {
          
          selectedCategory?.tasks.append(item as! Task)
        }
      } catch {
        
        print("Error writing to realm")
      }
    case is SubTask:
      do {
        try realm.write {
          
          (parent as! Task).subTasks.append(item as! SubTask)
        }
      } catch {
        
        print("Error writing to realm")
      }
    default:
      break
    }
  }
  
  func deleteItemFromRealm(_ controller: UITableViewController, didFinishDeleting item: Object) {
    do {
      try realm.write {
        
        realm.delete(item)
      }
    } catch {
      
      print("Error deleting from realm")
    }
  }
  
  func setTaskHasSubTaskStatus(for task: Task) {
    do {
      try realm.write {
        
        task.hasSubItems = true
        task.displaySubItems = true
      }
    } catch {
      
      print("Error modifying realm")
    }
  }
}
