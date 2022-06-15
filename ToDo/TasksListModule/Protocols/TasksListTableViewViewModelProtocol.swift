

import RealmSwift

protocol TasksListTableViewViewModelProtocol {
    
    var delegate: (TasksListTableViewViewModelDelegate)! { get set }
    
    var numberOfRows: Int { get }
    var tasksLists: Results<TasksList> { get set}
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TasksListTableViewCellViewModelProtocol?
    func createTasksList()
    func updateTasksList(_ indexPath: IndexPath)
    func deleteTasksList(_ indexPath: IndexPath)
    var searchBarIsEmpty: Bool { get set }
    func filteredTasks(_ searchText: String?)
}
