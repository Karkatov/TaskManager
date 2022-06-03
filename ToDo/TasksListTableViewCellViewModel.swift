//
//  TableViewCellViewModelType.swift
//  ToDo
//
//  Created by Duxxless on 01.06.2022.
//

import Foundation

class TasksListTableViewCellViewModel: TasksListTableViewCellViewModelType {
    
    private var taskList: TasksList!
    
    var titleLabel: String {
        return taskList.name
    }
    
    var countLabel: String {
        String(taskList.tasks.count)
    }
    
    var dateLabel: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: taskList.date)
    }
    
    init(taskList: TasksList) {
        self.taskList = taskList
    }
}