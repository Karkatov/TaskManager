//
//  Task.swift
//  ToDo
//
//  Created by Duxxless on 29.04.2022.
//

import Foundation
import RealmSwift

class Task: Object {
    
    @objc dynamic let name = ""
    @objc dynamic let note = ""
    @objc dynamic let isComplete = false
}
