
import UIKit
import SnapKit

class TasksListTableViewCell: UITableViewCell {
    
    var viewModel: TasksListTableViewCellViewModelProtocol! {
        willSet(viewModel) {
            titleLabel.text = viewModel.titleLabel
            countLabel.text = viewModel.calculateTasks()
            dateLabel.text = viewModel.dateLabel
        }
    }
    
    let titleLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.font = UIFont.boldSystemFont(ofSize: 18)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let countLabel: UILabel = {
        let label = UILabel()
        label.textColor = .lightGray
        label.textAlignment = .left
        label.numberOfLines = 0
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    let dateLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .left
        label.font = UIFont.systemFont(ofSize: 15)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupCellView(contentView)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupCellView(_ view: UIView){
        view.addSubview(titleLabel)
        view.addSubview(countLabel)
        view.addSubview(dateLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview().inset(10)
            make.left.equalToSuperview().inset(15)
            make.width.equalTo(view.snp.width).inset(15)
            make.bottom.equalTo(countLabel.snp.top).inset(-10)
        }
        countLabel.snp.makeConstraints { make in
            make.top.equalTo(titleLabel.snp.bottom).inset(10)
            make.left.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(10)
        }
        dateLabel.snp.makeConstraints { make in
            make.right.equalToSuperview().inset(15)
            make.bottom.equalToSuperview().inset(10)
        }
    }
}
