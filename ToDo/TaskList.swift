//
//  TaskList.swift
//  ToDo
//
//  Created by Duxxless on 29.04.2022.
//

import Foundation
import RealmSwift

class TasksList: Object {
    
    @objc dynamic let name = ""
    @objc dynamic let count = 0
    @objc dynamic let date = Date()
    
    let tasks = List<Task>()
}
