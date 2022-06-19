
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
        title = "Мои задачи"
        view.backgroundColor = .systemGray6
        navigationItem.leftBarButtonItem = editButtonItem
        let addButton = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showAlertForCreateNote))
        addButton.tintColor = .systemGreen
        editButtonItem.image = UIImage(systemName: "square.and.pencil")
        editButtonItem.tintColor = .systemOrange
        navigationItem.rightBarButtonItem = addButton
        navigationController?.navigationBar.prefersLargeTitles = true
        tableView.register(TasksListTableViewCell.self, forCellReuseIdentifier: viewModel.cellIdentifier)
    }
    
    private func setSearchController() {
        searchController = UISearchController()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.placeholder = "Поиск"
        searchController.definesPresentationContext = true
        searchController.searchBar.setValue("Отмена", forKey:"cancelButtonText")
        navigationItem.hidesSearchBarWhenScrolling = false
        navigationItem.searchController = searchController
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
}

// MARK: - Metods TableViewDelegate and TableViewDataSource
extension TasksListTableView {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: viewModel.cellIdentifier) as? TasksListTableViewCell,
              let viewModel = viewModel else { return UITableViewCell() }
        guard let cellViewModel = viewModel.cellViewModel(forIndexPath: indexPath) else { return UITableViewCell() }
        cell.viewModel = cellViewModel
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.selectRow(atIndexPath: indexPath)
        let detailViewModel = viewModel.getViewModelDetail()
        let tasksVC = TasksTableView()
        tasksVC.viewModel = detailViewModel
        navigationController?.pushViewController(tasksVC, animated: true)
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        return createSwipeActions(indexPath)
    }
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        let rotationTransform = CATransform3DTranslate(CATransform3DIdentity, 0, 50, 0)
        cell.layer.transform = rotationTransform
        cell.alpha = 0
        UIView.animate(withDuration: 0.3) {
            cell.layer.transform = CATransform3DIdentity
            cell.alpha = 1.0
        }
    }
    
    private func toogleCompletion( _ cell: UITableViewCell, isCompleted: Bool) {
        cell.accessoryType = isCompleted ? .checkmark : .none
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
    
    private func createSwipeActions(_ indexPath: IndexPath) -> UISwipeActionsConfiguration {
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
}

// MARK: - Metods TasksListTableViewViewModelDelegate
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
}

// MARK: - Metods UITextFieldDelegate
extension TasksListTableView: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        guard textField.text?.isEmpty == true else { return true }
        textField.text = string.capitalized
        return false
    }
}



