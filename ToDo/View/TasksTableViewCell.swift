//
//  TasksTableViewCell.swift
//  ToDo
//
//  Created by Duxxless on 13.06.2022.
//

import UIKit

class TasksTableViewCell: UITableViewCell {
    
    var viewModel: TasksTableViewCellViewModelProtocol! {
        willSet(viewModel) {
            textLabel?.text = viewModel.title
            detailTextLabel?.text = viewModel.note
            
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        
        textLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        textLabel?.numberOfLines = 0
        detailTextLabel?.numberOfLines = 0
        detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupIsComplete()  {
        if viewModel.isComplete == true {
            detailTextLabel?.isEnabled = false
            textLabel?.isEnabled = false

        } else if viewModel.isComplete == false {
            detailTextLabel?.isEnabled = true
            textLabel?.isEnabled = true
        }
    }
    
    
    private func makeSlashText(_ text:String) -> NSAttributedString {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
}
