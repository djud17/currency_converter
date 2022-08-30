//
//  FavoritesViewController.swift
//  Currency Calculator
//
//  Created by Давид Тоноян  on 27.08.2022.
//

import UIKit

final class FavoritesViewController: UIViewController {
    @IBOutlet weak var favoritesTableView: UITableView!
    
    var favoriteCurrencies: [FavoriteCurrency] = [] {
        didSet {
            favoriteCurrencies.sort { $0.charCode < $1.charCode } 
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        readData()
    }
    
    private func setupView() {
        navigationItem.title = "Favorites"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        favoritesTableView.allowsSelection = false
    }
    
    private func readData() {
        if let favCurrencies = Persistance.shared.realmRead() {
            favoriteCurrencies.removeAll()
            favCurrencies.forEach { favoriteCurrencies.append($0) }
            
            favoritesTableView.reloadData()
        }
    }
}
