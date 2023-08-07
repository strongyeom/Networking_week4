//
//  ViewController.swift
//  Networking_week4
//
//  Created by 염성필 on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        callRequest()
    }

    func callRequest() {
        
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOfficeKey)&targetDt=20031111"
        
        // SwiftyJSON을 사용해서 Alamofire와 같이 활용해서 쉽게 데이터 통신을 할 수 있음
        // method: .get은 데이터를 읽어오는것
        // validate: 응답의 상태를 알려준다.
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                // JSON에서 원하는 것에 도달하려면 차근차근(단계별로) 타고 내려가야함
                let name = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
                print("name", name)
                
                
                
            case .failure(let error):
                print(error)
            }
        }
    }

}

