//
//  ViewController.swift
//  411-FinalProject
//
//  Created by Juan Cocina on 10/28/21.
//

import UIKit

class ViewController: UIViewController {

    // creating an outlet for the view
    @IBOutlet var tableView: UITableView!
    
    var taskLists = [String]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        self.title = "Task Lists"
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //setup
        if !UserDefaults().bool(forKey: "setup") { //if hasn't been set up, set defaults
            UserDefaults().set(true, forKey: "setup")
            UserDefaults().set(0, forKey: "count")
        }
        
        // get the saved tasks
        updateTasks()
    }
    
    //update the tasks
    func updateTasks() {
        //remove all before resetting
        taskLists.removeAll()
        
        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }
        //my issue with updating the amount of tasks is in this for loop
        for x in 0..<count {
            if let task = UserDefaults().value(forKey: "task_\(x+1)") as? String {
                //print("task")
                //print(task)
                taskLists.append(task)
            }
        }
        //load new tasks
        tableView.reloadData()
    }
    func taskRemoved(sending: String) {

        guard let count = UserDefaults().value(forKey: "count") as? Int else {
            return
        }

        // if the value in UserDefaults matches what was removed from the array
        // then remove that (issues with duplicate list titles)
        for x in 0..<count {
            if let task = UserDefaults().value(forKey: "task_\(x+1)") as? String {
                if task == sending {
                    UserDefaults().removeObject(forKey: "task_\(x+1)")
                    return
                }
            }
        }
    }
    
    @IBAction func didTappAdd() {
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "entry") as! EntryViewController
        vc.title = "New Task"
        vc.update = { //reload the tables
            DispatchQueue.main.async {
                self.updateTasks()
            }
        }
        navigationController?.pushViewController(vc, animated: true)
    }
    
    // DELETION
}

// adding extensions for ViewController
extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ViewController: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return taskLists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = taskLists[indexPath.row]
        
        return cell
    }
    
    //deleting a cell
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            tableView.beginUpdates()
            
            //delete from the array
            let sending: String = taskLists[indexPath.row]
            print(sending)
            
            taskLists.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
            
            taskRemoved(sending: sending)
        
            tableView.endUpdates()
        }
    }
}

