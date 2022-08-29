//
//  FavoriteCurrencyExt.swift
//  Currency Calculator
//
//  Created by Давид Тоноян  on 27.08.2022.
//

import UIKit

extension FavoritesViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        favoriteCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let favCurrency = favoriteCurrencies[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: "favCurrency")
        
        cell?.textLabel?.text = favCurrency.charCode
        cell?.detailTextLabel?.text = "\(favCurrency.nominal) " + favCurrency.name
        
        return cell ?? UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        true
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let favCurrency = favoriteCurrencies[indexPath.row]
        Persistance.shared.realmDelete(favCurrency)
        favoriteCurrencies.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
}
