//
//  TasksTableViewCell.swift
//  ToDo
//
//  Created by Duxxless on 29.04.2022.
//

import UIKit

class TasksTableViewCell: UITableViewCell {

    let nameLabel: UILabel = {
        
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = UIFont.systemFont(ofSize: 20)
        label.numberOfLines = 0
        return label
    }()
    
    let doneImageView: UIImageView = {
        let imageView = UIImageView()
        let image = UIImage(systemName: "circle")
        imageView.image = image
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
