//
//  TasksListDelegate.swift
//  ToDo
//
//  Created by Duxxless on 08.06.2022.
//

import Foundation
import UIKit

protocol TasksListTableViewViewModelDelegate {
    func updateTableView(_ indexPath: IndexPath)
    func showAlert(_ tasksList: TasksList?, complition: (() -> Void)?)
}
