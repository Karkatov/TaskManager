//
//  ViewController.swift
//  ToDo
//
//  Created by Duxxless on 26.04.2022.
//

import UIKit
import RealmSwift

class TasksListTableVC: UITableViewController {
    
    var tasksLists: Results<TasksList>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tasksLists = realm.objects(TasksList.self)
        setTableView()
    }
    
    
    private func setTableView() {
        navigationItem.leftBarButtonItem = editButtonItem
        self.navigationItem.leftBarButtonItem?.title = "Изменить"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAlert))
        navigationItem.rightBarButtonItem = addButton
        view.backgroundColor = .systemGray6
        title = "ToDoLists"
        navigationController?.navigationBar.prefersLargeTitles = true
        // tableView.register(UINib(nibName: "ToDoTableViewCell", bundle: nil), forCellReuseIdentifier: "ToDoTableViewCell")
        tableView.register(TasksListTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
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
        cell.countLabel.text = checkTasks(currentTasksList.tasks.count)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tasksVC = TasksTableVC()
        tasksVC.currentTasksList = tasksLists[indexPath.row]
        navigationController?.pushViewController(tasksVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let currentList = self.tasksLists[indexPath.row]
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, _ in
            StorageManager.deleteTasksList(currentList)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        let editAction = UIContextualAction(style: .normal, title: nil) { _, _, complition in
            self.alertForAddAndUpdateList(currentList, complition: {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            })
            complition(true)
        }
        editAction.backgroundColor = .orange
        editAction.image = UIImage(systemName: "square.and.pencil")
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction])
    }
    
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        
        if editing {
            self.navigationItem.leftBarButtonItem?.title = "Готово"
            tableView.setEditing(editing, animated: true)
        } else {
            tableView.endEditing(true)
            self.navigationItem.leftBarButtonItem?.title = "Изменить"
        }
    }
}


extension TasksListTableVC {
    
    @objc func showAlert() {
        alertForAddAndUpdateList()
    }
    
    private func alertForAddAndUpdateList(_ tasksList: TasksList? = nil, complition: (() -> Void)? = nil) {
        var title = "Новый список задач"
        var doneButtonText = "Сохранить"
        
        if tasksList != nil {
            title = "Название списка задач"
            doneButtonText = "Изменить"
        }
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        var alertTextField: UITextField!
        
        let saveAction = UIAlertAction(title: doneButtonText, style: .default) { _ in
            guard let newList = alertTextField.text, !newList.isEmpty else { return }
            
            if tasksList != nil {
                StorageManager.editTasksList(tasksList!, newTitle: newList)
                if complition != nil { complition!() }
            } else {
                let newTasksList = TasksList()
                newTasksList.name = newList
                
                DispatchQueue.main.async {
                    StorageManager.saveTasksList(newTasksList)
                    self.tableView.insertRows(at: [IndexPath(row: self.tasksLists.count - 1, section: 0)], with: .automatic)
                }
            }
        }
        
        let cancelActon = UIAlertAction(title: "Отмена", style: .default)
        alert.addTextField { tf in
            tf.placeholder = "Название"
            guard let nameList = tasksList?.name else { return }
            tf.text = nameList
        }
        alertTextField = alert.textFields?.first
        alert.addAction(saveAction)
        alert.addAction(cancelActon)
        present(alert, animated: true)
    }
    
    private func checkTasks(_ count: Int) -> String {
        if count == 1 {
            return "\(count) задача"
        } else if (2...4).contains(count) {
            return "\(count) задачи"
        } else if count == 0 || (5...20).contains(count) {
            return "\(count) задач"
        }
        return "\(count) задач"
    }
}
