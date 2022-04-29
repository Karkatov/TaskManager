//
//  StorageManager.swift
//  ToDo
//
//  Created by Duxxless on 29.04.2022.
//

import Foundation
import RealmSwift

let realm = try! Realm()

class StorageManager {
    
    static func saveTasksList(_ tasksLists: [TasksList]) {
        try! realm.write {
            realm.add(tasksLists)
        }
    }
}
