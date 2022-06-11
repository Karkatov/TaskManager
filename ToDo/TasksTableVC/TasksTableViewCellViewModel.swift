//
//  TasksTableViewCellViewModel.swift
//  ToDo
//
//  Created by Duxxless on 11.06.2022.
//

import RealmSwift

class TasksTableViewCellViewModel: TasksTableViewCellViewModelType {
    
    var currentTasks: Results<Task>!
    var completedTask: Results<Task>!
    
    var currentTasksList: TasksList {
        willSet {
            currentTasks = newValue.tasks.filter("isComplete = false")
            completedTask =  newValue.tasks.filter("isComplete = true")
        }
    }
    init(_ currentTasksList: TasksList) {
        self.currentTasksList =  currentTasksList
    }
}
