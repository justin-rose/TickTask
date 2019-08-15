//
//  CategoryTableView.swift
//  TickTask
//
//  Created by Justin Rose on 7/27/19.
//  Copyright © 2019 Justin Rose. All rights reserved.
//

import UIKit
import SwipeCellKit
import RealmSwift
import ChameleonFramework

class CategoryViewModel: ModifyRealmViewControllerDelegate {
  
  let realm = try! Realm()
  
  var categories: Results<Category>?
  
  //MARK: Init Category
  
  init() {
  
    categories = realm.objects(Category.self)
  }
  
  //MARK: Realm Modification Delegate Methods
  
  func addItemToRealm(_ controller: UITableViewController, didFinishAdding item: Object, to parent: Object?) {
    
    do {
      try realm.write {
        
        realm.add(item)
      }
    } catch {
      
      print("Error writing to realm")
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
  
  //MARK: Cell Modification Methods
  
  func preparedCell(_ tableView: UITableView, for indexPath: IndexPath) -> SwipeTableViewCell {
    
    guard let category = categories?[indexPath.row] else { fatalError("Unable to retrieve category to convert to cell") }
      
    let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCell", for: indexPath) as! SwipeTableViewCell
    
    guard let categoryColor = HexColor(category.color) else { fatalError("Unable to convert category hex color to UIColor") }
    
    cell.textLabel?.text = category.title
    cell.backgroundColor = categoryColor
    cell.textLabel?.textColor = ContrastColorOf(categoryColor, returnFlat: true)
    
    return cell
  }
}

