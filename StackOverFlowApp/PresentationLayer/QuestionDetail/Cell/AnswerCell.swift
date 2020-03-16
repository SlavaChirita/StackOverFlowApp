//
//  AnswerTableViewCell.swift
//  StackOverFlowApp
//
//  Created by Veaceslav Chirita on 3/16/20.
//  Copyright © 2020 Veaceslav Chirita. All rights reserved.
//

import UIKit

protocol AvatarImageProtocol: class {
    func didTapOnAvatarImage(of userId: Int)
}

class AnswerCell: UITableViewCell {

    @IBOutlet weak var avatarImg: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    
    weak var delegate: AvatarImageProtocol!
    var userId: Int!
    
    var answer: Answer? {
        didSet {
            configure()
        }
    }
    
    override func prepareForReuse() {
        avatarImg.image  = nil
        nameLabel.text   = nil
        answerLabel.text = nil
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnAvatar))
        avatarImg.addGestureRecognizer(tapGesture)
        avatarImg.isUserInteractionEnabled = true
        
        avatarImg.layer.cornerRadius  = 25
        avatarImg.layer.masksToBounds = true
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func configure() {
        if let answer = answer {
            ImageLoader.shared.downloadImage(from: answer.owner.profileImage, imageView: avatarImg)
            nameLabel.text   = answer.owner.displayName
            answerLabel.text = answer.body
        }
    }
    
    @objc func didTapOnAvatar() {
        delegate.didTapOnAvatarImage(of: userId)
    }
    
}
