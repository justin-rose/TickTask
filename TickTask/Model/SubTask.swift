//
//  SubTask.swift
//  TickTask
//
//  Created by Justin Rose on 8/2/19.
//  Copyright © 2019 Justin Rose. All rights reserved.
//

import Foundation
import RealmSwift

class SubTask: Object {
  
  @objc dynamic var title: String = ""
  
  var parentItem = LinkingObjects(fromType: Task.self, property: "subTasks")
}
