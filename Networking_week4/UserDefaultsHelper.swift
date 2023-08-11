//
//  UserDefaultsHelper.swift
//  Networking_week4
//
//  Created by 염성필 on 2023/08/11.
//

import Foundation


class UserDefaultsHelper {
    // 모든 VC에서 인스턴스를 만들 필요가 없고 한군데서 사용할 수있도록 static 사용
    static let standard = UserDefaultsHelper() // 싱글톤 패턴
    // 외부에서 초기화에 접근 할 수 없게 제한하는 접근 제어자
    private init() { }
    let userDefaults = UserDefaults.standard
    // UserDefaultsHelper 파일내에서 한정적으로 사용할때 클래스,구조체 안에서 셋팅 -> 처리 할 수 있는 시간 (컴파일 시간) 자체가 줄어듬 => 컴파일 최적화
    
    enum Key: String {
        case nickname, age
    }
    
    var nickname: String {
        get {
            return userDefaults.string(forKey: Key.nickname.rawValue) ?? "대장"
        }
        set {
            userDefaults.set(newValue, forKey: Key.nickname.rawValue)
        }
    }
    
    var age: Int {
        get {
            return userDefaults.integer(forKey: Key.age.rawValue)
        }
        set {
            return userDefaults.set(newValue, forKey: Key.age.rawValue)
        }
    }
    
}
