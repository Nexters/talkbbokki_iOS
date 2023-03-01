//
//  CoreData.Category.swift
//  talkbbokki
//
//  Created by USER on 2023/02/28.
//

import Foundation
import CoreData

extension CoreDataManager {
    class CategoryData: CoreDataType {
        let persistentContainer: NSPersistentContainer = {
            let container = NSPersistentContainer(name: "Topic")
            container.loadPersistentStores(completionHandler: { (storeDescription, error) in
                if let error = error {
                    fatalError("Unresolved error, \((error as NSError).userInfo)")
                }
            })
            return container
        }()
        
        func fetch() -> [Category]? {
            let context = self.persistentContainer.viewContext
            let fetchRequest = NSFetchRequest<Category>(entityName: "Category")
            let sort = NSSortDescriptor(key: #keyPath(Category.priority), ascending: true)
            fetchRequest.sortDescriptors = [sort]
            do {
                return try context.fetch(fetchRequest)
            } catch {
                return nil
            }
        }
        
        func save(category: Model.Category, priority: Int) -> Bool {
            let context = self.persistentContainer.viewContext
            guard let entitiy = NSEntityDescription.entity(forEntityName: "Category", in: context) else { return false }
            guard let categoryObject: Category = NSManagedObject(entity: entitiy, insertInto: context) as? Category else { return false }
            categoryObject.filePath = category.filePath.orEmpty
            categoryObject.imageUrl = category.imageUrl.orEmpty
            categoryObject.bgColor = category.bgColor
            categoryObject.activeYn = category.activeYn
            categoryObject.code = category.code
            categoryObject.text = category.text
            categoryObject.priority = Int16(priority)
            return contextSave()
        }
        
        func delete(code: String) -> Bool {
            let fetchRequest: NSFetchRequest<NSFetchRequestResult>
                = NSFetchRequest<NSFetchRequestResult>(entityName: "Category")
            fetchRequest.predicate = NSPredicate(format: "code == %@", code)
            
            do {
                if let results: [Category] = try self.persistentContainer.viewContext.fetch(fetchRequest) as? [Category] {
                    if results.count != 0 {
                        self.persistentContainer.viewContext.delete(results[0])
                    }
                }
            } catch let error as NSError {
                print("Could not fatch🥺: \(error), \(error.userInfo)")
                return false
            }
            
            return contextSave()
        }
    }
}
