//
//  ViewController.swift
//  Coredata Tutorial
//
//  Created by Ricardo Champa on 23/04/2018.
//  Copyright © 2018 Ricardo Champa. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {

    @IBOutlet weak var tableview: UITableView!
    
    var people: [NSManagedObject] = []


    override func viewDidLoad() {
        super.viewDidLoad()
        
        super.title = "My acquaintances"
        tableview.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        //1
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Person")
        
        //3
        do {
            people = try managedContext.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch. \(error), \(error.userInfo)")
        }
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?){
        
        if(segue.identifier == "segue_addperson") {
            
            let vc = (segue.destination as! AddPersonViewController)
            vc.delegate = self
        }
    }
}

extension ViewController: MyProtocol {
    func onNewPersonAdded(person: NSManagedObject) {
        people.append(person)
        tableview.reloadData()
    }
}

// MARK: - UITableViewDataSource
extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return people.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
            let person = people[indexPath.row]
            let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
            let name = person.value(forKeyPath: "name") as? String
            let age = person.value(forKeyPath: "age") as? Int
            let text = name! + " has " + String(age!) + " y.o."
            cell.textLabel?.text = text
            return cell
    }
}
