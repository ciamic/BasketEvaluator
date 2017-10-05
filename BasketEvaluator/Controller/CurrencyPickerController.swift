//
//  CurrencyPickerController.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 30/09/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import UIKit

// MARK: - CurrencyPickerDelegate

/// The protocol which allows to get informed about currency picking via delegtion
protocol CurrencyPickerDelegate: class {
    
    func currencyPickerController(_ currencyPickerController: CurrencyPickerController,
                                  didPickCurrency currency: Currency)
    func currencyPickerControllerDidCancel(_ currencyPickerController: CurrencyPickerController)

}

// MARK: - CurrencyPickerController

/// The CurrencyPickerController allows the selection of a Currency
/// chosing between the supported Currencies of the CurrencyLayer API.
class CurrencyPickerController: UIViewController {
    
    // MARK: - Properties 
    
    // the currency data to whom ask for supported currencies
    var currencyData: CurrencyDataSource = UIApplication.shared.appDelegate.applicationFactory.currencyData
    
    // the delegate of the currency picker
    weak var delegate: CurrencyPickerDelegate?
    
    // for the searchBar partial results
    fileprivate var filteredCurrencies = [Currency]()
    
    // UISearchController still not supported by Interface Builder / Storyboard hence instantiated in code
    fileprivate var searchController: UISearchController!
    
    // MARK: - Outlets
    
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var tableView: UITableView!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        setupSearchController()
        subscribeToNotifications()
        currencyData.refreshAvailableCurrencies()
    }
    
    deinit {
        unsubscribeFromNotifications()
        searchController.view.removeFromSuperview()
    }
    
    // MARK: - Convenience
    
    private func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
    }
    
    private func setupSearchController() {
        searchController = UISearchController(searchResultsController: nil) // nil => uses the table view to show the results of the search
        searchController.searchResultsUpdater = self // protocol
        searchController.dimsBackgroundDuringPresentation = false // do not obscure the background during presentation
        definesPresentationContext = true // remove search bar when navigating to other controllers
        tableView.tableHeaderView = searchController.searchBar // set the search bar as table view header
    }
    
    // MARK: - Notifications
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(availableCurrenciesWillUpdate),
                                               name: NSNotification.Name(rawValue: Notifications.AvailableCurrenciesWillUpdateData),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(availableCurrenciesUpdateSuccess),
                                               name: NSNotification.Name(rawValue: Notifications.AvailableCurrenciesUpdateSuccess),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(availableCurrenciesUpdateFail),
                                               name: NSNotification.Name(rawValue: Notifications.AvailableCurrenciesUpdateFail),
                                               object: nil)
    }
    
    private func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: Notifications.AvailableCurrenciesWillUpdateData),
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: Notifications.AvailableCurrenciesUpdateSuccess),
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: Notifications.AvailableCurrenciesUpdateFail),
                                                  object: nil)
    }
    
    @objc private func availableCurrenciesWillUpdate() {
        DispatchQueue.main.async { [weak self] in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self?.spinner.startAnimating()
            self?.tableView.reloadData()
        }
    }
    
    private func availableCurrenciesDidUpdate() {
        DispatchQueue.main.async { [weak self] in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self?.spinner.stopAnimating()
            self?.tableView.reloadData()
        }
    }
    
    @objc private func availableCurrenciesUpdateSuccess() {
        availableCurrenciesDidUpdate()
    }
    
    @objc private func availableCurrenciesUpdateFail(notification: NSNotification) {
        availableCurrenciesDidUpdate()
        if let errorDescription = notification.userInfo?[NSLocalizedDescriptionKey] as? String {
            showSimpleAlert(withTitle: AlertMessages.AlertTitle, withMessage: errorDescription)
        } else {
            showSimpleAlert(withTitle: AlertMessages.AlertTitle, withMessage: AlertMessages.GenericAlertMessage)
        }
        
    }
    
    // MARK: - Actions
    
    @IBAction func cancelButtonTapped(_ sender: UIBarButtonItem) {
        // i.e. no selection
        delegate?.currencyPickerControllerDidCancel(self)
    }

}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension CurrencyPickerController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return currencyData.availableCurrencies.isEmpty ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return isFiltering() ? filteredCurrencies.count : currencyData.availableCurrencies.count
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        delegate?.currencyPickerController(self, didPickCurrency: currency(atIndexPath: indexPath))
    }
    
    private func configure(cell: UITableViewCell, withCurrency currency: Currency) {
        cell.textLabel?.text = currency.name
        cell.detailTextLabel?.text = currency.code.rawValue
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.CurrencyPickerControllerCellIdentifier, for: indexPath)
        configure(cell: cell, withCurrency: currency(atIndexPath: indexPath))
        return cell
    }
    
    // MARK: - Helpers
    
    // returns true iff the search bar text is empty or nil
    private func searchBarIsEmpty() -> Bool {
        return searchController.searchBar.text?.isEmpty ?? true
    }
    
    // returns true iff there is a search bar and it's text is not empty
    private func isFiltering() -> Bool {
        return searchController.isActive && !searchBarIsEmpty()
    }
    
    // retreives the correct selected currency
    private func currency(atIndexPath indexPath: IndexPath) -> Currency {
        return isFiltering() ? filteredCurrencies[indexPath.row] : currencyData.availableCurrencies[indexPath.row]
    }
    
}

// MARK: - UISearchResultsUpdating 

extension CurrencyPickerController: UISearchResultsUpdating {
    
    func updateSearchResults(for searchController: UISearchController) {
        filterContentFor(searchText: searchController.searchBar.text!)
    }
    
    // include all the results that matches, case insensitively, the searchText
    // (i.e. "US" will match both United States Dollar USD (match in the code) and Australian Dollar AUD (match in the name)
    private func filterContentFor(searchText: String) {
        filteredCurrencies = currencyData.availableCurrencies.filter {
            return $0.code.rawValue.lowercased().contains(searchText.lowercased()) || $0.name.lowercased().contains(searchText.lowercased())
        }
        
        tableView.reloadData()
    }
    
}
