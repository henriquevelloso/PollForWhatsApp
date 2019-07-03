//
//  PollListViewController.swift
//  Poll For WhatsApp
//
//  Created by Henrique Velloso on 02/07/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import UIKit
import Firebase
import CountryKit
import IHKeyboardAvoiding
import SwifterSwift

class PollListViewController: UIViewController {
    
    
    //MARK: - Properties
    private var viewModel: PollListViewModel?
    var user: UserLocal?
    var polls: [Poll]?
    
    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initViewModel()
        self.configNavigationBar()
        self.loadPollList()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
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
    
    func initViewModel() {
        
        if let user = self.user {
            self.viewModel = PollListViewModel(userLocal: user)
        } else {
            self.user = UserLocal(userId: nil, number: Auth.auth().currentUser?.phoneNumber, countryCode: nil, verificationID: nil, authenticationCode: nil)
            self.viewModel = PollListViewModel(userLocal: self.user!)
        }
    }
    
    func loadPollList() {
        self.viewModel?.pollListRetrieveData(completionMain: { (polls, error) in
            
            self.polls = polls
            
        })
    }
    
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    
}


extension PollListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    
}
