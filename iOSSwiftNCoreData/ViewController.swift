//
//  ViewController.swift
//  iOSSwiftNCoreData
//
//  Created by iPramodSinghRawat on 14/03/18.
//  Copyright © 2018 iPramodSinghRawat. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UISearchBarDelegate {
    
    var vehicles = [Vehicle]()
    var filterVehicles = [Vehicle]()
    
    let cellIdentifier = "Cell"
    
    @IBOutlet weak var vehiclesTableView: UITableView!
    @IBOutlet weak var vehicleSearchBar: UISearchBar!
    var searchActive : Bool = false
    
    var coreDataDBObj = CoreDataDB();
    //var vehicle: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //var vehicle1 = Vehicle(type: "bike",brand: "Yamaha",model: "RX135",engineCapacity: 135)
        
        //coreDataDBObj.putVehicleInLocalDB(vehicle_obj: vehicle1)
        self.navigationController?.isToolbarHidden = true

        self.vehiclesTableView.delegate = self
        self.vehiclesTableView.dataSource = self
        self.vehicleSearchBar.delegate = self
        
        self.loadSampleData()
        
    }
    
    func getContext () -> NSManagedObjectContext {
        
        //let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        return appDelegate.persistentContainer.viewContext
    }
    
    private func loadSampleData() {

        //1
        let managedContext = getContext();
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Vehicles")
        
        let sectionSortDescriptor = NSSortDescriptor(key: "id", ascending: true)
        let sortDescriptors = [sectionSortDescriptor]
        fetchRequest.sortDescriptors = sortDescriptors
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)            
            //print("Total Records : " + String(results.count))
            
            if(results.count>0){
                for var j in (0..<results.count){
                    
                    let vehicleId:Int16=((results[j] as AnyObject).value(forKey: "id") as! Int16?)!
                    let c_type:String=((results[j] as AnyObject).value(forKey: "type") as! String?)!
                    let c_brand:String=((results[j] as AnyObject).value(forKey: "brand") as! String?)!
                    let c_model:String=((results[j] as AnyObject).value(forKey: "model") as! String?)!
                    let c_engine_capacity:Int16=((results[j] as AnyObject).value(forKey: "engine_capacity") as! Int16?)!
                    
                    guard let vehicle_var:Vehicle = Vehicle(
                        id:Int16(vehicleId),
                        type: c_type,
                        brand: c_brand,
                        model: c_model,
                        engineCapacity: Int16(c_engine_capacity)) else {
                            fatalError("Unable to instantiate")
                    }
                    vehicles += [vehicle_var]
                }
                filterVehicles = vehicles
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
    }
    
    @IBAction func go2AddNewVehicle(){
        
        let alertController = UIAlertController(title: "Enter details?", message: "Enter your Vehicle Details", preferredStyle: .alert)
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            let typebx = alertController.textFields?[0].text
            let brandbx = alertController.textFields?[1].text
            let modelbx = alertController.textFields?[2].text
            let engineCapacitybx = alertController.textFields?[3].text
            
            //self.labelMessage.text = "Name: " + name! + "Email: " + email!
            
            let vehicleIn = Vehicle(type: typebx!,brand: brandbx!,model: modelbx!,engineCapacity: Int16(engineCapacitybx!)!)
            
            self.coreDataDBObj.putVehicleInLocalDB(vehicle_obj: vehicleIn)
            
            self.vehicles.removeAll()
            self.loadSampleData()
            DispatchQueue.main.async() {
                self.vehiclesTableView.reloadData()
            }
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Type"
            textField.keyboardType = .default
            textField.clearButtonMode = .whileEditing
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Brand"
            textField.clearButtonMode = .whileEditing
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Model"
            textField.clearButtonMode = .whileEditing
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Engine Capacity"
            textField.keyboardType = .numberPad
            textField.clearButtonMode = .whileEditing
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        if(searchActive) {
            return filterVehicles.count
        } else {
            return vehicles.count
        }
    }
    
    func editVehicle(vehicle: Vehicle){
        
        let alertController = UIAlertController(title: "Enter details?", message: "Enter your Vehicle Details", preferredStyle: .alert)
        //the confirm action taking the inputs
        let confirmAction = UIAlertAction(title: "Enter", style: .default) { (_) in
            
            //getting the input values from user
            let typebx = alertController.textFields?[0].text
            let brandbx = alertController.textFields?[1].text
            let modelbx = alertController.textFields?[2].text
            let engineCapacitybx = alertController.textFields?[3].text
            
            //self.labelMessage.text = "Name: " + name! + "Email: " + email!
            
            let vehicleIn = Vehicle(id:vehicle.id!, type: typebx!,brand: brandbx!,model: modelbx!,engineCapacity: Int16(engineCapacitybx!)!)
            
            //self.coreDataDBObj.putVehicleInLocalDB(vehicle_obj: vehicleIn)
            
            self.coreDataDBObj.updateVehicleData(vehicle: vehicleIn)
            
            self.vehicles.removeAll()
            self.loadSampleData()
            DispatchQueue.main.async() {
                self.vehiclesTableView.reloadData()
            }
            
        }
        
        //the cancel action doing nothing
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in }
        
        //adding textfields to our dialog box
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Type"
            textField.text = vehicle.type
            textField.keyboardType = .default
            textField.clearButtonMode = .whileEditing
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Brand"
            textField.text = vehicle.brand
            textField.clearButtonMode = .whileEditing
        }
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Enter Model"
            textField.text = vehicle.model
            textField.clearButtonMode = .whileEditing
        }
        
        alertController.addTextField { (textField) in
            //let ecap:String = String(describing: vehicle.engineCapacity) as String
            
            textField.placeholder = "Enter Engine Capacity"
            textField.text = "\(vehicle.engineCapacity ?? 0)"
            textField.keyboardType = .numberPad
            textField.clearButtonMode = .whileEditing
        }
        
        //adding the action to dialogbox
        alertController.addAction(confirmAction)
        alertController.addAction(cancelAction)
        
        //finally presenting the dialog box
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    /*start: Sliding options*/
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        
        let vehicle:Vehicle = vehicles[indexPath.row]
        var indrow = indexPath.row as Int?
        //print(indexPath?.row)
        print("Row data Clicked \(indrow) \n")
        
        var vehicle_brand = vehicles[indrow!].brand
        var r_id = vehicles[indrow!].id as! Int16
        var fr_id:String = String(r_id)
        
        let editSlideOpt = UITableViewRowAction(style: .normal, title: "Edit") { action, index in
            print("Edit button for : \(vehicle) Edit")
            self.editVehicle(vehicle: vehicle)
        }
        editSlideOpt.backgroundColor = .blue
        
        let delete = UITableViewRowAction(style: .normal, title: "Delete") { action, index in
            
            print("Delete button for : \(vehicle) tapped")
            
            let refreshAlert = UIAlertController(title: "Delete", message: "This Record Will Be Deleted", preferredStyle: UIAlertControllerStyle.alert)
            refreshAlert.addAction(UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction!) in
                self.deleteAVehicleRecord(id: r_id)
            }))
            refreshAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: { (action: UIAlertAction!) in
            }))
            self.present(refreshAlert, animated: true, completion: nil)
            
        }
        delete.backgroundColor = .red
        
        return [delete,editSlideOpt]
    }
    
    func deleteAVehicleRecord(id: Int16){
        
        self.coreDataDBObj.deleteARecord(id: id)
        
        self.vehicles.removeAll()
        self.loadSampleData()
        DispatchQueue.main.async() {
            self.vehiclesTableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as? VehiclesTableViewCell  else {
            fatalError("The dequeued cell is not an instance of MealTableViewCell.")
        }
        
        let vehicle:Vehicle
        
        if(searchActive) {
            vehicle = filterVehicles[indexPath.row]
        } else {
            vehicle = vehicles[indexPath.row]
        }
        
        cell.typeTxtLbl.text = vehicle.type
        cell.brandTxtLbl.text = vehicle.brand
        cell.modelTxtLbl.text = vehicle.model
        cell.engineCapacityTxtLbl.text = "\(vehicle.engineCapacity ?? 0)"
        
        return cell
    }
    
    func searchBarTextDidBeginEditing(_ searchBar: UISearchBar) {
        searchActive = true;
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        searchActive = false;
        self.vehicleSearchBar.endEditing(true)
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.vehicleSearchBar.endEditing(true)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        searchActive = false;
        self.vehicleSearchBar.endEditing(true)
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        
        filterVehicles = vehicles.filter { ($0.brand?.localizedCaseInsensitiveContains(searchText))! }
        
        if(filterVehicles.count == 0){
            searchActive = false;
        } else {
            searchActive = true;
        }
        self.vehiclesTableView.reloadData()
    }

}

