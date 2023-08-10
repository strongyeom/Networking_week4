//
//  PapagoViewController.swift
//  Networking_week4
//
//  Created by 염성필 on 2023/08/10.
//

import UIKit
import Alamofire
import SwiftyJSON

/*
 ["ko","en","ja","zh-CN","zh-TW","vi","id","th","de","ru","es","it","fr"],
 ["한국어", "영어", "일본어", "중국어 간체", "중국어 번체", "베트남어", "인도네시아어", "태국어", "독일어", "러시아어","스페인어", "이탈리아어","프랑스어"]]
 */

class PapagoViewController: UIViewController {
    
    
    @IBOutlet var sourcePicker: UIPickerView!
    @IBOutlet var targetPicker: UIPickerView!
    
    
    @IBOutlet var originalTextView: UITextView!
    
    @IBOutlet var requestBtn: UIButton!
    
    @IBOutlet var textVIewHeightConstainsts: NSLayoutConstraint!
    
    @IBOutlet var translateTextView: UITextView!
    
    @IBOutlet var cancelBtn: UIButton!
    
    let textViewMaxHeight : CGFloat = 60
    
    let textViewPlaceHolder: String = "통역 진행시켜! 영차!"
 
    var pickerList : [String:String] =  ["ko":"한국어","en":"영어","ja": "일본어","zh-CN":"중국어 간체","zh-TW":"중국어 번체","vi": "베트남어","id":"인도네시아어","th":"태국어","de":"독일어","ru":"러시아어","es":"스페인어","it": "이탈리아어","fr":"프랑스어"]
    
    var first: String = ""
    var second: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        translateTextView.text = ""
        settingCancelBtn()
        settingOriginalTextView()
        settingtranslateTextView()
        settingPicker()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        print("viewWillAppear")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
            let alert = UIAlertController(title: "언어를 선택해주세요", message: "원본언어 -> 목적언어", preferredStyle: .alert)
            let ok = UIAlertAction(title: "확인", style: .default)

            alert.addAction(ok)
            self.present(alert, animated: true)
        }
      
    }
    
    func settingPicker() {
        sourcePicker.delegate = self
        targetPicker.delegate = self
        sourcePicker.dataSource = self
        targetPicker.dataSource = self
    }
    
    @IBAction func tapGestureClicked(_ sender: UITapGestureRecognizer) {
        view.endEditing(true)
    }
    
    func settingCancelBtn() {
        cancelBtn.isHidden = true
        cancelBtn.isEnabled = false
    }
    
    
    func settingOriginalTextView() {
        
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
    
    func settingtranslateTextView() {
        translateTextView.font = .systemFont(ofSize: 20, weight: .medium)
        translateTextView.textAlignment = .center
        translateTextView.isEditable = false
    }
    
    func callRequest(sourceText: String, targetText: String) {
        translateTextView.text = ""
        let url = "https://openapi.naver.com/v1/papago/n2mt"
        let header: HTTPHeaders = [
            "X-Naver-Client-Id" : "myXCWsXxrg83Q4L0SAdP",
            "X-Naver-Client-Secret" : "2s8Jgd07Ij"
        ]
        
        let parameters: Parameters = [
            "source" : "\(sourceText)",
            "target" : "\(targetText)",
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
        callRequest(sourceText: first, targetText: second)
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


// MARK: - UIPickerViewDelegate
extension PapagoViewController: UIPickerViewDelegate {
    func pickerView(_ pickerView: UIPickerView, viewForRow row: Int, forComponent component: Int, reusing view: UIView?) -> UIView {

        let valueArray = pickerList.values.map { $0 }
        var label = UILabel()
        if let v = view as? UILabel { label = v }
        label.font = UIFont (name: "Helvetica Neue", size: 13)
        label.text =  valueArray[row]
        label.textAlignment = .center
        return label
    }
}


// MARK: - UIPickerViewDataSource
extension PapagoViewController: UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return pickerList.count
    }
    
//    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
//
//        let valueArray = pickerList.values.map { $0 }
//
//        return valueArray[row]
//    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        print("tag : \(pickerView.tag)")
        
        let keyArray = pickerList.keys.map { $0 }
        
        if pickerView.tag == 0 {
            first = keyArray[row]
        } else {
            second = keyArray[row]
        }
    }
}
