//
//  ApiManager.swift
//  FrancisAdelante_TOWA_iOS_Exam
//
//  Created by Francis Adelante on 2/13/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit


enum APIStatus {
    case apiSuccess // ** Expected response parsed correctly.
    case apiFail // ** Backend framework error or invalid URL
    case apiError // ** Connection errors such as no internet, or connection timeout
    
}

struct ApiResponse {
    var apiStatus: APIStatus?
    var error: Error?
    var data: Any?
}

typealias InternalAPICompletionHandler = (_ responseObject: AnyObject?, _ error: Error?) -> Void
typealias APICompletionHandler = (_ apiResponse: ApiResponse) -> Void

class ApiManager: NSObject {
    
    static let shared = ApiManager()
    
    lazy var assets: AssetsApiObject = {
        return AssetsApiObject()
    }()

}
