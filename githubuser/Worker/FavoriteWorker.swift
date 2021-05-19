import Foundation
import UIKit
import CoreData
import RxSwift
import RxCocoa

class FavoriteWorker {
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var context: NSManagedObjectContext?
    
    init() {
        context = appDelegate?.persistentContainer.viewContext
    }
    
    func makeFavorite(userId: Int64) {
        guard
            let context = self.context,
            let entity = NSEntityDescription.entity(
                forEntityName: "Favorite",
                in: context)
        else { return }
        
        let newFavorite = NSManagedObject(entity: entity, insertInto: context)
        newFavorite.setValue(userId, forKey: "id")
        newFavorite.setValue(true, forKey: "favorite")
        do {
            try context.save()
        } catch {
            print("Storing data Failed")
        }
    }
    
    func makeUnFavorite(userId: Int64) {
        guard let context = self.context else { return }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            guard let objectList = result as? [NSManagedObject] else { return }
            for data in objectList {
                if data.value(forKey: "id") as? Int64 == userId {
                    context.delete(data)
                }
            }
            try context.save()
        } catch {}
    }
    
    func fetchFavorite(userId: Int64) -> Bool {
        guard let context = self.context else { return false }
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
        request.returnsObjectsAsFaults = false
        do {
            let result = try context.fetch(request)
            guard let objectList = result as? [NSManagedObject] else { return false }
            for data in objectList {
                if data.value(forKey: "id") as? Int64 == userId {
                    return data.value(forKey: "favorite") as? Bool ?? false
                }
            }
        } catch {}
        return false
    }
}
