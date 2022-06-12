//
//  TableViewCellViewModelType.swift
//  ToDo
//
//  Created by Duxxless on 01.06.2022.
//

import Foundation

class TasksListTableViewCellViewModel: TasksListTableViewCellViewModelProtocol {
    
    private var taskList: TasksList!
    
    var titleLabel: String {
        return taskList.name
    }
    
    func calculateTasks() -> String {
        let taskCount = taskList.tasks.count
        if [1,21,31,41,51].contains(taskCount) {
                return "\(taskCount) задача"
            } else if (2...4).contains(taskCount) {
                return "\(taskCount) задачи"
            } else if taskCount == 0 || (5...20).contains(taskCount) {
                return "\(taskCount) задач"
            }
            return "\(taskCount) задач"
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
