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
}

// Invoice Model


// Conversation Model
struct Conversation {
    let conversationID: String;
    let email: String;
    let subject: String;
    let message: String;
    let invoiceNumber: String;
}


// Appointment Model


// Service Model

struct UserService {
    let serviceID: String;
    let title: String;
    let description: String;
    let hourlyRate: String;
    let minHours: String;
    let category: String;
}
