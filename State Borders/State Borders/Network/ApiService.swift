//
//  ApiService.swift
//  State Borders
//
//  Created by Niso on 10/16/19.
//  Copyright © 2019 Niso. All rights reserved.
//

import UIKit
import Alamofire

public enum ApiService: URLRequestConvertible {
    
    enum Constants {
        static let baseURLPath = "https://restcountries.eu/rest/v2"
    }
    
    case getAllStates
    case getStatesBorders(stateID: String)
    
    var method: HTTPMethod {
        switch self {
        case .getAllStates:
            return .get
        case .getStatesBorders:
            return .get
        }
    }
    
    var path: String {
        switch self {
        case .getAllStates:
            return "/all"
        case .getStatesBorders(let stateID):
            return "/alpha/\(stateID)"
        }
    }
    
    var parameters: [String: Any] {
        switch self {
        case .getAllStates:
            return ["include_docs": "true"]
        case .getStatesBorders:
            return ["include_docs": "true"]
        }
    }
    
    public func asURLRequest() throws -> URLRequest {
        let url = try Constants.baseURLPath.asURL()
        
        var request = URLRequest(url: url.appendingPathComponent(path))
        
        request.httpMethod = method.rawValue
        
        return try URLEncoding.default.encode(request, with: parameters)
    }
}
