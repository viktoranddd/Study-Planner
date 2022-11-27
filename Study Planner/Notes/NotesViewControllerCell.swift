//
//  NotesViewControllerCell.swift
//  Study Planner
//
//  Created by Viktor Andreev on 26.11.2022.
//

import Foundation
import UIKit

final class notesViewControllerCell: UITableViewCell {
    
    private var xSize: Int = 0
    
    private let titleLabel = UILabel()
    private let subtitleLabel = UILabel()
    
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
        
        
        titleLabel.frame = CGRect(x: 15 + xSize,
                                  y: 5,
                                  width: Int(frame.width) - 25 - 2 * xSize,
                                  height: Int(frame.height)/2)
        
        subtitleLabel.frame = CGRect(x: 15 + xSize,
                                     y: Int(frame.height)/2,
                                     width: Int(frame.width) - 25 - 2 * xSize,
                                     height: Int(frame.height)/2)
        
        
    }
    
    private func setupViews() {
        addSubview(titleLabel)
        addSubview(subtitleLabel)
    }
    
    func configure(title: String, note: String, isEdit: Bool) {
        if isEdit == true {
            self.xSize = 50
            titleLabel.alpha = 0.5
            subtitleLabel.alpha = 0.5
        }
        else {
            self.xSize = 0
            titleLabel.alpha = 1
            subtitleLabel.alpha = 1
        }
        titleLabel.text = title
        titleLabel.font = .boldSystemFont(ofSize: 20)
        subtitleLabel.text = note
    }
}
