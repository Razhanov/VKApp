//
//  Firebase.swift
//  VK App
//
//  Created by Karim Razhanov on 26/07/2018.
//  Copyright © 2018 Karim Razhanov. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


enum UserData {
    case userID
    case userAdedGroups
}

class FirebaseService {
    static func saveToFirebase(data: String, userDataDescription: UserData) {
        let dbLink = Database.database().reference()
        
        switch userDataDescription {
        case .userID:
            dbLink.child("UserID").setValue(data)
        case .userAdedGroups:
            dbLink.child("UserAdedGroups").setValue(data)
        } 
    }
}









