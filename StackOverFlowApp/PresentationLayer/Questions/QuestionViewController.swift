//
//  ViewController.swift
//  StackOverFlowApp
//
//  Created by Veaceslav Chirita on 3/13/20.
//  Copyright © 2020 Veaceslav Chirita. All rights reserved.
//

import UIKit
import CoreData

@available(iOS 10.0, *)
class QuestionViewController: UIViewController {
    
    @IBOutlet weak var searchBar: UISearchBar!
    @IBOutlet weak var segmentControl: UISegmentedControl!
    @IBOutlet weak var questionResponseTable: UITableView!
    
    var questions = [Question]()
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchBar.delegate = self
        questionResponseTable.delegate   = self
        questionResponseTable.dataSource = self
        questionResponseTable.register(UINib.init(nibName: "QuestionCell", bundle: nil), forCellReuseIdentifier: "QuestionCell")
        
        NetworkManager.shared.getQuestions { [weak self] (questions, error) in
            if error?.isEmpty ?? true {
                DispatchQueue.main.async {
                    DatabaseManager.shared.saveQuestionsToDb(questions: questions?.items)
                    self?.questions = questions!.items
                    self?.questionResponseTable.reloadData()
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        let destinationVC = segue.destination as! QuestionDetailViewController
        destinationVC.question = sender as? Question
    }
}

@available(iOS 10.0, *)
extension QuestionViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let screenSize  = UIScreen.main.bounds
        let screenWidth = screenSize.width
        let questionHeight = questions[indexPath.row].title.height(withConstrainedWidth: screenWidth - 40, font: UIFont(name: "Avenir-Medium", size: 15)!)
        
        return questionHeight + 101 + 16
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return questions.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = questionResponseTable.dequeueReusableCell(withIdentifier: "QuestionCell", for: indexPath) as! QuestionCell
        cell.question = questions[indexPath.row]
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "to_question_details", sender: questions[indexPath.row])
    }
}

@available(iOS 10.0, *)
extension QuestionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        guard let questionsResponse = DatabaseManager.shared
            .fetchQuestions(by: segmentControl.selectedSegmentIndex, searchText: searchText) else {
                return
        }
        questions = questionsResponse
        questionResponseTable.reloadData()
    }
}
