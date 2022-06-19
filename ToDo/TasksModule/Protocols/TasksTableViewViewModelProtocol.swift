

import RealmSwift

protocol TasksTableViewViewModelProtocol {
    
    var delegate: (TasksTableViewDelegate)! { get set }
    var tasksList: TasksList { get set }
    var currentTasks: Results<Task>! { get set }
    var completedTask: Results<Task>! { get set}
    var searchBarIsEmpty: Bool { get set }
    var cellIdentifier: String { get set}
    func filteredTasks(_ searchText: String?)
    func getNumberOfRows(_ section: Int) -> Int
    func getNumberOfSections() -> Int
    func getTitleOfSection(_ section: Int) -> String
    func getCurrentOrCompletedTasks(_ indexPath: IndexPath) -> Task
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TasksTableViewCellViewModelProtocol?
    func createTask()
    func updateTask(_ task: Task, indexPath: IndexPath)
    func deleteTask(_ task: Task)
}
