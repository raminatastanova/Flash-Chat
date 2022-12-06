//
//  ChatViewController.swift
//  Flash Chat iOS13
//
//  Created by Angela Yu on 21/10/2019.
//  Copyright © 2019 Angela Yu. All rights reserved.
//

import UIKit
import FirebaseCore
import FirebaseFirestore
import FirebaseAuth

class ChatViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var messageTextfield: UITextField!
    //reference to database
    let db = Firestore.firestore()
    
    var messages: [Message] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        title = K.appName
        navigationItem.hidesBackButton = true
        //register my nib file
        tableView.register(UINib(nibName: K.cellNibName, bundle: nil), forCellReuseIdentifier: K.cellIdentifier)
        
loadMessages ()
    }
    
    //get all current data that we have inside our database
    func loadMessages() {
     
        //tap into our database
        db.collection(K.FStore.collectionName)
            .order(by: K.FStore.dateField)
            .addSnapshotListener { (querySnapshot, error) in
            //clear all messages
            self.messages = []
            if let e = error {
                print("There is an issue retrieving data from a firestore \(e)")
            } else {
                if let snapshotDocuments = querySnapshot?.documents {
                    for doc in snapshotDocuments {
                        let data = doc.data()
                        if let messageSender = data[K.FStore.senderField] as? String, let messageBody = data[K.FStore.bodyField] as? String {
                            let newMessage = Message(sender: messageSender, body: messageBody)
                            self.messages.append(newMessage)
                            
                            DispatchQueue.main.async {
                                self.tableView.reloadData()
                                let indexPath = IndexPath (row: self.messages.count - 1, section: 0)
                                self.tableView.scrollToRow(at: indexPath, at: .top, animated: true)
                            }
                            
                        }
                    }
                }
            }
        }
        
    }
    @IBAction func sendPressed(_ sender: UIButton) {
        if let messageBody = messageTextfield.text, let messageSender = Auth.auth().currentUser?.email {
            //send data to FirebaseFirestore
            db.collection(K.FStore.collectionName).addDocument(data:
            [K.FStore.senderField: messageSender,
             K.FStore.bodyField: messageBody,
             K.FStore.dateField: Date().timeIntervalSince1970
            ]){ (error) in
                if let e = error {
                    print("There is a issue with saving data to firestore, \(e)")
                } else {
                    print("Successfully saved data")
                    DispatchQueue.main.async {
                        self.messageTextfield.text = ""

                    }
                }
            }
        }
        
        
    }
    
    @IBAction func logOutPressed(_ sender: UIBarButtonItem) {
        //let firebaseAuth = Auth.auth()
    do {
      //try firebaseAuth.signOut()
        try Auth.auth().signOut()
        navigationController?.popToRootViewController(animated: true)
    } catch let signOutError as NSError {
      print("Error signing out: %@", signOutError)
    }
      
    }
    
}
//UITableViewDataSource is more about telling how many cells and which cells put into tableView
extension ChatViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    //indexpath is the position
    func tableView(_ tableView: UITableView, cellForRowAt indexPath:
                   IndexPath) -> UITableViewCell {
        let message = messages[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: K.cellIdentifier, for: indexPath)
       //to cast reusable cell as MessageCell Class
        as! MessageCell
        cell.label.text = message.body
        
        
        //this is a message from current logged in user
        if message.sender == Auth.auth().currentUser?.email {
            cell.leftImageView.isHidden = true
            cell.rightImageView.isHidden = false
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.lightPurple)
            cell.label.textColor = UIColor(named: K.BrandColors.purple)
        }
        //message from another sender
        else {
            cell.leftImageView.isHidden = false
            cell.rightImageView.isHidden = true
            cell.messageBubble.backgroundColor = UIColor(named: K.BrandColors.purple)
            cell.label.textColor = UIColor(named: K.BrandColors.lightPurple)
        }
       
        return cell
    }
    
    
}
