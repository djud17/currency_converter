//
//  File.swift
//  Currency Calculator
//
//  Created by Давид Тоноян  on 27.08.2022.
//

import RealmSwift

final class Persistance {
    static let shared = Persistance()
    let realm = try! Realm()
    
    func realmWrite(_ currency: Any) {
        try! realm.write{
            realm.add(currency as! Object)
        }
    }
    
    func realmDelete(_ currency: FavoriteCurrency) {
        try! realm.write{
            realm.delete(currency)
        }
    }
    
    func realmRead() -> Results<FavoriteCurrency>? {
        let array = realm.objects(FavoriteCurrency.self)
        return array
    }
    
    func checkPersistance(_ currency: Currrency) -> Bool {
        var addedToFav: Bool = false
        
        if let favCurrencies = realmRead() {
            for favCurrency in favCurrencies where favCurrency.numCode == currency.numCode {
                addedToFav = true
                break
            }
        }
        
        return addedToFav
    }
}
