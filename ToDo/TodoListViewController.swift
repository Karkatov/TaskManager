//
//  ViewController.swift
//  ToDo
//
//  Created by Duxxless on 26.04.2022.
//

import UIKit
import RealmSwift

class TodoListViewController: UITableViewController {
    
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
        tableView.register(TableViewCell.self, forCellReuseIdentifier: "Cell")
    }
}

extension TodoListViewController {
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "Cell") as? TableViewCell else { return UITableViewCell() }
        cell.titleLabel.text = "111"
        cell.countLabel.text = "1"
        return cell
    }
}


extension TodoListViewController {
    
    @objc func showAlert() {
        
        let title = ""
        let massege = ""
        
        let alert = UIAlertController(title: title, message: massege, preferredStyle: .alert)
        let doneAction = UIAlertAction(title: "OK", style: .default) { action in
            
        }
        
        let cancelActon = UIAlertAction(title: "Отмена", style: .cancel)
        alert.addTextField { tf in
            tf.placeholder = "Введите название списка"
        }
        alert.addAction(doneAction)
        alert.addAction(cancelActon)
        present(alert, animated: true)
    }
}
