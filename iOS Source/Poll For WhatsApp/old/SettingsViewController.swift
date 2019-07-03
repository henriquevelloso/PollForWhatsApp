//
//  SettingsViewController.swift
//  Poll for WhatsApp
//
//  Created by Henrique Velloso on 27/03/19. b
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import UIKit
import Firebase

class SettingsViewController: UIViewController {

    //MARK: - Properties
    
    //MARK: - Outlets
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configNavigationBar()
        // Do any additional setup after loading the view.
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
    
    //MARK: - IBActions

}
