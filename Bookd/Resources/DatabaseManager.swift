//
//  DatabaseManager.swift
//  Bookd
//
//  Created by Tanishq Sharma on 2022-08-08.
//

import Foundation
import FirebaseDatabase

final class DatabaseManager {
    
    static let shared = DatabaseManager();
    private let database = Database.database().reference()
}

extension DatabaseManager {
    
    // insert the user in the database
    public func insertUser(with user: User){
        database.child("Users").child(user.uid).setValue([
            "firstName": user.firstName,
            "lastName": user.lastName,
            "email": user.emailAddress,
            "username": user.username,
            "uid": user.uid
        ])
    }
    
    // insert the services under "/service/uid" tag
    
    public func insertService(uid: String, service: UserService) {
        
        // print statement
        print("Inside: Creating service for user \(uid)")
        
        let reference = database.child("Services").child(uid).childByAutoId();
        
        // storing things under services -> uid -> generating auto id and then setting value to it
        reference.setValue([
            "serviceID": reference.key,
            "title": service.title,
            "description": service.description,
            "minHours": service.minHours,
            "hourlyRate": service.hourlyRate,
            "category": service.category
        ])
    }
}

