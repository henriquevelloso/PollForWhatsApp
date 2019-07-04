//
//  SendMessageViewController.swift
//  Poll for WhatsApp
//
//  Created by Henrique Velloso on 27/03/19. b
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import UIKit
import Firebase
import CountryKit
import IHKeyboardAvoiding
import SwifterSwift

class SendMessageViewController: UIViewController {

    //MARK: - Properties
    private var viewModel = SendMessageViewModel()
    var placeholderLabel : UILabel!
    
    //MARK: - Outlets
    @IBOutlet weak var phoneNumberText: UITextField!
    @IBOutlet weak var countryCodeLabel: UILabel!
    @IBOutlet weak var countryFlag: UIImageView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var messageText: UITextView!
    @IBOutlet weak var formContent: UIView!
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNavigationBar()
        self.configMessageView()
        self.phoneNumberConfig()
        self.countryCodeAndFlagConfig()
        self.configKeyboard()

    }
    
    //MARK: - Custom functions
    func configNavigationBar() {
        
        
        let suggestImage  = UIImage(named: "logoMark")!.withRenderingMode(.alwaysOriginal)
        let suggestButton = UIButton(frame: CGRect(x: 0, y: 0, width: 35, height: 35))
        suggestButton.setBackgroundImage(suggestImage, for: .normal)
        suggestButton.addTarget(self, action: #selector(self.logOff), for: .touchUpInside)
        suggestButton.transform = CGAffineTransform(translationX: 5, y: -3)
        let suggestButtonContainer = UIView(frame: suggestButton.frame)
        suggestButtonContainer.addSubview(suggestButton)
        let suggestButtonItem = UIBarButtonItem(customView: suggestButtonContainer)
        navigationItem.rightBarButtonItem = suggestButtonItem
        navigationItem.setHidesBackButton(true, animated: false)
    }

    @objc func logOff() {
        
        let firebaseAuth = Auth.auth()
        do {
            try firebaseAuth.signOut()
            self.performSegue(withIdentifier: "goToLogin", sender: nil)
        } catch let signOutError as NSError {
            print ("Error signing out: %@", signOutError)
        }
    }
    
    func configKeyboard() {
        KeyboardAvoiding.avoidingView = self.formContent
        //KeyboardAvoiding.keyboardAvoidingMode = .maximum
    }
    
    func configMessageView() {
        
        messageText.delegate = self
        placeholderLabel = UILabel()
        placeholderLabel.text = "Poll title"
        placeholderLabel.font = phoneNumberText.font
        placeholderLabel.sizeToFit()
        messageText.addSubview(placeholderLabel)
        placeholderLabel.frame.origin = CGPoint(x: 5, y: (messageText.font?.pointSize)! / 2)
        placeholderLabel.textColor = UIColor(red: 118.0/255.0, green: 132.0/255.0, blue: 159.0/255.0, alpha: 0.7)
        placeholderLabel.isHidden = !messageText.text.isEmpty
    }
    
    func phoneNumberConfig() {
        
        let color = UIColor(red: 118.0/255.0, green: 132.0/255.0, blue: 159.0/255.0, alpha: 0.7)
        self.phoneNumberText.attributedPlaceholder = NSAttributedString(string: self.phoneNumberText.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: color])
        self.phoneNumberText.autocorrectionType = .no
        self.phoneNumberText.delegate = self
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
    
    func showAcceptMessage() {
        
        
            let text: [AttributedTextBlock] = [
                .normal(""),
                .header1("Poll for WhatsApp Policy Terms."),
                .header2("Accept this standard policies and terms for use this service"),
                .list("Your identity or your phone number will be sent in the message, this will be sent from one of our phone numbers."),
                .list("Will be recorded in our database the message content, who sent the message and the phone number of destination, in total privacy."),
                .list("This message will be logged for security reasons only. "),
                
                .list("You are fully responsible for the content you submit in the messages."),
                .list("Do not send messages with offensive content, we can reveal who you are to the recipient of the message."),
                .list("Keep this itens in mind when you are composing your anonymous message."),
                .normal("Accept these terms so you can send your pools. Keep these items in mind when composing your message."),
                .normal("Remember, 'GREAT POWERS COME WITH GREAT RESPONSIBILITIES.'")
            ]
            
            let alert = UIAlertController(style: .actionSheet)
            alert.addTextViewer(text: .attributedText(text))
            let action = UIAlertAction(title: "I ACCEPT THIS TERMS", style: .default) { action in
                
                UserDefaults.standard.set(true, forKey: "termsAccepted")
                
                
            }
            
            alert.addAction(action)
            self.topMostController().present(alert, animated: true, completion: nil)
            
            print("First launch, setting UserDefault.")
            UserDefaults.standard.set(true, forKey: "launchedBefore")
        
    }
    
    func sendMessage() {
        
        self.loadingView.alpha = 0
        self.loadingView.isHidden = false
        
        UIView.animate(withDuration: 1) {
            self.loadingView.alpha = 1
        }
        let link1 = "https://bit.ly/2X1rKGZ"
        let link2 = "https://bit.ly/2X1rKGZ"
        let link3 = "https://bit.ly/2X1rKGZ"
        
        let question01 = "Opção 01"
        let question02 = "Opção 02"
        let question03 = "Opção 03"
        
        let user = Auth.auth().currentUser!
        let fullMessage = "_You reveived a poll message from user: \(user.phoneNumber!)_\n________________________\n\n\n*\(self.messageText.text!)*\n\n1) \(question01) [\(link1)]\n\n2) \(question02) [\(link2)]\n\n3) \(question03) [\(link3)]\n________________________\n_This message was sent using the app 'Poll for WhatsApp' for iOS._"
        
        
        self.viewModel.sendMessageWassenger(countryCode: self.countryCodeLabel.text!, phoneNumber: self.phoneNumberText.text!, messageText: fullMessage) { (response, error) in
            
            
            DispatchQueue.main.async{
                UIView.animate(withDuration: 1) {
                    self.loadingView.alpha = 0
                }
            }
            
            if let err = error {
                self.showAlert(title: "Message NOT sent", message: err.localizedDescription)
                return
            }
            
//            if let resp = response {
//                if resp.resultCode != 0 {
//                    self.showAlert(title: "Message NOT sent", message: resp.description)
//                    return
//                }
            
                //MESSAGE SENT
                
                //Your message has been queued to be sent shortly.
                self.showAlert(title: "Message SENT", message: "Your message has been queued to be sent shortly.")
                self.messageText.text = ""
                
//            }
            
        }
        
        /*
        self.viewModel.sendMessageApiWha(countryCode: self.countryCodeLabel.text!, phoneNumber: self.phoneNumberText.text!, messageText: fullMessage) { (response, error) in
            
            UIView.animate(withDuration: 0.5) {
                self.loadingView.alpha = 0
            }
            
            if let err = error {
                self.showAlert(title: "Message NOT sent", message: err.localizedDescription)
                return
            }
            
            if let resp = response {
                if resp.resultCode != 0 {
                    self.showAlert(title: "Message NOT sent", message: resp.description)
                    return
                }
                
                //MESSAGE SENT
                
                //Your message has been queued to be sent shortly.
                self.showAlert(title: "Message SENT", message: "Your message has been queued to be sent shortly.")
                self.messageText.text = ""
                
            }
            
            
        } */
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
    
    @IBAction func sendMessageAction(_ sender: Any) {
        
        self.view.endEditing(true)
        
        if phoneNumberText.text!.isEmpty {
            showAlert(title: "Requiered", message: "Mobile Number is Requiered.", buttonTitles: ["OK"], highlightedButtonIndex: 0) { index in
                self.phoneNumberText.becomeFirstResponder()
            }
            return
        }
        
        if messageText.text!.isEmpty {
            showAlert(title: "Requiered", message: "Message is Requiered.", buttonTitles: ["OK"], highlightedButtonIndex: 0) { index in
                self.messageText.becomeFirstResponder()
            }
            return
        }
        
        let termsAccepted = UserDefaults.standard.bool(forKey: "termsAccepted")
        if termsAccepted  {
            self.sendMessage()
        } else {
            showAcceptMessage()
        }
    }
    
}

extension SendMessageViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
         placeholderLabel.isHidden = !messageText.text.isEmpty
    }
}


extension SendMessageViewController: UITextFieldDelegate {
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
