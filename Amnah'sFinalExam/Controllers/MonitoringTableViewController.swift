//
//  MonitoringTableViewController.swift
//  Amnah'sFinalExam
//
//  Created by amnah alhwaiml on 11/06/1443 AH.
//

import UIKit
import Firebase

class MonitoringTableViewController: UITableViewController {
    var onlineEmails = [String]()
    
    @IBAction func LogOutButtonPressed(_ sender: UIBarButtonItem) {
//        var rowNum : Int
        for i in 0 ..< onlineEmails.count   {
            if onlineEmails[i] == UserDefaults.standard.value(forKey: "email") as! String {
                onlineEmails.remove(at: i)            }
        }
        do{
            
            try Auth.auth().signOut()
            Database.database().reference().child("OnlineEmails").setValue(onlineEmails)
//            let vc = LoginViewController()
//            let nav = UINavigationController(rootViewController: vc)
//            self.present(nav, animated: true , completion: nil)
            let nav = self.storyboard?.instantiateViewController(withIdentifier: "LoginNav") as! UINavigationController
            nav.modalPresentationStyle = .fullScreen
            present(nav , animated: true)
            print("LoggedOut")
            
            
            }catch let err{
                print(err)
            }
        
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        Database.database().reference().child("OnlineEmails").observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                if let value = snapshot.value as? NSArray {
                    value.forEach() {i in
                        print("i is \(i)")
                    let obj = i as! String


                        self.onlineEmails.append(obj)
                        
                        self.tableView.reloadData()
 }}
            }
         })
        { error in
         print(error.localizedDescription)
       }
        
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return onlineEmails.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = onlineEmails[indexPath.row] 
        return cell
    }
  

   

}
