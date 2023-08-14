//
//  KakaoAPIManager.swift
//  Networking_week4
//
//  Created by 염성필 on 2023/08/11.
//

import Foundation
import Alamofire
import SwiftyJSON

class KakaoAPIManager {
    
    static let shared = KakaoAPIManager()
    
    private init() { }
    
    // headers - 딕셔너리 형태 헤더 이름 키 값 넣으면 됌
    // 타입은 HTTPHeaders 맞춰야함
    let header: HTTPHeaders = ["Authorization": APIKey.kakaoKey]
    
    func callRequest(type: EndPoint, query: String, completionHandler: @escaping (JSON) -> () ) {
        
        // 한글에 대한 인식이 안되기 때문에 한글에 대한 처리를 해줘야함
        let text = query.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        
        
        let url = type.requestURL + text

        // 카카오는 .validate(statusCode: 200...500) : 실패 코드를 상세적으로 볼 수 있음
        
        AF
            .request(url, method: .get, headers: header)
            .validate(statusCode: 200...500)
            .responseJSON { response in
            
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(url)") // 여기서 끝남
                completionHandler(json)
               
            case .failure(let error):
                print(error)
            }
        }
        
    }
    
}
