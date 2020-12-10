//
//  detailViewController.swift
//  Employee_Management
//
//  Created by SARDAR SAAB on 2020-12-08.
//

import UIKit
import CoreData
//    ------------------------Differentiator for making code readable--------------------------------

class detailViewController: UIViewController,UIImagePickerControllerDelegate , UINavigationControllerDelegate  {
    
    @IBOutlet weak var imgView: UIImageView! //added image outlet
    
    @IBOutlet weak var name: UITextField!//added name outlet
    
    @IBOutlet weak var year: UITextField!//added year outlet
    
    @IBOutlet weak var department: UITextField!//added department outlet
    
    @IBOutlet weak var SaveBtn: UIButton!//added saveBtn outlet
    
    
    var choosenId : UUID?
    
    var choosenName = ""
    
    var choosenDepartment = ""
    
    var choosenYearBirth = ""
    
    
    //    ------------------------Differentiator for making code readable--------------------------------
    
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        //for image tap function
        
              imgView.isUserInteractionEnabled = true // enables userInteraction
        
        let imgTapRecogniser = UITapGestureRecognizer(target: self, action: #selector(chooseImg)) // enables tap recognition
        
        imgView.addGestureRecognizer(imgTapRecogniser) //initialises image view data on load
                 getData() //initialises get data function on load
    }
    
    
    //    ------------------------Differentiator for making code readable--------------------------------
    
    @IBAction func btnSave(_ sender: UIButton) {
        
      let appdelegate = UIApplication.shared.delegate as! AppDelegate
        
        let context = appdelegate.persistentContainer.viewContext
        
        let newEmployee = NSEntityDescription.insertNewObject(forEntityName: "Employees" , into: context)
        
         //Saving STRING DATA into Database
        
        newEmployee.setValue(name.text!, forKey: "name")
        
        newEmployee.setValue(department.text!, forKey: "department")
        
        // Saving INT DATA into DataBase
        
        if let year = Int(year.text!){
            
            newEmployee.setValue(year, forKey: "yearBirth")
            
        }
        
         //Saving IMAGE DATA into Database
        let data = imgView.image?.jpegData(compressionQuality: 0.5)
        
        newEmployee.setValue(data, forKey: "image")
        
        
        //Saving ID DATA into Database
        
        newEmployee.setValue(UUID(), forKey: "id")
         do{
            
           try  context.save()
            
             print("Success Employee Saved SuccessFully")// if everything worked code compiler with print This text.
            
            }
         
         catch{
            print("Error") // if something did not worked code compiler with print error.
            
         }
        
        
        NotificationCenter.default.post(name: NSNotification.Name("newEmployee") , object: nil)
        //notification center used to recieve notifications
        
        
        navigationController?.popViewController(animated: true)
        //to see ViewController
        
        
    }
    
    
    //    ------------------------Differentiator for making code readable--------------------------------
    
    @objc func chooseImg(){ // function for choosing Image from UI Image View
        
       let chooseImg = UIImagePickerController()
        
        chooseImg.delegate = self
        
        chooseImg.sourceType = .photoLibrary // using photo library as a source for images
        
       present(chooseImg, animated: true, completion: nil) //presenting image into UI image view
        
    }
    
    //    ------------------------Differentiator for making code readable--------------------------------
    
    // IMAGE Function
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any])
    
    {
        imgView.image = info[.originalImage] as? UIImage
        
        dismiss(animated: true, completion: nil)
    }
    
    
    //    ------------------------Differentiator for making code readable--------------------------------
    
    
    
    //Function to get Data from Database
    func getData()
    {
        if choosenName != "" // if chooseName is not null
        {
            SaveBtn.isHidden = true // to disable editing Details into the database
            
            let myAppDelegate = UIApplication.shared.delegate as! AppDelegate
            
            let context = myAppDelegate.persistentContainer.viewContext
            
            let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Employees") // fetching request from database
            
            let idString = choosenId?.uuidString
            
          fetchRequest.predicate = NSPredicate(format: "id = %@", idString!)
            do
            {
                let results = try context.fetch(fetchRequest)
                
                if results.count > 0
                {
                    for result in results as! [NSManagedObject]
                    
                    {
                        if let imageData = result.value(forKey: "image") as? Data
                    {
                            imgView.image = UIImage(data: imageData) //displays Image Data into UIIMAGE view
                    }
                    
                        if let yearData = result.value(forKey: "yearBirth") as? Int
                    {
                            year.text = String(yearData)//displays YearBorn Data into text view
                    }
                    
                        if let nameData = result.value(forKey: "name") as? String
                    {
                        name.text = nameData//displays Name Data into text view
                    }
                    
                        if let departmentData = result.value(forKey: "department") as? String
                    {
                    
                        department.text = departmentData//displays Department Data into text view
                    }
                    }
                }
            }
                catch
                {
                    print("Error")// if something did not worked code compiler with print error.
                }
            
                }
                        else
                        {
                            SaveBtn.isHidden = false // this will enable save button again to Re-edit Data
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

