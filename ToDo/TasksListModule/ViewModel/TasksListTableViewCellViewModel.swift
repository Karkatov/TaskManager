
import Foundation

class TasksListTableViewCellViewModel: TasksListTableViewCellViewModelProtocol {
    
    private var taskList: TasksList!

    var titleLabel: String {
        return taskList.name
    }
    
    func calculateTasks() -> String {
        let currentTasksCount = taskList.tasks.filter("isComplete = false").count
        if [1,21,31,41,51].contains(currentTasksCount) {
            return "\(currentTasksCount) задача"
        } else if (2...4).contains(currentTasksCount) {
            return "\(currentTasksCount) задачи"
        } else if currentTasksCount == 0 || (5...20).contains(currentTasksCount) {
            return "\(currentTasksCount) задач"
        }
        return "\(currentTasksCount) задача"
    }
    
    var dateLabel: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ru_RU")
        dateFormatter.dateStyle = .medium
        return dateFormatter.string(from: taskList.date)
    }
    
    init(taskList: TasksList) {
        self.taskList = taskList
    }
}
