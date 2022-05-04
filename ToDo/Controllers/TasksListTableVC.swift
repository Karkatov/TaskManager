//
//  ViewController.swift
//  ToDo
//
//  Created by Duxxless on 26.04.2022.
//

import UIKit
import RealmSwift

class TasksListTableVC: UITableViewController {
    
    let tasksLists = [TasksList]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setTableView()
    }
    
    
    private func setTableView() {
        navigationItem.leftBarButtonItem = editButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAlert))
      
        navigationItem.rightBarButtonItem = addButton
        
        view.backgroundColor = .systemYellow
    
        title = "ToDo"
        navigationController?.navigationBar.prefersLargeTitles = true
       // tableView.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "ToDoTableViewCell")
        tableView.register(TasksListTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension TasksListTableVC {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tasksLists.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TasksListTableViewCell else { return UITableViewCell() }
        let currentTasksList = tasksLists[indexPath.row]
        cell.titleLabel.text = currentTasksList.name
        cell.countLabel.text = String(currentTasksList.count)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tasksVC = TasksTableVC()
        navigationController?.pushViewController(tasksVC, animated: true)
    }
}


extension TasksListTableVC {
    
    @objc func showAlert() {
        
        let title = "Save TasksList"
        let massege = ""
        
        let alert = UIAlertController(title: title, message: massege, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "OK", style: .default) { action in
            let newTasksList = TasksList()
            guard let name = alert.textFields?.first?.text else { return }
            newTasksList.name = name
            
            DispatchQueue.main.async {
                StorageManager.saveTasksList([newTasksList])
            }
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
