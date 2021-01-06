//
//  StoreViewController.swift
//  Secret Messages
//
//  Created by Yash Mathur on 7/21/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import GoogleMobileAds
import StoreKit

class StoreViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, GADBannerViewDelegate, SKPaymentTransactionObserver {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        
        //ads
//        //test ads
//        adUnit.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        //production ads
        adUnit.adUnitID = "ca-app-pub-2988257212304464/2812486743"
        adUnit.rootViewController = self
        adUnit.load(GADRequest())
        adUnit.delegate = self
        
        //Payments
        SKPaymentQueue.default().add(self)
        
        print("View has loaded :)")
    }
    
    let defaults = UserDefaults.init(suiteName: "group.yashmathur.encoded")!
    
    //ad reference
    @IBOutlet weak var adUnit: GADBannerView!
    
    //IAP identifiers
    let addOneCodeIAPRef = "com.yashmathur.encoded.add_one_code"
    let addThreeCodesIAPRef = "com.yashmathur.encoded.add_three_codes"
    let unlockSystemCodesIAPRef = "com.yashmathur.encoded.unlock_system_keyboards"
    
    //references
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var confirmPurchasePopUp: UIView!
    @IBOutlet weak var confirmPurchaseTitle: UILabel!
    @IBOutlet weak var confirmPurchaseDetailLabel: UILabel!
    @IBOutlet weak var confirmPurchaseCancelButtonRef: UIButton!
    @IBOutlet weak var confirmPurchaseConfirmButtonref: UIButton!
    
    
    //function to set up the elements
    func setUpElements() {
        
        //setting row height
        storeTableView.rowHeight = 150
        
        //BG for tableview
        storeTableView.backgroundColor = UIColor.clear
        
        //errorLabel
        errorLabel.alpha = 0
        errorLabel.font = UIFont(name: "Audiowide-Regular", size: 12)
        
        //pop up
        confirmPurchasePopUp.alpha = 0
        confirmPurchasePopUp.layer.borderColor = CGColor.init(srgbRed: 0, green: 0, blue: 0, alpha: 1)
        confirmPurchasePopUp.layer.borderWidth = 3
        confirmPurchaseTitle.font = UIFont(name: "Audiowide-Regular", size: 17)
        confirmPurchaseDetailLabel.font = UIFont(name: "Audiowide-Regular", size: 15)
        confirmPurchaseCancelButtonRef.titleLabel?.font = UIFont(name: "Audiowide-Regular", size: 14)
        confirmPurchaseConfirmButtonref.titleLabel?.font = UIFont(name: "Audiowide-Regular", size: 15)
    }
    
    //tableview reference
    @IBOutlet weak var storeTableView: UITableView!
    
    //tableview functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        Store.storeItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: StoreTableViewCell = tableView.dequeueReusableCell(withIdentifier: "storeCell") as! StoreTableViewCell
        cell.itemLabel.text = Store.storeItems[indexPath.row]
        cell.itemDescriptionLabel.text = Store.storeItemDescriptions[indexPath.row]
        cell.itemImage.image = Store.storeImages[indexPath.row]
        
        //setting design
        cell.itemLabel.font = UIFont(name: "Audiowide-Regular", size: 17)
        cell.itemDescriptionLabel.font = UIFont(name: "Audiowide-Regular", size: 12)
        cell.itemLabel.numberOfLines = 0
        cell.itemDescriptionLabel.numberOfLines = 0
        cell.itemImage.layer.borderWidth = 2
        cell.itemImage.layer.borderColor = CGColor.init(srgbRed: 0.001, green: 1, blue: 0.478, alpha: 1)
        
        return cell
    }
    
    //variable for saving purchase IAP Ref
    var purchaseIAPRef: String? = ""
    
    //selecting an item
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if SKPaymentQueue.canMakePayments() {
            purchaseIAPRef = Store.IAPRefs[indexPath.row]
            let item = Store.storeItems[indexPath.row]
            let itemDescription = Store.storeItemDescriptions[indexPath.row]
            self.confirmPurchaseDetailLabel.text = item + ": " + itemDescription
            self.confirmPurchasePopUp.alpha = 1
        } else {
            print("User unable to make payments")
            self.errorLabel.text = "Sorry agent, you are unable to make purchases!"
            self.errorLabel.alpha = 0
        }
    }
    
    //cancel purchase
    @IBAction func cancelPurchase(_ sender: Any) {
        self.confirmPurchasePopUp.alpha = 0
    }
    
    //confirming purchase
    @IBAction func confirmPurchase(_ sender: Any) {
        if SKPaymentQueue.canMakePayments() {
            if let purchase = self.purchaseIAPRef {
                print(purchase)
                let paymentRequest = SKMutablePayment()
                paymentRequest.productIdentifier = purchase
                SKPaymentQueue.default().add(self)
                SKPaymentQueue.default().add(paymentRequest)
            } else {
                print("Could not get purchase ID")
                self.errorLabel.text = "Sorry agent, there was an error in making the purchase!"
                self.errorLabel.alpha = 1
                self.confirmPurchasePopUp.alpha = 0
            }
        } else {
            print("User has already bought this item most likely!")
            self.errorLabel.text = "You have already bought this item agent!"
            self.errorLabel.alpha = 1
            self.confirmPurchasePopUp.alpha = 0
        }
    }
    
    
    //handling purchases
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
    
        for transaction in transactions {
            switch transaction.transactionState {
            
            case .purchasing:
                print("Purchasing")
                break
            
            case .purchased:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                
                if let purchase = self.purchaseIAPRef {
                    if purchase == self.addOneCodeIAPRef {
                        let limit = defaults.integer(forKey: "Limit") + 1
                        defaults.setValue(limit, forKey: "Limit")
                    } else if purchase == self.addThreeCodesIAPRef {
                        let limit = defaults.integer(forKey: "Limit") + 3
                        defaults.setValue(limit, forKey: "Limit")
                    } else if purchase == self.unlockSystemCodesIAPRef {
                        defaults.setValue(true, forKey: "System Keyboards")
                    }
                }
                break
                
            case .restored:
                SKPaymentQueue.default().finishTransaction(transaction)
                print("Purchases has been restored!")
                break
                
            case .failed:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                print("Transaction Failed")
                self.errorLabel.text = "Sorry agent, purchase was a failure!"
                self.errorLabel.alpha = 1
                break
                
            case .deferred:
                SKPaymentQueue.default().finishTransaction(transaction)
                SKPaymentQueue.default().remove(self)
                print("Deffered")
                break
                
            default:
                break
            }
        }
        
    }
    

}
