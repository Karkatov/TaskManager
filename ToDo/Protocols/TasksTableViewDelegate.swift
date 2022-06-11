//
//  TasksTableViewDelegate.swift
//  ToDo
//
//  Created by Duxxless on 08.06.2022.
//

import Foundation

protocol TasksTableViewDelegate {
    func updateTableView(_ indexPath: IndexPath?)
    func showAlert(_ task: Task?, complition: (() -> Void)?)
}
