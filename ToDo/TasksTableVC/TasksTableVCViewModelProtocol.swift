//
//  TasksTableVCViewModelType.swift
//  ToDo
//
//  Created by Duxxless on 04.06.2022.
//

import RealmSwift

protocol TasksTableVCViewModelProtocol {
   
    var delegate: TasksTableViewDelegate { get set }
    
    var tasksList: TasksList { get set }
    var currentTasks: Results<Task>! { get }
    var completedTask: Results<Task>! { get }
    
    func getNumberOfRows(_ section: Int) -> Int
    func getNumberOfSections() -> Int
    func getTitleOfSection(_ section: Int) -> String
    func getCurrentOrCompletedTasks(_ indexPath: IndexPath) -> Task
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TasksTableViewCellViewModelProtocol?
    func createTask()
    func updateTask(_ task: Task)
    func deleteTask(_ task: Task)
}
