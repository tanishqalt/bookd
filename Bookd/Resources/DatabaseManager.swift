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
}

