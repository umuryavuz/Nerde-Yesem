//
//  NetworkService.swift
//  Nerde Yesem
//
//  Created by umur yavuz on 28.06.2019.
//  Copyright © 2019 umur yavuz. All rights reserved.
//

import Foundation
import Moya

//#error("Enter a Yelp API key by visiting yelp.com/developers then delete this error.")
private let apiKey = "3mdS8O4anjkZeuxsemxOgrKM9vpiXUA_HJ3e2G9UTcd0mkQ3svuGQIU-z3iisyPncVCLqT5ZeqMlW7tCU_MzIQgb1KDaEB-HLyFw1_x697UcdovkjRFCdbjzrwAWXXYx"

enum YelpService {
    enum BusinessesProvider: TargetType {
        case search(lat: Double, long: Double)
        case details(id: String)
        
        var baseURL: URL {
            return URL(string: "https://api.yelp.com/v3/businesses")!
        }
        
        var path: String {
            switch self {
            case .search:
                return "/search"
            case let .details(id):
                return "/\(id)"
            }
        }
        
        var method: Moya.Method {
            return .get
        }
        
        var sampleData: Data {
            return Data()
        }
        
        var task: Task {
            switch self {
            case let .search(lat, long):
                return .requestParameters(
                    parameters: ["latitude": lat, "longitude": long, "limit": 15], encoding: URLEncoding.queryString)
            case .details:
                return .requestPlain
            }
            
        }
        
        var headers: [String : String]? {
            return ["Authorization": "Bearer \(apiKey)"]
        }
    }
}
