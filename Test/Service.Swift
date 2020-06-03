//
//  Service.Swift
//  Test
//
//  Created by Kyle Wood on 2020/06/03.
//  Copyright © 2020 Kyle Wood. All rights reserved.
//

import Foundation
import Moya

enum Service {
    case contractDetails
}

extension Service: TargetType {
    var sampleData: Data {
        Data()
    }
    
    var baseURL: URL { return URL(string: "https://contractdetails.p.rapidapi.com")! }
    var path: String {
        switch self {
        case .contractDetails:
            return "/contract"
        }
    }
    var method: Moya.Method {
        switch self {
        case .contractDetails:
            return .get
        }
    }
    var task: Task {
        switch self {
        case .contractDetails: // Send no parameters
            return .requestPlain
        }
    }
    
    var headers: [String: String]? {
        [
            "Content-type": "application/json",
            "x-rapidapi-host": "contractdetails.p.rapidapi.com",
            "x-rapidapi-key": "c85041cdb3msh0dd1fbea0b44d29p1ec983jsn391cb2d9243a",
            "X-RapidAPI-Proxy-Secret": "8b5b0950-a574-11ea-81b1-d32e6e935253",
        ]
    }
}
// MARK: - Helpers
private extension String {
    var urlEscaped: String {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
    }

    var utf8Encoded: Data {
        return data(using: .utf8)!
    }
}
