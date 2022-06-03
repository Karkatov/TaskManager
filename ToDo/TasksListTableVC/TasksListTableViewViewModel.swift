//
//  ViewModel.swift
//  ToDo
//
//  Created by Duxxless on 01.06.2022.
//

import Foundation
import RealmSwift

class TasksListTableViewViewModel: TasksListTableViewViewModelType {
    
    var tasksLists: Results<TasksList> = realm.objects(TasksList.self).sorted(byKeyPath: "date", ascending: false)
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TasksListTableViewCellViewModelType? {
        
        let taskList = tasksLists[indexPath.row]
        return TasksListTableViewCellViewModel(taskList: taskList)
    }

    var numberOfRows: Int {
        return tasksLists.count
    }
}
