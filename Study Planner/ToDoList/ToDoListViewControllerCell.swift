//
//  ToDoListViewControllerCell.swift
//  Study Planner
//
//  Created by Viktor Andreev on 26.11.2022.
//

import Foundation
import UIKit

final class toDoListViewControllerCell: UITableViewCell {
    
    private var xSize: Int = 0
    private let titleTextLabel = UILabel()
    private let checkImageView = UIImageView()
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupViews()
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupViews()
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        checkImageView.frame = CGRect(x: 10 + xSize,
                                     y: 10,
                                     width: 30,
                                     height: 30)
        
        titleTextLabel.frame = CGRect(x: 50 + xSize,
                                  y: 10,
                                  width: Int(frame.width) - 50 - 2 * xSize,
                                  height: 30)
            
    }
    
    private func setupViews() {
        addSubview(checkImageView)
        addSubview(titleTextLabel)
    }
    
    func configure(status: Bool, text: String, isEdit: Bool) {
        
        if status == true {
            checkImageView.image = UIImage(systemName: "checkmark.circle.fill")
        } else {
            checkImageView.image = UIImage(systemName: "checkmark.circle")
        }
        if isEdit == true {
            self.xSize = 50
            checkImageView.alpha = 0.5
            titleTextLabel.alpha = 0.5
        }
        else {
            self.xSize = 0
            checkImageView.alpha = 1
            titleTextLabel.alpha = 1
        }
        
        checkImageView.tintColor = UIColor { traitCollection in
            switch traitCollection.userInterfaceStyle {
            case .dark:
                return .white
            default:
                return .black
            }
        }
        
        titleTextLabel.text = text
        titleTextLabel.font = .systemFont(ofSize: 18)
    }
}
