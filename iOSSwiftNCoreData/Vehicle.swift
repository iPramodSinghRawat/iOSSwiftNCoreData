//
//  Vehicle.swift
//  iOSSwiftNCoreData
//
//  Created by iPramodSinghRawat on 14/03/18.
//  Copyright © 2018 iPramodSinghRawat. All rights reserved.
//

class Vehicle {
    
    var id: Int16?
    var type: String?
    var brand: String?
    var model: String?
    var engineCapacity: Int16?
    
    init() {
    }
    
    init(id: Int16) {
        self.id = id
    }
    
    init(type: String, brand: String, model: String, engineCapacity: Int16) {
        self.type = type
        self.brand = brand
        self.model = model
        self.engineCapacity = engineCapacity
    }
    
    init(id: Int16, type: String, brand: String, model: String, engineCapacity: Int16) {
        self.id = id
        self.type = type
        self.brand = brand
        self.model = model
        self.engineCapacity = engineCapacity
    }
}
