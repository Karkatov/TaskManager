

import Foundation

protocol TasksListTableViewCellViewModelProtocol {
    var titleLabel: String { get }
    var dateLabel: String { get }
    func calculateTasks() -> String
}
