//
//  NutritionStore.swift
//  Nutrition Analysis
//
//  Created by mohamed mahmoud helmy on 7/4/21.
//

import Foundation
import RxSwift

public class NutritionStore: NutritionService {

    public static let shared = NutritionStore()
    private init() {}
    private let appId = "8d38b5bb"
    private let appkey = "6bb2bc112eaa880fe77bc3abb986f521"
    private let baseAPIURL = "https://api.edamam.com/api"
    private let urlSession = URLSession.shared

    private let jsonDecoder: JSONDecoder = {
        let jsonDecoder = JSONDecoder()
        jsonDecoder.keyDecodingStrategy = .convertFromSnakeCase
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-mm-dd"
        jsonDecoder.dateDecodingStrategy = .formatted(dateFormatter)
        return jsonDecoder
    }()


    func fetchTotalNutrition(params: [String]) -> Observable<NutritionModel> {
        do {
            let urlComponents = URLComponents(string: "\(baseAPIURL)/nutrition-details?app_id=\(appId)&app_key=\(appkey)")
            let data = try JSONEncoder().encode(["ingr": params])

            return Observable.from(optional: urlComponents)
                .flatMap { Observable.from(optional: $0.url) }
                .flatMap { self.urlSession.dataTaskObservable(with: $0, and: data) }
                .flatMap { data in
                    Observable.deferred {
                        Observable.just(try self.jsonDecoder.decode(NutritionModel.self, from: data))
                    }
                }
        } catch {
            return Observable.error(NutritionError.serializationError)
        }
        
    }

    func fetchOneNutrition(param: String) -> Observable<NutritionModel> {
        let urlComponents = URLComponents(string: "\(baseAPIURL)/nutrition-data?app_id=\(appId)&app_key=\(appkey)&ingr=\(param.addingPercentEncoding(withAllowedCharacters: .alphanumerics)!)")

        return Observable.from(optional: urlComponents)
            .flatMap { Observable.from(optional: $0.url) }
            .flatMap { self.urlSession.dataTaskObservable(with: URLRequest(url: $0)) }
            .flatMap { data in
                Observable.deferred {
                    Observable.just(try self.jsonDecoder.decode(NutritionModel.self, from: data))
                }
            }

    }

}

extension URLSession {
    func dataTaskObservable(with request: URLRequest) -> Observable<Data> {
        return Observable.create { subscriber in
            let dataTask = self.dataTask(with: request) { (data, _, error) in
                if error != nil {
                    subscriber.onError(NutritionError.invalidResponse)
                    subscriber.onCompleted()
                    return
                }
                if let data = data {
                    subscriber.onNext(data)
                    subscriber.onCompleted()
                    return
                }
                subscriber.onError(NutritionError.noData)
                subscriber.onCompleted()
            }
            dataTask.resume()
            return Disposables.create {
                dataTask.cancel()
            }
        }
    }

    func dataTaskObservable(with url: URL, and data: Data) -> Observable<Data> {
        var urlRequest = URLRequest(url: url)
        urlRequest.httpBody = data
        urlRequest.addValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.httpMethod = "POST"
        return dataTaskObservable(with: urlRequest)
    }
}

