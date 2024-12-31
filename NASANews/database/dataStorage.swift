//
//  dataStorage.swift
//  NASANews
//
//  Created by Haneen Medhat on 26/10/2024.
//

import Foundation
import CoreData
import UIKit


let appDelegate = UIApplication.shared.delegate as! AppDelegate
let context = appDelegate.persistentContainer.viewContext

class DataStorage {
   
    
// MARK: Save to coreData:
    static func saveNews(news:NewsInfo){
        guard let entity = NSEntityDescription.entity(forEntityName: "News", in: context) else{ return}
        let object = NSManagedObject(entity: entity, insertInto: context)
        
        object.setValue(news.author, forKey: "author")
        object.setValue(news.title, forKey: "title")
        object.setValue(news.description, forKey: "descrip")
        object.setValue(news.image, forKey: "image")
        object.setValue(news.date, forKey: "date")
        do{
        try context.save()
            print("News saved successfully")
        }catch let error as NSError{
            print("Error while saving the news \(error.userInfo)")
        }
    }
    
  // MARK: Fetch from CoreData:
    static func fetchNews() -> [NewsInfo]{
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "News")
        do{
        let result = try context.fetch(fetchRequest)
           let newsArray :[NewsInfo] = result.compactMap{ object in
               guard
                let author = object.value(forKey: "author") as? String,
                let title = object.value(forKey: "title") as? String,
                let description = object.value(forKey: "descrip") as? String,
                let image = object.value(forKey: "image") as? String,
                let date = object.value(forKey: "date") as? String
               else{ return nil }
                
                return NewsInfo(author: author, title: title, description: description, image: image, date: date)

            }
            return newsArray
        }catch let error as NSError{
            print("Coulding fetch the news \(error.userInfo)")
            return []
        }
    }
    
    // MARK: Fetch from CoreData with predicate:
    static func fetchNewsPredicate(title:String) -> [NewsInfo]{
          let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "News")
        fetchRequest.predicate = NSPredicate(format:"title == %@",title)

          do{
          let result = try context.fetch(fetchRequest)
             let newsArray :[NewsInfo] = result.compactMap{ object in
                 guard
                  let author = object.value(forKey: "author") as? String,
                  let title = object.value(forKey: "title") as? String,
                  let description = object.value(forKey: "descrip") as? String,
                  let image = object.value(forKey: "image") as? String,
                  let date = object.value(forKey: "date") as? String
                 else{ return nil }
                  
                  return NewsInfo(author: author, title: title, description: description, image: image, date: date)

              }
              return newsArray
          }catch let error as NSError{
              print("Coulding fetch the news \(error.userInfo)")
              return []
          }
      }
    
 //MARK: Delete from CoreData
   static func deleteNews(title:String){
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "News")
        fetchRequest.predicate = NSPredicate(format:"title == %@",title)
        
        do {
             let result = try context.fetch(fetchRequest)
            for news in result{
               context.delete(news)

            }
            try context.save()
            print("News deleted successfully")
        }catch let error as NSError{
            print("couldnt delete the news \(error.userInfo)")
        }
    }
    
    
}
