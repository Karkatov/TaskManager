
import RealmSwift

class TasksTableViewCellViewModel: TasksTableViewCellViewModelProtocol {
    
    var identifier = "TasksTableViewCell"
    var task: Task
    
    var title: String {
        return task.name
    }
    
    var note: String {
        return task.note
    }
    
    var isComplete: Bool {
        return task.isComplete
    }
    
    init(_ task: Task) {
        self.task = task
    }
}
