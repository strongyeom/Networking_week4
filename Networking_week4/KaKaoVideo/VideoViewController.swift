//
//  VideoViewController.swift
//  Networking_week4
//
//  Created by 염성필 on 2023/08/08.
//

import UIKit
import Alamofire
import SwiftyJSON
import Kingfisher

//struct Video {
//
//    let auhor: String
//    let dateTime: String
//    let playTime: Int
//    let thumnail: String
//    let title: String
//    let link: String
//
//    var contents: String {
//        return "\(auhor) | \(playTime)회\n \(dateTime)"
//    }
//}


class VideoViewController: UIViewController {
    
    var videoList: KakaoVideo = KakaoVideo(documents: [])
    
    var page: Int = 1
    var isEnd = false // 현재 페이지가 마지막 페이지인지 점검하는 프로퍼티
    @IBOutlet var searchBar: UISearchBar!
    @IBOutlet var tableView: UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 140
        tableView.prefetchDataSource = self
        searchBar.delegate = self
    }
    
    func callRequest(query: String, page: Int) {
//        KakaoAPIManager.shared.callRequest(type: .video, query: query) { json in
//            print("==== \(json)")
//        }
       
        KakaoAPIManager.shared.callRequest(type: .video, query: query, page: page) { result in
         
            
            guard let result else { return }
            print("result.documents",result.documents)
            self.videoList.documents.append(contentsOf: result.documents)
            self.tableView.reloadData()
        }
        
    }
    //        AF
    //            .request(url, method: .get, headers: header)
    //            .validate(statusCode: 200...500)
    //            .responseJSON { response in
    //
    //            switch response.result {
    //            case .success(let value):
    //                let json = JSON(value)
    //                print("JSON: \(url)")
    //
    //                // 상태 코드에 대한 정보
    //                print("response 상태 코드 : ", response.response?.statusCode)
    //
    //                // 상태 코드 확인
    //                let statusCode = response.response?.statusCode ?? 500
    //
    //
    //                // 상태에 따른 분기 처리
    //                if statusCode == 200 {
    //
    //                    // 마지막 페이지 인지 아닌지 확인
    //                    self.isEnd = json["meta"]["is_end"].boolValue
    //
    //                    for item in json["documents"].arrayValue {
    //
    //                        let auhor = item["author"].stringValue
    //                        let dateTime = item["datetime"].stringValue
    //                        let playTime = item["play_time"].intValue
    //                        let thumnail = item["thumbnail"].stringValue
    //                        let title = item["title"].stringValue
    //                        let link = item["url"].stringValue
    //
    //                        let data = Video(auhor: auhor, dateTime: dateTime, playTime: playTime, thumnail: thumnail, title: title, link: link)
    //
    //                        self.videoList.append(data)
    //                    }
    //                    print(self.videoList)
    //                    self.tableView.reloadData()
    //                } else {
    //                    print("문제가 발생, 잠시 후 다시 시도해주세요")
    //                }
    //
    //
    //
    //            case .failure(let error):
    //                print(error)
    //            }
    //        }
    
}
extension VideoViewController: UISearchBarDelegate {
    
    // ‼️ 네트워크시 실시간 호출 보다는 return키를 활용해서 서버 통신
    
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        
        // page 초기화시켜서 다른 검색어를 입력했을때 페이지 1부터 나올 수 있도록 설정
        page = 1
         self.videoList.documents.removeAll()
        
        guard let query = searchBar.text else { return }
        
        callRequest(query: query, page: page)
        
    }
}

 // UITableViewDataSourcePrefetching: iOS 10이상 사용가능한 프로토콜 -  cellForRowAt 메서드가 호출되기 전에 미리 호출 됨
extension VideoViewController: UITableViewDelegate, UITableViewDataSource, UITableViewDataSourcePrefetching {
    /*
     cellForRowAt은 사용자의 눈에 보일때 실행
     
     cellForRowAt 호출 되기 전에 미리 호출 되는 메서드 - 용량이 큰 데이터나 사진을 보여 주고 싶을 때 미리 다운로드 받을 수 있음
     
     */
    
    // 셀이 화면에 보이기 직전에 필요한 리소스를 미리 다운 받는 기능
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
       
      //  guard let videoList = videoList else { return }
        
        for indexPath in indexPaths {
            // 배열의 갯수와 indexPath.row 같아 졌을때(0부터 시작) 실행
            // page : 카카오 같은 경우에는 페이지 제한이 있음
            // isEnd : 마지막 페이지 인지 아닌지
            print("prefetchRowsAt \(videoList.documents.count - 1), row: \(indexPath.row) page: \(page)")
            dump(videoList.documents)
            print("prefetchRowsAt - documents 갯수: \(videoList.documents.count)")
            if videoList.documents.count - 1 == indexPath.row && page < 15 && isEnd == false {
                // 페이지 증가
                page += 1
                // 증가된 페이지 매개변수로 넣어서 다시 서칭
                callRequest(query: searchBar.text!, page: page)
            }
        }
    }
    
    // 빠르게 스크롤시 다운로드 받고 있는 상황일때 다운로드 취소하는 메서드
    // 취소 기능 : 직접 취소하는 기능을 구현해주어야함
    func tableView(_ tableView: UITableView, cancelPrefetchingForRowsAt indexPaths: [IndexPath]) {
        
        print("======== 취소 : \(indexPaths)")
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       // guard let videoList else { return 0 }
        print("videoList.documents.count",videoList.documents.count)
        return videoList.documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: VideoTableViewCell.identifier, for: indexPath) as? VideoTableViewCell else { return UITableViewCell() }
       //  guard let videoList else { return UITableViewCell() }
        let row = videoList.documents[indexPath.row]
        cell.videoname.text = row.title
        cell.playtime.text = row.contents
        
        if let url = URL(string: row.thumbnail) {
            cell.videoImage.kf.setImage(with: url)
        }
        
        return cell
    }
}
