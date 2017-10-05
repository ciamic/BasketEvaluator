//
//  CheckoutViewController.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 30/09/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import UIKit

/// The CheckoutViewController riepilogates the total amount due in order to purchase the items contained in a basket.
/// It allows to change the currency used.
class CheckoutViewController: UIViewController {
    
    // MARK: - Properties
    
    // the basket item data to whom ask for data
    var basketItemData: BasketItemDataSource = UIApplication.shared.appDelegate.applicationFactory.basketItemData
    
    // the currency layer client used for currency conversion purposes
    var currencyLayerClient: CurrencyLayerClientAPI = UIApplication.shared.appDelegate.applicationFactory.currencyLayerClient
    
    fileprivate var lastCurrency: Currency?
    
    // MARK: - Outlets
    
    @IBOutlet weak var amountLabel: UILabel!
    @IBOutlet weak var amountSpinner: UIActivityIndicatorView!
    @IBOutlet weak var numberOfItemsLabel: UILabel!
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Convenience
    
    // sets the number of items label to the currently number of items contained in the basket
    // and the amount label to the USD value of the basket
    private func setupUI() {
        let numberOfItems = basketItemData.basketItemsTotalQuantity
        numberOfItemsLabel.text = numberOfItems == 1 ? Storyboard.OneItem : "\(numberOfItems) " + Storyboard.MultipleItems
        currencyFormatter.currencyCode = CurrencyCodes.USD
        amountLabel.text = currencyFormatter.string(from: basketItemData.basketItemsTotalPriceInDollars)
    }
    
    // MARK: - Actions
    
    // instantiates a CurrencyPickerController and sets self as the delegate in order to respond to currency changes
    @IBAction func changeCurrencyButtonTapped(_ sender: UIButton) {
        if let currencyPickerNavVC = storyboard?.instantiateViewController(withIdentifier: Storyboard.CurrencyPickerNavControllerIdentifier) as? UINavigationController {
            if let currencyPickerVC = currencyPickerNavVC.visibleViewController as? CurrencyPickerController {
                currencyPickerVC.delegate = self
                present(currencyPickerNavVC, animated: true, completion: nil)
            }
        }
    }
    
}

// MARK: - CurrencyPickerDelegate

extension CheckoutViewController: CurrencyPickerDelegate {
    
    func currencyPickerControllerDidCancel(_ currencyPickerController: CurrencyPickerController) {
        dismiss(animated: true, completion: nil)
    }
    
    func currencyPickerController(_ currencyPickerController: CurrencyPickerController, didPickCurrency currency: Currency) {
        dismiss(animated: true, completion: nil)
        lastCurrency = currency
        updateAmountLabel(withCurrency: currency)
    }
    
    // MARK: - Helpers
    
    // updates the amount label value with the currency specified as parameter
    private func updateAmountLabel(withCurrency currency: Currency) {
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        amountSpinner.startAnimating()
        amountLabel.textColor = UIColor.lightGray
        let total = basketItemData.basketItemsTotalPriceInDollars
        currencyLayerClient.convert(amountInDollars: total, toCurrency: currency) { [weak self] convertedValue, error in
            // check that the content is still fresh
            // (i.e. we still want the value for that currency when coming back from the completion handler.
            // Fetching on the internet can take time and the user could somehow fire 2 or more requests,
            // the first one coming back after some other one.
            // We handle this by capturing the value of the parameter currency in the closure-scope variable with 
            // the same name and check for code equality when we come back from the network
            if currency.code.rawValue == self?.lastCurrency?.code.rawValue {
                guard error == nil else {
                    DispatchQueue.main.async {
                        UIApplication.shared.isNetworkActivityIndicatorVisible = false
                        self?.amountSpinner.stopAnimating()
                        self?.amountLabel.textColor = UIColor.black
                        self?.showSimpleAlert(withTitle: AlertMessages.AlertTitle, withMessage: AlertMessages.GenericAlertMessage)
                    }
                    return
                }
                DispatchQueue.main.async {
                    UIApplication.shared.isNetworkActivityIndicatorVisible = false
                    self?.amountSpinner.stopAnimating()
                    self?.amountLabel.textColor = UIColor.black
                    currencyFormatter.currencyCode = currency.code.rawValue
                    self?.amountLabel.text = currencyFormatter.string(from: convertedValue!)
                }
            }
        }
    }
    
}
