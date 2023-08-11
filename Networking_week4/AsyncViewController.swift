//
//  AsyncViewController.swift
//  Networking_week4
//
//  Created by 염성필 on 2023/08/11.
//

import UIKit

class AsyncViewController: UIViewController {
    
    @IBOutlet var first: UIImageView!
    @IBOutlet var second: UIImageView!
    @IBOutlet var third: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        // 비율로 잡을 경우 비율 타이밍 보다 스토리보드 기반으로 먼저 이뤄지기때문에 완벽한 원으로 나타나지 않는다.
//        first.layer.cornerRadius = first.frame.width / 2
//
        
        // 타이밍 계산: 비율로 그려줄때는 메인 쓰레드에서 진행
        // 가장 마지막에 실행됨
        DispatchQueue.main.async {
        self.first.layer.cornerRadius = self.first.frame.width / 2
        }
        first.clipsToBounds = true
        first.contentMode = .scaleToFill
    }
    
    // sync(동기) async(비동기) serial(직렬) concurrent(동시)
    // UI Freezing: 용량이 큰 데이터를 받을때 아무것도 하지 못하는 상황
    
    
    @IBAction func downloadBtnClicked(_ sender: UIButton) {
        
        
        // 오픈소스 사용 하지 않고 URLImage 사용
        //  Data 타입으로 변환
        let url = URL(string: "https://api.nasa.gov/assets/img/general/apod.jpg")!
        
        // 작업이 클때는 global().async에서 작업한다.
        DispatchQueue.global().async {
        let data = try! Data(contentsOf: url)
                
            // UI 업데이트는 main.async에서만 작업한다.
            DispatchQueue.main.async {
                
                self.first.image = UIImage(data: data)
            }
        }
        
        
    
        
       
    }
    
}
