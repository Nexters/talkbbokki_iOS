//
//  CoreDataManager.swift
//  talkbbokki
//
//  Created by USER on 2023/02/26.
//

import Foundation
import CoreData

final class CoreDataManager {
    static let shared = CoreDataManager()
    private let persistentContainer: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "Topic")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error {
                fatalError("Unresolved error, \((error as NSError).userInfo)")
            }
        })
        return container
    }()
    
    func fetchTopics() -> [Topic]? {
        let context = self.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<Topic>(entityName: "Topic")
        let sort = NSSortDescriptor(key: #keyPath(Topic.saveAt), ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do {
            return try context.fetch(fetchRequest)
        } catch {
            return nil
        }
    }

    func fetchTopic(with id: Int) -> Topic? {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
            = NSFetchRequest<NSFetchRequestResult>(entityName: "Topic")
        fetchRequest.predicate = NSPredicate(format: "topicID == %d", id.int32)
        
        do {
            if let results: [Topic] = try self.persistentContainer.viewContext.fetch(fetchRequest) as? [Topic] {
                return results.first
            }
        } catch let error as NSError {
            print("Could not fetch🥺: \(error), \(error.userInfo)")
            return nil
        }
        return nil
    }
    
    func save(topic: Model.Topic, bgColor: Int) async -> Bool {
        let context = self.persistentContainer.viewContext
        guard let entitiy = NSEntityDescription.entity(forEntityName: "Topic", in: context) else { return false }
        guard let topicObject: Topic = NSManagedObject(entity: entitiy, insertInto: context) as? Topic else { return false }
        topicObject.topicID = topic.topicID.int32
        topicObject.viewCount = topic.viewCount.int32
        topicObject.tag = topic.tag.rawValue
        topicObject.pcLink = topic.pcLink
        topicObject.name = topic.name
        topicObject.createAt = topic.createAt
        topicObject.category = topic.category
        topicObject.bgColor = Int64(bgColor)
        topicObject.saveAt = Date()
        return await contextSave()
    }
    
    func deleteTopic(id: Int) async -> Bool {
        let fetchRequest: NSFetchRequest<NSFetchRequestResult>
            = NSFetchRequest<NSFetchRequestResult>(entityName: "Topic")
        fetchRequest.predicate = NSPredicate(format: "topicID == %d", id)
        
        do {
            if let results: [Topic] = try self.persistentContainer.viewContext.fetch(fetchRequest) as? [Topic] {
                if results.count != 0 {
                    self.persistentContainer.viewContext.delete(results[0])
                }
            }
        } catch let error as NSError {
            print("Could not fatch🥺: \(error), \(error.userInfo)")
            return false
        }
        
        return await contextSave()
    }
}

private extension CoreDataManager {
    func contextSave() async -> Bool {
        return await withCheckedContinuation({ continuation in
            do {
                try persistentContainer.viewContext.save()
                continuation.resume(returning: true)
            } catch let error as NSError {
                print("Could not save🥶: \(error), \(error.userInfo)")
                continuation.resume(returning: false)
            }
        })
    }
}
