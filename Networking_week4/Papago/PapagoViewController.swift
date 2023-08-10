//
//  PapagoViewController.swift
//  Networking_week4
//
//  Created by 염성필 on 2023/08/10.
//

import UIKit
import Alamofire
import SwiftyJSON


class PapagoViewController: UIViewController {
    
    @IBOutlet var originalTextView: UITextView!
    
    @IBOutlet var requestBtn: UIButton!
    
    @IBOutlet var textVIewHeightConstainsts: NSLayoutConstraint!
    
    @IBOutlet var translateTextView: UITextView!
    
    @IBOutlet var cancelBtn: UIButton!
    
    let textViewMaxHeight : CGFloat = 60
    
    let textViewPlaceHolder: String = "통역 진행시켜! 영차!"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        translateTextView.text = ""
        settingCancelBtn()
        settingOriginalTextView()
        translateTextView.isEditable = false
        callRequest()
    }
    
    @IBAction func tapGestureClicked(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func settingCancelBtn() {
        cancelBtn.isHidden = true
        cancelBtn.isEnabled = false
    }
    
    
    func settingOriginalTextView() {
        
        originalTextView.text = ""
        originalTextView.layer.borderColor = UIColor.lightGray.cgColor
        originalTextView.layer.borderWidth = 1
        originalTextView.delegate = self
        originalTextView.font = .systemFont(ofSize: 15)
        originalTextView.text = textViewPlaceHolder
        originalTextView.textColor = .lightGray
        originalTextView.keyboardType = .webSearch
        
        
        originalTextView.isScrollEnabled = false
        originalTextView.sizeToFit()
        
    }
    
    func callRequest() {
        translateTextView.text = ""
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : "myXCWsXxrg83Q4L0SAdP",
            "X-Naver-Client-Secret" : "2s8Jgd07Ij"
        ]
        
        let parameters: Parameters = [
            "source" : "ko",
            "target" : "en",
            "text": originalTextView.text ?? ""
        ]
        
        
        AF.request(url, method: .post, parameters: parameters, headers: header).validate().responseJSON { response in
            switch response.result {
            case .success(let value):
                let json = JSON(value)
                print("JSON: \(json)")
                
                let tranlslateText = json["message"]["result"]["translatedText"].stringValue
                
                self.translateTextView.text = tranlslateText
                
            case .failure(let error):
                print(error)
            }
        }
    }
    
}

// MARK: - UITextViewDelegate
extension PapagoViewController: UITextViewDelegate {
    
    
    
    func textViewDidChange(_ textView: UITextView) {
       
        if originalTextView.contentSize.height > textViewMaxHeight {
            // print("텍스트 뷰가 👉넘어감")
            self.textVIewHeightConstainsts.constant = textViewMaxHeight}
           // self.view.layoutIfNeeded()
//        } else {
//            let newSize = originalTextView.sizeThatFits(originalTextView.frame.size)
//
//            textVIewHeightConstainsts.constant =  newSize.height
//
//            // 조건 이유 - 계속 bottomStackConstant 값이 newSize.height으로 변경되서 UI 망가짐
//            if textVIewHeightConstainsts.constant < 60 {
//                textVIewHeightConstainsts.constant = 60
//            }
//           // self.view.layoutIfNeeded()
//        }
    }
   
    // 텍스트 필드 플레이스 홀더
    // 텍스트 필드에 커서가 시작됐을 때
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.text == textViewPlaceHolder {
            textView.text = ""
            textView.textColor = .black
            cancelBtn.isHidden = false
            cancelBtn.isEnabled = true
        }
    }
    // 텍스트 필드에 커서가 없어졌을 때
    func textViewDidEndEditing(_ textView: UITextView) {
        textView.text = textViewPlaceHolder
        textView.textColor = .lightGray
    }
}
