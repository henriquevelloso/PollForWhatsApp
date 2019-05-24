//
//  AuthenticateViewController.swift
//  Poll for WhatsApp
//
//  Created by Henrique Velloso on 27/03/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding

class AuthenticateViewController: UIViewController {

    //MARK: - Properties
    private var viewModel = AuthenticationViewModel()
    var user: UserLocal?
    
    //MARK: - Outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var phoneNumberLabel: UILabel!
    @IBOutlet weak var verificationCodeText: UITextField!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var formContainer: UIView!
    
     //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNavigationBar()
        self.titleConfig()
        self.verificationCodeConfig()
        self.keyboardConfig()
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        self.verificationCodeText.text = ""
    }

    //MARK: - Custom functions
    
    func keyboardConfig() {
        KeyboardAvoiding.avoidingView = self.formContainer
    }
    
    func configNavigationBar() {
        self.navigationController?.navigationBar.setBackgroundImage(UIImage(), for: .default)
        self.navigationController?.navigationBar.shadowImage = UIImage()
        self.navigationController?.navigationBar.isTranslucent = true
        self.navigationController?.view.backgroundColor = .clear
        
        
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
        if let user = self.user {
            self.phoneNumberLabel.text = "\(user.countryCode!) \(user.number!)"
        }
    }
    
    func verificationCodeConfig() {
        
        if #available(iOS 12.0, *) {
            self.verificationCodeText.textContentType = .oneTimeCode
        }
        
        let color = UIColor(red: 118.0/255.0, green: 132.0/255.0, blue: 159.0/255.0, alpha: 0.7)
        self.verificationCodeText.attributedPlaceholder = NSAttributedString(string: self.verificationCodeText.placeholder!, attributes: [NSAttributedString.Key.foregroundColor: color])
        self.verificationCodeText.delegate = self
        self.verificationCodeText.becomeFirstResponder()
    }

    
    //MARK: - IBActions
    
    
    @IBAction func authenticateAction(_ sender: Any) {
        
        let verificationCode = self.verificationCodeText.text!
        guard let verificationID = self.user?.verificationID! else {
            self.showAlert(title: "Error", message: "Verification code is invalid.")
            return
        }
        
        if verificationCode.isEmpty {
            showAlert(title: "Requiered", message: "Verification code is requiered.")
        } else {
            
            self.loadingView.alpha = 0
            self.loadingView.isHidden = false
            
            UIView.animate(withDuration: 0.5) {
                self.loadingView.alpha = 1
            }
            
            
            self.viewModel.signInAndRetrieveData(verificationCode: verificationCode, verificationID: verificationID) { user, error in
                
                if let er = error {
                    self.showAlert(title: "Error", message: er.localizedDescription, buttonTitles: ["OK"], highlightedButtonIndex: 0, completion: { index in
                        UIView.animate(withDuration: 0.5) {
                            self.loadingView.alpha = 0
                        }
                    })
                } else {
                    self.performSegue(withIdentifier: "goToMessages", sender: user)
                }
                
            }
            
        }
        
    }
    
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    

}


extension AuthenticateViewController: UITextFieldDelegate {
    
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
