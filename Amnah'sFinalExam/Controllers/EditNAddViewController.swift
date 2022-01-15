//
//  EditNAddViewController.swift
//  Amnah'sFinalExam
//
//  Created by amnah alhwaiml on 09/06/1443 AH.
//

import UIKit



class EditNAddViewController: UIViewController {
    
    
   
    
    @IBOutlet weak var addTextfeild: UITextField!
    var key : Int?
    var  item : String?
    weak var delegate : EditNSaveViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        addTextfeild.text = item
        // Do any additional setup after loading the view.
    }
    
    @IBAction func SaveButtonPressed(_ sender: UIButton) {
        guard let Oneitem = addTextfeild.text else {
            print ("Error saving New Item")
            return
        }
        delegate?.itemSaved(by: self, with: Oneitem, at: key)
       }


}
