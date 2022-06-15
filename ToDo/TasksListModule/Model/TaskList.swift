

import RealmSwift

class TasksList: Object {
    
    @objc dynamic var name = ""
    @objc dynamic var count = 0
    @objc dynamic var date = Date()
    let tasks = List<Task>()
}
