//
//  LoginViewController.swift
//  Poll for WhatsApp
//
//  Created by Henrique Velloso on 26/03/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {
    
    //MARK: - Properties
    var user: User?
    
    //MARK: - Outlets
    @IBOutlet weak var introdutionLabel: UILabel!
    @IBOutlet weak var loginButton: TrueUIButton!
    
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        showButtonAnimation()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: animated)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
    }
    
    //MARK: - Custom functions
    
    func showButtonAnimation() {
        
        self.introdutionLabel.transform = CGAffineTransform(translationX: 0, y: 60)
        self.introdutionLabel.alpha = 0
        self.loginButton.alpha = 0
        
        UIView.animate(withDuration: 0.7, animations: { //0.7
            self.introdutionLabel.alpha = 1
        }) { _ in
            Timer.setTimeout(1.5, completion: { //1.5
                
                self.user = Auth.auth().currentUser
                if let user = self.user {
//                    self.presentNextViewController()
                    self.performSegue(withIdentifier: "goToPollListLogged", sender: user)
                } else {
                    UIView.animate(withDuration: 1.1, animations: { //1.1
                        self.loginButton.alpha = 1
                        self.introdutionLabel.transform = CGAffineTransform(translationX: 0, y:  0)
                    })
                }
            })
        }
    }
    
    func presentNextViewController() {
        
        let registerViewController = self.storyboard?.instantiateViewController(withIdentifier: "MessageTabBarController") as! UITabBarController
        self.present(registerViewController, animated: true)
    }
    
    //MARK: - IBActions
    @IBAction func goToPhoneViewController(_ sender: Any) {
        performSegue(withIdentifier: "goToPhoneNumber", sender: nil)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPhoneNumber" {
            let _ = segue.destination as! PhoneNumberViewController
        }
        
        if segue.identifier == "goToPollListLogged" {
       //     let _ = segue.destination as! SendMessageViewController
            
        }
    }
    
}
