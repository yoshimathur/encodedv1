//
//  SecretCodesHomeViewController.swift
//  Secret Messages
//
//  Created by Yash Mathur on 7/18/20.
//  Copyright © 2020 Hills Production. All rights reserved.
//

import UIKit
import GoogleMobileAds

class SecretCodesHomeViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate, GADBannerViewDelegate, GADRewardedAdDelegate {
    
    var rewardedAd: GADRewardedAd?
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setUpElements()
        setUpArrays()
        
        //making the keyboard disapear when you tap the view
        let tap = UITapGestureRecognizer(target: self.view, action: #selector(UIView.endEditing(_:)))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
        
        //ads
//        //test ads
//        adUnit.adUnitID = "ca-app-pub-3940256099942544/2934735716"
        //production ads
        adUnit.adUnitID = "ca-app-pub-2988257212304464/1231795850"
        adUnit.rootViewController = self
        adUnit.load(GADRequest())
        adUnit.delegate = self
        
//        //test ads
//        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-3940256099942544/1712485313")
        //production ads
        rewardedAd = GADRewardedAd(adUnitID: "ca-app-pub-2988257212304464/2353305830")
        rewardedAd?.load(GADRequest(), completionHandler: { (error) in
            if let error = error {
                print("There was an error: \(error.localizedDescription)")
                self.errorLabel.text = error.localizedDescription
                self.errorLabel.alpha = 1
            } else {
                print("Ad loaded")
            }
        })
        
        
        print("View has loaded :)")
    }
    
    //color
    let green = UIColor.init(named: "Classic Font")
    
    //user defaults
    let defaults = UserDefaults(suiteName: "group.yashmathur.encoded")!
    
    //references
    @IBOutlet weak var codesTableView: UITableView!
    @IBOutlet weak var addNewCode: UILabel!
    @IBOutlet weak var headerLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UILabel!
    @IBOutlet weak var storeButtonRef: UIButton!
    @IBOutlet weak var errorLabel: UILabel!
    @IBOutlet weak var adUnit: GADBannerView!
    @IBOutlet weak var deleteCodePopUp: UIView!
    @IBOutlet weak var deleteCodeTitle: UILabel!
    @IBOutlet weak var deleteCodePopUpLabel: UILabel!
    @IBOutlet weak var deleteCodeButtonRef: UIButton!
    @IBOutlet weak var cancelDeleteCodePopUpButtonRef: UIButton!
    
    //selection variables
    var selectedCodeName: String = ""
    var selectedCodeDescription: String = ""
    var selectedCodeID: String = ""
    
    //function to set up the elements
    func setUpElements() {
        
        //fonts
        headerLabel.font = UIFont(name: "Audiowide-Regular", size: 27)
        descriptionLabel.font = UIFont(name: "Audiowide-Regular", size: 15)
        addNewCode.font = UIFont(name: "Audiowide-Regular", size: 17)
        storeButtonRef.titleLabel?.font = UIFont(name: "Audiowide-Regular", size: 15)
        
        //table view background color
        self.codesTableView.backgroundColor = UIColor.clear
        
        //tapping the addNewCode label
        addNewCode.backgroundColor = UIColor.init(named: "Classic Font")
        addNewCode.isUserInteractionEnabled = true
        let tap = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(_:)))
        addNewCode.addGestureRecognizer(tap)
        
        //error Label should be hidden
        errorLabel.alpha = 0
        
        //pop up
        deleteCodePopUp.alpha = 0
        deleteCodePopUp.layer.borderColor = CGColor.init(red: 0, green: 0, blue: 0, alpha: 1)
        deleteCodePopUp.layer.borderWidth = 3
        deleteCodeTitle.font = UIFont.init(name: "Audiowide-Regular", size: 17)
        deleteCodePopUpLabel.font = UIFont.init(name: "Audiowide-Regular", size: 15)
        deleteCodeButtonRef.titleLabel?.font = UIFont.init(name: "Audiowide-Regular", size: 15)
        cancelDeleteCodePopUpButtonRef.titleLabel?.font = UIFont.init(name: "Audiowide-Regular", size: 14)
    }
    
    //function to handle the tap of the label
    @objc func handleTap(_ sender: UITapGestureRecognizer) {
        print("tapped on label")
        self.performSegue(withIdentifier: "createCodeSegue", sender: self)
    }
    
    //variables
    var codesArray: [String] = UserDefaults(suiteName: "group.yashmathur.encoded")!.array(forKey: "Codes")! as! [String]
    var codesNamesArray: [String] = []
    var codeDescriptionsArray: [String] = []
    var codeIDArray: [String] = []
    
    //function to set up the arrays
    func setUpArrays() {
        self.codesNamesArray.removeAll()
        self.codeDescriptionsArray.removeAll()
        self.codeIDArray.removeAll()
        print(self.codesArray)
        for id in codesArray.reversed() {
            codeIDArray.append(id)
            let code: [Any] = defaults.array(forKey: id) ?? ["Could not retrieve data!", "Could not retrieve data!"]
            let codeName: String = code[0] as! String
            let codeDescription: String = code[1] as! String
            self.codesNamesArray.append(codeName)
            self.codeDescriptionsArray.append(codeDescription)
        }
        limitUserCodes()
        codesTableView.reloadData()
    }
    
    //function to limit users wihtout unlimited codes to only 7 codes
    func limitUserCodes() {
        print(self.codesArray.count)
        let limit = defaults.integer(forKey: "Limit")
        print(limit)
        if self.codesArray.count == limit {
            self.addNewCode.backgroundColor = UIColor.lightGray
            self.addNewCode.isUserInteractionEnabled = false
            self.errorLabel.alpha = 1
            self.errorLabel.font = UIFont(name: "Audiowide-Regular", size: 15)
            self.errorLabel.text = "Unlock more codes in the store!"
        }
    }
    
    //table view functions
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return codesArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let codeCell = UITableViewCell(style: .subtitle, reuseIdentifier: "codeCell")
        codeCell.textLabel?.text = "\(codesNamesArray[indexPath.row]): \(codeDescriptionsArray[indexPath.row])"
        codeCell.detailTextLabel?.text = "codeID: \(codeIDArray[indexPath.row])"
        
        //design
        codeCell.textLabel?.textColor = UIColor.init(named: "Classic Font")
        codeCell.detailTextLabel?.textColor = UIColor.white
        codeCell.textLabel?.numberOfLines = 0
        codeCell.detailTextLabel?.numberOfLines = 0
        codeCell.backgroundColor = UIColor.black
        codeCell.textLabel?.font = UIFont(name: "Audiowide-Regular", size: 17)
        codeCell.detailTextLabel?.font = UIFont(name: "Audiowide-Regular", size: 12)
        
        return codeCell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedCodeName = codesNamesArray[indexPath.row]
        self.selectedCodeDescription = codeDescriptionsArray[indexPath.row]
        self.selectedCodeID = codeIDArray[indexPath.row]
        self.performSegue(withIdentifier: "homeToPreviewSegue", sender: self)
    }
    
    //deleting a code
    var deletedCode: String = ""
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        var deleteAction: UIContextualAction
        deleteAction = UIContextualAction(style: .destructive, title: "Delete", handler: { (action, view, handler) in
            self.deleteCodePopUp.alpha = 1
            self.deletedCode = self.codeIDArray[indexPath.row]
            print(self.deletedCode)
        })
        
        deleteAction.backgroundColor = UIColor.systemPink
        let delete = UISwipeActionsConfiguration(actions: [deleteAction])
        return delete
    }
    
    @IBAction func deleteCode(_ sender: Any) {
        if rewardedAd?.isReady == true {
            rewardedAd?.present(fromRootViewController: self, delegate: self)
            self.deleteCodePopUp.alpha = 0
            self.codesTableView.reloadData()
        } else {
            self.errorLabel.text = "Sorry agent, we are having trouble loading the ad!"
            self.errorLabel.alpha = 0
        }
    }
    
    func rewardedAd(_ rewardedAd: GADRewardedAd, userDidEarn reward: GADAdReward) {
        print("Reward")
        let codeIndex: Int = self.codesArray.firstIndex(of: self.deletedCode)!
        self.codesArray.remove(at: codeIndex)
        print(self.codesArray)
        self.defaults.setValue(self.codesArray, forKey: "Codes")
        print(self.defaults.array(forKey: "Codes") as Any)
        self.defaults.removeObject(forKey: self.deletedCode)
        self.setUpElements()
        self.setUpArrays()
    }
    
    func rewardedAdDidDismiss(_ rewardedAd: GADRewardedAd) {
        self.setUpElements()
        self.setUpArrays()
    }
    
    @IBAction func cancelDeletePopUp(_ sender: Any) {
        self.deleteCodePopUp.alpha = 0
        self.codesTableView.reloadData()
    }
    
    //carrying user data over
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "homeToPreviewSegue" {
            let profile = segue.destination as! SecretCodePreviewViewController
            profile.codeName = self.selectedCodeName
            profile.codeDescription = self.selectedCodeDescription
            profile.codeID = self.selectedCodeID
        }
    }
}

