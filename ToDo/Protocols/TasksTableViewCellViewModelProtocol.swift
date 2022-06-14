//
//  TasksTableViewViewModelType.swift
//  ToDo
//
//  Created by Duxxless on 08.06.2022.
//

import UIKit

protocol TasksTableViewCellViewModelProtocol {
    var title: String { get }
    var note: String { get }
    var isComplete: Bool { get }
}
