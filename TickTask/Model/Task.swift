//
//  Task.swift
//  TickTask
//
//  Created by Justin Rose on 7/27/19.
//  Copyright © 2019 Justin Rose. All rights reserved.
//

import Foundation
import RealmSwift

class Task: Object {
  @objc dynamic var title: String = ""
  @objc dynamic var done: Bool = false
  @objc dynamic var hasSubItems: Bool = false
  @objc dynamic var displaySubItems: Bool = false
  @objc dynamic var dateCreated: Date?
  
  var parentCategory = LinkingObjects(fromType: Category.self, property: "tasks")
  
  let subTasks = List<SubTask>()
}
