//
//  DatabaseManager.swift
//  StackOverFlowApp
//
//  Created by Veaceslav Chirita on 3/17/20.
//  Copyright © 2020 Veaceslav Chirita. All rights reserved.
//

import UIKit
import CoreData

class DatabaseManager {
    
    static let shared = DatabaseManager()
    
    private init() {}
    
    @available(iOS 10.0, *)
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
    
    @available(iOS 10.0, *)
    func fetchQuestions(by cryteria: Int, searchText: String) -> [Question]? {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
            return nil
        }
        
        var questionsArray = [Question]()
        //questions.removeAll()
        let managedContext = appDelegate.persistentContainer.viewContext
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Questions")
        
        switch cryteria {
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
                questionsArray.append(Question(
                    questionId: data.value(forKey: "question_id") as! Int,
                    owner: Owner(
                        displayName: data.value(forKey: "display_name") as! String,
                        profileImage: data.value(forKey: "profile_image") as! String),
                    tags: (data.value(forKey: "tags") as! String).split(separator: ",").map(String.init),
                    title: data.value(forKey: "title") as! String)
                )
            }
            return questionsArray
        } catch {
            print("Failed")
            return nil
        }
    }
}
