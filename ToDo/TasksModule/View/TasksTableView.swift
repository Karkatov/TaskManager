

import UIKit
import RealmSwift

class TasksTableView: UITableViewController {
    
    var viewModel: TasksTableViewViewModelProtocol!
    var searchController: UISearchController!
    var searchMode = false
    var editMode = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        setSearchController()
        setTableView()
    }
    
    private func setTableView() {
        title = viewModel.tasksList.name
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(createTask))
        addButton.tintColor = .systemGreen
        editButtonItem.image = UIImage(systemName: "list.bullet")
        editButtonItem.tintColor = .systemOrange
        navigationItem.rightBarButtonItems = [addButton, editButtonItem]
        view.backgroundColor = .systemGray6
        tableView.register(TasksTableViewCell.self, forCellReuseIdentifier: viewModel.cellIdentifier)
    }
    
    private func makeSlashText(_ text:String) -> NSAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    private func setSearchController() {
        searchController = UISearchController()
        searchController.searchBar.delegate = self
       // searchController.obscuresBackgroundDuringPresentation = false
        //searchController.definesPresentationContext = true
        searchController.searchBar.placeholder = "Поиск"
        searchController.searchBar.setValue("Отмена", forKey:"cancelButtonText")
        searchController.isActive = false
        navigationItem.searchController = searchController
    }
    
    @objc func createTask() {
        UIFeedbackGenerator.selectionFeedback()
        tableView.isEditing = false
        viewModel.createTask()
    }
}

// MARK: - Metods UITableViewDataSource and UITableViewDelegate
extension TasksTableView {
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.getNumberOfSections()
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.getNumberOfRows(section)
    }
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        view.backgroundColor = .systemGray6
        let label = UILabel()
        label.text = viewModel.getTitleOfSection(section)
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.frame = CGRect(x: 15, y: view.frame.height / 2, width: 300, height: 30)
        if label.text == "АКТИВНЫЕ ЗАДАЧИ" {
            label.textColor = .systemRed
        } else {
            label.textColor = .systemGreen
        }
        view.addSubview(label)
        return view
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellIdentifier) as? TasksTableViewCell else { return UITableViewCell()
        }
        cell.viewModel = viewModel.cellViewModel(forIndexPath: indexPath)
        cell.setupIsComplete()
        return cell
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        editMode = true
        let task = viewModel.getCurrentOrCompletedTasks(indexPath)
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, _ in
            StorageManager.deleteTask(task)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
            UIFeedbackGenerator.notificationFeedback()
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        let editAction = UIContextualAction(style: .normal, title: nil) { _, _, complition in
            self.viewModel.updateTask(task, indexPath: indexPath)
            UIFeedbackGenerator.impactFeedback()
            complition(true)
        }
        editAction.backgroundColor = .orange
        editAction.image = UIImage(systemName: "square.and.pencil")
        
        let doneAction = UIContextualAction(style: .normal, title: nil) { _, _, _ in
            let newTask = Task()
            newTask.name = task.name
            newTask.note = task.note
            newTask.isComplete = !task.isComplete
            StorageManager.deleteTask(task)
            StorageManager.saveTask(self.viewModel.tasksList, task: newTask)
            let section = newTask.isComplete ? 1 : 0
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .automatic)
            tableView.insertRows(at: [IndexPath(row: 0, section: section)], with: .automatic)
            UIFeedbackGenerator.impactFeedback()
            tableView.endUpdates()
            
        }
        doneAction.backgroundColor = task.isComplete ? .systemCyan : .systemGreen
        doneAction.image = task.isComplete ? UIImage(systemName: "shift") : UIImage(systemName: "checkmark")
        return UISwipeActionsConfiguration(actions: [deleteAction, editAction, doneAction])
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        guard !searchMode else { return }
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.3) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    override func setEditing(_ editing: Bool, animated: Bool) {
        super.setEditing(editing, animated: animated)
        if editing {
            UIFeedbackGenerator.selectionFeedback()
            guard !editMode else {
                editMode = false
                return }
            tableView.setEditing(editing, animated: true)
            editButtonItem.image = UIImage(systemName: "checkmark")
            editButtonItem.tintColor = .systemGreen
            navigationItem.rightBarButtonItem?.isEnabled = false
        } else {
            navigationItem.rightBarButtonItem?.isEnabled = true
            editButtonItem.image = UIImage(systemName: "list.bullet")
            editButtonItem.tintColor = .systemOrange
            tableView.endEditing(true)
        }
    }
}
// MARK: - Metods TasksTableViewDelegate
extension TasksTableView: TasksTableViewDelegate {
    
    func editStatusTask(_ indexPath: IndexPath, taskName: String, isComplete: Bool) -> Int {
        let tasks = viewModel.tasksList.tasks
        let taskName = tasks[indexPath.row].name
        var row = 0
        for task in tasks {
            guard task.isComplete == isComplete else { continue }
            if task.name != taskName {
                row += 1
            } else if task.name == taskName {
                break
            }
        }
        return row
    }
    
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
            UIFeedbackGenerator.selectionFeedback()
            guard let taskName = nameTextField.text, !taskName.isEmpty else { return }
            let taskNote = noteTextField.text ?? ""
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
        nameTextField.delegate = self
        noteTextField.delegate = self
        alert.addAction(saveAction)
        alert.addAction(cancelActon)
        present(alert, animated: true)
    }
}

// MARK: - Metods UISearchResultsUpdating
extension TasksTableView: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchText != "" {
            searchMode = true
            viewModel.searchBarIsEmpty = false
            viewModel.filteredTasks(searchText)
        } else {
            searchMode = false
            viewModel.searchBarIsEmpty = true
            viewModel.filteredTasks("")
        }
        tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("Отмена", for: .normal)
        }
        return true
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchMode = false
        viewModel.searchBarIsEmpty = true
        viewModel.filteredTasks("")
        tableView.reloadData()
    }
}

// MARK: - Metods UITextFieldDelegate
extension TasksTableView: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField.text?.isEmpty == true else { return true }
        textField.text = string.capitalized
        return false
    }
}

