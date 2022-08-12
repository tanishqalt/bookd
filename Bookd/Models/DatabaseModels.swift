//
//  UserModel.swift
//  Bookd
//
//  Created by Tanishq Sharma on 2022-08-08.
//

import Foundation

// User Model
struct User {
    let firstName: String;
    let lastName: String;
    let username: String;
    let emailAddress: String;
    var paymentAddress: String {
      return emailAddress
    };
    let uid: String;
    let currentBalance: String?;
}

// Invoice Model
struct Invoice {
    let invoiceID: String;
    let status: String;
    let contactEmail: String;
    let dateCompleted: String;
    let invoiceNumber: String;
    let serviceDescription: String;
    let invoiceTotal: String;
}


// Conversation Model
struct Conversation {
    let conversationID: String;
    let email: String;
    let subject: String;
    let message: String;
    let invoiceNumber: String;
}


// Appointment Model
struct Appointment {
    let appointmentID: String;
    let contactName: String;
    let contactEmail: String;
    let scheduledTime: String;
    let service: String;
    let notes: String;
}


// Service Model

struct UserService {
    let serviceID: String;
    let title: String;
    let description: String;
    let hourlyRate: String;
    let minHours: String;
    let category: String;
}
