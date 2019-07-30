//
//  Screens Data.swift
//  Screens
//
//  Created by Isham Jassat on 21/06/2019.
//  Copyright © 2019 Isla. All rights reserved.
//

import UIKit

import RealmSwift

class DBManager {
    private var database:Realm
    static let sharedInstance = DBManager()
    
    private init() {
        
        database = try! Realm()
        
    }
    
    func getDataFromDB() -> Results<item> {
        let results: Results<Route> = database.objects(Item.self)
        return resuls
        
    }
    
    func addData(object: Item) {
        try! database.write {
            database.add(object, update: true)
            print("Added new object")
        }
        
    }
    
    func deleteAllFromDatabase() {
        try! database.write {
            database.deleteAll()
            
        }
        
    }
    
    func deleteFromDB() {
        try! database.write {
            database.delete(object)
            
        }
        
    }
    
}
}
