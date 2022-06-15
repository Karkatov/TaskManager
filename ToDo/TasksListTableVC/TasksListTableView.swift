
import UIKit
import RealmSwift

class TasksListTableView: UITableViewController {
    
    var viewModel: TasksListTableViewViewModelProtocol!
    var searchController: UISearchController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = TasksListTableViewViewModel()
        viewModel.delegate = self
        setSearchController()
        setTableView()
    }
    
    private func setTableView() {
        navigationItem.leftBarButtonItem = editButtonItem
        navigationItem.leftBarButtonItem?.title = "Изменить"
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAlertForCreateNote))
        navigationItem.rightBarButtonItem = addButton
        view.backgroundColor = .systemGray6
        title = "Мои заметки"
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(TasksListTableViewCell.self, forCellReuseIdentifier: "Cell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

extension TasksListTableView {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TasksListTableViewCell,
              let viewModel = viewModel else { return UITableViewCell() }
        guard let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath) else { return UITableViewCell() }
        cell.viewModel = cellViewModel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tasksVC = TasksTableView()
        tasksVC.currentTasksList = viewModel.tasksLists[indexPath.row]
        navigationController?.pushViewController(tasksVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: nil) { _, _, _ in
            self.viewModel.deleteTasksList(indexPath)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        deleteAction.backgroundColor = .systemRed
        deleteAction.image = UIImage(systemName: "trash")
        
        let editAction = UIContextualAction(style: .normal, title: nil) { _, _, complition in
            self.viewModel.updateTasksList(indexPath)
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
    @objc func showAlertForCreateNote() {
        tableView.isEditing = false
        viewModel.createTasksList()
    }
    private func setSearchController() {
        searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        navigationItem.searchController = searchController
        searchController.searchBar.placeholder = "Поиск"
        searchController.definesPresentationContext = true
    }
}

extension TasksListTableView: TasksListTableViewViewModelDelegate {
    func updateTableView(_ indexPath: IndexPath) {
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
    
    func showAlert(_ tasksList: TasksList? = nil, complition: (() -> Void)? = nil) {
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
                StorageManager.saveTasksList(newTasksList)
                self.tableView.insertRows(at: [IndexPath(row: 0, section: 0)], with: .automatic)
            }
        }
        let cancelActon = UIAlertAction(title: "Отмена", style: .default)
        alert.addTextField { tf in
            tf.placeholder = "Название"
            guard let nameList = tasksList?.name else { return }
            tf.text = nameList
        }
        alertTextField = alert.textFields?.first
        alertTextField.delegate = self
        alert.addAction(saveAction)
        alert.addAction(cancelActon)
        present(alert, animated: true)
    }
}

// MARK: - Metods UISearchResultsUpdating
extension TasksListTableView: UISearchResultsUpdating, UISearchBarDelegate {
    
    func updateSearchResults(for searchController: UISearchController) {
        if let text = searchController.searchBar.text, text != "" {
            viewModel.searchBarIsEmpty = false
            viewModel.filteredTasks(text)
        } else {
            viewModel.searchBarIsEmpty = true
            viewModel.filteredTasks(nil)
        }
        tableView.reloadData()
    }
    
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        if let cancelButton = searchBar.value(forKey: "cancelButton") as? UIButton {
            cancelButton.setTitle("Отмена", for: .normal)
        }
        return true
    }
}

extension TasksListTableView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField.text?.isEmpty == true else { return true }
        textField.text = string.uppercased()
        return false
    }
}



