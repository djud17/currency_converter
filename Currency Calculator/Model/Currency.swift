//
//  Currency.swift
//  Currency Calculator
//
//  Created by Давид Тоноян  on 27.08.2022.
//

import RealmSwift

struct Currrency {
    let numCode: String
    let charCode: String
    let name: String
    let value: String
    let nominal: String
}

final class FavoriteCurrency: Object {
    @objc dynamic var numCode: String = ""
    @objc dynamic var charCode: String = ""
    @objc dynamic var name: String = ""
    @objc dynamic var value: String = ""
    @objc dynamic var nominal: String = ""
}
