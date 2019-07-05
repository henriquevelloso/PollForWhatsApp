//
//  NewPollViewController.swift
//  Poll For WhatsApp
//
//  Created by Henrique Velloso on 04/07/19.
//  Copyright © 2019 Henrique Velloso. All rights reserved.
//

import UIKit
import IHKeyboardAvoiding
import SwifterSwift

class NewPollViewController: UIViewController {

    //MARK: - Properties
    private var viewModel: NewPollViewModel?
    var user: UserLocal?
    var newPoll: Poll?
    
    var placeholderTitle = UILabel()
    var placeholderOptionA = UILabel()
    var placeholderOptionB = UILabel()
    var placeholderOptionC = UILabel()
    var placeholderOptionD = UILabel()
    var placeholderOptionE = UILabel()
    var placeholderOptionF = UILabel()
    
    //MARK: - Outlets
    @IBOutlet weak var pollQuestion: UILabel!
    @IBOutlet weak var pollTitle: UITextView!
    @IBOutlet weak var optionA: UITextView!
    @IBOutlet weak var optionB: UITextView!
    @IBOutlet weak var optionC: UITextView!
    @IBOutlet weak var optionD: UITextView!
    @IBOutlet weak var optionE: UITextView!
    @IBOutlet weak var optionF: UITextView!
    @IBOutlet weak var stack: UIStackView!
    @IBOutlet weak var loadingView: UIView!
    
    //MARK: - View life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configPlaceHolder()
        self.viewModel = NewPollViewModel(userLocal: self.user!)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        KeyboardAvoiding.avoidingView = self.stack
        KeyboardAvoiding.keyboardAvoidingMode = .maximum
    }
    
    //MARK: - Custom functions
    
    func configPlaceHolder(textView: UITextView, text: String, placeholder: UILabel) {
    
        textView.delegate = self
        placeholder.text = text
        placeholder.font = self.pollQuestion.font
        placeholder.sizeToFit()
        textView.addSubview(placeholder)
        
        placeholder.frame.origin = CGPoint(x: 5, y: (textView.font?.pointSize)! / 2)
        placeholder.textColor = UIColor(red: 53.0/255.0, green: 59.0/255.0, blue: 73.0/255.0, alpha: 0.35)
        placeholder.isHidden = !textView.text.isEmpty
        
    }
    
    func configPlaceHolder() {
    
        self.configPlaceHolder(textView: self.pollTitle, text: "write you poll question here", placeholder: self.placeholderTitle)
        self.configPlaceHolder(textView: self.optionA, text: "write your answer here", placeholder: self.placeholderOptionA)
        self.configPlaceHolder(textView: self.optionB, text: "write your answer here", placeholder: self.placeholderOptionB)
        self.configPlaceHolder(textView: self.optionC, text: "optional answer", placeholder: self.placeholderOptionC)
        self.configPlaceHolder(textView: self.optionD, text: "optional answer", placeholder: self.placeholderOptionD)
        self.configPlaceHolder(textView: self.optionE, text: "optional answer", placeholder: self.placeholderOptionE)
        self.configPlaceHolder(textView: self.optionF, text: "optional answer", placeholder: self.placeholderOptionF)
        
    }
    
    // MARK: - Actions
    
    @IBAction func dismissKeyboard(_ sender: UITapGestureRecognizer) {
        self.view.endEditing(true)
    }
    
    @IBAction func saveAction(_ sender: Any) {
    
        self.view.endEditing(true)
        
        if self.pollTitle.text!.isEmpty {
            showAlert(title: "Requiered", message: "Poll title is Requiered.", buttonTitles: ["OK"], highlightedButtonIndex: 0) { index in
                self.pollTitle.becomeFirstResponder()
            }
            return
        }
        
        if self.optionA.text!.isEmpty {
            showAlert(title: "Requiered", message: "Answer A is Requiered.", buttonTitles: ["OK"], highlightedButtonIndex: 0) { index in
                self.optionA.becomeFirstResponder()
            }
            return
        }
        
        if self.optionB.text!.isEmpty {
            showAlert(title: "Requiered", message: "Answer B is Requiered.", buttonTitles: ["OK"], highlightedButtonIndex: 0) { index in
                self.optionB.becomeFirstResponder()
            }
            return
        }
        
        UIView.animate(withDuration: 1, animations: {
            self.loadingView.alpha = 1
        })
        
        let options = [self.optionA.text.trim(), self.optionB.text.trim(), self.optionC.text.trim(), self.optionD.text.trim(), self.optionE.text.trim(), self.optionF.text.trim()]
        
        self.viewModel?.createNewPollData(poolTitle: self.pollTitle.text.trim(), pollOptions: options, completionMain: { (poll, error) in
            
            if let err = error {
                self.showAlert(title: "Ops", message: err.localizedDescription)
            } else {
                
                self.newPoll = poll
                self.performSegue(withIdentifier: "goToPollDetailNew", sender: self)
            }
            
            UIView.animate(withDuration: 1, animations: {
                self.loadingView.alpha = 0
            })
        })
        
        
    }
    
    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goToPollDetailNew"
        {
            if let destinationVC = segue.destination as? DetailPollViewController {
                destinationVC.user = self.user
                destinationVC.poll = self.newPoll
                destinationVC.isNewPoll = true
            }
        }
    }
    

}


extension NewPollViewController : UITextViewDelegate {
    func textViewDidChange(_ textView: UITextView) {
        placeholderTitle.isHidden = !pollTitle.text.isEmpty
        placeholderOptionA.isHidden = !optionA.text.isEmpty
        placeholderOptionB.isHidden = !optionB.text.isEmpty
        placeholderOptionC.isHidden = !optionC.text.isEmpty
        placeholderOptionD.isHidden = !optionD.text.isEmpty
        placeholderOptionE.isHidden = !optionE.text.isEmpty
        placeholderOptionF.isHidden = !optionF.text.isEmpty
    }
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        textView.returnKeyType = .done
        return true
    }
    
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        
        if text == "\n" {
            self.view.endEditing(true)
        }
        
        return true
    }
}
