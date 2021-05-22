import Foundation
import UIKit
import CoreData
import RxSwift
import RxCocoa

struct UserFavoriteModel {
    var id: Int64
    var name: String
}

class FavoriteWorker {
    weak var appDelegate = UIApplication.shared.delegate as? AppDelegate
    var context: NSManagedObjectContext?
    
    init() {
        context = appDelegate?.persistentContainer.viewContext
    }
    
    func makeFavorite(userId: Int64, uesrName: String) {
        guard
            let context = self.context,
            let entity = NSEntityDescription.entity(
                forEntityName: "Favorite",
                in: context)
        else { return }
        
        let newFavorite = NSManagedObject(entity: entity, insertInto: context)
        newFavorite.setValue(userId, forKey: "id")
        newFavorite.setValue(uesrName, forKey: "user")
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
    
    func fetchFavorite(keyword: String = "", startIndex: Int = 0) -> Observable<[UserFavoriteModel]> {
        return Observable.create { observer in
            guard let context = self.context else {
                observer.onError(ServiceError(ErrorType.fetchDBError))
                return Disposables.create()
            }
            let request = NSFetchRequest<NSFetchRequestResult>(entityName: "Favorite")
            if !keyword.isEmpty {
                request.predicate = NSPredicate(format: "user CONTAINS[c] '\(keyword)'")
            }
            request.returnsObjectsAsFaults = false
            do {
                let result = try context.fetch(request)
                guard let objectList = result as? [NSManagedObject] else {
                    observer.onError(ServiceError(ErrorType.fetchDBError))
                    return Disposables.create()
                }
                var userFavoriteList: [UserFavoriteModel] = []
                if startIndex > objectList.count - 1 {
                    observer.onNext([])
                    return Disposables.create()
                }
                for index in startIndex...objectList.count - 1 {
                    print(index)
                    let data = objectList[index]
                    let userName = toString(data.value(forKey: "user") as? String)
                    let favoriteModel = UserFavoriteModel(
                        id: data.value(
                            forKey: "id") as? Int64 ?? 0,
                        name: userName
                    )
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
