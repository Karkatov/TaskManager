

import Foundation

protocol TasksTableViewDelegate: AnyObject {
    func updateTableView(_ indexPath: IndexPath)
    func showAlert(_ task: Task?, complition: (() -> Void)?)
}
