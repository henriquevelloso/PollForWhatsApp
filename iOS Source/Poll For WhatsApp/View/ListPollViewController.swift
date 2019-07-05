//
//  ListPollViewController.swift
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

class ListPollViewController: UIViewController {
    
    
    //MARK: - Properties
    private var viewModel: ListPollViewModel?
    var user: UserLocal?
    var polls: [Poll]?
    let refreshControl = UIRefreshControl()
    var selectedIndex: Int?

    //MARK: - Outlets
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var loadingView: UIView!
    @IBOutlet weak var newPollButton: TrueUIButton!
    @IBOutlet weak var loaderIndicator: UIActivityIndicatorView!
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loaderIndicator.isHidden = false
        self.loaderIndicator.startAnimating()
        
        self.initViewModel()
        self.configNavigationBar()
        self.configTableView()
        self.loadPollList()
        
    }
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(false, animated: animated)
        
        self.loaderIndicator.isHidden = false
        self.loaderIndicator.startAnimating()
//        self.newPollButton.alpha = 0
//        self.tableView.alpha = 0
        self.loadPollList()
        
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
            self.viewModel = ListPollViewModel(userLocal: user)
        } else {
            
            let phoneNumber = Auth.auth().currentUser?.phoneNumber?.removingPrefix("+")
            
            self.user = UserLocal(userId: nil, number: phoneNumber, countryCode: nil, verificationID: nil, authenticationCode: nil)
            self.viewModel = ListPollViewModel(userLocal: self.user!)
        }
    }
    
    @objc func refreshTableView() {
        
        self.loaderIndicator.isHidden = true
        self.loadPollList()
    }
    
    func loadPollList() {
        
        UIView.animate(withDuration: 0.3) {
            self.loadingView.isHidden = false
            self.loadingView.alpha = 1
        }
        
        self.viewModel?.pollListRetrieveData(completionMain: { (polls, error) in

            self.polls = polls
            self.tableView.reloadData()

            UIView.animate(withDuration: 0.3, animations: {
                self.loadingView.alpha = 0
                self.tableView.alpha = 1
                self.newPollButton.alpha = 1
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
            if let destinationVC = segue.destination as? NewPollViewController {
                destinationVC.user = self.user
            }
        } else if  segue.identifier == "goToPollDetail" {
            if let destinationVC = segue.destination as? DetailPollViewController {
                destinationVC.user = self.user
                if let ps = self.polls {
                    destinationVC.poll = ps[self.selectedIndex!]
                }
                destinationVC.isNewPoll = false
            }
        }
        
    }

}

// MARK: - TableView delegates
extension ListPollViewController: UITableViewDelegate, UITableViewDataSource {
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
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.selectedIndex = indexPath.item
        performSegue(withIdentifier: "goToPollDetail", sender: self)
        
    }
}
