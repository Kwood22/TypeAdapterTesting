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
            "Content-type": "application/json", "x-rapidapi-host": "contractdetails.p.rapidapi.com", "x-rapidapi-key": "c85041cdb3msh0dd1fbea0b44d29p1ec983jsn391cb2d9243a", "X-RapidAPI-Proxy-Secret": "8b5b0950-a574-11ea-81b1-d32e6e935253"
        ]

        AF.request("https://contractdetails.p.rapidapi.com/contract", headers: headers).responseDecodable(of: ProductDetail.Contract.self) { response in
            debugPrint(response)
            switch response.result {
            case .success(let contract):
                let productID: Int  = (contract.tables.first?.cards.first as? ProductDetail.BankTableCard)?.data.productId ?? -1
                self.DisplayLabel.text = "\(productID)"
            case .failure:
                print("Error")
            }
        }

        AF.request("https://contractdetails.p.rapidapi.com/contract", headers: headers).responseJSON { response in
            debugPrint(response)
        }
    }


}

protocol TableCard: Codable {
    var heading: String {get}
    var type: ProductDetail.TableType {get}
    var details: [ProductDetail.TableDetail] {get}
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

    public enum TableType: String, Codable, Equatable {
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
        var cards: [TableCard]

        private enum CodingKeys: String, CodingKey {
            case heading, cards
        }

        enum TablesTypeKey: CodingKey {
            case type
        }

        init(from decoder: Decoder) throws {
            let values = try decoder.container(keyedBy: CodingKeys.self)
            heading = try values.decode(String.self, forKey: .heading)

            var cardsArrayForType = try values.nestedUnkeyedContainer(forKey: .cards)
            var cards = [TableCard]()
            var unDecodedCardArray = cardsArrayForType

            while(!cardsArrayForType.isAtEnd) {
                let unDecodedCard = try cardsArrayForType.nestedContainer(keyedBy: TablesTypeKey.self)
                let type = try unDecodedCard.decode(ProductDetail.TableType.self, forKey: TablesTypeKey.type)
                switch type {
                case .bankDetail:
                    cards.append(try unDecodedCardArray.decode(BankTableCard.self))
                case .beneficary:
                    cards.append(try unDecodedCardArray.decode(BeneficiaryTableCard.self))
                }
            }
            self.cards = cards
        }

        func encode(to encoder: Encoder) throws {
        }
    }

    class BankTableCard: TableCard {
        var heading: String
        var type: ProductDetail.TableType
        var details: [ProductDetail.TableDetail]
        let data: BankMetaData
    }

    class BeneficiaryTableCard: TableCard {
        let data: BenaficaryMetaData
        var heading: String
        var type: ProductDetail.TableType
        var details: [ProductDetail.TableDetail]
    }

    struct BankMetaData: Codable {
        let productId: Int
        let contractId: Int
        let bankCode: Int
    }

    struct BenaficaryMetaData: Codable {
        let contractStartDay: String
        let contractDurationYears: Int
        let contractEmergencyContactNumber: String
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
