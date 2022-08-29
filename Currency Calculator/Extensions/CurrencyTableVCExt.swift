//
//  ApiClient.swift
//  Currency Calculator
//
//  Created by Давид Тоноян  on 27.08.2022.
//

import UIKit

extension CurrencyTableViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return currencies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "currencyCell", for: indexPath) as? CustomCell
        let currency = currencies[indexPath.row]
        cell?.charCodeLabel.text = currency.charCode
        cell?.currencyNameLabel.text = currency.nominal + " " + currency.name
        cell?.currencyRateLabel.text = currency.value
        
        let image: Favorites = Persistance.shared.checkPersistance(currency) ? .added : .notAdded
        cell?.favoriteButton.tag = indexPath.row
        cell?.favoriteButton.setImage(UIImage(systemName: image.rawValue), for: .normal)
        
        return cell ?? CustomCell()
    }
}

extension CurrencyTableViewController: XMLParserDelegate {
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String] = [:]) {
        self.elementName = elementName
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        if elementName == "Valute" {
            let currency = Currrency(numCode: numCode, charCode: charCode, name: name, value: value, nominal: nominal)
            currencies.append(currency)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        let data = string.trimmingCharacters(in: .whitespacesAndNewlines)
        
        if !data.isEmpty {
            switch elementName {
            case "Nominal":
                self.nominal = data
            case "CharCode":
                self.charCode = data
            case "Name":
                self.name = data
            case "Value":
                self.value = data
            case "NumCode":
                self.numCode = data
            default:
                break
            }
        }
    }
}


