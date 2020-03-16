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
                    self?.saveQuestionsToDb(questions: questions?.items)
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
extension QuestionViewController {
    func saveQuestionsToDb(questions: [Question]?) {
        if let questions = questions {
            guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
            }
            let managedContext = appDelegate.persistentContainer.viewContext
            let entity = NSEntityDescription.entity(forEntityName: "Questions", in: managedContext)!
            
            for index in 0..<questions.count {
                let questionsContext = NSManagedObject(entity: entity, insertInto: managedContext)
                questionsContext.setValue(questions[index].questionId, forKeyPath: "question_id")
                questionsContext.setValue(questions[index].owner.profileImage, forKeyPath: "profile_image")
                questionsContext.setValue(questions[index].tags.joined(separator: ", "), forKeyPath: "tags")
                questionsContext.setValue(questions[index].title, forKeyPath: "title")
                questionsContext.setValue(questions[index].owner.displayName, forKeyPath: "display_name")
            }
            
            do {
                try managedContext.save()
            } catch let error as NSError {
                print("Could not save. \(error), \(error.userInfo)")
            }
        }
    }
}

@available(iOS 10.0, *)
extension QuestionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        questions.removeAll()
        print("searchText \(searchText)")
        
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Questions")
        
        
        switch segmentControl.selectedSegmentIndex {
        case 0:
            request.predicate = NSPredicate(format: "tags CONTAINS %@", searchText.lowercased())
        case 1:
            request.predicate = NSPredicate(format: "display_name CONTAINS %@", searchText)
        case 2:
            request.predicate = NSPredicate(format: "title CONTAINS %@", searchText)
        default:
            break
        }
        
        
        request.returnsObjectsAsFaults = false
        do {
            let result = try managedContext.fetch(request)
            for data in result as! [NSManagedObject] {
                questions.append(Question(
                    questionId: data.value(forKey: "question_id") as! Int,
                    owner: Owner(displayName: data.value(forKey: "display_name") as! String,
                                 profileImage: data.value(forKey: "profile_image") as! String),
                    tags: (data.value(forKey: "tags") as! String).split(separator: ",").map(String.init),
                    title: data.value(forKey: "title") as! String)
                )
                print(data.value(forKey: "title") as! String)
                print(questions.count)
            }
            questionResponseTable.reloadData()
            
        } catch {
            
            print("Failed")
        }
        
    }
}
