//
//  Ingredient.swift
//  assignment3
//
//  Created by Jacob Efendi on 5/19/19.
//  Copyright © 2019 group144. All rights reserved.
//

import Foundation

class Ingredient {
    var name: String
    var quantity: Int
    //var unitOfMeasurement: String
    
    init(name: String, quantity: Int) {
        self.name = name
        self.quantity = quantity
        //unitOfMeasurement = ""
    }
    
    /*
    init(name: String, quantity: Int, unitOfMeasurement: String) {
        self.name = name
        self.quantity = quantity
        self.unitOfMeasurement = unitOfMeasurement
    }*/
}
