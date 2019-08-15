//
//  BaseTableViewController.swift
//  TickTask
//
//  Created by Justin Rose on 8/9/19.
//  Copyright © 2019 Justin Rose. All rights reserved.
//

import UIKit
import SwipeCellKit

class BaseTableViewController: UITableViewController, SwipeTableViewCellDelegate {
  
  override func viewDidLoad() {
        super.viewDidLoad()

      
  }

  func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath, for orientation: SwipeActionsOrientation) -> [SwipeAction]? {
    
    guard orientation == .right else { return nil }
    
    return updateModelBySwipe(for: indexPath)
  }
  
  func updateModelBySwipe(for indexPath: IndexPath) -> [SwipeAction]? {
    
    //overridden by each child view controller
    return nil
  }
}
