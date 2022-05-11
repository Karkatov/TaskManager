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
    private var currentTasks: Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setTableView()
    }
    
    
    private func setTableView() {
        title = currentTasksList.name
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAlert))
        
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
        navigationItem.rightBarButtonItems?[1].title = "Изменить"
        view.backgroundColor = .systemGray6
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension TasksTableVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 0
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return "hello"
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currentTasks.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .value1, reuseIdentifier: "Cell")
        let task = currentTasks[indexPath.row]
        cell.textLabel?.text = task.name
        cell.detailTextLabel?.text = task.note
        return cell
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            self.navigationItem.rightBarButtonItems?[1].title = "Готово"
            tableView.setEditing(editing, animated: true)
        } else {
            tableView.endEditing(true)
            self.navigationItem.rightBarButtonItems?[1].title = "Изменить"
        }
    }
}


extension TasksTableVC {
    
    @objc func showAlert() {
        alertForAddAndUpdateTask()
    }
    
    private func alertForAddAndUpdateTask(_ task: Task? = nil,
                                          complition: (() -> Void)? = nil) {
        var title = "Новая заметка"
        var doneButton = "Сохранить"
        
        if task != nil {
            title = "Измените заметку"
            doneButton = "Изменить"
        }
        var nameTextField: UITextField!
        var noteTextField: UITextField!
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let taskName = nameTextField.text, !taskName.isEmpty else { return }
            guard let taskNote = noteTextField.text, !taskNote.isEmpty else { return }
            let newTask = Task()
            newTask.name = taskName
            newTask.note = taskNote
            StorageManager.saveTask(self.currentTasksList, task: newTask)
            self.tableView.reloadData()
            
        }
        let cancelActon = UIAlertAction(title: "Отмена", style: .default)
        alert.addTextField()
        alert.addTextField()
        nameTextField = alert.textFields?[0]
        noteTextField = alert.textFields?[1]
        alert.addAction(doneAction)
        alert.addAction(cancelActon)
        present(alert, animated: true)
    }
}


