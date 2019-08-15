//
//  BaseViewModel.swift
//  TickTask
//
//  Created by Justin Rose on 8/5/19.
//  Copyright © 2019 Justin Rose. All rights reserved.
//

import Foundation
import RealmSwift

//This delegate protocol adds functions for adding and deleting items from the Realm
protocol ModifyRealmViewControllerDelegate: class {
  
  var realm: Realm { get }
  func addItemToRealm(_ controller: UITableViewController, didFinishAdding item: Object, to parent: Object?)
  func deleteItemFromRealm(_ controller: UITableViewController, didFinishDeleting item: Object)
}

//extension ModifyRealmViewControllerDelegate {
//  func addItemToRealm(_ controller: UITableViewController, didFinishAdding item: Object, to parent: Object? = nil) {}
//}
