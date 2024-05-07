// This file was generated from JSON Schema using quicktype, do not modify it directly.
// To parse the JSON, add this file to your project and do:
//
//   let welcome = try? JSONDecoder().decode(ProfileData.self, from: jsonData)

import UIKit

// 실제 사용하려는 구조체
struct Profile {
    var imageUrlToStr: String
    var coverImage: UIImage?
    let name: String
    let description: String
    let mbti: String
    let location: [String]
    let interest: [String]
    let favorite: [String]
}

extension Profile {
    static let basicImage = "https://www.notion.so/images/page-cover/solid_yellow.png"
}

//============(json으로 가져오는 노션 데이터)=====================================================

// MARK: - Welcome⭐️
struct ProfileData: Codable {
    let object: String
    let results: [Result] // ⭐️
    let nextCursor: JSONNull?
    let hasMore: Bool
    let type: String
    let pageOrDatabase: PageOrDatabase
    // let developerSurvey: String
    let requestID: String

    enum CodingKeys: String, CodingKey {
        case object, results
        case nextCursor = "next_cursor"
        case hasMore = "has_more"
        case type
        case pageOrDatabase = "page_or_database"
        // case developerSurvey = "developer_survey"
        case requestID = "request_id"
    }
}

// MARK: - PageOrDatabase
struct PageOrDatabase: Codable {
}

// MARK: - Result⭐️
struct Result: Codable {
    let object, id, createdTime, lastEditedTime: String
    let createdBy, lastEditedBy: TedBy
    let cover: Cover
    let icon: Icon?
    let parent: Parent
    let archived, inTrash: Bool
    let properties: Properties // ⭐️
    let url, publicURL: String

    enum CodingKeys: String, CodingKey {
        case object, id
        case createdTime = "created_time"
        case lastEditedTime = "last_edited_time"
        case createdBy = "created_by"
        case lastEditedBy = "last_edited_by"
        case cover, icon, parent, archived
        case inTrash = "in_trash"
        case properties, url
        case publicURL = "public_url"
    }
}

// MARK: - Cover
struct Cover: Codable {
    let type: String
    let file: File?
    let external: External?
}

// MARK: - External
struct External: Codable {
    let url: String
}

// MARK: - File
struct File: Codable {
    let url: String
    let expiryTime: String

    enum CodingKeys: String, CodingKey {
        case url
        case expiryTime = "expiry_time"
    }
}

// MARK: - TedBy
struct TedBy: Codable {
    let object: Object
    let id: String
}

enum Object: String, Codable {
    case user = "user"
}

// MARK: - Icon
struct Icon: Codable {
    let type, emoji: String
}

// MARK: - Parent
struct Parent: Codable {
    let type, databaseID: String

    enum CodingKeys: String, CodingKey {
        case type
        case databaseID = "database_id"
    }
}

// MARK: - Properties⭐️
struct Properties: Codable {
    let mbti: Tags
    let 간단소개: 간단소개
    let github, blog: Blog
    let 관심분야, 좋아하는것취미, 거주주활동지역: Tags
    let name: Name

    enum CodingKeys: String, CodingKey {
        case mbti = "MBTI"
        case 간단소개 = "간단 소개"
        case github, blog
        case 관심분야 = "관심 분야"
        case 좋아하는것취미 = "좋아하는 것 / 취미"
        case 거주주활동지역 = "거주 / 주 활동 지역"
        case name = "Name"
    }
}

// MARK: - Blog
struct Blog: Codable {
    let id: BlogID
    let type: BlogType
    let url: String?
}

enum BlogID: String, Codable {
    case gevo = "GEVO"
    case ux7DN = "UX%7Dn"
}

enum BlogType: String, Codable {
    case url = "url"
}

// MARK: - Tags
struct Tags: Codable {
    let id: TagID
    let type: TagType
    let multiSelect: [MultiSelect]

    enum CodingKeys: String, CodingKey {
        case id, type
        case multiSelect = "multi_select"
    }
}

enum TagID: String, Codable {
    case eNLP = "ENlp"
    case sWCN = "sWCN"
    case the7Bn3Cx = "%7BN%3CX"
    case weBv = "WeBv"
}

// MARK: - MultiSelect
struct MultiSelect: Codable {
    let id, name, color: String // ⭐️ name: 원하는 tag의 이름
}

enum TagType: String, Codable {
    case multiSelect = "multi_select"
}

// MARK: - Name
struct Name: Codable {
    let id, type: String
    let title: [Title]
}

// MARK: - Title
struct Title: Codable {
    let type: TitleType
    let text: Text
    let annotations: Annotations
    let plainText: String
    let href: JSONNull?

    enum CodingKeys: String, CodingKey {
        case type, text, annotations
        case plainText = "plain_text"
        case href
    }
}

// MARK: - Annotations
struct Annotations: Codable {
    let bold, italic, strikethrough, underline: Bool
    let code: Bool
    let color: Color
}

enum Color: String, Codable {
    case colorDefault = "default"
}

// MARK: - Text
struct Text: Codable {
    let content: String
    let link: JSONNull?
}

enum TitleType: String, Codable {
    case text = "text"
}

// MARK: - 간단소개
struct 간단소개: Codable {
    let id, type: String
    let richText: [Title]

    enum CodingKeys: String, CodingKey {
        case id, type
        case richText = "rich_text"
    }
}

// MARK: - Encode/decode helpers

class JSONNull: Codable, Hashable {

    public static func == (lhs: JSONNull, rhs: JSONNull) -> Bool {
        return true
    }

    public func hash(into hasher: inout Hasher) {
        hasher.combine(0)
    }

    public init() {}

    public required init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        if !container.decodeNil() {
            throw DecodingError.typeMismatch(JSONNull.self, DecodingError.Context(codingPath: decoder.codingPath, debugDescription: "Wrong type for JSONNull"))
        }
    }

    public func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encodeNil()
    }
}
