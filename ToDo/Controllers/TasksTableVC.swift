//
//  TasksTableViewController.swift
//  ToDo
//
//  Created by Duxxless on 29.04.2022.
//

import UIKit
import RealmSwift

class TasksTableVC: UITableViewController {
    
    var currentTasksList: TasksList!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    
    private func setTableView() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAlert))
        
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
        view.backgroundColor = .systemGray6
        title = "ToDo"
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension TasksTableVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "hello"
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTasksList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "Cell")
        let task = currentTasksList.tasks[indexPath.row]
        cell.textLabel?.text = "111"
        cell.detailTextLabel?.text = task.note
        return cell
    }
}


extension TasksTableVC {
    
    @objc func showAlert() {
        
        let title = ""
        let massege = ""
        
        let alert = UIAlertController(title: title, message: massege, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "OK", style: .default) { action in
        }
        
        let cancelActon = UIAlertAction(title: "Отмена", style: .default)
        alert.addTextField { tf in
            tf.placeholder = "Hовый список"
        }
        alert.addAction(doneAction)
        alert.addAction(cancelActon)
        present(alert, animated: true)
    }
}
