//
//  ViewModel.swift
//  ToDo
//
//  Created by Duxxless on 01.06.2022.
//

import Foundation
import RealmSwift

class TasksListTableViewViewModel: TasksListTableViewViewModelProtocol {

    var delegate: TasksListTableViewViewModelDelegate
    
    var tasksLists: Results<TasksList> = realm.objects(TasksList.self).sorted(byKeyPath: "date", ascending: false)
    
    var numberOfRows: Int {
            return tasksLists.count
        }
    
    init() {
        self.delegate = TasksListTableView()
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TasksListTableViewCellViewModelProtocol? {
        let taskList = tasksLists[indexPath.row]
        return TasksListTableViewCellViewModel(taskList: taskList)
    }
    
    func createTasksList() {
        delegate.showAlert(nil, complition: nil)
    }
    
    func updateTasksList(_ indexPath: IndexPath) {
        delegate.showAlert(tasksLists[indexPath.row]) {
            self.delegate.updateTableView(indexPath)
        }
    }
    
    func deleteTasksList(_ indexPath: IndexPath) {
        StorageManager.deleteTasksList(tasksLists[indexPath.row])
    }
}
