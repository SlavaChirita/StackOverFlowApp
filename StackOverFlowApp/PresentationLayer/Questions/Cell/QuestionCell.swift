//
//  QuestionCell.swift
//  StackOverFlowApp
//
//  Created by Veaceslav Chirita on 3/13/20.
//  Copyright © 2020 Veaceslav Chirita. All rights reserved.
//

import UIKit

class QuestionCell: UITableViewCell {

    @IBOutlet weak var avatarImage: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var tagLabel: UILabel!
    @IBOutlet weak var questionLabel: UILabel!
    
    var question: Question? {
        didSet {
            configure()
        }
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        avatarImage.layer.cornerRadius  = 25
        avatarImage.layer.masksToBounds = true
    }
    
    override func prepareForReuse() {
        avatarImage.image  = nil
        nameLabel.text     = nil
        tagLabel.text      = nil
        questionLabel.text = nil
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configure() {
        guard let quest = question else {
            return
        }
    
        ImageLoader.shared.downloadImage(from: quest.owner.profileImage, imageView: avatarImage)
        nameLabel.text     = quest.owner.displayName
        tagLabel.text      = getTagsFromArray(stringArray: quest.tags) ?? ""
        questionLabel.text = quest.title
    }
    
    func getTagsFromArray(stringArray: [String]) -> String? {
        if stringArray.count == 0 {
            return nil
        }
        return stringArray.joined(separator: ", ")
    }
    
    func downloadImage(from urlString: String) {
        print("Download Started")
        let url = URL(string: urlString)
        getData(from: url!) { data, response, error in
            guard let data = data, error == nil else { return }
            print(response?.suggestedFilename ?? url!.lastPathComponent)
            print("Download Finished")
            DispatchQueue.main.async() {
                self.avatarImage.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
    
}
