//
//  TasksTableViewViewModel.swift
//  ToDo
//
//  Created by Duxxless on 04.06.2022.
//

import Foundation
import RealmSwift

class TasksTableViewViewModel: TasksTableViewViewModelProtocol {
    
    weak var delegate: TasksTableViewDelegate!
    var currentTasks: Results<Task>! {
        return tasksList.tasks.filter("isComplete = false")
    }
    var completedTask: Results<Task>! {
        return tasksList.tasks.filter("isComplete = true")
    }
    
    var tasksList: TasksList
    
    init(_ tasksList: TasksList) {
        self.delegate = TasksTableView()
        self.tasksList = tasksList
    }
    
    func getNumberOfSections() -> Int {
        
        return 2
        }
    
    func getNumberOfRows(_ section: Int) -> Int {
        return section == 0 ? currentTasks.count : completedTask.count
       }
    
    func getCurrentOrCompletedTasks(_ indexPath: IndexPath) -> Task {
        return indexPath.section == 0 ? currentTasks[indexPath.row] : completedTask[indexPath.row]
     }
    
    func getTitleOfSection(_ section: Int) -> String {
            return section == 0 ? "АКТИВНЫЕ ЗАДАЧИ" : "ВЫПОЛНЕННЫЕ ЗАДАЧИ"
        }
    
    func createTask() {
        delegate.showAlert(nil, complition: nil)
    }
    
    func updateTask(_ task: Task, indexPath: IndexPath) {
        delegate.showAlert(task) {
            self.delegate.updateTableView(indexPath)
        }
    }
    
    func deleteTask(_ task: Task) {
        StorageManager.deleteTask(task)
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TasksTableViewCellViewModelProtocol? {
        if indexPath.section == 0 {
            return TasksTableViewCellViewModel(currentTasks[indexPath.row])
        } else if indexPath.section == 1 {
            return TasksTableViewCellViewModel(completedTask[indexPath.row])
        }
        return nil
    }
    
}
