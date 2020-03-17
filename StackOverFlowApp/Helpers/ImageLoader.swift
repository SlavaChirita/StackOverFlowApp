//
//  ImageDownload.swift
//  StackOverFlowApp
//
//  Created by Veaceslav Chirita on 3/16/20.
//  Copyright © 2020 Veaceslav Chirita. All rights reserved.
//

import UIKit

class ImageLoader {
    
    static let shared = ImageLoader()
    private init() {}
    
    func downloadImage(from urlString: String, imageView: UIImageView) {
        let url = URL(string: urlString)
        getData(from: url!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() {
                imageView.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
