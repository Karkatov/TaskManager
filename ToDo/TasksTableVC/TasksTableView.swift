//
//  TasksTableViewController.swift
//  ToDo
//
//  Created by Duxxless on 29.04.2022.
//

import UIKit
import RealmSwift

class TasksTableView: UITableViewController {
    
    var currentTasksList: TasksList!
    var viewModel: TasksTableViewViewModelProtocol!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        viewModel = TasksTableViewViewModel(currentTasksList)
        viewModel.delegate = self
        setTableView()
    }
    
    private func setTableView() {
        title = viewModel.tasksList.name
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createTasksList))
        
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
        navigationItem.rightBarButtonItems?[1].title = "Изменить"
        view.backgroundColor = .systemGray6
        tableView.register(TasksTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    private func makeSlashText(_ text:String) -> NSAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}

extension TasksTableView {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }
    override func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return viewModel.getTitleOfSection(section)
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows(section)
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TasksTableViewCell else { return UITableViewCell() }
        var task: Task!
        task = viewModel.getCurrentOrCompletedTasks(indexPath)
        guard let newCell = viewModel.cellViewModel(forIndexPath: indexPath) else { return UITableViewCell() }
        cell.viewModel = newCell
        cell.setupIsComplete()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TasksTableViewCell
        var task: Task!
        task = viewModel.getCurrentOrCompletedTasks(indexPath)
        
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, _ in
            StorageManager.deleteTask(task)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        let editAction = UIContextualAction(style: .normal, title: nil) { _, _, complition in
            self.viewModel.updateTask(task, indexPath: indexPath)
            complition(true)
        }
        editAction.backgroundColor = .orange
        editAction.image = UIImage(systemName: "square.and.pencil")
        
        let doneAction = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            StorageManager.isCompleted(task)
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
    
    @objc func createTasksList() {
        viewModel.createTask()
    }
}

extension TasksTableView: TasksTableViewDelegate {
    func updateTableView(_ indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func showAlert(_ task: Task?, complition: (() -> Void)?) {
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
                StorageManager.saveTask(self.viewModel.tasksList, task: newTask)
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

