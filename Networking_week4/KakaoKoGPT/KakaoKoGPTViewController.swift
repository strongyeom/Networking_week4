//
//  KakaoKoGPTViewController.swift
//  Networking_week4
//
//  Created by 염성필 on 2023/08/10.
//

import UIKit
import Alamofire
import SwiftyJSON



class KakaoKoGPTViewController: UIViewController {

    @IBOutlet var requestTextView: UITextView!
    
    @IBOutlet var messageBtn: UIButton!
    
    @IBOutlet var koGPTTextView: UITextView!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        requestTextView.layer.borderColor = UIColor.blue.cgColor
        requestTextView.layer.borderWidth = 1
        
        koGPTTextView.layer.borderColor = UIColor.red.cgColor
        koGPTTextView.layer.borderWidth = 1
        
    }
    @IBAction func messageKoGPTBtnClicked(_ sender: UIButton) {
        callRequest()
    }
    
    func callRequest() {
        
        koGPTTextView.text = ""
        
        
        let url = "https://api.kakaobrain.com/v1/inference/kogpt/generation"
        
        let header: HTTPHeaders = [
            "Authorization": "KakaoAK 4c942e12e007634357d2bd5a3da08341",
            "Content-Type": "application/json"
        ]
        
        
        struct Parameter: Encodable {
            let prompt: String
            let max_tokens: Int
        }
        let parameter = Parameter(prompt: requestTextView.text ?? "오늘 날씨는", max_tokens: 120)
  
        AF.request(url, method: .post, parameters: parameter, encoder: JSONParameterEncoder.default, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                let answerGPT = json["generations"][0]["text"].stringValue
                
                self.koGPTTextView.text = answerGPT
            case .failure(let error):
                print(error)
            }
        }
    }

}
