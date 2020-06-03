//
//  ViewController.swift
//  Test
//
//  Created by Kyle Wood on 2020/06/03.
//  Copyright © 2020 Kyle Wood. All rights reserved.
//

import UIKit
import Alamofire
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    @IBOutlet weak var DisplayLabel: UILabel!
    private let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        let headers: HTTPHeaders = [
            "Content-type": "application/json","x-rapidapi-host": "contractdetails.p.rapidapi.com","x-rapidapi-key": "c85041cdb3msh0dd1fbea0b44d29p1ec983jsn391cb2d9243a","X-RapidAPI-Proxy-Secret": "8b5b0950-a574-11ea-81b1-d32e6e935253"
        ]

        AF.request("https://contractdetails.p.rapidapi.com/contract", headers: headers).responseDecodable(of: ProductDetail.Contract.self) { response in
            debugPrint(response)
        }
        
        AF.request("https://contractdetails.p.rapidapi.com/contract", headers: headers).responseJSON { response in
            debugPrint(response)
        }
    }


}

public enum ProductDetail {
// Everything here is contained inside this enum to namespace things a little better purely because of name clashes on
// some other models we have. I'm weary of just using those models because looking at the changes for the Orchestrator
// all models are redefined and not reused. Reusing the models we have currently wil also mean we might be introducing
// bugs and I'm just trying to prevent this.

    public enum Value: String, Codable {
        case active = "ACTIVE"
        case inactive = "INACTIVE"
        case paidUp = "PAID_UP"
    }
    
    public enum TableType: String, Codable {
        case bankDetail = "BANK_DETAILS"
        case beneficary = "BENEFICIARY"
    }

    struct Contract: Codable {
        let tables: [TableSection]
        let lists: [ListSection]
        let funds: [TableSection]
    }


    struct Detail: Codable {
        let value: String
        let description: String
    }

    struct TableSection: Codable {
        let heading: String?
        let cards: [TableCard]
    }

    struct TableCard: Codable {
        let headings: [String]
        let type: TableType
        let details: [TableDetail]
    }

    struct TableDetail: Codable {
        var columnOne: Detail
        var columnTwo: Detail
        var value: String
        var description: String
    }

    struct ListSection: Codable {
        let heading: String?
        let cards: [ListCard]
    }

    struct ListCard: Codable {
        let heading: String?
        let details: [Detail]

        init(heading: String? = nil, details: [Detail]) {
            self.heading = heading
            self.details = details
        }
    }

    struct BankingDetails {
        let bankName: String
        let accountType: String?
        let accountNumber: String?
        let debitDay: String?
    }
}
