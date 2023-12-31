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
    
    //@escaping : callRequest -> Alamofire -> global.async -> 함수 종료 이후에 매개변수를 실행시키고 싶다 / 없으면 함수가 종료됨에따라 클로저도 같이 종료된다.
    func callRequest(sourceText: String, targetText: String, text: String, resultString: @escaping (Papago?) -> () ) {
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
        print("first: \(sourceText), second: \(targetText)")
        
        AF.request(url, method: .post, parameters: parameters, headers: header).validate(statusCode: 200...500)
            .responseDecodable(of:Papago.self) { result in
                resultString(result.value)
            }
        
    }
}
