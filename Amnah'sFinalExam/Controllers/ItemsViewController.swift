//
//  ItemsViewController.swift
//  Amnah'sFinalExam
//
//  Created by amnah alhwaiml on 09/06/1443 AH.
//

import UIKit
import Firebase
import SwiftUI

class ItemsViewController: UITableViewController, EditNSaveViewControllerDelegate {
    
    
    
    var CurrEmail = UserDefaults.standard.value(forKey: "email") as! String
    var onlineEmails = [String]()
    var items = [[String:String]]()
    var key : Int?
    override func viewDidLoad() {
        super.viewDidLoad()
        isLoggedIn()
        tableView.dataSource = self
        tableView.delegate = self
        
//        Database.database().reference().child("OnlineEmails").observeSingleEvent(of: .value, with: { snapshot in
//            if snapshot.exists() {
//                if let value = snapshot.value as? NSArray {
//                    value.forEach() {i in
//                        let obj = i as! String
//
//
//                        self.onlineEmails.append(obj)
//
//                        self.tableView.reloadData()
//                    }}
//            }
//        })
//        { error in
//            print(error.localizedDescription)
//        }
        
        Database.database().reference().child("items").observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                if let value = snapshot.value as? NSArray {
                    value.forEach() {i in
                        let obj = i as! NSDictionary
                        let name = obj["Item Name"] as? String ?? ""
                        print (name)
                        let uEmail = obj["User Email"] as? String ?? ""
                        self.items.append(["Item Name":name,
                                           "User Email":uEmail])
                        print(uEmail)
                        self.tableView.reloadData()

                    }}
            }
        }) { error in
            print(error.localizedDescription)
        }
        
//        print (onlineEmails)
    }
    func isLoggedIn(){
        if Auth.auth().currentUser == nil {
            //        let vc =  LoginViewController()
            //        let nav = UINavigationController(rootViewController: vc)
            //        nav.modalPresentationStyle = .fullScreen
            //        present(nav , animated: true)
            let nav = self.storyboard?.instantiateViewController(withIdentifier: "LoginNav") as! UINavigationController
            nav.modalPresentationStyle = .fullScreen
            present(nav , animated: true)
            //        ViewController(nav, animated: true)
            
            
        }
        
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "AddItemSegue"{
            let navigationController = segue.destination as! UINavigationController
            let EditNAddViewController = navigationController.topViewController as!  EditNAddViewController
            EditNAddViewController.delegate = self
        }
        else if segue.identifier == "EditItemSegue"{
            let navigationController = segue.destination as! UINavigationController
            let EditNAddViewController = navigationController.topViewController as! EditNAddViewController
            EditNAddViewController.delegate = self
            
            print("EditItemSegue")
            //             key = sender as? Int ?? 0
            
            print(key)
            if key != nil {
                //            if items[key!] != nil {
                print("items not nil")
                EditNAddViewController.item = items[key!]["Item Name"]
                EditNAddViewController.key = key}
            //            }
        }
    }
    
    
    //TableView Functions
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! ItemsTableViewCell
        cell.itemNameLable.text = items[indexPath.row]["Item Name"]
        cell.itemEmailLable.text = items[indexPath.row]["User Email"]
        return cell
    }
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        key = indexPath.row
        
        performSegue(withIdentifier: "EditItemSegue", sender: indexPath)
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        Database.database().reference().child("items").setValue(items)
        tableView.reloadData()
        key = indexPath.row
        
    }
    
    //delegate functions
    func itemSaved(by controller: EditNAddViewController, with text: String, at key: Int?){
        
        
        if let ip = key {
            items[ip]["Item Name"] = text
            items[ip]["User Email"] = CurrEmail
            //add to the firebase
            Database.database().reference().child("items").setValue(items)
            //add to the table view
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
        }
        else {
            var userDictionry = [String:String]()
            userDictionry["Item Name"] = text
            userDictionry["User Email"] = CurrEmail
            self.items.append(userDictionry)
            //add to the firebase
            Database.database().reference().child("items").setValue(items)
            //add to the table view
            self.tableView.reloadData()
            self.dismiss(animated: true, completion: nil)
            return
            
        }
        
    }
    
    
}


