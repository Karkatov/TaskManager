

import Foundation
import UIKit

protocol TasksListTableViewViewModelDelegate: AnyObject {
    func updateTableView(_ indexPath: IndexPath)
    func showAlert(_ tasksList: TasksList?, complition: (() -> Void)?)
}
