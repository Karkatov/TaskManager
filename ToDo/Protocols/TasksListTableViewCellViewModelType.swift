//
//  TableViewCellViewModelType.swift
//  ToDo
//
//  Created by Duxxless on 01.06.2022.
//

import Foundation

protocol TasksListTableViewCellViewModelType {
    var titleLabel: String { get }
    var countLabel: String { get }
    var dateLabel: String { get }
}
