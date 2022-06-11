//
//  Protocols.swift
//  ToDo
//
//  Created by Duxxless on 01.06.2022.
//

import RealmSwift

protocol TasksListTableViewViewModelType {
    
    var delegate: TasksListTableViewViewModelDelegate { get set }
    
    var numberOfRows: Int { get }
    var tasksLists: Results<TasksList> { get }
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TasksListTableViewCellViewModelType?
    func createTasksList()
    func updateTasksList(_ indexPath: IndexPath)
    func deleteTasksList(_ indexPath: IndexPath)
}
