import Foundation
import UIKit
import CoreData
import RxSwift
import RxCocoa

struct UserFavoriteModel {
    var id: Int64
    var isFavorite: Bool
}

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
        } catch {
            print("Delete data Failed", error.localizedDescription)
        }
    }
    
    func fetchFavorite() -> Observable<[UserFavoriteModel]> {
        return Observable.create { observer in
            guard let context = self.context else {
                observer.onError(ServiceError(ErrorType.fetchDBError))
                return Disposables.create()
            }
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                guard let objectList = result as? [NSManagedObject] else {
                    observer.onError(ServiceError(ErrorType.fetchDBError))
                    return Disposables.create()
                }
                var userFavoriteList: [UserFavoriteModel] = []
                for data in objectList {
                    let favoriteModel = UserFavoriteModel(
                        id: data.value(
                            forKey: "id") as? Int64 ?? 0,
                        isFavorite: data.value(
                            forKey: "favorite") as? Bool ?? false)
                    userFavoriteList.append(favoriteModel)
                }
                observer.onNext(userFavoriteList)
            } catch {
                observer.onError(ServiceError(ErrorType.fetchDBError))
            }
            
            return Disposables.create()
        }
    }
}
