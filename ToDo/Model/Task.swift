//
//  Task.swift
//  ToDo
//
//  Created by Duxxless on 29.04.2022.
//


import RealmSwift

class Task: Object {
    
    @objc dynamic var name = "name"
    @objc dynamic var note = ""
    @objc dynamic var isComplete = false
}
