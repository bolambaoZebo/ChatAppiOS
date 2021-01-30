//
//  ConversationTableViewCell.swift
//  Chatapp
//
//  Created by dnamicro on 2021/01/30.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {
    
//    static let identifier = 
    let userNameLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 21, weight: .semibold)
        return label
    }()
    
    let userMessageLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 18, weight: .regular)
        label.numberOfLines = 0
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userMessageLabel)
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userNameLabel.frame = CGRect(x: 10, y: 10, width: 100.0, height: 100.0)
        userMessageLabel.frame = CGRect(x: 10, y: 10, width: 100.0, height: 100.0)
    }
    
    public func configure(with model: String){
        
    }
    
    

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}

extension ConversationTableViewCell {
}
