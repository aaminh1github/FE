//
//  EditNSaveDelagate.swift
//  Amnah'sFinalExam
//
//  Created by amnah alhwaiml on 09/06/1443 AH.
//

import Foundation

protocol EditNSaveViewControllerDelegate: AnyObject{
    func itemSaved(by controller: EditNAddViewController, with text: String, at key: Int?)
    
}
