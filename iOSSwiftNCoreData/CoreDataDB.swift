//
//  CoreDataDB.swift
//  iOSSwiftNCoreData
//
//  Created by iPramodSinghRawat on 14/03/18.
//  Copyright © 2018 iPramodSinghRawat. All rights reserved.
//

import UIKit
import CoreData

class CoreDataDB{

    let vehicleTable="Vehicles"
    let appDelegate:AppDelegate
    
    init(){
        appDelegate = UIApplication.shared.delegate as! AppDelegate
    }
    
    func getContext () -> NSManagedObjectContext {
        return appDelegate.persistentContainer.viewContext
    }
    
    func createPrimaryKey(tableName: String) -> Int32{
        var id : Int32 = 0
        let managedContext=getContext();
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: tableName)//"Person"
        do {
            let results =
                try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            if(results.count==0){
                id=1
            }else{
                let lastRecordID:Int32=((results[results.count-1] as AnyObject).value(forKey: "id") as! Int32?)!
                id=lastRecordID+1
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        return id
    }
    
    /*Vehicle DB Process */
    func putVehicleInLocalDB(vehicle_obj : Vehicle){
        var c_id:Int32 = self.createPrimaryKey(tableName: vehicleTable)
        print ("Generated PrimaryKey ID \(c_id)")
        let context = getContext()
        let entity =  NSEntityDescription.entity(forEntityName: vehicleTable, in: context)
        let transc = NSManagedObject(entity: entity!, insertInto: context)
        
        transc.setValue(c_id, forKey: "id")
        transc.setValue(vehicle_obj.type, forKey: "type")
        transc.setValue(vehicle_obj.brand, forKey: "brand")
        transc.setValue(vehicle_obj.model, forKey: "model")
        transc.setValue(vehicle_obj.engineCapacity, forKey: "engine_capacity")
        
        //save the object
        do {
            try context.save()
            print("Data Saved!")
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        } catch {
        }
    }
    
    func updateVehicleData(vehicle: Vehicle){
                
        let managedContext=self.getContext();
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: vehicleTable)
        fetchRequest.predicate = NSPredicate(format: "id == %d", vehicle.id!)
        do {
            let fetchedEntities = try managedContext.fetch(fetchRequest)// as! NSManagedObject
            
            if(fetchedEntities.count==0){
                print("\n No Such Data to Update")
            }else{
                
                let vehicleData = fetchedEntities[0] as! NSManagedObject
                
                vehicleData.setValue(vehicle.type, forKey: "type")
                vehicleData.setValue(vehicle.brand, forKey: "brand")
                vehicleData.setValue(vehicle.model, forKey: "model")
                vehicleData.setValue(vehicle.engineCapacity, forKey: "engine_capacity")
                
                try managedContext.save()
            }
            
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
            // Do something in response to error condition
        }
    }
    
    func deleteARecord(id: Int16){
        let managedContext=self.getContext();
        
        let predicate = NSPredicate(format: "id == %d", id)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: vehicleTable)
        fetchRequest.predicate = predicate
        do {
            let fetchedEntities =
                try managedContext.fetch(fetchRequest) //as! NSFetchRequest<NSFetchRequestResult>)
            
            if(fetchedEntities.count==0){
                print("\n No Such Data to Delete")
            }else{
                for object in fetchedEntities {
                    managedContext.delete(object as! NSManagedObject)
                }
                try managedContext.save()
                print("\n Record Deleted")
            }
        } catch {
            // Do something in response to error condition
        }
    }
    
    
    func deleteAllRecordsOfTable(tableName: String){
        let managedContext=getContext();
        // Create Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: tableName)
        // Create Batch Delete Request
        let batchDeleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        do {
            try managedContext.execute(batchDeleteRequest)
        } catch {
            // Error Handling
        }
    }
    
    func checkExistingVehicle(id: Int16)->Bool{
        
        let managedObjectContext: NSManagedObjectContext
        managedObjectContext=getContext();
        
        let predicate = NSPredicate(format: "id == %d", id)
        
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>.init(entityName: vehicleTable)
        fetchRequest.predicate = predicate
        do{
            let results = try managedObjectContext.fetch(fetchRequest) as! [NSManagedObject]
            
            if(results.count==0){ return false
            }else{
                return true
            }
        } catch let error as NSError {
            //print("Could not fetch \(error), \(error.userInfo)")
            return false
        }
    }
    
    func getVehicleDetails(id : Int16) -> Vehicle{
        
        var vehicle:Vehicle = Vehicle()
        
        //1
        let managedContext=getContext();
        //2
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: vehicleTable)
        fetchRequest.predicate = NSPredicate(format: "id == %d", id)
        
        //3
        do {
            let results =
                try managedContext.fetch(fetchRequest as! NSFetchRequest<NSFetchRequestResult>)
            
            print("Total Records : " + String(results.count))
            
            if(results.count>0){
                
                var v_type:String=""
                if(((results[0] as AnyObject).value(forKey: "type")) != nil){
                    v_type = ((results[0] as AnyObject).value(forKey: "type") as! String?)!
                }
                
                var v_brand:String=""
                if(((results[0] as AnyObject).value(forKey: "brand")) != nil){
                    v_brand = ((results[0] as AnyObject).value(forKey: "brand") as! String?)!
                }
                
                var v_model:String=""
                if(((results[0] as AnyObject).value(forKey: "model")) != nil){
                    v_model = ((results[0] as AnyObject).value(forKey: "model") as! String?)!
                }
                
                var v_engine_capacity:Int16=0
                if(((results[0] as AnyObject).value(forKey: "engine_capacity")) != nil){
                    v_engine_capacity = ((results[0] as AnyObject).value(forKey: "engine_capacity") as! Int16?)!
                }
                
                vehicle = Vehicle(id: id,type: v_type,brand: v_brand,model: v_model,engineCapacity: v_engine_capacity)
            }
        } catch let error as NSError {
            print("Could not fetch \(error), \(error.userInfo)")
        }
        
        return vehicle
    }
    
    
}
