//
//  TasksTableViewCellViewModel.swift
//  ToDo
//
//  Created by Duxxless on 11.06.2022.
//

import RealmSwift

class TasksTableViewCellViewModel: TasksTableViewCellViewModelProtocol {
    
    var task: Task
    
    var titleLabel: String {
        return task.name
    }
    
    var detailLabel: String {
        return task.note
    }
    
    init(_ task: Task) {
        self.task = task
    }
}
