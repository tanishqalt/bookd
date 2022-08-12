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
            "uid": user.uid,
            "currentBalance": user.currentBalance
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
    
    // insert the conversations under "/conversions/uid" tag
    public func insertConversation(uid: String, conversation: Conversation) {
        
        // print statement
        print("Inside: Creating conversation for user \(uid)")
        
        let reference = database.child("Conversations").child(uid).childByAutoId();
        
        // storing things under conversations -> uid -> generating auto id and then setting value to it
        reference.setValue([
            "conversationID": reference.key,
            "subject": conversation.subject,
            "email": conversation.email,
            "invoiceNumber": conversation.invoiceNumber,
            "message": conversation.message,
        ])
    }
    
    
    // insert the appointment under "/appointments/uid" tag
    
    public func insertAppointment(uid: String, appointment: Appointment){
        
        // print statement
        print("Inside: Creating appointment for user \(uid)")
        
        let reference = database.child("Appointments").child(uid).childByAutoId();
        

        // storing things under appointments -> uid -> generating auto id and then setting value to it
        reference.setValue([
            "appointmentID": reference.key,
            "contactName": appointment.contactName,
            "contactEmail": appointment.contactEmail,
            "notes": appointment.notes,
            "service": appointment.service,
            "scheduledTime": appointment.scheduledTime
        ])
    }
    
    // insert invoice under "/invoices/uid" tag
    
    public func insertInvoice(uid: String, invoice: Invoice){
        
        // print statement
        print("Inside: Creating invoice for user \(uid)")
        
        let reference = database.child("Invoices").child(uid).childByAutoId();
        

        // storing things under invoices -> uid -> generating auto id and then setting value to it
        reference.setValue([
            "invoiceID": reference.key,
            "status": invoice.status,
            "contactEmail": invoice.contactEmail,
            "dateCompleted": invoice.dateCompleted,
            "invoiceNumber": invoice.invoiceNumber,
            "serviceDescription": invoice.serviceDescription,
            "invoiceTotal": invoice.invoiceTotal
        ])
    }

    public func updateUserBalance(uid: String, balance: String) {
        // update the user balance "currentBalance"
        database.child("Users").child(uid).child("currentBalance").setValue(balance)
    }

    // function to get the user and return it
    public func getUser(with uid: String, completion: @escaping (User) -> Void) {
        database.child("Users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
                    
            let user = User(firstName: snapshot.childSnapshot(forPath: "firstName").value as! String, lastName: snapshot.childSnapshot(forPath: "lastName").value as! String, username: snapshot.childSnapshot(forPath: "username").value as! String, emailAddress: snapshot.childSnapshot(forPath: "emailAddress").value as! String, uid: snapshot.childSnapshot(forPath: "uid").value as! String, currentBalance: snapshot.childSnapshot(forPath: "currentBalance").value as? String ?? "0")
            
            completion(user)
        }
    }

    // function to update an appointment and set the status
    public func updateAppointmentStatus(uid: String, appointmentID: String, status: String) {
        database.child("Appointments").child(uid).child(appointmentID).child("status").setValue(status)
    }
}

