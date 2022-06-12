//
//  TasksTableViewCellViewModel.swift
//  ToDo
//
//  Created by Duxxless on 11.06.2022.
//

import RealmSwift

class TasksTableViewCellViewModel: TasksTableViewCellViewModelProtocol {
    
    var currentTasks: Results<Task>!
    var completedTask: Results<Task>!
    
    var currentTasksList: TasksList {
        willSet {
            currentTasks = newValue.tasks.filter("isComplete = false")
            completedTask =  newValue.tasks.filter("isComplete = true")
        }
    }
    
    var titleLabel: String
    
    var detailLabel: String
    
    func isComplited() {
    
    }
    
    init(_ currentTasksList: TasksList) {
        self.currentTasksList =  currentTasksList
    }
}
