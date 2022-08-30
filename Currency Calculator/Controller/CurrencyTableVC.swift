//
//  ViewController.swift
//  Currency Calculator
//
//  Created by Давид Тоноян  on 27.08.2022.
//

import UIKit

final class CurrencyTableViewController: UIViewController {
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    
    var currencies = [Currrency]()
    var elementName = ""
    var numCode = ""
    var charCode = ""
    var name = ""
    var value = ""
    var nominal = ""
    
    enum Favorites: String {
        case added = "star.fill"
        case notAdded = "star"
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupView()
        fetchData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        tableView.reloadData()
    }
    
    private func setupView() {
        navigationItem.title = "Currency Rates"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        tableView.allowsSelection = false
        activityIndicator.isHidden = true
    }
    
    private func fetchData() {
        let url = URL(string: "https://www.cbr.ru/scripts/XML_daily.asp")!
        if let parser = XMLParser(contentsOf: url) {
            parser.delegate = self
            if parser.parse() {
                DispatchQueue.main.asyncAfter(deadline: .now()) {
                    self.animateTableView()
                }
            }
        }
    }
    
    @IBAction func refreshData(_ sender: UIBarButtonItem) {
        currencies.removeAll()
        activityIndicator.isHidden = false
        activityIndicator.startAnimating()
        fetchData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.activityIndicator.stopAnimating()
            self.activityIndicator.isHidden = true
        }
    }
    
    @IBAction func calculateButtonTapped(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "calculateVC") as! CalculateViewController
        vc.currencies = currencies
        navigationController?.pushViewController(vc, animated: true)
    }
    
    @IBAction func favoriteButtonTapped(_ sender: UIButton) {
        let currency = currencies[sender.tag]
        var image: Favorites
        
        if Persistance.shared.checkPersistance(currency) {
            deleteElementFromPersistance(currency)
            image = .notAdded
        } else {
            writeElementToPersistance(currency)
            image = .added
        }
        sender.setImage(UIImage(systemName: image.rawValue), for: .normal)
    }
    
    private func deleteElementFromPersistance(_ currency: Currrency) {
        if let favCurrencies = Persistance.shared.realmRead() {
            for fvCur in favCurrencies where fvCur.numCode == currency.numCode {
                Persistance.shared.realmDelete(fvCur)
                break
            }
        }
    }
    
    private func writeElementToPersistance(_ currency: Currrency) {
        let newCurrency = FavoriteCurrency()
        newCurrency.nominal = currency.nominal
        newCurrency.charCode = currency.charCode
        newCurrency.numCode = currency.numCode
        newCurrency.value = currency.value
        newCurrency.name = currency.name
        Persistance.shared.realmWrite(newCurrency)
    }
    
    private func animateTableView() {
        tableView.reloadData()
        
        let cells = tableView.visibleCells
        let tableViewHeight = tableView.frame.height
        var delay: Double = 0
        
        for cell in cells {
            cell.transform = CGAffineTransform(translationX: 0, y: tableViewHeight)
            
            UIView.animate(withDuration: 1.5,
                           delay: delay * 0.05,
                           usingSpringWithDamping: 0.8,
                           initialSpringVelocity: 0,
                           options: .curveEaseInOut,
                           animations: {
                cell.transform = CGAffineTransform.identity
            })
            delay += 1
        }
    }
}
