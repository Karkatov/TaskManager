

import RealmSwift

protocol TasksListTableViewViewModelProtocol {
    
    var delegate: (TasksListTableViewViewModelDelegate)! { get set }
    var numberOfRows: Int { get }
    var tasksLists: Results<TasksList> { get set}
    var searchBarIsEmpty: Bool { get set }
    var cellIdentifier: String { get set }
    
    func selectRow(atIndexPath indexPath: IndexPath)
    func createTasksList()
    func updateTasksList(_ indexPath: IndexPath)
    func deleteTasksList(_ indexPath: IndexPath)
    func filteredTasks(_ searchText: String?)
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TasksListTableViewCellViewModelProtocol?
    func getViewModelDetail() -> TasksTableViewViewModelProtocol?
}
