//
//  StorageManager.swift
//  ToDo
//
//  Created by Duxxless on 29.04.2022.
//

import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveTasksList(_ tasksList: TasksList) {
        try! realm.write {
            realm.add(tasksList)
        }
    }
    
    static func deleteTasksList(_ tasksList: TasksList) {
        try! realm.write {
            let tasks = tasksList.tasks
            realm.delete(tasks)
            realm.delete(tasksList)
        }
    }
    
    static func editTasksList(_ tasksList: TasksList, newTitle: String) {
        try! realm.write {
            tasksList.name = newTitle
        }
    }
    
    static func saveTask(_ tasksList: TasksList, task: Task) {
        try! realm.write({
            tasksList.tasks.insert(task, at: 0)
        })
    }
}
