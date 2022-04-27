//
//  TableViewCell.swift
//  ToDo
//
//  Created by Duxxless on 26.04.2022.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {

    @IBOutlet weak var label: UILabel!
    
    @IBOutlet weak var button: UIButton!
    override func awakeFromNib() {
        super.awakeFromNib()
        label.text = "Hello"
        label.font = UIFont.boldSystemFont(ofSize: 25)
     
    }

    @IBAction func pressedButton(_ sender: UIButton) {
 
        button.setImage(UIImage(systemName: "heart.fill"), for: .normal)
        button.tintColor = .red
    }
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
