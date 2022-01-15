//
//  LoginViewController.swift
//  Amnah'sFinalExam
//
//  Created by amnah alhwaiml on 09/06/1443 AH.
//

import UIKit
import Firebase
import JGProgressHUD

class LoginViewController: UIViewController {
    var onlineEmails = [String]()
    let spinner = JGProgressHUD.init(style: .dark)
    
    
    
    
    @IBOutlet weak var emailTF: UITextField!
    @IBOutlet weak var passwordTF: UITextField!
    
    @IBAction func logInButtonPressed(_ sender: UIButton) {
        guard let userEmail = emailTF.text,
              let userPass = passwordTF.text
        else{
            print("cannot Save login data")
            return
        }
        spinner.show(in: view)
        Auth.auth().signIn(withEmail: userEmail, password: userPass) {
            [weak self] AuthDataResult, Error in
            guard let strongSelf = self else{
                               return
                           }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss(animated: true)
            }
            guard let result = AuthDataResult, Error == nil else{
                print("faild to login\(Error)")
                return
            }
            let _ = result.user
            print("Logged in")
            UserDefaults.standard.setValue(strongSelf.emailTF.text, forKey: "email")
            strongSelf.onlineEmails.append(UserDefaults.standard.value(forKey: "email") as! String)
            Database.database().reference().child("OnlineEmails").setValue(strongSelf.onlineEmails)
            


           
               
                strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        
    }
    }
    override func viewDidLoad() {
        super.viewDidLoad()

        Database.database().reference().child("OnlineEmails").observeSingleEvent(of: .value, with: { snapshot in
            if snapshot.exists() {
                if let value = snapshot.value as? NSArray {
                    value.forEach() {i in
                    let obj = i as! String
                       
                        
                        self.onlineEmails.append(obj)
                        
                        
 }}
            }
         })
        { error in
         print(error.localizedDescription)
       }
    }
    



}
