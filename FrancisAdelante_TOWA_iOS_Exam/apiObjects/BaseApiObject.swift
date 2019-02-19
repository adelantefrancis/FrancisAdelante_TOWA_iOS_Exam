//
//  BaseApiObject.swift
//  FrancisAdelante_TOWA_iOS_Exam
//
//  Created by Francis Adelante on 2/13/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

public enum HTTPMethod: String {
    case options = "OPTIONS"
    case get     = "GET"
    case head    = "HEAD"
    case post    = "POST"
    case put     = "PUT"
    case patch   = "PATCH"
    case delete  = "DELETE"
    case trace   = "TRACE"
    case connect = "CONNECT"
}

struct AppError {
    
    static let domain = "com.domandtom.opinionShield.error"
    
    struct UnknownError {
        static let code = 101
        static let message = "Unknown error occured"
    }
    
    struct ParseError {
        static let code = 102
        static let message = "There was an error parsing the JSON file."
    }
    
    struct DataManagerFetchFail {
        static let code = 103
        static let message = "The DataManager failed to fetch the object"
    }
    
}


class BaseApiObject: NSObject {
    func apiRequest(endPoint: String,
                    method: HTTPMethod = .get,
                    completion: @escaping InternalAPICompletionHandler) {
        
        let request = URLRequest(url: URL(string: endPoint)!)
        
        let session = URLSession.shared
        
        let task = session.dataTask(with: request, completionHandler: {data, response, error -> Void in
            
            if let data = data {
                let json = try? JSONSerialization.jsonObject(with: data, options: [])
                if let response = response as? HTTPURLResponse , 200...299 ~= response.statusCode {
                    completion(json as AnyObject, error)
                } else {
                    completion(json as AnyObject, error)
                }
            }
        })
        task.resume()
    }
    
}
