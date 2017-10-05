//
//  BasketTableViewController.swift
//  BasketEvaluator
//
//  Created by Michelangelo on 27/09/2017.
//  Copyright © 2017 Michelangelo. All rights reserved.
//

import UIKit

/// The BasketTableViewController class allows to manage a virtual basket containing basket items.
class BasketTableViewController: UIViewController {

    // MARK: - Properties
    
    // the basket item data to whom ask for data
    var basketItemData: BasketItemDataSource = UIApplication.shared.appDelegate.applicationFactory.basketItemData
    
    // MARK: - Outlets
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var spinner: UIActivityIndicatorView!
    @IBOutlet weak var checkoutBarButtonItem: UIBarButtonItem!

    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupTableView()
        subscribeToNotifications()
        basketItemData.refreshBasketItems() // refresh the model
    }
    
    deinit {
        unsubscribeFromNotifications()
    }
    
    // MARK: - Convenience
    
    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        tableView.estimatedRowHeight = tableView.rowHeight
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.allowsSelection = false
    }
    
    // MARK: - Notifications
    
    private func subscribeToNotifications() {
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(availableBasketItemsWillUpdate),
                                               name: NSNotification.Name(rawValue: Notifications.BasketItemsWillUpdateData),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(availableBasketItemsUpdateSuccess),
                                               name: NSNotification.Name(rawValue: Notifications.BasketItemsUpdateSuccess),
                                               object: nil)
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(availableBasketItemsUpdateFail),
                                               name: NSNotification.Name(rawValue: Notifications.BasketItemsUpdateFail),
                                               object: nil)
    }
    
    private func unsubscribeFromNotifications() {
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: Notifications.BasketItemsWillUpdateData),
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: Notifications.BasketItemsUpdateSuccess),
                                                  object: nil)
        NotificationCenter.default.removeObserver(self,
                                                  name: NSNotification.Name(rawValue: Notifications.BasketItemsUpdateFail),
                                                  object: nil)
    }
    
    @objc private func availableBasketItemsWillUpdate() {
        DispatchQueue.main.async { [weak self] in
            UIApplication.shared.isNetworkActivityIndicatorVisible = true
            self?.spinner.startAnimating()
            self?.tableView.reloadData()
        }
    }
    
    @objc private func availableBasketItemsDidUpdate() {
        DispatchQueue.main.async { [weak self] in
            UIApplication.shared.isNetworkActivityIndicatorVisible = false
            self?.spinner.stopAnimating()
            self?.tableView.reloadData()
        }
    }
    
    @objc private func availableBasketItemsUpdateSuccess() {
        availableBasketItemsDidUpdate()
    }
    
    @objc private func availableBasketItemsUpdateFail(notification: NSNotification) {
        availableBasketItemsDidUpdate()
        if let errorDescription = notification.userInfo?[NSLocalizedDescriptionKey] as? String {
            showSimpleAlert(withTitle: AlertMessages.AlertTitle, withMessage: errorDescription)
        } else {
            showSimpleAlert(withTitle: AlertMessages.AlertTitle, withMessage: AlertMessages.GenericAlertMessage)
        }
    }
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Storyboard.CheckoutViewControllerSegueIdentifier {
            if let checkoutViewController = segue.destination as? CheckoutViewController {
                // even if know that the default basketItemData for the checkoutViewController
                // is the same as the one of this controller, we set it in case things will change in the future
                // (i.e. we want the same basketItemData for the checkoutViewController)
                checkoutViewController.basketItemData = basketItemData
            }
        }
    }

}

// MARK: - UITableViewDataSource and UITableViewDelegate

extension BasketTableViewController: UITableViewDataSource, UITableViewDelegate {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return basketItemData.basketItems.isEmpty ? 0 : 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return basketItemData.basketItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Storyboard.BasketItemTableViewCellIdentifier,
                                                 for: indexPath) as! BasketItemTableViewCell
        let basketItem = basketItemData.basketItems[indexPath.row]
        configure(cell: cell, withBasketItem: basketItem)
        return cell
    }
    
    private func configure(cell: BasketItemTableViewCell, withBasketItem basketItem: BasketItem) {
        cell.delegate = self
        cell.basketItem = basketItem
        cell.nameLabel.text = basketItem.item.name
        cell.amountStepper.value = Double(basketItem.quantity)
        cell.amountLabel.text = "\(basketItem.quantity)"
        currencyFormatter.currencyCode = CurrencyCodes.USD
        // configure the cell using USD as default currency such that the label will show i.e. "$1.30 x Bottle"
        cell.priceLabel.text =
            currencyFormatter.string(from: basketItem.item.priceInDollars)! + Storyboard.PriceToUnitSeparator + basketItem.item.unitOfMeasurement
    }
    
}

// MARK: - BasketItemTableViewCellDelegate

extension BasketTableViewController: BasketItemTableViewCellDelegate {
    
    func basketItemTableViewCell(_ basketItemTableViewCell: BasketItemTableViewCell, didChangeAmountWithNewValue newValue: Int) {
        // when the selected amount for a given basket item changes, update the model
        let index = tableView.indexPath(for: basketItemTableViewCell)!.row
        basketItemData.updateQuantityOfBasketItem(atIndex: index, withQuantity: newValue)
        // also, update the amountLabel value of the cell
        basketItemTableViewCell.amountLabel.text = "\(newValue)"
        // finally, if the basket contains at least 1 item, enable the checkout button, otherwise, disable it
        checkoutBarButtonItem.isEnabled = basketItemData.basketItemsTotalQuantity > 0 ? true : false
    }
    
}
