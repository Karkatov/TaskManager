
import Foundation
import RealmSwift

class TasksListTableViewViewModel: TasksListTableViewViewModelProtocol {
    
    private var selectedIndexPath: IndexPath?
    var searchBarIsEmpty = true
    weak var delegate: TasksListTableViewViewModelDelegate!
    var tasksLists: Results<TasksList> = realm.objects(TasksList.self).sorted(byKeyPath: "date", ascending: false)
    var cellIdentifier = "TasksListTableViewCell"
    var numberOfRows: Int {
        return tasksLists.count
    }
    
    func selectRow(atIndexPath indexPath: IndexPath) {
        self.selectedIndexPath = indexPath
    }
    
    func cellViewModel(forIndexPath indexPath: IndexPath) -> TasksListTableViewCellViewModelProtocol? {
        let taskList = tasksLists[indexPath.row]
        return TasksListTableViewCellViewModel(taskList: taskList)
    }
    
    func getViewModelDetail() -> TasksTableViewViewModelProtocol? {
        guard let selectedIndexPath = selectedIndexPath else { return nil }
        return TasksTableViewViewModel(tasksLists[selectedIndexPath.row])
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
    
    func filteredTasks(_ searchText: String?) {
        if searchBarIsEmpty {
            tasksLists = realm.objects(TasksList.self).sorted(byKeyPath: "date", ascending: false)
        } else {
            guard let text = searchText else { return }
            tasksLists = tasksLists.filter("name CONTAINS[c] '\(text)'")
        }
    }
}
