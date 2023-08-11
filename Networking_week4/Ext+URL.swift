//
//  Ext+URL.swift
//  Networking_week4
//
//  Created by 염성필 on 2023/08/11.
//

import Foundation

extension URL {
    static let  baseURL = "https://dapi.kakao.com/v2/search/"
    
    static func makeEndPointString(_ endPoint: String) -> String {
        return baseURL + endPoint
    }
}
