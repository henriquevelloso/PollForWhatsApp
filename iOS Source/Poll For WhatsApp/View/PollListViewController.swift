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
    let refreshControl = UIRefreshControl()

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var newPollButton: TrueUIButton!
    @IBOutlet weak var loaderIndicator: UIActivityIndicatorView!
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initViewModel()
        self.configNavigationBar()
        self.configTableView()
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
    
    @objc func refreshTableView() {
        
        self.loaderIndicator.isHidden = true
        self.loadPollList()
    }
    
    func loadPollList() {
        
        UIView.animate(withDuration: 0.5) {
            self.loadingView.isHidden = false
            self.loadingView.alpha = 1
        }
        
        self.viewModel?.pollListRetrieveData(completionMain: { (polls, error) in
            
            self.polls = polls
            self.tableView.reloadData()
            
            UIView.animate(withDuration: 0.5, animations: {
                self.loadingView.alpha = 0
                self.tableView.alpha = 1
            }, completion: { _ in
                
                self.loadingView.isHidden = false
                self.refreshControl.endRefreshing()
            })
            
            if let err = error {
                self.showAlert(title: "Error", message: err.localizedDescription)
            }
            
        })
    }
    
    func configTableView() {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: self.tableView.width, height: 130))
        let imageHeader = UIImageView(image: UIImage(named: "tableViewheader"))
        imageHeader.contentMode = .scaleToFill
        headerView.addSubview(imageHeader)
        imageHeader.anchorCenterSuperview()
        imageHeader.topAnchor.constraint(equalTo: headerView.topAnchor, constant: 8).isActive = true
        imageHeader.bottomAnchor.constraint(equalTo: headerView.bottomAnchor, constant: -4).isActive = true
        imageHeader.leftAnchor.constraint(equalTo: headerView.leftAnchor, constant: 8).isActive = true
        imageHeader.rightAnchor.constraint(equalTo: headerView.rightAnchor, constant: -8).isActive = true
        
        self.tableView.alpha = 0
        self.tableView.tableFooterView = UIView()
        self.tableView.tableHeaderView = headerView
        let nibName = UINib(nibName: "PollTableViewCell", bundle: nil)
        self.tableView.register(nibName, forCellReuseIdentifier: "PollTableViewCell")
        self.tableView.refreshControl = refreshControl
        self.tableView.estimatedRowHeight = 80
        self.tableView.rowHeight = UITableView.automaticDimension
        
        self.refreshControl.addTarget(self, action: #selector(refreshTableView), for: .valueChanged)
        refreshControl.tintColor = UIColor.white
        self.refreshControl.attributedTitle = NSAttributedString(string: "Loading...", attributes: [.foregroundColor: UIColor.white])


    }
    
    
    // MARK: - Actions
    
    @IBAction func goToNewPollAction(_ sender: Any) {
        performSegue(withIdentifier: "goToNewPoll", sender: self)
    }
    

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
       
        if segue.identifier == "goToNewPoll"
        {
//            if let destinationVC = segue.destinationViewController as? OtherViewController {
//                destinationVC.numberToDisplay = counter
//            }
        }
        
    }
    
}


extension PollListViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let polls = self.polls {
            return polls.count
        }
        
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let polls = self.polls {
            
            let poll = polls[indexPath.item]
            let cell = self.tableView.dequeueReusableCell(withIdentifier: "PollTableViewCell", for: indexPath) as! PollTableViewCell
            cell.commonInit(title: poll.title!, voteCount: "\(poll.voteCount ?? 0)")
            cell.setVoteCountainerColor(voteCount: poll.voteCount ?? 0)
            cell.selectionStyle = .none
            return cell
        }
        
        
        return UITableViewCell()
    }
}
