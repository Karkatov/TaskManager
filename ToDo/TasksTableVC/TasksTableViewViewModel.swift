
import Foundation
import RealmSwift

class TasksTableViewViewModel: TasksTableViewViewModelProtocol {
    
    weak var delegate: TasksTableViewDelegate!
    
    var currentTasks: Results<Task>!
    var completedTask: Results<Task>!
    
    var tasksList: TasksList
    
    var searchBarIsEmpty = true
    
    func filteredTasks(_ searchText: String? = nil) {
        if searchBarIsEmpty {
            currentTasks = tasksList.tasks.filter("isComplete = false")
            completedTask = tasksList.tasks.filter("isComplete = true")
        } else {
            guard let text = searchText else { return }
            currentTasks = currentTasks.filter("name CONTAINS[c] '\(text)'")
            completedTask = completedTask.filter("name CONTAINS[c] '\(text)'")
        }
    }
    
    init(_ tasksList: TasksList) {
        self.tasksList = tasksList
        currentTasks = tasksList.tasks.filter("isComplete = false")
        completedTask = tasksList.tasks.filter("isComplete = true")
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
