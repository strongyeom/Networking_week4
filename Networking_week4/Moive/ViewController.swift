//
//  ViewController.swift
//  Networking_week4
//
//  Created by 염성필 on 2023/08/07.
//

import UIKit
import Alamofire
import SwiftyJSON

struct Movie {
    var title: String
    var release: String
}

class ViewController: UIViewController {

    
    var movieList: [Movie] = []
    
    @IBOutlet var searchBar: UISearchBar!
    
    @IBOutlet var indicatorView: UIActivityIndicatorView!
    
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 60
        searchBar.delegate = self
        indicatorView.isHidden = true
    }

    func callRequest(date: String) {
        indicatorView.startAnimating()
        indicatorView.isHidden = false
        
        let url = "http://kobis.or.kr/kobisopenapi/webservice/rest/boxoffice/searchDailyBoxOfficeList.json?key=\(APIKey.boxOfficeKey)&targetDt=\(date)"
        
        // SwiftyJSON을 사용해서 Alamofire와 같이 활용해서 쉽게 데이터 통신을 할 수 있음
        // method: .get은 데이터를 읽어오는것
        // validate: 응답의 상태를 알려준다.
        AF.request(url, method: .get).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                // JSON에서 원하는 것에 도달하려면 차근차근(단계별로) 타고 내려가야함
//                let name1 = json["boxOfficeResult"]["dailyBoxOfficeList"][0]["movieNm"].stringValue
//                let name2 = json["boxOfficeResult"]["dailyBoxOfficeList"][1]["movieNm"].stringValue
//                let name3 = json["boxOfficeResult"]["dailyBoxOfficeList"][2]["movieNm"].stringValue
//
//                self.movieList.append(contentsOf: [name1, name2, name3])
//
                for item in json["boxOfficeResult"]["dailyBoxOfficeList"].arrayValue {
                    let movieNm = item["movieNm"].stringValue
                    let openDt = item["openDt"].stringValue
                    let data = Movie(title: movieNm, release: openDt)
                    self.movieList.append(data)
                }
                
//                for i in 0..<json["boxOfficeResult"]["dailyBoxOfficeList"].count {
//                    let movieNm = json["boxOfficeResult"]["dailyBoxOfficeList"][i]["movieNm"].stringValue
//                    self.movieList.append(movieNm)
//                }
                /*
                 error : "The request timed out."
                 네트워크 응답 시간 너무 길어진다면 네트워크 성공이라고 볼 수 없음
                 (타임 아웃 defaults 대략 60초)
                 => 타임 설정 가능 의도적으로 실패로 넘겨서 다시 시도 유도해 볼 수 있음
                
                 */
                self.indicatorView.stopAnimating()
                self.indicatorView.isHidden = true
                self.tableView.reloadData()
                
            case .failure(let error):
                print(error)
            }
        }
    }

}
extension ViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return movieList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "movieCell")!
        cell.textLabel?.text = movieList[indexPath.row].title
        cell.detailTextLabel?.text = movieList[indexPath.row].release
        return cell
    }
    
}

extension ViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        // 20220101 > 1. 8글자 2. 202232333 올바른 날짜 3. 날짜 범주
        callRequest(date: searchBar.text!)
        
        
        
        
    }
    
    
}
