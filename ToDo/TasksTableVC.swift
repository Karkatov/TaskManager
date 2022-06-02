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
    
    var currentTasks: Results<Task>!
    var completedTask: Results<Task>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        filteringTasks()
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
    private func filteringTasks() {
        currentTasks = currentTasksList.tasks.filter("isComplete = false")
        completedTask = currentTasksList.tasks.filter("isComplete = true")
    }
    
    private func makeSlashText(_ text:String) -> NSAttributedString {
     let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
    return attributeString
    }
}

extension TasksTableVC {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return section == 0 ? "АКТИВНЫЕ ЗАДАЧИ" : "ВЫПОЛНЕННЫЕ ЗАДАЧИ"
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return section == 0 ? currentTasks.count : completedTask.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell.init(style: .subtitle, reuseIdentifier: "Cell")
        var task: Task!
        task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTask[indexPath.row]
        
        
        cell.textLabel?.text = task.name
        cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        cell.textLabel?.numberOfLines = 0
        cell.detailTextLabel?.text = task.note
        cell.detailTextLabel?.numberOfLines = 0
        cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
        
        if task.isComplete == true {
            cell.detailTextLabel?.isEnabled = false
            cell.textLabel?.isEnabled = false
            cell.textLabel?.attributedText = makeSlashText(task.name)
            cell.detailTextLabel?.attributedText = makeSlashText(task.note)
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        
        var task: Task!
        task = indexPath.section == 0 ? currentTasks[indexPath.row] : completedTask[indexPath.row]
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, _ in
            StorageManager.deleteTask(task)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        let editAction = UIContextualAction(style: .normal, title: nil) { _, _, complition in
            self.alertForAddAndUpdateTask(task) {
                tableView.reloadRows(at: [indexPath], with: .automatic)
            }
            //complition(true)
        }
        editAction.backgroundColor = .orange
        editAction.image = UIImage(systemName: "square.and.pencil")
        
        let doneAction = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            StorageManager.isCompleted(task)
            self.filteringTasks()
            tableView.reloadData()
        }
        doneAction.backgroundColor = task.isComplete ? .systemCyan : .systemGreen
        doneAction.image = task.isComplete ? UIImage(systemName: "shift") : UIImage(systemName: "checkmark")
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction, doneAction])
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
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
        var title = "Новая задача"
        var doneButton = "Сохранить"
        
        if task != nil {
            title = "Изменение задачи"
            doneButton = "Изменить"
        }
        var nameTextField: UITextField!
        var noteTextField: UITextField!
        let alert = UIAlertController(title: title, message: nil, preferredStyle: .alert)
        let saveAction = UIAlertAction(title: doneButton, style: .default) { _ in
            guard let taskName = nameTextField.text, !taskName.isEmpty else { return }
            guard let taskNote = noteTextField.text, !taskNote.isEmpty else { return }
            if task != nil {
                StorageManager.editTask(task!, taskName: taskName, taskNote: taskNote)
                if complition != nil {
                    complition!()
                }
            } else {
                let newTask = Task()
                newTask.name = taskName
                newTask.note = taskNote
                StorageManager.saveTask(self.currentTasksList, task: newTask)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
        
        let cancelActon = UIAlertAction(title: "Отмена", style: .default)
        alert.addTextField() { textField in
            textField.text = task?.name
            textField.placeholder = "Название"
        }
        alert.addTextField() { textField in
            textField.text = task?.note
            textField.placeholder = "Описание"
        }
        nameTextField = alert.textFields?[0]
        noteTextField = alert.textFields?[1]
        alert.addAction(saveAction)
        alert.addAction(cancelActon)
        present(alert, animated: true)
    }
}


