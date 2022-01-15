//
//  DatabaseManager.swift
//  Amnah'sFinalExam
//
//  Created by amnah alhwaiml on 09/06/1443 AH.
//

import Foundation
import FirebaseAuth
import FirebaseDatabase
import Firebase


struct Customer {
    var  firstName : String
    var lastName :String
    var emailAddress :String
    var items = [String]()
//    init (fName:String,SName:String,Email:String){
//      
//        firstName = fName
//        lastName = SName
//        emailAddress = Email
//    }
}
final class DataBaseManager {
   static var shared = DataBaseManager()
    private let database = Database.database().reference()
    
    
}
extension DataBaseManager {
    
        func insert (with user :Customer){
            var safeEmail = user.emailAddress.replacingOccurrences(of: "@", with: "_")
            safeEmail = safeEmail.replacingOccurrences(of: ".", with: "_")
            
            database.child(safeEmail).setValue(["first_name":user.firstName,
                           "last_name":user.lastName])
        }
    func addItem(email:String){
        let SafeEmail = safeEmail(email: email)
        
    }
        
    
    func delate(){
        
    }
    func edit(){
        
    }
    func safeEmail (email:String)->String{
        var safeEmail = email.replacingOccurrences(of: "@", with: "_")
        safeEmail = email.replacingOccurrences(of: ".", with: "_")
        return safeEmail
    }
    public func isExist(whith email:String, completion : @escaping ((Bool) -> Void)){
        let safeEmail = safeEmail(email: email)

        database.child(safeEmail).observeSingleEvent(of: .value , with: { snapshot in
            guard snapshot.value as? String != nil else {
                
                completion(false)
                return
            }
            completion(true)
        })
    }
    
}


