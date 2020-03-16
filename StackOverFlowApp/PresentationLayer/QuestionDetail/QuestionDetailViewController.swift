//
//  QuestionDetailViewController.swift
//  StackOverFlowApp
//
//  Created by Veaceslav Chirita on 3/14/20.
//  Copyright © 2020 Veaceslav Chirita. All rights reserved.
//

import UIKit

class QuestionDetailViewController: UIViewController {
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagsLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var answerTableView: UITableView!
    
    var question: Question!
    var answers: [Answer]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        avatarImage.layer.cornerRadius = 25
        avatarImage.layer.masksToBounds = true
        
        answerTableView.delegate   = self
        answerTableView.dataSource = self
        
        answerTableView.register(UINib.init(nibName: "AnswerCell", bundle: nil), forCellReuseIdentifier: "AnswerCell")
    }
    
    override func viewWillAppear(_ animated: Bool) {
        nameLabel.text = question.owner.displayName
        tagsLabel.text = question.tags.joined(separator: ", ")
        questionLabel.text = question.title
        ImageLoader.shared.downloadImage(from: question.owner.profileImage, imageView: avatarImage)
        spinner.isHidden = false
        spinner.startAnimating()
        
        NetworkManager.shared.getAnswers(questionId: question!.questionId) { [weak self] (answers, error) in
            if error?.isEmpty ?? true {
                DispatchQueue.main.async {
                    self?.spinner.isHidden = true
                    self?.spinner.stopAnimating()
                    self?.answers = answers?.items
                    self?.answerTableView.reloadData()
                }
            }
        }
    }
}

extension QuestionDetailViewController: UITableViewDelegate, UITableViewDataSource, AvatarImageProtocol {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenSize  = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let questionHeight = answers?[indexPath.row].body.height(withConstrainedWidth: screenWidth - 40, font: UIFont(name: "Avenir-Medium", size: 15)!)
        
        return questionHeight! + 101 + 16
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return answers?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = answerTableView.dequeueReusableCell(withIdentifier: "AnswerCell", for: indexPath) as! AnswerCell
        ImageLoader.shared.downloadImage(from: answers![indexPath.row].owner.profileImage,
                                         imageView: cell.avatarImg)
        cell.nameLabel.text   = answers![indexPath.row].owner.displayName
        cell.answerLabel.text = answers![indexPath.row].body
        let userId            = answers![indexPath.row].owner.userId
        cell.userId           = userId
        
        cell.delegate = self
        
        return cell
    }
    
    func didTapOnAvatarImage(of userId: Int) {
        performSegue(withIdentifier: "to_profile_info", sender: userId)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! ProfileViewController
        destinationVC.userId = sender as? Int
    }
    
}
