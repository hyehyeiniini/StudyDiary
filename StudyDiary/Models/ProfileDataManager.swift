//
//  ProfileDataManager.swift
//  StudyDiary
//
//  Created by Chris lee on 5/4/24.
//

import UIKit
import Alamofire

class ProfileDatagManager {
    
    // 첫 번째 element의 value로 노션 API로 발급받은 시크릿 키 사용
    let notionHeaders : HTTPHeaders = [HTTPHeader(name: "Authorization", value: "secret_8dnR0AsrTyr2hjX1y1Vyv3T2ag3nkVwC92cY0iec7iO"),
                                           HTTPHeader(name: "Notion-Version", value: "2022-06-28")]
        
    func getProfileArray(completion: @escaping ([Profile]?) -> Void) {
        notionRead { profiles in
            if let profiles = profiles {
                // API 요청 결과를 처리하는 코드
                completion(profiles)
            } else {
                // API 요청 실패 처리 코드
                print("API request failed.")
            }
        }
    }

    
    func notionRead(completion: @escaping ([Profile]?) -> ()) {
        AF.request("https://api.notion.com/v1/databases/603d2a899f4d402288b179c1f574af9c/query",
                   method: .post,
                   parameters: nil,
                   encoding: JSONEncoding.default, // 요청 본문을 json 형식으로 변환
                   headers: notionHeaders,
                   interceptor: nil,
                   requestModifier: nil).validate(statusCode: 200..<600).response { [weak self] response in
            
            switch response.result {
            case .success(let data): // 응답에 성공하면
                guard let data = data else { return } // data 변수에 응답 데이터 저장
                
                do {
                    guard let prettyJson = NSString(data: data, encoding: String.Encoding.utf8.rawValue) else { return }
                    // print("get Json : \(prettyJson)")
                    let parsedData = try JSONDecoder().decode(ProfileData.self, from: data) // 응답 데이터를 ProfileData(json -> quicktype.io로 변환한 구조체)로 디코드
                    let decodedData = self?.notionDataManufacturing(parsedData: parsedData)
                    completion(decodedData)
                } catch {
                    print("파싱 에러 : \(error)")
                    completion(nil)
                }
            case .failure(let error): // 응답에 실패하면
                print("응답 에러 : \(error)")
                completion(nil)
            }
            
        }
    }
    
    func notionDataManufacturing(parsedData: ProfileData) -> [Profile] {
        var profiles: [Profile] = []
        for result in parsedData.results {
            
            let imageUrlToStr = getNotionUrl(cover: result.cover)
            let name = getNotionText(richText: result.properties.name.title)
            let description = getNotionText(richText: result.properties.간단소개.richText)
            let mbti = getNotionTags(multiSelect:  result.properties.mbti.multiSelect)[0]
            let location = getNotionTags(multiSelect: result.properties.거주주활동지역.multiSelect)
            let interest = getNotionTags(multiSelect: result.properties.관심분야.multiSelect)
            let favorite = getNotionTags(multiSelect: result.properties.좋아하는것취미.multiSelect)
            
            let profile = Profile(imageUrlToStr: imageUrlToStr, coverImage: nil, name: name, description: description, mbti: mbti, location: location, interest: interest, favorite: favorite)
            
            profiles.append(profile)
        }
        return profiles
    }
      
    
    func getNotionUrl(cover: Cover) -> String {
        if let urlStr = cover.file?.url {
            return urlStr
        }
        if let urlStr = cover.external?.url {
            return urlStr
        }
        return ""
    }
    
    
    func getNotionText(richText: [Title]) -> String {
        if richText.isEmpty {
            return "";
        }
        return richText[0].text.content
    }
    
    func getNotionTags(multiSelect: [MultiSelect]) -> [String]{
        var tagArray: [String] = []
        if multiSelect.isEmpty {
            return tagArray
        }
        tagArray = multiSelect.map { $0.name }
        return tagArray
    }
}
