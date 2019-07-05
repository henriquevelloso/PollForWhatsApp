//
//  DetailPollViewController.swift
//  Poll For WhatsApp
//
//  Created by Henrique Velloso on 03/07/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import UIKit
import PieCharts
import Firebase

class DetailPollViewController: UIViewController {

    
    //MARK: - Properties
    private var viewModel: DetailPollViewModel?
    var user: UserLocal?
    var poll: Poll?
    var isNewPoll: Bool = false
    var chartList: [PieSliceModel] = []
    
    //MARK: - Outlets
    @IBOutlet weak var fontDefaultToGraph: UILabel!
    @IBOutlet weak var chartsCountainer: TrueUIView!
    @IBOutlet weak var spacer: UIView!
    @IBOutlet weak var deleteButton: TrueUIButton!
    @IBOutlet weak var okButton: TrueUIButton!
    
    @IBOutlet weak var chartView: PieChart!
    
    @IBOutlet weak var loadingView: UIView!
    
    @IBOutlet weak var polldateLabel: UILabel!
    @IBOutlet weak var pollQuestionLabel: UILabel!
    
    @IBOutlet weak var optionC: TrueUIView!
    @IBOutlet weak var optionD: TrueUIView!
    @IBOutlet weak var optionE: TrueUIView!
    @IBOutlet weak var optionF: TrueUIView!
    
    @IBOutlet weak var optionAText: UILabel!
    @IBOutlet weak var optionAVotes: UILabel!
    @IBOutlet weak var optionAVoteContainer: TrueUIView!
    
    @IBOutlet weak var optionBText: UILabel!
    @IBOutlet weak var optionBVotes: UILabel!
    @IBOutlet weak var optionBVoteContainer: TrueUIView!
    
    @IBOutlet weak var optionCText: UILabel!
    @IBOutlet weak var optionCVotes: UILabel!
    @IBOutlet weak var optionCVoteContainer: TrueUIView!
    
    @IBOutlet weak var optionDText: UILabel!
    @IBOutlet weak var optionDVotes: UILabel!
    @IBOutlet weak var optionDVoteContainer: TrueUIView!
    
    @IBOutlet weak var optionEText: UILabel!
    @IBOutlet weak var optionEVotes: UILabel!
    @IBOutlet weak var optionEVoteContainer: TrueUIView!
    
    @IBOutlet weak var optionFText: UILabel!
    @IBOutlet weak var optionFVotes: UILabel!
    @IBOutlet weak var optionFVoteContainer: TrueUIView!
    
    
        //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loadScreen()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        if self.isNewPoll {
            self.navigationItem.setHidesBackButton(true, animated:false)
            self.spacer.isHidden = true
            self.deleteButton.isHidden = true
            self.okButton.isHidden = false
        } else {
            self.navigationItem.setHidesBackButton(false, animated:false)
            self.spacer.isHidden = false
            self.deleteButton.isHidden = false
            self.okButton.isHidden = true
        }
    }
    
    //MARK: - Custom functions
    func loadScreen() {
                
        self.optionC.isHidden = true
        self.optionD.isHidden = true
        self.optionE.isHidden = true
        self.optionF.isHidden = true
        
        if self.isNewPoll {
            self.optionAVoteContainer.widthAnchor.constraint(equalToConstant: 0).isActive = true
            self.optionBVoteContainer.widthAnchor.constraint(equalToConstant: 0).isActive = true
            self.optionCVoteContainer.widthAnchor.constraint(equalToConstant: 0).isActive = true
            self.optionDVoteContainer.widthAnchor.constraint(equalToConstant: 0).isActive = true
            self.optionEVoteContainer.widthAnchor.constraint(equalToConstant: 0).isActive = true
            self.optionFVoteContainer.widthAnchor.constraint(equalToConstant: 0).isActive = true
            
            self.optionAVoteContainer.isHidden = true
            self.optionBVoteContainer.isHidden = true
            self.optionCVoteContainer.isHidden = true
            self.optionDVoteContainer.isHidden = true
            self.optionEVoteContainer.isHidden = true
            self.optionFVoteContainer.isHidden = true
        }
        
        if let poll = self.poll {
            
            if !self.isNewPoll {
                self.polldateLabel.text = "\(poll.voteCount!) votes on poll created on \(poll.creationDate!.string())"
            }
            self.pollQuestionLabel.text = self.poll?.title

            
            if let list = poll.optionList {
                
                
                
                for (index, option) in list.enumerated() {
                    
                    if index == 0 {
                        self.optionAText.text = option.title
                        self.optionAVotes.text = String(option.count!)
                        
                        let votes = Double(option.count!)
                        let color = UIColor(red: 115.0/255.0, green: 0.0/255.0, blue: 161.0/255.0, alpha: 1.0) //roxo
                        
                        
                        self.chartList.append(PieSliceModel(value: votes, color: color, obj: "A)"))
                        
                    }
                    
                    if index == 1 {
                        self.optionBText.text = option.title
                        self.optionBVotes.text = String(option.count!)
                        
                        let votes = Double(option.count!)
                        let color = UIColor(red: 39.0/255.0, green: 105.0/255.0, blue: 255.0/255.0, alpha: 1.0) //azul
                       
                        self.chartList.append(PieSliceModel(value: votes, color: color, obj: "B)"))
                    }
                    
                    if index == 2 {
                        self.optionC.isHidden = false
                        self.optionCText.text = option.title
                        self.optionCVotes.text = String(option.count!)
                        
                        let votes = Double(option.count!)
                        let color = UIColor(red: 255.0/255.0, green: 44.0/255.0, blue: 125.0/255.0, alpha: 1.0) //warren

                        self.chartList.append(PieSliceModel(value: votes, color: color, obj: "C)"))
                    }
                    
                    if index == 3 {
                        self.optionD.isHidden = false
                        self.optionDText.text = option.title
                        self.optionDVotes.text = String(option.count!)
                        
                        let votes = Double(option.count!)
                        let color = UIColor(red: 255.0/255.0, green: 219.0/255.0, blue: 14.0/255.0, alpha: 1.0) //amarelo

                        self.chartList.append(PieSliceModel(value: votes, color: color, obj: "D)"))
                    }
                    
                    if index == 4 {
                        self.optionE.isHidden = false
                        self.optionEText.text = option.title
                        self.optionEVotes.text = String(option.count!)
                        
                        let votes = Double(option.count!)
                         let color = UIColor(red: 0.0/255.0, green: 183.0/255.0, blue: 48.0/255.0, alpha: 1.0) //verde
                        self.chartList.append(PieSliceModel(value: votes, color: color, obj: "E)"))
                    }
                    
                    if index == 5 {
                        self.optionF.isHidden = false
                        self.optionFText.text = option.title
                        self.optionFVotes.text = String(option.count!)
                        
                        let votes = Double(option.count!)
                        let color = UIColor(red: 159.0/255.0, green: 248.0/255.0, blue: 255.0/255.0, alpha: 1.0) //clarinho
                        self.chartList.append(PieSliceModel(value: votes, color: color, obj: "F)"))
                    }
                }
            }
            
            if poll.voteCount > 0 {
                self.chartsCountainer.isHidden = false
                self.addCharts()
            } else {
                self.chartsCountainer.isHidden = true
            }
        }
        
    }
    
    func addCharts() {

        chartView.models.append(contentsOf: chartList)
        let textLineLayerSettings = PieLineTextLayerSettings()
        
        let formatter = NumberFormatter()
        formatter.maximumFractionDigits = 1
        textLineLayerSettings.label.font = self.fontDefaultToGraph.font //UIFont.systemFont(ofSize: 12)
         textLineLayerSettings.label.textColor = self.fontDefaultToGraph.textColor
        textLineLayerSettings.label.textGenerator = { slice in
            
            let option = slice.data.model.obj as! String
            return formatter.string(from: slice.data.percentage * 100 as NSNumber).map{"\(option) \($0)%"} ?? ""
            

        }
        
        let textLineLayer = PieLineTextLayer()
        textLineLayer.settings = textLineLayerSettings
        
        chartView.layers = [ textLineLayer]
    }
    
    func prepateContentToShare() -> String {
        let linkRaw = "https://us-central1-poll-for-whatsapp.cloudfunctions.net/pollApi"
        let linkAppstore = "http://apple.com"
        var messageDic : String = ""
        
        if let pollLocal = self.poll  {
            
            
            let messageHeader01 = "_You reveived a poll message from user: \(self.user!.number!)_\n________________________\n\n\n"
            let messagePollTitle02 = "*\(pollLocal.title!)*\n\n"
            let messageFooter04 = "\n________________________\n_This message was sent using the app 'Poll for WhatsApp' for iOS._"
            let messageFooter05 = "\n\(linkAppstore)"
            
            var messageOption03 = ""
            for option in pollLocal.optionList! {
                messageOption03 = messageOption03 + "*\(option.prefix ?? "")* \(option.title ?? "") [\(option.link ?? "")]\n\n"
            }
            
            messageDic.append(contentsOf: messageHeader01)
            messageDic.append(contentsOf: messagePollTitle02)
            messageDic.append(contentsOf: messageOption03)
            messageDic.append(contentsOf: messageFooter04)
            messageDic.append(contentsOf: messageFooter05)
        }
        
        return messageDic
        
    }
    
    
    // MARK: - Actions

    @IBAction func deletePollAction(_ sender: Any) {
        
        self.showAlert(title: "WARNING", message: "Do you really want to delete this poll?", buttonTitles: ["Cancel","YES!"], highlightedButtonIndex: 0) { (index) in
            if index == 1 {
                UIView.animate(withDuration: 1, animations: {
                        self.loadingView.alpha = 1
                })
                
                let db = Firestore.firestore()
                db.collection("users").document(self.user!.number!).collection("poll").document(self.poll!.documentId!).delete() { err in
                    if let err = err {
                        print("Error removing document: \(err)")
                        UIView.animate(withDuration: 1, animations: {
                            self.loadingView.alpha = 0
                            self.showAlert(title: "Ops", message: err.localizedDescription)
                        })
                    } else {
                        print("Document successfully removed!")
                        
                        self.navigationController?.popViewController()
                    }
                }
                
            }
        }
    }
    
    
    @IBAction func sharePollButton(_ sender: UIButton) {
        
        // text to share
        let text = self.prepateContentToShare()
        
        // set up activity view controller
        let textToShare = [ text ]
        let activityViewController = UIActivityViewController(activityItems: textToShare, applicationActivities: nil)
        activityViewController.popoverPresentationController?.sourceView = self.view // so that iPads won't crash
        activityViewController.setValue("WhatsApp", forKey: "subject")
        // exclude some activity types from the list (optional)
        
        activityViewController.excludedActivityTypes = [.airDrop, .print, .assignToContact, .saveToCameraRoll, .addToReadingList, .postToFlickr, .postToVimeo, .postToFacebook, .message, .postToWeibo, .mail, .openInIBooks, .addToReadingList, .postToLinkedIn, .addToiCloudDrive, .postToXing, UIActivity.ActivityType(rawValue: "com.apple.reminders.RemindersEditorExtension"), UIActivity.ActivityType(rawValue: "com.apple.mobilenotes.SharingExtension")]
        
        // present the view controller
        self.present(activityViewController, animated: true, completion: nil)
        
    }
    
    @IBAction func goToListAction(_ sender: Any) {
        performSegue(withIdentifier: "goToList", sender: self)
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    

}

extension DetailPollViewController: PieChartDelegate {
    func onSelected(slice: PieSlice, selected: Bool) {
        
    }
    
    
}
