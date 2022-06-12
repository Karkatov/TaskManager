//
//  TasksTableViewViewModel.swift
//  ToDo
//
//  Created by Duxxless on 04.06.2022.
//

import Foundation
import RealmSwift

class TasksTableViewViewModel: TasksTableVCViewModelProtocol {
 
    var delegate: TasksTableViewDelegate
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
    
    func updateTask(_ task: Task) {
        delegate.showAlert(task) {
            self.delegate.updateTableView(nil)
        }
    }
    
    func deleteTask(_ task: Task) {
        StorageManager.deleteTask(task)
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TasksTableViewCellViewModelProtocol? {
        return TasksTableViewCellViewModel(tasksList)
    }
    
}
