//
//  ViewController.swift
//  firebaseTestProj
//
//  Created by Michael  Murphy on 10/28/18.
//  Copyright © 2018 Michael  Murphy. All rights reserved.
//

import UIKit
import Firebase


class ViewController: UIViewController {

    @IBOutlet weak var quoteLbl: UILabel!
    @IBOutlet weak var quoteTextField: UITextField!
    @IBOutlet weak var authorTextField: UITextField!
    
    var docRef: DocumentReference!
    var quoteListener: ListenerRegistration!
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        docRef = Firestore.firestore().document("sampleData/inspiration")
    }
    
    
    @IBAction func fetchPressed(_ sender: UIButton) {
        docRef.getDocument { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else {return}
            let myData = docSnapshot.data()
            let latestQuote = myData?["quote"] as? String ?? ""
            let quoteAuthor = myData?["author"] as? String ?? ""
            self.quoteLbl.text = "\"\(latestQuote)\" -- \(quoteAuthor)"
         }
        
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        docRef.addSnapshotListener { (docSnapshot, error) in
            guard let docSnapshot = docSnapshot, docSnapshot.exists else {return}
            let myData = docSnapshot.data()
            let latestQuote = myData?["quote"] as? String ?? ""
            let quoteAuthor = myData?["author"] as? String ?? ""
            self.quoteLbl.text = "\"\(latestQuote)\" -- \(quoteAuthor)"
        }
        
    }
    
    
    override func viewDidDisappear(_ animated: Bool) {
        quoteListener.remove()
    }
    
    @IBAction func saveBtnPressed(_ sender: UIButton) {
        guard let quoteText = quoteTextField.text, !quoteText.isEmpty else {return}
        guard let quoteAuthor = quoteTextField.text, !quoteAuthor.isEmpty else {return}
        let dataToSave: [String: Any] = ["quote": quoteText, "author": quoteAuthor]
        docRef.setData(dataToSave) { (error) in
            print(error)
        }
        
        
        
    }
    

}

