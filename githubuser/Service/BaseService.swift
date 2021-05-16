import Foundation
import Moya
import RxSwift

class BaseService<Resp: Codable> {
    func translateResponse(result: Result<Response, MoyaError>) throws -> Resp {
        switch result {
        case .success(let resp):
            guard let jsonString = try? resp.mapString() else {
                throw ServiceError(.translateResponseFail)
            }
            if let data = jsonString.data(using: String.Encoding.utf8) {
                do {
                    let decoder = JSONDecoder()
                    let model = try decoder.decode(Resp.self, from: data)
                    return model
                } catch {
                    throw ServiceError(.translateResponseFail)
                }
            }
            throw ServiceError(.translateResponseFail)
        case .failure(let error):
            print(error.localizedDescription)
            throw ServiceError(.serviceFail)
        }
    }
}

public struct ServiceError: Error {
    var type: ErrorType
    init(_ type: ErrorType) {
        self.type = type
    }
}

public enum ErrorType: String {
    case serviceFail = "Can't connect service, please try again"
    case translateResponseFail = "Can't translate Response"
    case noData = "No data to display"
    case fetchDBError = "Can't fetch data from SQLite"
    case saveDBError = "Can't save data"
    case downloadImageError = "Can't download image data"
}
