//
//  Category.swift
//  TickTask
//
//  Created by Justin Rose on 7/27/19.
//  Copyright © 2019 Justin Rose. All rights reserved.
//

import Foundation
import RealmSwift

class Category: Object {
  
  @objc dynamic var title: String = ""
  @objc dynamic var color: String = ""
  
  var tasks = List<Task>()
}
