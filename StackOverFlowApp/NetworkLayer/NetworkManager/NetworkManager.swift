//
//  NetworkManager.swift
//  StackOverFlowApp
//
//  Created by Veaceslav Chirita on 3/13/20.
//  Copyright © 2020 Veaceslav Chirita. All rights reserved.
//

import Foundation

class NetworkManager {
    static let shared = NetworkManager()
    let baseURL = "https://api.stackexchange.com/2.2/"
    
    private init() {}
    
    func getQuestions(completed: @escaping (FeedResponse?, String?) -> Void) {
        let endPoint = baseURL + "questions?order=desc&sort=activity&site=stackoverflow"
        guard let url = URL(string: endPoint) else {
            completed(nil, "Something went wrong")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(nil, "Something went wrong")
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, "Invalid response from the server.")
                return
            }
            
            guard let data = data else {
                completed(nil, "The data received from the server is invalid")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let questions = try decoder.decode(FeedResponse.self, from: data)
                completed(questions, nil)
            } catch {
                completed(nil, "The data received from the server is invalid")
            }
        }
        task.resume()
    }
    
    func getAnswers(questionId: Int, completed: @escaping (AnswerItems?, String?) -> Void) {
        let endPoint = baseURL + "questions/\(questionId)/answers?order=desc&sort=activity&site=stackoverflow&filter=!9Z(-wzu0T"
        guard let url = URL(string: endPoint) else {
            completed(nil, "Something went wrong")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(nil, "Something went wrong")
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, "Invalid response from the server.")
                return
            }
            
            guard let data = data else {
                completed(nil, "The data received from the server is invalid")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let answers = try decoder.decode(AnswerItems.self, from: data)
                completed(answers, nil)
            } catch {
                completed(nil, "The data received from the server is invalid")
            }
        }
        task.resume()
    }
    
    func getUser(id: Int, completed: @escaping (UserProfileItems?, String?) -> Void) {
        let endPoint = baseURL + "users/\(id)?order=desc&sort=reputation&site=stackoverflow"
        guard let url = URL(string: endPoint) else {
            completed(nil, "Something went wrong")
            return
        }
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let _ = error {
                completed(nil, "Something went wrong")
                return
            }
            guard let response = response as? HTTPURLResponse, response.statusCode == 200 else {
                completed(nil, "Invalid response from the server.")
                return
            }
            
            guard let data = data else {
                completed(nil, "The data received from the server is invalid")
                return
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.keyDecodingStrategy = .convertFromSnakeCase
                let user = try decoder.decode(UserProfileItems.self, from: data)
                completed(user, nil)
            } catch {
                completed(nil, "The data received from the server is invalid")
            }
        }
        task.resume()
    }
}
