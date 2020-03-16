//
//  ProfileViewController.swift
//  StackOverFlowApp
//
//  Created by Veaceslav Chirita on 3/16/20.
//  Copyright © 2020 Veaceslav Chirita. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var goldCounter: UILabel!
    @IBOutlet weak var silverCounter: UILabel!
    @IBOutlet weak var bronzeCounter: UILabel!
    
    var userId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImage.layer.cornerRadius = 75
        avatarImage.layer.masksToBounds = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        spinner.isHidden = false
        spinner.startAnimating()
        
        NetworkManager.shared.getUser(id: userId) { [weak self] (user, error) in
            if error?.isEmpty ?? true {
                DispatchQueue.main.async {
                    self?.spinner.isHidden = true
                    self?.spinner.stopAnimating()
                    self?.nameLabel.text = user?.items[0].displayName
                    ImageLoader.shared.downloadImage(from: (user?.items[0].profileImage)!, imageView: self!.avatarImage)
                    self?.goldCounter.text   = "\(user!.items[0].badgeCounts.gold)"
                    self?.silverCounter.text = "\(user!.items[0].badgeCounts.silver)"
                    self?.bronzeCounter.text = "\(user!.items[0].badgeCounts.bronze)"
                }
            }
        }
    }
}
