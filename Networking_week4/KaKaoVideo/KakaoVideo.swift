
import Foundation

// MARK: - KakaoVideo
struct KakaoVideo: Codable {
    var documents: [Document]
}

// MARK: - Document
struct Document: Codable {
    let author: String
    let datetime: String
    let playTime: Int
    let thumbnail: String
    let title: String
    let link: String
    
    var contents: String {
        return "\(author) | \(playTime)회\n \(datetime)"
    }

    enum CodingKeys: String, CodingKey {
        case author, datetime
        case playTime = "play_time"
        case thumbnail, title
        case link = "url"
    }
}
