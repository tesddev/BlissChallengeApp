//
//  AppAPI.swift
//  MoyaTestProject
//
//  Created by GIGL iOS on 30/07/2022.
//

import Foundation
import Moya

enum AppAPI {
    case emojis
    case searchedEmojis(username: String)
    case appleRepos(page: Int, size: Int)
}

extension AppAPI: TargetType {
    var baseURL: URL {
        return URL(string: "https://api.github.com")!
    }
        
    var path: String {
        switch self {
        case .emojis: return "/emojis"
        case .searchedEmojis(username: let username):
            return "/users/\(username)"
        case .appleRepos(page: let page, size: let size):
            return "/users/:username/repos?page=\(page)&size=\(size)"
        }
    }
    
    var method: Moya.Method {
        return .get
    }
    
    var task: Task {
        switch self {
        case .emojis:
            return .requestPlain
            
        case .searchedEmojis(username: let username):
            return .requestParameters(parameters: ["username": username],
                                      encoding: URLEncoding.default)
            
        case .appleRepos(page: let page, size: let size):
            return .requestParameters(parameters: [
                                                   "username": "apple",
                                                   "page": page,
                                                   "size": size],
                                      encoding: URLEncoding.default)
        }
    }
    
    var headers: [String : String]? {
        return ["Content-Type": "application/json"]
    }
}
