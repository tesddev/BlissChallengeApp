//
//  NetworkManager.swift
//  MoyaTestProject
//
//  Created by TES on 31/07/2022.
//

import Foundation
import Moya

class NetworkManager {
    static let shared = NetworkManager()
    let provider = MoyaProvider<AppAPI>()
    
    func fetchEmojis(completion: @escaping (Result<Emojis, Error>) -> Void){
        provider.request(.emojis) { result in
            switch result {
            case .success(let response):
                do {
                    let results = try JSONDecoder().decode(Emojis.self, from: response.data)
                    completion(.success(results))
                } catch _ {
                    break
                }
                
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
    
    func fetchSearchedEmojis(username: String, completion: @escaping (EmojiSearchModel) -> (), errorCompletion: @escaping (APIError) -> ()){
        provider.request(.searchedEmojis(username: username)) { result in
            switch result {
            case .success(let response):
                do {
                    let results = try JSONDecoder().decode(EmojiSearchModel.self, from: response.data)
                    completion(results)
                } catch _ {
                    errorCompletion(.dataNotFound)
                }
                
            case .failure(_):
                break
            }
        }
    }
    
    func getAppleRepos(page: Int, size: Int, completion: @escaping(Result<AppleURL, Error>) -> Void){
        guard let url = URL(string: "https://api.github.com/users/apple/repos?page=\(page)&size=\(size)") else {return}
        
        
        let parameters: [String: Any] = [
            "page": page,
            "size": size
        ]
        var request = URLRequest(url: url)

        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        do {
            request.httpBody = try JSONSerialization.data(withJSONObject: parameters, options: .prettyPrinted)
        } catch _ {
            return
        }
        
        let task = URLSession.shared.dataTask(with: URLRequest(url: url)) { data, _, error in
            guard let data = data, error == nil else {return}
            
            do{
                let results = try JSONDecoder().decode(AppleURL.self, from: data)
                completion(.success(results))
            } catch {
                completion(.failure(APIError.failedToGetData))
            }
        }
        task.resume()
    }
    
    enum APIError: Swift.Error {
        case failedToGetData
        case dataNotFound
    }
}
