
import UIKit

protocol TasksTableViewCellViewModelProtocol {
    var title: String { get }
    var note: String { get }
    var isComplete: Bool { get }
}
