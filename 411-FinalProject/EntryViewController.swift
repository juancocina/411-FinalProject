//
//  EntryViewController.swift
//  411-FinalProject
//
//  Created by Juan Cocina on 11/9/21.
//

import UIKit

class EntryViewController: UIViewController,  UITextFieldDelegate{
    
    var update: (()-> Void)?
    
    @IBOutlet var field: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        field.delegate = self
        
        // programming the button that saves tasks
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .done, target: self, action: #selector(saveTask))
        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        saveTask()
        
        return true
    }

    @objc func saveTask() {
        guard let text = field.text, !text.isEmpty else {
            return
        }
        //save tasks
        guard let count = UserDefaults().value(forKey: "count") as? Int else{
            return
        }//keep track of tasks
        let newCount = count + 1
        
        UserDefaults().set(newCount, forKey: "count") //update the count
        UserDefaults().set(text, forKey: "task_\(newCount)")
        
        //updates ViewController
        update?()
        navigationController?.popViewController(animated: true)
        
        
    }

}
