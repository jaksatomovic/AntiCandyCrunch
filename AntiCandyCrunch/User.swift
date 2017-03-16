//
//  User.swift
//  AntiCandyCrunch
//
//  Created by SANDOR NAGY on 24/08/16.
//  Copyright © 2016 Rebeloper. All rights reserved.
//

import Foundation

class User {
  fileprivate var _userFBid: String!
  fileprivate var _profileImageUrl: String!
  fileprivate var _score: String!
  fileprivate var _userCurrentStars: String!
  
  fileprivate var _userKey: String!
  
  var userFBid: String {
    return _userFBid
  }
  
  var profileImageUrl: String {
    return _profileImageUrl
  }
  
  var score: String {
    return _score
  }
  
  var userKey: String {
    return _userKey
  }
  
  var userCurrentStars: String {
    return _userCurrentStars
  }
  
  init(userFBid: String, profileImageUrl: String, score: String, userCurrentStars: String) {
    self._userFBid = userFBid
    self._profileImageUrl = profileImageUrl
    self._score = score
    self._userCurrentStars = userCurrentStars
  }
  
  init(userKey: String, userData: Dictionary<String, AnyObject>) {
    self._userKey = userKey
    
    if let userFBid = userData["userFBid"] as? String {
      self._userFBid = userFBid
    }
    
    if let profileImageUrl = userData["profileImageUrl"] as? String {
      self._profileImageUrl = profileImageUrl
    }
    
    if let score = userData["score"] as? String {
      self._score = score
    }
    
    if let userCurrentStars = userData["userCurrentStars"] as? String {
      self._userCurrentStars = userCurrentStars
    }
  }
}
