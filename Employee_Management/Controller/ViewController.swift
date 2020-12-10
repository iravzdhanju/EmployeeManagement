//
//  ViewController.swift
//  Employee_Management
//
//  Created by SARDAR SAAB on 2020-12-08.
//

import UIKit//importing UI kit

import CoreData // importing core data

class ViewController: UIViewController ,
                      UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var tableView: UITableView!//Outlet of UITABLE VIEW
    
    // declaring variables to store data
    var NameArray = [String]()
    
    var idArray = [UUID]()
    
    var IdChoosen : UUID?
    
    
    //    ------------------------Differentiator for making code readable--------------------------------
    var NameChoosen = ""
    
    var YearBirthChoosen = ""
    
    var DepartmentChoosen = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.navigationBar.topItem?.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add
                 , target: self , action: #selector(addButtonPressed)) // implementing ADD Button with code
        
        tableView.delegate = self
        
        tableView.dataSource = self
        
        viewData() //initiliazing view data Function
    }
    
    
    //    ------------------------Differentiator for making code readable--------------------------------
    
    override func viewWillAppear(_ animated: Bool)
    {
        //notification center used to recieve notifications from database
        
        NotificationCenter.default.addObserver(self, selector: #selector(viewData), name: NSNotification.Name("newEmployee"), object: nil)//database source
    }
    

    //    ------------------------Differentiator for making code readable--------------------------------
    
    
    
    @objc func addButtonPressed(){
        
        performSegue(withIdentifier: "toDetailView", sender: nil) //performing Segue to different Views
        
       }
    //    ------------------------Differentiator for making code readable--------------------------------
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return NameArray.count // Returning Array Count
    }
    
    //    ------------------------Differentiator for making code readable--------------------------------
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = NameArray[indexPath.row]
        
        return cell // returning cell text
    }
    
    //    ------------------------Differentiator for making code readable--------------------------------
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //populating values
        
        IdChoosen = idArray[indexPath.row]
        
        NameChoosen = NameArray[indexPath.row]
        
        performSegue(withIdentifier: "toDetailView", sender: nil) //performing segue when success
    }
    
    
    //    ------------------------Differentiator for making code readable--------------------------------
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?)
    {
        //populating values to table view
        
        if segue.identifier == "toDetailView"
        {
            let destinations = segue.destination as! detailViewController
            
            destinations.choosenId = IdChoosen
            
            destinations.choosenName = NameChoosen
            
            destinations.choosenDepartment = DepartmentChoosen
            
            destinations.choosenYearBirth = YearBirthChoosen
        }
    }
    
   // ------------------------Differentiator for making code readable--------------------------------
    
    @objc func viewData()
    {// viewing saved data from the database
        
        //removing catche from variables
        
        idArray.removeAll(keepingCapacity: false)
        
        NameArray.removeAll(keepingCapacity: false)
        
        let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
        
        
        let context = myAppDelegate.persistentContainer.viewContext
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees") //fetching details from the database to display in UITable View
        
        do
        {
            let results = try context.fetch(fetchRequest) // fetching request from database
            
            if results.count > 0
            {
                for result in results as! [NSManagedObject]
                {
                    if let id = result.value(forKey: "id") as? UUID
                    {
                        idArray.append(id) // adding elements into IdArray
                    }
                    
                    if let name = result.value(forKey: "name") as? String
                    {
                        NameArray.append(name)// adding elements into NameArray
                    }
                    
                    tableView.reloadData() //reloading Table
                }
            }
        }
        catch
        {
            print("Error")// if something did not worked code compiler with print error.
        }
    }
    
    
    
    //    ------------------------Differentiator for making code readable--------------------------------
    
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath)
    {
        if editingStyle == .delete // deleting data
        {
            let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            
            let context = myAppDelegate.persistentContainer.viewContext
            
            let theFetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees") //fetching details from the database to display in UITable View
            
            let idString = idArray[indexPath.row].uuidString
            
            theFetchRequest.predicate = NSPredicate(format: "id = %@", idString)
            
            do
            {
                let results = try context.fetch(theFetchRequest)//fetching requests
                
                if results.count > 0
                {
                    for result in results as! [NSManagedObject]
                    {
                        if let id = result.value(forKey: "id") as? UUID
                        {
                            if id == idArray[indexPath.row]
                            {//deleting data from table View
                                context.delete(result)
                                
                                idArray.remove(at: indexPath.row)
                                
                                NameArray.remove(at: indexPath.row)
                                
                                tableView.reloadData()
                                
                                do
                                {
                                    try context.save()//function to save data into UiTable View
                                    
                                }
                                catch
                                {
                                    
                                    print("Error")// if something did not worked code compiler with print error.
                                }
                                break
                            }
                        }
                    }
                }
            }
                                catch
                                {
                                    print("Error")// if something did not worked code compiler with print error.
                                }
        }

}
    
}
//    ----------------------------END----------------------------

//Ravinderpal Singh
//1912283

//CHecklist
//----------------------------------------------------------
//A table view and add button,[done]
//• When user click on Add button it will redirect to second page.[done]
//At the top of the page you have an image view for entering the employee photo.[done]
//• Three text fields for entering name, department and year of birth[done]
//• A button to save these details.[done]
//• A back button to navigate back to first page.[done]
//All the data (photo, name, department, year of birth) should save in database.[done]
//• Close the second page and return to first page and employee’s name should display in table
//view.[done]
