//
//  TableViewCellViewModelType.swift
//  ToDo
//
//  Created by Duxxless on 01.06.2022.
//

import Foundation

protocol TasksListTableViewCellViewModelProtocol {
    var titleLabel: String { get }
    var dateLabel: String { get }
    func calculateTasks() -> String
}
