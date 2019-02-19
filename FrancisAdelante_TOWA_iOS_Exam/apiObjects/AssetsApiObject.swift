//
//  AssetsApiObject.swift
//  FrancisAdelante_TOWA_iOS_Exam
//
//  Created by Francis Adelante on 2/15/19.
//  Copyright © 2019 Developer. All rights reserved.
//

import UIKit

class AssetsApiObject: BaseApiObject {
    func fetchAssets(completion: @escaping APICompletionHandler){
        let url = "https://private-d55d7f-codeexamapis.apiary-mock.com/sampleassets"
        
        apiRequest(endPoint: url) { (response, error) in
            
            var apiResponse = ApiResponse()
            
            guard error == nil else {
                apiResponse.apiStatus = APIStatus.apiError
                apiResponse.error = error
                completion(apiResponse)
                return
            }
            
            guard let responseObject = response as? [String: AnyObject] else {
                apiResponse.apiStatus = APIStatus.apiFail
                apiResponse.error = NSError.makeError(appErrorDomain: AppError.ParseError.code)
                completion(apiResponse)
                return
            }
            
            if let assets = responseObject["data"] as? [AnyObject] {
                
                for asset in assets {
                    guard let assetObject = asset as? [String: AnyObject] else {
                        continue
                    }
                    Asset.assetsObjectWithData(assetsData: assetObject)
                }
            }
            
            DataManager.shared.saveChanges()
            
            apiResponse.apiStatus = APIStatus.apiSuccess
            apiResponse.data = responseObject
            completion(apiResponse)
        }
    }

}
