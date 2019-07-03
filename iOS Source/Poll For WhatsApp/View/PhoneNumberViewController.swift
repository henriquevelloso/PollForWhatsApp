//
//  PhoneNumberViewController.swift
//  Poll for WhatsApp
//
//  Created by Henrique Velloso on 19/03/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import UIKit
import CountryKit
import Firebase
import SwifterSwift
import IHKeyboardAvoiding

class PhoneNumberViewController: UIViewController {
    
    //MARK: - Properties
    private var viewModel = PhoneNumberViewModel()
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phoneNumberText: UITextField!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var flagCountainer: UIView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var formContainer: UIView!
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNavigationBar()
        self.titleConfig()
        self.phoneNumberConfig()
        self.countryCodeAndFlagConfig()
        self.keyboardConfig()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
  
    //MARK: - Custom functions
    
    func keyboardConfig() {
        KeyboardAvoiding.avoidingView = self.formContainer
    }
    
    func configNavigationBar() {
         
        let suggestImage  = UIImage(named: "logoMark")!.withRenderingMode(.alwaysOriginal)
        let suggestButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        suggestButton.setBackgroundImage(suggestImage, for: .normal)
        suggestButton.transform = CGAffineTransform(translationX: 5, y: -3)
        let suggestButtonContainer = UIView(frame: suggestButton.frame)
        suggestButtonContainer.addSubview(suggestButton)
        let suggestButtonItem = UIBarButtonItem(customView: suggestButtonContainer)
        navigationItem.rightBarButtonItem = suggestButtonItem
    }
    
    func titleConfig() {
        self.titleLabel.setLineSpace(space: 4)
    }
    
    func phoneNumberConfig() {
        
        let color = UIColor(red: 118.0/255.0, green: 132.0/255.0, blue: 159.0/255.0, alpha: 0.7)
        self.phoneNumberText.attributedPlaceholder = NSAttributedString(string: self.phoneNumberText.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: color])
        self.phoneNumberText.autocorrectionType = .no
        self.phoneNumberText.delegate = self
        self.phoneNumberText.becomeFirstResponder()
    }
    
    func countryCodeAndFlagConfig() {
        
        let countryKit = CountryKit()
        let usa = countryKit.countries[244]
        self.countryCodeLabel.text =  "+\(usa.phoneCode!)"
        self.countryFlag.image = usa.flagImage
        
        guard let currentCountry = countryKit.current else {
            return
        }
        
        guard let phoneCode = currentCountry.phoneCode else {
            return
        }
        
        self.countryCodeLabel.text =  "+\(phoneCode)"
        self.countryFlag.image = currentCountry.flagImage
        
    }
    
    
    
    //MARK: - IBActions
    @IBAction func openCountryCodePickerAction(_ sender: UITapGestureRecognizer) {
        
        let alert = UIAlertController(style: .actionSheet, title: "Phone Codes")
        alert.addLocalePicker(type: .phoneCode) { info in
            // action with selected object
            
            self.countryCodeLabel.text =  info?.phoneCode
            self.countryFlag.image = info?.flag
            
        }
        alert.addAction(title: "Cancel", style: .cancel)
        self.topMostController().present(alert, animated: true, completion: nil)
    }
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    
    @IBAction func sendCodeTapped(_ sender: UIButton) {
        
        let countryCode = self.countryCodeLabel.text!
        let phoneNumber = self.phoneNumberText.text!
        
        if phoneNumber.isEmpty {
            showAlert(title: "Requiered", message: "Phone number is requiered.")
        } else {
            
            self.loadingView.alpha = 0
            self.loadingView.isHidden = false
            
            UIView.animate(withDuration: 0.5) {
                self.loadingView.alpha = 1
            }
            
            self.viewModel.verifyPhoneNumber(countryCode: countryCode, phoneNumber: phoneNumber) { (user, error) in
                
                if let er = error {
                    
                    self.showAlert(title: "Error", message: er.localizedDescription, buttonTitles: ["OK"], highlightedButtonIndex: 0, completion: { index in
                        
                        UIView.animate(withDuration: 0.5) {
                            self.loadingView.alpha = 0
                        }
                    })
                    
                } else {
                    self.performSegue(withIdentifier: "goToAuthentication", sender: user)
                }
            }
        }
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "goToAuthentication" {
            let viewController = segue.destination as! AuthenticateViewController
            viewController.user  = sender as? UserLocal
            self.loadingView.isHidden = true
            self.loadingView.alpha = 0
        }
    }
}


extension PhoneNumberViewController: UITextFieldDelegate {
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        
        if string == "" {
            return true
        }
        
        guard let _ = Int(string) else {
            return false
        }
        
        return true
    }
    
}
