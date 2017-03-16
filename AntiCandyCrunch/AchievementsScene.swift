//
//  AchievementsScene.swift
//  AntiCandyCrunch
//
//  Created by SANDOR NAGY on 02/08/16.
//  Copyright © 2016 Rebeloper. All rights reserved.
//

import SpriteKit

class AchievementsScene: SKScene {
  
  var achievementBadge1: SKSpriteNode?
  var achievementBadge2: SKSpriteNode?
  var achievementBadge3: SKSpriteNode?
  var achievementBadge4: SKSpriteNode?
  var achievementBadge5: SKSpriteNode?
  var achievementBadge6: SKSpriteNode?
  var achievementBadge7: SKSpriteNode?
  var achievementBadge8: SKSpriteNode?
  var achievementBadge9: SKSpriteNode?
  var achievementBadge10: SKSpriteNode?
  var achievementBadge11: SKSpriteNode?
  var achievementBadge12: SKSpriteNode?
  var achievementBadge13: SKSpriteNode?
  var achievementBadge14: SKSpriteNode?
  var achievementBadge15: SKSpriteNode?
  var achievementBadge16: SKSpriteNode?
  var achievementBadge17: SKSpriteNode?
  var achievementBadge18: SKSpriteNode?
  var achievementBadge19: SKSpriteNode?
  var achievementBadge20: SKSpriteNode?
  var achievementBadge21: SKSpriteNode?
  var achievementBadge22: SKSpriteNode?
  var achievementBadge23: SKSpriteNode?
  var achievementBadge24: SKSpriteNode?
  var achievementBadge25: SKSpriteNode?
  var achievementBadge26: SKSpriteNode?
  var achievementBadge27: SKSpriteNode?
  var achievementBadge28: SKSpriteNode?
  var achievementBadge29: SKSpriteNode?
  var achievementBadge30: SKSpriteNode?
  
  var arrayOfAchievementBadges = [String]()
  
  var moveAchievementsScrollLayerDown: SKAction?
  var moveAchievementsScrollLayerUp: SKAction?
  
  var achievementsScrollLayerHeight: CGFloat = 10150
  var achievementsScrollLayerInitialHeight: CGFloat?
  
  var pagination = 0
  
  enum Direction: String {
    case Up, Down, Left, Right
  }
  
  var achievementsScrollLayer: SKNode?
  
  override func didMove(to view: SKView) {
    
    RateMyApp.sharedInstance.trackAppUsage()
    
    // Setup acheivementsScrollLayer
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "acheivementsScrollLayer") {
        if let someNode:SKNode = node {
          self.achievementsScrollLayer = someNode
        }
      }
    }
    //acheivementsScrollLayer = self.childNodeWithName("acheivementsScrollLayer")
    achievementsScrollLayerInitialHeight = achievementsScrollLayer?.position.y
    
    // Setup topPanel
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "topPanel") {
        if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
          if DeviceType.IS_IPHONE_4_OR_LESS {
            someSpriteNode.position.y = 810
          } else if DeviceType.IS_IPAD {
            someSpriteNode.position.y = 720
          } else if DeviceType.IS_IPAD_PRO {
            someSpriteNode.position.y = 720
          }
        }
      }
    }
    
    // Setup buttonLevels
    arrayOfAchievementBadges = [ "AchievementBadge1", "AchievementBadge2", "AchievementBadge3", "AchievementBadge4", "AchievementBadge5", "AchievementBadge6", "AchievementBadge7", "AchievementBadge8", "AchievementBadge9", "AchievementBadge10", "AchievementBadge11", "AchievementBadge12", "AchievementBadge13", "AchievementBadge14", "AchievementBadge15", "AchievementBadge16", "AchievementBadge17", "AchievementBadge18", "AchievementBadge19", "AchievementBadge20", "AchievementBadge21", "AchievementBadge22", "AchievementBadge23", "AchievementBadge24", "AchievementBadge25", "AchievementBadge26", "AchievementBadge27", "AchievementBadge28", "AchievementBadge29", "AchievementBadge30" ]
    /*
    PlayerStats.sharedInstance.setAchievementStatusCompleted(true, forAchievement: 1)
    PlayerStats.sharedInstance.setAchievementStatusCompleted(true, forAchievement: 2)
    PlayerStats.sharedInstance.setAchievementStatusCompleted(true, forAchievement: 3)*/
    
    updateAchievements()
    
    for i in 1...30 { // TODO: change it to 30
      
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "achievementTextLine\(i)_1") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            
            someLabelNode.fontName = kCustomFontName
            someLabelNode.fontSize = CGFloat(kAchievementTextLine1FontSize)
            
            switch i {
            case 1:
              someLabelNode.text = achievementTextLine1_1
            case 2:
              someLabelNode.text = achievementTextLine2_1
            case 3:
              someLabelNode.text = achievementTextLine3_1
            case 4:
              someLabelNode.text = achievementTextLine4_1
            case 5:
              someLabelNode.text = achievementTextLine5_1
            case 6:
              someLabelNode.text = achievementTextLine6_1
            case 7:
              someLabelNode.text = achievementTextLine7_1
            case 8:
              someLabelNode.text = achievementTextLine8_1
            case 9:
              someLabelNode.text = achievementTextLine9_1
            case 10:
              someLabelNode.text = achievementTextLine10_1
            case 11:
              someLabelNode.text = achievementTextLine11_1
            case 12:
              someLabelNode.text = achievementTextLine12_1
            case 13:
              someLabelNode.text = achievementTextLine13_1
            case 14:
              someLabelNode.text = achievementTextLine14_1
            case 15:
              someLabelNode.text = achievementTextLine15_1
            case 16:
              someLabelNode.text = achievementTextLine16_1
            case 17:
              someLabelNode.text = achievementTextLine17_1
            case 18:
              someLabelNode.text = achievementTextLine18_1
            case 19:
              someLabelNode.text = achievementTextLine19_1
            case 20:
              someLabelNode.text = achievementTextLine20_1
            case 21:
              someLabelNode.text = achievementTextLine21_1
            case 22:
              someLabelNode.text = achievementTextLine22_1
            case 23:
              someLabelNode.text = achievementTextLine23_1
            case 24:
              someLabelNode.text = achievementTextLine24_1
            case 25:
              someLabelNode.text = achievementTextLine25_1
            case 26:
              someLabelNode.text = achievementTextLine26_1
            case 27:
              someLabelNode.text = achievementTextLine27_1
            case 28:
              someLabelNode.text = achievementTextLine28_1
            case 29:
              someLabelNode.text = achievementTextLine29_1
            case 30:
              someLabelNode.text = achievementTextLine30_1
            default:
              print("Ooops, no such achievement line.")
            }
            
            
          }
        }
        
        if (node.name == "achievementTextLine\(i)_2") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            
            someLabelNode.fontName = kCustomFontName
            someLabelNode.fontSize = CGFloat(kAchievementTextLine2FontSize)
            
            switch i {
            case 1:
              someLabelNode.text = achievementTextLine1_2
            case 2:
              someLabelNode.text = achievementTextLine2_2
            case 3:
              someLabelNode.text = achievementTextLine3_2
            case 4:
              someLabelNode.text = achievementTextLine4_2
            case 5:
              someLabelNode.text = achievementTextLine5_2
            case 6:
              someLabelNode.text = achievementTextLine6_2
            case 7:
              someLabelNode.text = achievementTextLine7_2
            case 8:
              someLabelNode.text = achievementTextLine8_2
            case 9:
              someLabelNode.text = achievementTextLine9_2
            case 10:
              someLabelNode.text = achievementTextLine10_2
            case 11:
              someLabelNode.text = achievementTextLine11_2
            case 12:
              someLabelNode.text = achievementTextLine12_2
            case 13:
              someLabelNode.text = achievementTextLine13_2
            case 14:
              someLabelNode.text = achievementTextLine14_2
            case 15:
              someLabelNode.text = achievementTextLine15_2
            case 16:
              someLabelNode.text = achievementTextLine16_2
            case 17:
              someLabelNode.text = achievementTextLine17_2
            case 18:
              someLabelNode.text = achievementTextLine18_2
            case 19:
              someLabelNode.text = achievementTextLine19_2
            case 20:
              someLabelNode.text = achievementTextLine20_2
            case 21:
              someLabelNode.text = achievementTextLine21_2
            case 22:
              someLabelNode.text = achievementTextLine22_2
            case 23:
              someLabelNode.text = achievementTextLine23_2
            case 24:
              someLabelNode.text = achievementTextLine24_2
            case 25:
              someLabelNode.text = achievementTextLine25_2
            case 26:
              someLabelNode.text = achievementTextLine26_2
            case 27:
              someLabelNode.text = achievementTextLine27_2
            case 28:
              someLabelNode.text = achievementTextLine28_2
            case 29:
              someLabelNode.text = achievementTextLine29_2
            case 30:
              someLabelNode.text = achievementTextLine30_2
            default:
              print("Ooops, no such achievement line.")
            }
            
            
          }
        }
        
      }
      
    }
    
    // swipe gesture recognizers
    let swipeRight:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(WorldMapScene.swipedRight(_:)))
    swipeRight.direction = .right
    view.addGestureRecognizer(swipeRight)
    
    let swipeLeft:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(WorldMapScene.swipedLeft(_:)))
    swipeLeft.direction = .left
    view.addGestureRecognizer(swipeLeft)
    
    let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(AchievementsScene.swipedUp(_:)))
    swipeUp.direction = .up
    view.addGestureRecognizer(swipeUp)
    
    let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(AchievementsScene.swipedDown(_:)))
    swipeDown.direction = .down
    view.addGestureRecognizer(swipeDown)
    
    moveAchievementsScrollLayerDown = SKAction.move(by: CGVector(dx: 0, dy: -(achievementsScrollLayerHeight / 10 + 40)), duration: 0.3)
    moveAchievementsScrollLayerUp = SKAction.move(by: CGVector(dx: 0, dy: achievementsScrollLayerHeight / 10 + 40), duration: 0.3)
    
  }
  
  // remove gesture recognizers when we leave the scene
  override func willMove(from view: SKView) {
    //saveScore()
    
    if view.gestureRecognizers != nil {
      for gesture in view.gestureRecognizers! {
        if let recognizer = gesture as? UISwipeGestureRecognizer {
          view.removeGestureRecognizer(recognizer)
        }
      }
    }
  }
  
  // respond to swipes
  func swipedRight(_ sender:UISwipeGestureRecognizer){
    //movePlayer(.Right)
  }
  
  func swipedLeft(_ sender:UISwipeGestureRecognizer){
    //movePlayer(.Left)
  }
  
  func swipedUp(_ sender:UISwipeGestureRecognizer){
    moveAcheivementsScrollLayer(.Up)
  }
  
  func swipedDown(_ sender:UISwipeGestureRecognizer){
    moveAcheivementsScrollLayer(.Down)
  }
  
  func moveAcheivementsScrollLayer(_ theDirection: Direction) {
    switch theDirection {
      
    case Direction.Up:
      
      print("up")
      if !(achievementsScrollLayer?.hasActions())! {
        if pagination < 9 {
          pagination += 1
          achievementsScrollLayer?.run(moveAchievementsScrollLayerUp!)
        }
      }
      
      /*
      //achievementsScrollLayer?.runAction(moveAchievementsScrollLayerUp!)
      if achievementsScrollLayer?.position.y < achievementsScrollLayerInitialHeight {
        if !(achievementsScrollLayer?.hasActions())! {
          achievementsScrollLayer?.runAction(moveAchievementsScrollLayerUp!)
        }
      }*/
      
    case Direction.Down:
      
      print("down")
      if !(achievementsScrollLayer?.hasActions())! {
        if pagination > 0 {
          pagination -= 1
          achievementsScrollLayer?.run(moveAchievementsScrollLayerDown!)
        }
      }
      
      /*
      if achievementsScrollLayer?.position.y >= /*-8680*/ -((achievementsScrollLayerHeight * 2.33) + achievementsScrollLayerInitialHeight!) {
        if !(achievementsScrollLayer?.hasActions())! {
          achievementsScrollLayer?.runAction(moveAchievementsScrollLayerDown!)
        }
      }*/
      
    case Direction.Right:
      
      print("right")
      
    case Direction.Left:
      
      print("left")
      
    }
  }
  
  func updateAchievements() {
    for achievemenetName in arrayOfAchievementBadges {
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == achievemenetName) {
          if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
            if !PlayerStats.sharedInstance.getStatusForAchievementWithName(achievemenetName) {
              someSpriteNode.color = SKColor.black
              someSpriteNode.colorBlendFactor = 0.9
            }
            
            someSpriteNode.texture = SKTexture(imageNamed: achievemenetName)
          }
        }
      }
    }
  }
  
  func runButtonTappedAnimationOn(_ node: SKNode) {
    node.run(SKAction.sequence([SKAction.scale(by: 1.1, duration: 0.1), SKAction.scale(by: 0.9, duration: 0.1)]))
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    /* Called when a touch begins */
    for touch in touches {
      let positionInScene = touch.location(in: self)
      let touchedNode = self.atPoint(positionInScene)
      
      if let name = touchedNode.name
      {
        if name == "buttonBack"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          goToMainMenuScene()
        }
        
        
        
      }
    }
    
  }
  
  func goToMainMenuScene() {
    let mainMenuScene = MainMenuScene(fileNamed: "MainMenuScene")
    let transition = SKTransition.moveIn(with: SKTransitionDirection.down, duration: 0.5)
    //let skView = self.view as SKView!
    mainMenuScene?.scaleMode = .aspectFill
    self.view?.presentScene(mainMenuScene!, transition: transition)
  }
  
}
