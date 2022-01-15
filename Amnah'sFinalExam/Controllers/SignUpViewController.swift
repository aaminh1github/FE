//
//  SignUpViewController.swift
//  Amnah'sFinalExam
//
//  Created by amnah alhwaiml on 09/06/1443 AH.
//

import UIKit
import JGProgressHUD
import Firebase

class SignUpViewController: UIViewController {

    
    let spinner = JGProgressHUD.init(style: .dark)
    var onlineEmails = [String]()
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var email: UITextField!
    
    
    @IBAction func registerButtonPressed(_ sender: Any) {
        guard let firstname  = firstName.text,
                let lastname = lastName.text,
                let userEmail = email.text,
        let userpass = password.text,
        !firstname.isEmpty,
        !lastname.isEmpty,
        !userEmail.isEmpty,
        !userpass.isEmpty
        
        else {
            print("errror saving the data")
            alertUserLoginError()
            return
        }
       DataBaseManager.shared.isExist(whith: userEmail, completion: {[weak self] availabl in
            guard let strongSelf = self else {
                return
            }
            guard !availabl else{
            strongSelf.alertUserLoginError(message: "the email is already exist")
                return}
        })
        spinner.show(in: view)
         Auth.auth().createUser(withEmail: userEmail, password: userpass, completion: {[weak self] authResult, error in
            guard let strongSelf = self else{
                              return
                          }
            DispatchQueue.main.async {
                strongSelf.spinner.dismiss(animated: true)
            }
                guard  authResult != nil , error == nil else {
                    print("Error cureating user\(error)")
                    return
                }
            
             DataBaseManager.shared.insert(with: Customer(firstName: firstname, lastName: lastname, emailAddress: userEmail))
             print("created user \(userEmail)")
             strongSelf.onlineEmails.append(UserDefaults.standard.value(forKey: "email") as! String )
             Database.database().reference().child("OnlineEmails").setValue(strongSelf.onlineEmails)
             
             
             UserDefaults.standard.setValue(strongSelf.email.text, forKey: "email")
 //            UserDefaults.standard.setValue("\(self.firstName) \(lastName)", forKey: "name")

             strongSelf.navigationController?.dismiss(animated: true, completion: nil)
        })
         
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
        // Do any additional setup after loading the view.
    }
    
    func alertUserLoginError(message: String = "Please enter all information to create a new account.") {
        let alert = UIAlertController(title: "Woops",
                                      message: message,
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title:"Dismiss",
                                      style: .cancel, handler: nil))
        present(alert, animated: true)
    }

}
