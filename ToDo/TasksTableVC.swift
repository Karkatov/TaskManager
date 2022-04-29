//
//  TasksTableViewController.swift
//  ToDo
//
//  Created by Duxxless on 29.04.2022.
//

import UIKit
import RealmSwift

class TasksTableVC: UITableViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
    }
    
    
    private func setTableView() {
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAlert))
        
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
        
        view.backgroundColor = .systemYellow
        title = "ToDo"
        tableView.register(TasksListTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension TasksTableVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TasksListTableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = "111"
        cell.countLabel.text = "1"
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
            tf.placeholder = "Введите название списка"
        }
        alert.addAction(doneAction)
        alert.addAction(cancelActon)
        present(alert, animated: true)
    }
}
