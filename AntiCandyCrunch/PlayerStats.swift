//
//  PlayerStats.swift
//  AntiCandyCrunch
//
//  Created by SANDOR NAGY on 22/07/16.
//  Copyright © 2016 Rebeloper. All rights reserved.
//

import Foundation
import SwiftKeychainWrapper
import SpriteKit

let kHighestUnlockedLevel = "kHighestUnlockedLevel"
let kFirstLaunch = "kFirstLaunch"
let kCurrentLevel = "kCurrentLevel"
let kCurrentLevelWinStatus = "kCurrentLevelWinStatus"
let kCurrentCollectableType = "kCurrentCollectableType"
let kStarsAchievedInLevel = "kStarsAchievedInLevel"
let kIsRandomLevel = "kIsRandomLevel"
let kAchievementBadge = "AchievementBadge"
let kChainValueForCookieType = "kChainValueForCookieType"
let kOverallTime = "kOverallTime"
let kOverallMoves = "kOverallMoves"
let kOverallStars = "kOverallStars"
let kFacebookFriendID = "kFacebookFriendID"
let kFacebookFriendScore = "kFacebookFriendScore"
let kSoundState = "kSoundState"
let kStarsToGiveForFacebookInvite = "kStarsToGiveForFacebookInvite"

class PlayerStats {
  
  static let sharedInstance = PlayerStats()
  fileprivate init() {} //This prevents others from using the default '()' initializer for this class.
  
  func setupDefaultValues() {
    if !UserDefaults.standard.bool(forKey: kFirstLaunch) {
      
      print("First launch ...")
      
      saveNewHighestUnlockedLevel(1) // TODO: set it to 1
      
      var h = 1
      repeat {
        setStarsAchieved(0, forLevel: h)
        h = h + 1
      } while h <= 108
      
      UserDefaults.standard.set(kInitialStarsToGiveAtFirstLaunch, forKey: kOverallStars)
      
      saveFacebookFriend("1", id: "0", score: "0")
      saveFacebookFriend("2", id: "0", score: "0")
      saveFacebookFriend("3", id: "0", score: "0")
      
      if let _ = KeychainWrapper.defaultKeychainWrapper().stringForKey(kFirebaseUID) {
        print("REBELOPER: Deleting existing keychain data for key \(kFirebaseUID)")
        KeychainWrapper.defaultKeychainWrapper().removeObjectForKey(kFirebaseUID)
      } else {
        print("REBELOPER: No data found in keychain for key \(kFirebaseUID). No need to delete.")
      }
      
      setSound(true)
      
      saveStarsToGiveForFacebookInvite(kInitialStarsToGiveAtFacebookInvite)
      
      UserDefaults.standard.set(true, forKey: kFirstLaunch)
      UserDefaults.standard.synchronize()
    }
    
  }
  
  func saveNewHighestUnlockedLevel(_ level: Int) {
    
    if isCurrentWonLevelTheHighest(level) {
      UserDefaults.standard.set(level, forKey: kHighestUnlockedLevel)
      UserDefaults.standard.synchronize()
    } else {
      print("Current won level is not the highest one. Not saving.")
    }
    
    
  }
  
  func isCurrentWonLevelTheHighest(_ level: Int) -> Bool {
    if getHighestUnlockedLevel() <= level {
      return true
    } else {
      return false
    }
  }
  
  func getHighestUnlockedLevel() -> Int {
    return UserDefaults.standard.integer(forKey: kHighestUnlockedLevel)
  }
  
  func saveCurrentLevel(_ level: Int) {
    UserDefaults.standard.set(level, forKey: kCurrentLevel)
    UserDefaults.standard.synchronize()
  }
  
  func getCurrentLevel() -> Int {
    return UserDefaults.standard.integer(forKey: kCurrentLevel)
  }
  
  func saveCurrentLevelWinStatus(_ win: Bool) {
    UserDefaults.standard.set(win, forKey: kCurrentLevelWinStatus)
    UserDefaults.standard.synchronize()
  }
  
  func getCurrentLevelWinStatus() -> Bool {
    return UserDefaults.standard.bool(forKey: kCurrentLevelWinStatus)
  }
  
  func saveCurrentCollectableType() {
    UserDefaults.standard.set(Int(arc4random_uniform(6)) + 1, forKey: kCurrentCollectableType)
    UserDefaults.standard.synchronize()
  }
  
  func getCurrentCollectableType() -> Int {
    return UserDefaults.standard.integer(forKey: kCurrentCollectableType)
  }
  
  func setStarsAchieved(_ stars: Int, forLevel: Int) {
    UserDefaults.standard.set(stars, forKey: kStarsAchievedInLevel + String(forLevel))
    UserDefaults.standard.synchronize()
  }
  
  func getStarsAchievedForLevel(_ level: Int) -> Int {
    return UserDefaults.standard.integer(forKey: kStarsAchievedInLevel + String(level))
  }
  
  func updateOverallStarsWith(_ stars: Int) {
    UserDefaults.standard.set(getOverallStars() + stars, forKey: kOverallStars)
    UserDefaults.standard.synchronize()
  }
  
  func getOverallStars() -> Int {
    return UserDefaults.standard.integer(forKey: kOverallStars)
  }
  
  func saveIsRandomLevel(_ value: Bool) {
    UserDefaults.standard.set(value, forKey: kIsRandomLevel)
    UserDefaults.standard.synchronize()
  }
  
  func getIsRandomLevel() -> Bool {
    return UserDefaults.standard.bool(forKey: kIsRandomLevel)
  }
  
  func setAchievementStatusCompleted(_ status: Bool, forAchievement: Int) {
    UserDefaults.standard.set(status, forKey: kAchievementBadge + String(forAchievement))
    UserDefaults.standard.synchronize()
  }
  
  func getStatusForAchievement(_ achievement: Int) -> Bool {
    return UserDefaults.standard.bool(forKey: kAchievementBadge + String(achievement))
  }
  
  func getStatusForAchievementWithName(_ name: String) -> Bool {
    return UserDefaults.standard.bool(forKey: name)
  }
  
  func saveNewChainValueForCookieType(_ cookieType: CookieType) {
    UserDefaults.standard.set(getChainValueForCookieType(cookieType) + 1, forKey: kChainValueForCookieType + cookieType.spriteName)
    UserDefaults.standard.synchronize()
    
    checkForAchievementsForCookieType(cookieType)
  }
  
  func getChainValueForCookieType(_ cookieType: CookieType) -> Int {
    return UserDefaults.standard.integer(forKey: kChainValueForCookieType + cookieType.spriteName)
  }
  
  func checkForAchievementsForCookieType(_ cookieType: CookieType) {
    var dataDict = Dictionary<String, String>()
    dataDict["CompletedAchievemenet"] = "0"
    
    switch cookieType {
    case .croissant:
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains1 && getChainValueForCookieType(cookieType) < achievementMilestoneChains2 && !getStatusForAchievement(1) {
        setAchievementStatusCompleted(true, forAchievement: 1)
        dataDict["CompletedAchievemenet"] = "1"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains2 && getChainValueForCookieType(cookieType) < achievementMilestoneChains3 && !getStatusForAchievement(2) {
        setAchievementStatusCompleted(true, forAchievement: 2)
        dataDict["CompletedAchievemenet"] = "2"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains3 && getChainValueForCookieType(cookieType) < achievementMilestoneChains4  && !getStatusForAchievement(3) {
        setAchievementStatusCompleted(true, forAchievement: 3)
        dataDict["CompletedAchievemenet"] = "3"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains4 && !getStatusForAchievement(4) {
        setAchievementStatusCompleted(true, forAchievement: 4)
        dataDict["CompletedAchievemenet"] = "4"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
    case .cupcake:
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains1 && getChainValueForCookieType(cookieType) < achievementMilestoneChains2 && !getStatusForAchievement(5) {
        setAchievementStatusCompleted(true, forAchievement: 5)
        dataDict["CompletedAchievemenet"] = "5"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains2 && getChainValueForCookieType(cookieType) < achievementMilestoneChains3 && !getStatusForAchievement(6) {
        setAchievementStatusCompleted(true, forAchievement: 6)
        dataDict["CompletedAchievemenet"] = "6"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains3 && getChainValueForCookieType(cookieType) < achievementMilestoneChains4  && !getStatusForAchievement(7) {
        setAchievementStatusCompleted(true, forAchievement: 7)
        dataDict["CompletedAchievemenet"] = "7"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains4 && !getStatusForAchievement(8) {
        setAchievementStatusCompleted(true, forAchievement: 8)
        dataDict["CompletedAchievemenet"] = "8"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
    case .danish:
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains1 && getChainValueForCookieType(cookieType) < achievementMilestoneChains2 && !getStatusForAchievement(9) {
        setAchievementStatusCompleted(true, forAchievement: 9)
        dataDict["CompletedAchievemenet"] = "9"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains2 && getChainValueForCookieType(cookieType) < achievementMilestoneChains3 && !getStatusForAchievement(10) {
        setAchievementStatusCompleted(true, forAchievement: 10)
        dataDict["CompletedAchievemenet"] = "10"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains3 && getChainValueForCookieType(cookieType) < achievementMilestoneChains4  && !getStatusForAchievement(11) {
        setAchievementStatusCompleted(true, forAchievement: 11)
        dataDict["CompletedAchievemenet"] = "11"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains4 && !getStatusForAchievement(12) {
        setAchievementStatusCompleted(true, forAchievement: 12)
        dataDict["CompletedAchievemenet"] = "12"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
    case .donut:
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains1 && getChainValueForCookieType(cookieType) < achievementMilestoneChains2 && !getStatusForAchievement(13) {
        setAchievementStatusCompleted(true, forAchievement: 13)
        dataDict["CompletedAchievemenet"] = "13"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains2 && getChainValueForCookieType(cookieType) < achievementMilestoneChains3 && !getStatusForAchievement(14) {
        setAchievementStatusCompleted(true, forAchievement: 14)
        dataDict["CompletedAchievemenet"] = "14"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains3 && getChainValueForCookieType(cookieType) < achievementMilestoneChains4  && !getStatusForAchievement(15) {
        setAchievementStatusCompleted(true, forAchievement: 15)
        dataDict["CompletedAchievemenet"] = "15"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains4 && !getStatusForAchievement(16) {
        setAchievementStatusCompleted(true, forAchievement: 16)
        dataDict["CompletedAchievemenet"] = "16"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
    case .macaroon:
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains1 && getChainValueForCookieType(cookieType) < achievementMilestoneChains2 && !getStatusForAchievement(17) {
        setAchievementStatusCompleted(true, forAchievement: 17)
        dataDict["CompletedAchievemenet"] = "17"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains2 && getChainValueForCookieType(cookieType) < achievementMilestoneChains3 && !getStatusForAchievement(18) {
        setAchievementStatusCompleted(true, forAchievement: 18)
        dataDict["CompletedAchievemenet"] = "18"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains3 && getChainValueForCookieType(cookieType) < achievementMilestoneChains4  && !getStatusForAchievement(19) {
        setAchievementStatusCompleted(true, forAchievement: 19)
        dataDict["CompletedAchievemenet"] = "19"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains4 && !getStatusForAchievement(20) {
        setAchievementStatusCompleted(true, forAchievement: 20)
        dataDict["CompletedAchievemenet"] = "20"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
    case .sugarCookie:
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains1 && getChainValueForCookieType(cookieType) < achievementMilestoneChains2 && !getStatusForAchievement(21) {
        setAchievementStatusCompleted(true, forAchievement: 21)
        dataDict["CompletedAchievemenet"] = "21"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains2 && getChainValueForCookieType(cookieType) < achievementMilestoneChains3 && !getStatusForAchievement(22) {
        setAchievementStatusCompleted(true, forAchievement: 22)
        dataDict["CompletedAchievemenet"] = "22"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains3 && getChainValueForCookieType(cookieType) < achievementMilestoneChains4  && !getStatusForAchievement(23) {
        setAchievementStatusCompleted(true, forAchievement: 23)
        dataDict["CompletedAchievemenet"] = "23"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
      if getChainValueForCookieType(cookieType) >= achievementMilestoneChains4 && !getStatusForAchievement(24) {
        setAchievementStatusCompleted(true, forAchievement: 24)
        dataDict["CompletedAchievemenet"] = "24"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
      }
    default:
      print("Ooops, no such cookie type to inspect.")
    }
  }
  
  func saveOverallTime(_ time: Int) {
    UserDefaults.standard.set(getOverallTime() + time, forKey: kOverallTime)
    UserDefaults.standard.synchronize()
  }
  
  func getOverallTime() -> Int {
    return UserDefaults.standard.integer(forKey: kOverallTime)
  }
  
  func checkForAchievementsForTime() {
    var dataDict = Dictionary<String, String>()
    dataDict["CompletedAchievemenet"] = "0"
    
    if getOverallTime() >= achievementMilestoneTime1 && getOverallTime() < achievementMilestoneTime2 && !getStatusForAchievement(25) {
      setAchievementStatusCompleted(true, forAchievement: 25)
      dataDict["CompletedAchievemenet"] = "25"
      NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
    }
    if getOverallTime() >= achievementMilestoneTime2 && getOverallTime() < achievementMilestoneTime3 && !getStatusForAchievement(26) {
      setAchievementStatusCompleted(true, forAchievement: 26)
      dataDict["CompletedAchievemenet"] = "26"
      NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
    }
    if getOverallTime() >= achievementMilestoneTime3 && !getStatusForAchievement(27) {
      setAchievementStatusCompleted(true, forAchievement: 27)
      dataDict["CompletedAchievemenet"] = "27"
      NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
    }
  }
  
  func saveOverallMoves(_ moves: Int) {
    UserDefaults.standard.set(getOverallMoves() + moves, forKey: kOverallMoves)
    UserDefaults.standard.synchronize()
  }
  
  func getOverallMoves() -> Int {
    return UserDefaults.standard.integer(forKey: kOverallMoves)
  }
  
  func checkForAchievementsForMoves() {
    var dataDict = Dictionary<String, String>()
    dataDict["CompletedAchievemenet"] = "0"
    
    if getOverallMoves() >= achievementMilestoneMoves1 && getOverallMoves() < achievementMilestoneMoves2 && !getStatusForAchievement(28) {
      setAchievementStatusCompleted(true, forAchievement: 28)
      dataDict["CompletedAchievemenet"] = "28"
      NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
    }
    if getOverallMoves() >= achievementMilestoneMoves2 && getOverallMoves() < achievementMilestoneMoves3 && !getStatusForAchievement(29) {
      setAchievementStatusCompleted(true, forAchievement: 29)
      dataDict["CompletedAchievemenet"] = "29"
      NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
    }
    if getOverallMoves() >= achievementMilestoneMoves3 && !getStatusForAchievement(30) {
      setAchievementStatusCompleted(true, forAchievement: 30)
      dataDict["CompletedAchievemenet"] = "30"
      NotificationCenter.default.post(name: Notification.Name(rawValue: "AchievementCompletedNotification"), object: nil, userInfo: dataDict)
    }
  }
  
  func saveFacebookFriend(_ place: String, id: String, score: String) {
    UserDefaults.standard.set(id, forKey: "\(kFacebookFriendID)\(place)")
    UserDefaults.standard.set(score, forKey: "\(kFacebookFriendScore)\(place)")
    UserDefaults.standard.synchronize()
  }
  
  func getFacebookUserFriend(_ place: String) -> (id: String, score: String) {
    return (UserDefaults.standard.object(forKey: "\(kFacebookFriendID)\(place)") as! String , UserDefaults.standard.object(forKey: "\(kFacebookFriendScore)\(place)") as! String)
  }
  
  func setSound(_ state: Bool) {
    UserDefaults.standard.set(state, forKey: kSoundState)
    UserDefaults.standard.synchronize()
  }
  
  func getSoundState() -> Bool {
    return UserDefaults.standard.bool(forKey: kSoundState)
  }
  
  func playButtonTapSoundOnSpriteNode(_ spriteNode: SKSpriteNode) {
    if getSoundState() {
      spriteNode.run(SKAction.playSoundFileNamed(soundTap, waitForCompletion: false))
    }
  }
  
  func playButtonTapSoundOnNode(_ node: SKNode) {
    if getSoundState() {
      node.run(SKAction.playSoundFileNamed(soundTap, waitForCompletion: false))
    }
  }
  
  func saveStarsToGiveForFacebookInvite(_ value: Int) {
    UserDefaults.standard.set(value, forKey: kStarsToGiveForFacebookInvite)
    UserDefaults.standard.synchronize()
  }
  
  func getStarsToGiveForFacebookInvite() -> Int {
    return UserDefaults.standard.integer(forKey: kStarsToGiveForFacebookInvite)
  }
  
}
