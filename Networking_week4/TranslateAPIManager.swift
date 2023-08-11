//
//  TranslateAPIManager.swift
//  Networking_week4
//
//  Created by 염성필 on 2023/08/11.
//

import Foundation
import Alamofire
import SwiftyJSON

class TranslateAPIManager {
    static let shared = TranslateAPIManager()
    
    private init() { }
    
    func callRequest(sourceText: String, targetText: String, text: String, resultString: @escaping (String) -> () ) {
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : "myXCWsXxrg83Q4L0SAdP",
            "X-Naver-Client-Secret" : "2s8Jgd07Ij"
        ]
        
        let parameters: Parameters = [
            "source" : "\(sourceText)",
            "target" : "\(targetText)",
            "text": text
        ]
        
        AF.request(url, method: .post, parameters: parameters, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let tranlslateText = json["message"]["result"]["translatedText"].stringValue
                
                resultString(tranlslateText)
            case .failure(let error):
                print(error)
            }
        }
        
    }
}
