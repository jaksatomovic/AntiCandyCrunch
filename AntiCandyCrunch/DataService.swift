//
//  DataService.swift
//  AntiCandyCrunch
//
//  Created by SANDOR NAGY on 24/08/16.
//  Copyright © 2016 Rebeloper. All rights reserved.
//

import Foundation
import Firebase

let DB_BASE = FIRDatabase.database().reference()

class DataService {
  
  static let ds = DataService()
  
  fileprivate var _REF_BASE = DB_BASE
  fileprivate var _REF_USERS = DB_BASE.child("users")
  
  var REF_BASE: FIRDatabaseReference {
    return _REF_BASE
  }
  
  var REF_USERS: FIRDatabaseReference {
    return _REF_USERS
  }
  
  func createFirebaseDBUser(_ uid: String, userData: Dictionary<String, String>) {
    REF_USERS.child(uid).updateChildValues(userData)
  }
  
}
