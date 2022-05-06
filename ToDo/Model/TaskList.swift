//
//  TaskList.swift
//  ToDo
//
//  Created by Duxxless on 29.04.2022.
//


import RealmSwift

class TasksList: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var count = 0
    @objc dynamic var date = Date()
    
    let tasks = List<Task>()
}
