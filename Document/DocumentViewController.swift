//
//  DocumentViewController.swift
//  Document
//
//  Created by Alex Davis on 8/28/19.
//  Copyright © 2019 Alex Davis. All rights reserved.
//

import UIKit

class DocumentViewController: UIViewController {

    @IBOutlet weak var docTableView: UITableView!
    
    let fileManager = FileManager.default
    var documents: [Document] = []
    let dateFormatter = DateFormatter()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        docTableView.dataSource = self
        docTableView.delegate = self
        
        dateFormatter.dateStyle = .short
        dateFormatter.timeStyle = .short
        
        let documentsURL = fileManager.urls(for: .documentDirectory, in: .userDomainMask)[0].path
       
        if !fileManager.changeCurrentDirectoryPath(documentsURL) {
            fatalError("Could not open application document directory!")
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        super.viewWillAppear(animated)
        documents.removeAll()
        
        do {
            for fileName in try fileManager.contentsOfDirectory(atPath: ".") {
                let attributes = try fileManager.attributesOfItem(atPath: fileName)
                documents.append(Document(name: fileName, size: attributes[FileAttributeKey.size] as! Int, lastModified: attributes[FileAttributeKey.modificationDate] as! Date))
            }
        } catch {
            print(error.localizedDescription)
        }
        
        docTableView.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if let selected = docTableView.indexPathForSelectedRow, let destination = segue.destination as? AddDocViewController {
            let document = documents[selected.row]
            destination.document = document
        }
    }
}

extension DocumentViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        return documents.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
       
        let cell = tableView.dequeueReusableCell(withIdentifier: "DocCell", for: indexPath) as! DocumentsCellTableViewCell
        
        let document = documents[indexPath.row]
        
        cell.NameLabel.text = document.name
        cell.SizeLabel.text = "\(document.size) bytes"
        cell.TimeLabel.text = "Last Modified: \(dateFormatter.string(from: document.lastModified))"
        
        return cell
    }
}

extension DocumentViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive, title: "Delete") { (ac: UIContextualAction, view: UIView, success: (Bool) -> Void) in
            let document = self.documents[indexPath.row]
            do {
                try self.fileManager.removeItem(atPath: document.name)
                self.documents.remove(at: indexPath.row)
                success(true)
                self.docTableView.reloadData()
            } catch {
                print(error.localizedDescription)
                success(false)
            }
        }
        
        return UISwipeActionsConfiguration(actions: [deleteAction])
    
    }
}
