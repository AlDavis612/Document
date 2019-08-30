//
//  AddDocViewController.swift
//  Document
//
//  Created by Alex Davis on 8/29/19.
//  Copyright © 2019 Alex Davis. All rights reserved.
//

import UIKit

class AddDocViewController: UIViewController {

    @IBOutlet weak var NameField: UITextField!
    @IBOutlet weak var TextViewField: UITextView!
    
    var document: Document?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        guard let document = document else {
            return
        }
        
        NameField.text = document.name
        if let dataBuffer = FileManager.default.contents(atPath: document.name) {
            TextViewField.text = String(data: dataBuffer, encoding: .utf8) ?? ""
        }
    }
    
    @IBAction func SaveButton(_ sender: Any) {
       guard let FileName = TextViewField.text, FileName.count > 0, let content = TextViewField.text, content.count > 0 else {
            return
            }
        
        FileManager.default.createFile(atPath: FileName, contents: content.data(using: .utf8), attributes: nil)
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func EditName(_ sender: Any) {
        self.title = NameField.text ?? "Add Document"
    }
    

}
