//
//  AddPersonViewController.swift
//  Coredata Tutorial
//
//  Created by Ricardo Champa on 23/04/2018.
//  Copyright © 2018 Ricardo Champa. All rights reserved.
//

import UIKit
import CoreData

protocol MyProtocol {
    func onNewPersonAdded(person: NSManagedObject)
}

class AddPersonViewController: UIViewController {

    @IBOutlet weak var tf_name: UITextField!
    @IBOutlet weak var tf_age: UITextField!
    
    var delegate : MyProtocol?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.title = "Add new person"
        
    }
    
    @IBAction func addPerson(_ sender: UIBarButtonItem) {
        
        let name = tf_name.text!;
        let age = Int(tf_age.text!)!;
        
        self.save(name: name, age: age)
    }
    
    func save(name: String, age: Int) {
        
        guard let appDelegate =
            UIApplication.shared.delegate as? AppDelegate else {
                return
        }
        
        // 1
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // 2
        let entity = NSEntityDescription.entity(forEntityName: "Person", in: managedContext)!
        let person = NSManagedObject(entity: entity, insertInto: managedContext)
        
        // 3
        person.setValue(name, forKeyPath: "name")
        person.setValue(age, forKeyPath: "age")
        
        // 4
        do {
            try managedContext.save()
            
            if let optional_delegate = self.delegate {
                optional_delegate.onNewPersonAdded(person: person)
            }
            self.navigationController?.popViewController(animated: true)
            
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }

}
