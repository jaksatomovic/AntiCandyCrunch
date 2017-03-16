//
//  WorldMapScene.swift
//  AntiCandyCrunch
//
//  Created by SANDOR NAGY on 20/07/16.
//  Copyright © 2016 Rebeloper. All rights reserved.
//

import SpriteKit

class WorldMapScene: SKScene {
  
  var theChosenLevel: Level!
  
  var collectableCandyType: SKSpriteNode!
  var popupMissionTextLine1_1: SKLabelNode!
  var popupMissionTextLine1_2: SKLabelNode!
  var popupMissionTextLine2_1: SKLabelNode!
  var popupMissionTextLine2_2: SKLabelNode!
  
  enum Direction: String {
    case Up, Down, Left, Right
  }
  
  enum SpriteChildAction: String {
    case ChangeTextureTo01, ChangeTextureTo02, ChangeTextureTo03, ChangeTextureTo04, Hide
  }
  
  enum LabelChildAction: String {
    case BounceLevelNumber
  }
  
  let levelsHolderHeight: CGFloat = 3480
  var levelsHolderInitialHeight: CGFloat?
  
  var levelsHolder: SKNode?
  var moveLevelsHolderDown: SKAction?
  var moveLevelsHolderUp: SKAction?
  
  var buttonLevel001: SKSpriteNode?
  var buttonLevel002: SKSpriteNode?
  var buttonLevel003: SKSpriteNode?
  var buttonLevel004: SKSpriteNode?
  var buttonLevel005: SKSpriteNode?
  var buttonLevel006: SKSpriteNode?
  var buttonLevel007: SKSpriteNode?
  var buttonLevel008: SKSpriteNode?
  var buttonLevel009: SKSpriteNode?
  var buttonLevel010: SKSpriteNode?
  var buttonLevel011: SKSpriteNode?
  var buttonLevel012: SKSpriteNode?
  var buttonLevel013: SKSpriteNode?
  var buttonLevel014: SKSpriteNode?
  var buttonLevel015: SKSpriteNode?
  var buttonLevel016: SKSpriteNode?
  var buttonLevel017: SKSpriteNode?
  var buttonLevel018: SKSpriteNode?
  var buttonLevel019: SKSpriteNode?
  var buttonLevel020: SKSpriteNode?
  var buttonLevel021: SKSpriteNode?
  var buttonLevel022: SKSpriteNode?
  var buttonLevel023: SKSpriteNode?
  var buttonLevel024: SKSpriteNode?
  var buttonLevel025: SKSpriteNode?
  var buttonLevel026: SKSpriteNode?
  var buttonLevel027: SKSpriteNode?
  var buttonLevel028: SKSpriteNode?
  var buttonLevel029: SKSpriteNode?
  var buttonLevel030: SKSpriteNode?
  var buttonLevel031: SKSpriteNode?
  var buttonLevel032: SKSpriteNode?
  var buttonLevel033: SKSpriteNode?
  var buttonLevel034: SKSpriteNode?
  var buttonLevel035: SKSpriteNode?
  var buttonLevel036: SKSpriteNode?
  
  var arrayOfLevelButtons = [String]()
  var arrayOfLevelButtonLabels = [String]()
  var arrayOfButtonLocks = [String]()
  
  var currentLevelNumber = 1
  
  var topPanel: SKSpriteNode?
  
  var isPopupShown = false
  
  var buttonFacebook: SKSpriteNode!
  var buttonFacebookLabel: SKLabelNode!
  
  var facebookFriendBestLevel1: SKLabelNode!
  var facebookFriendBestLevel2: SKLabelNode!
  var facebookFriendBestLevel3: SKLabelNode!
  
  var facebookUser1: SKSpriteNode!
  var facebookUser2: SKSpriteNode!
  var facebookUser3: SKSpriteNode!
  
  var pagination = 0
  
  var popupTitleLabel: SKLabelNode!
  var popupTextLine1: SKLabelNode!
  var popupTextLine2: SKLabelNode!
  var popupTextLine3: SKLabelNode!
  var popupButtonLabel: SKLabelNode!
  
  var popupButtonMissionOKLabel: SKLabelNode!
  
  override func didMove(to view: SKView) {
    
    /* Setup your scene here */
    // Setup levelsHolder
    levelsHolder = self.childNode(withName: "levelsHolder")
    levelsHolderInitialHeight = levelsHolder?.position.y
    
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
    
    // get collectableCandyType
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "collectableCandyType") {
        if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
          self.collectableCandyType = someSpriteNode
        }
      }
    }
    
    // get popupMissionTextLine1_1
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "popupMissionTextLine1_1") {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          self.popupMissionTextLine1_1 = someLabelNode
          self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kWorldMapMissionTextFontSize))
        }
      }
    }
    
    // get popupMissionTextLine1_2
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "popupMissionTextLine1_2") {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          self.popupMissionTextLine1_2 = someLabelNode
          self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kWorldMapMissionTextFontSize))
        }
      }
    }
    
    // get popupMissionTextLine2_1
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "popupMissionTextLine2_1") {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          self.popupMissionTextLine2_1 = someLabelNode
          self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kWorldMapMissionTextFontSize))
        }
      }
    }
    
    // get popupMissionTextLine2_2
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "popupMissionTextLine2_2") {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          self.popupMissionTextLine2_2 = someLabelNode
          self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kWorldMapMissionTextFontSize))
        }
      }
    }
    
    // get buttonFacebook
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "buttonFacebook") {
        if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
          self.buttonFacebook = someSpriteNode
        }
      }
    }
    
    // get buttonFacebookLabel
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "buttonFacebookLabel") {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          self.buttonFacebookLabel = someLabelNode
          self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kWorldMapFacebookButtonLabelFontSize))
        }
      }
    }
    
    // get facebookFriendBestLevel1
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "facebookFriendBestLevel1") {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          self.facebookFriendBestLevel1 = someLabelNode
          self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kWorldMapFacebookFriendScoreLabelFontSize))
        }
      }
    }
    
    // get facebookFriendBestLevel2
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "facebookFriendBestLevel2") {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          self.facebookFriendBestLevel2 = someLabelNode
          self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kWorldMapFacebookFriendScoreLabelFontSize))
        }
      }
    }
    
    // get facebookFriendBestLevel3
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "facebookFriendBestLevel3") {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          self.facebookFriendBestLevel3 = someLabelNode
          self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kWorldMapFacebookFriendScoreLabelFontSize))
        }
      }
    }
    
    // get facebookUser1
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "facebookUser1") {
        if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
          self.facebookUser1 = someSpriteNode
        }
      }
    }
    
    // get facebookUser2
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "facebookUser2") {
        if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
          self.facebookUser2 = someSpriteNode
        }
      }
    }
    
    // get facebookUser3
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "facebookUser3") {
        if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
          self.facebookUser3 = someSpriteNode
        }
      }
    }
    
    // get unlocked level alert labels
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "popupTitleLabel") {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          self.popupTitleLabel = someLabelNode
          self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kWorldMapLockedLevelAlertTitleLabelFontSize))
        }
      }
      
      if (node.name == "popupTextLine1") {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          self.popupTextLine1 = someLabelNode
          self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kWorldMapLockedLevelAlertTextLabelFontSize))
        }
      }
      
      if (node.name == "popupTextLine2") {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          self.popupTextLine2 = someLabelNode
          self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kWorldMapLockedLevelAlertTextLabelFontSize))
        }
      }
      
      if (node.name == "popupTextLine3") {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          self.popupTextLine3 = someLabelNode
          self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kWorldMapLockedLevelAlertTextLabelFontSize))
        }
      }
      
      if (node.name == "popupButtonLabel") {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          self.popupButtonLabel = someLabelNode
          self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kWorldMapLockedLevelAlertButtonLabelFontSize))
        }
      }
      
      if (node.name == "popupButtonMissionOKLabel") {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          self.popupButtonMissionOKLabel = someLabelNode
          self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kWorldMapMissionAlertOKButtonLabelFontSize))
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
    
    let swipeUp:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(WorldMapScene.swipedUp(_:)))
    swipeUp.direction = .up
    view.addGestureRecognizer(swipeUp)
    
    let swipeDown:UISwipeGestureRecognizer = UISwipeGestureRecognizer(target: self, action: #selector(WorldMapScene.swipedDown(_:)))
    swipeDown.direction = .down
    view.addGestureRecognizer(swipeDown)
    
    moveLevelsHolderDown = SKAction.move(by: CGVector(dx: 0, dy: -(levelsHolderHeight / 3 + 40)), duration: 0.3)
    moveLevelsHolderUp = SKAction.move(by: CGVector(dx: 0, dy: levelsHolderHeight / 3 + 40), duration: 0.3)
    
    // Setup buttonLevels
    arrayOfLevelButtons = [ "buttonLevel001", "buttonLevel002", "buttonLevel003", "buttonLevel004", "buttonLevel005", "buttonLevel006", "buttonLevel007", "buttonLevel008", "buttonLevel009", "buttonLevel010", "buttonLevel011", "buttonLevel012", "buttonLevel013", "buttonLevel014", "buttonLevel015", "buttonLevel016", "buttonLevel017", "buttonLevel018", "buttonLevel019", "buttonLevel020", "buttonLevel021", "buttonLevel022", "buttonLevel023", "buttonLevel024", "buttonLevel025", "buttonLevel026", "buttonLevel027", "buttonLevel028", "buttonLevel029", "buttonLevel030", "buttonLevel031", "buttonLevel032", "buttonLevel033", "buttonLevel034", "buttonLevel035", "buttonLevel036" ]
    
    // Setup buttonLevelLabels
    arrayOfLevelButtonLabels = [ "buttonLevelLabel1", "buttonLevelLabel2", "buttonLevelLabel3", "buttonLevelLabel4", "buttonLevelLabel5", "buttonLevelLabel6", "buttonLevelLabel7", "buttonLevelLabel8", "buttonLevelLabel9", "buttonLevelLabel10", "buttonLevelLabel11", "buttonLevelLabel12", "buttonLevelLabel13", "buttonLevelLabel14", "buttonLevelLabel15", "buttonLevelLabel16", "buttonLevelLabel17", "buttonLevelLabel18", "buttonLevelLabel19", "buttonLevelLabel20", "buttonLevelLabel21", "buttonLevelLabel22", "buttonLevelLabel23", "buttonLevelLabel24", "buttonLevelLabel25", "buttonLevelLabel26", "buttonLevelLabel27", "buttonLevelLabel28", "buttonLevelLabel29", "buttonLevelLabel30", "buttonLevelLabel31", "buttonLevelLabel32", "buttonLevelLabel33", "buttonLevelLabel34", "buttonLevelLabel35", "buttonLevelLabel36" ]
    
    // Setup buttonLocks
    arrayOfButtonLocks = [ "buttonLock1", "buttonLock2", "buttonLock3", "buttonLock4", "buttonLock5", "buttonLock6", "buttonLock7", "buttonLock8", "buttonLock9", "buttonLock10", "buttonLock11", "buttonLock12", "buttonLock13", "buttonLock14", "buttonLock15", "buttonLock16", "buttonLock17", "buttonLock18", "buttonLock19", "buttonLock20", "buttonLock21", "buttonLock22", "buttonLock23", "buttonLock24", "buttonLock25", "buttonLock26", "buttonLock27", "buttonLock28", "buttonLock29", "buttonLock30", "buttonLock31", "buttonLock32", "buttonLock33", "buttonLock34", "buttonLock35", "buttonLock36" ]
    
    setupCurrentWorldLevelList()
    
    setupFacebookTopPanel()
    
    NotificationCenter.default.addObserver(self, selector: #selector(updateFacebookFriendsPanelToNewScores(_:)), name: NSNotification.Name(rawValue: "updateFacebookFriendsPanelToNewScores"), object: nil)
    
  }
  
  func setupLabel(_ label: SKLabelNode, fontName: String, fontSize:CGFloat) {
    label.fontName = fontName
    label.fontSize = fontSize
  }
  
  func findChildByName (_ theName: String, doSpriteChildAction: SpriteChildAction) {
    
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == theName) {
        if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
          switch doSpriteChildAction {
          case SpriteChildAction.ChangeTextureTo01:
            someSpriteNode.texture = SKTexture(imageNamed: "ButtonWorld01Level")
          case SpriteChildAction.ChangeTextureTo02:
            someSpriteNode.texture = SKTexture(imageNamed: "ButtonWorld02Level")
          case SpriteChildAction.ChangeTextureTo03:
            someSpriteNode.texture = SKTexture(imageNamed: "ButtonWorld03Level")
          case SpriteChildAction.ChangeTextureTo04:
            someSpriteNode.texture = SKTexture(imageNamed: "ButtonWorld04Level")
          case SpriteChildAction.Hide:
            someSpriteNode.alpha = 0.0
          }
        }
      }
    }
  }
  
  func findChildByName (_ theName: String, doLabelChildAction: LabelChildAction) {
    
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == theName) {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          switch doLabelChildAction {
          case LabelChildAction.BounceLevelNumber:
            someLabelNode.text = String(self.currentLevelNumber)
            someLabelNode.fontSize = CGFloat(kWorldMapLevelLabelFontSize)
            someLabelNode.fontName = kCustomFontName
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
          if !isPopupShown {
            print("Touched \(name).")
            PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
            runButtonTappedAnimationOn(touchedNode)
            goToMainMenuScene()
          }
          
        }
        
        for i in 1...36 {
          if name == "buttonLevelLabel\(i)"
          {
            if !isPopupShown {
              isPopupShown = true
              print("Touched \(name).")
              PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
              runButtonTappedAnimationOn(touchedNode)
              switch currentWorld {
              case 1:
                showMissionPopup(i)
              case 2:
                showMissionPopup(i + 36)
              case 3:
                showMissionPopup(i + 72)
              case 4:
                showMissionPopup(i + 108)
              default:
                print("Ooops. No such level.")
              }
            }
          }
        }
        
        for i in 1...36 {
          if name == "buttonLock\(i)"
          {
            if !isPopupShown {
              isPopupShown = true
              print("Touched \(name).")
              PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
              runButtonTappedAnimationOn(touchedNode)
              self.enumerateChildNodes(withName: "//*") {
                node, stop in
                if (node.name == "popupLayer") {
                  if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
                    if !someSpriteNode.hasActions() {
                      someSpriteNode.run(SKAction.move(to: CGPoint(x: 540, y: 960), duration: 0.3))
                    }
                  }
                }
              }
            }
          }
        }
        
        if name == "buttonOK" || name == "popupButtonLabel"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          isPopupShown = false
          self.enumerateChildNodes(withName: "//*") {
            node, stop in
            if (node.name == "popupLayer") {
              if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
                if !someSpriteNode.hasActions() {
                  someSpriteNode.run(SKAction.move(to: CGPoint(x: 540, y: -1000), duration: 0.3))
                }
              }
            }
          }
        }
        
        if name == "buttonMissionOK" || name == "popupButtonMissionOKLabel"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          isPopupShown = false
          goToGameScene(PlayerStats.sharedInstance.getCurrentLevel())
        }
        
        if name == "buttonMissionCancel"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          isPopupShown = false
          self.enumerateChildNodes(withName: "//*") {
            node, stop in
            if (node.name == "popupMissionLayer") {
              if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
                if !someSpriteNode.hasActions() {
                  someSpriteNode.run(SKAction.move(to: CGPoint(x: 540, y: -1000), duration: 0.3))
                }
              }
            }
          }
        }
        
        if name == "buttonFacebook" || name == "buttonFacebookLabel"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          let gameViewController = self.view?.window?.rootViewController as! GameViewController
          
          if gameViewController.isUserSignedIn() {
            
            if PlayerStats.sharedInstance.getStarsToGiveForFacebookInvite() > 0 {
              let alertController = UIAlertController(title: "Invite Friends", message: "Invite friends and get \(PlayerStats.sharedInstance.getStarsToGiveForFacebookInvite()) stars.", preferredStyle: .alert)
              let OKAction = UIAlertAction(title: "Invite", style: .default) { (action) in
                // invite some more friends
                gameViewController.openFacebookAppInvitePanel()
              }
              alertController.addAction(OKAction)
              
              let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (action) in
              }
              alertController.addAction(cancelAction)
              
              gameViewController.present(alertController, animated: true) {
              }
            } else {
              // invite some more friends
              gameViewController.openFacebookAppInvitePanel()
            }
            
            
            
          } else {
            // log in
            gameViewController.loginToFacebook({ (result) in
              if result {
                print("REBELOPER: Logged into Facebook - \(result)")
                self.buttonFacebookLabel.text = "Invite"
              } else {
                print("REBELOPER: Logged into Facebook - \(result)")
              }
            })
          }
        }
        
        
      }
    }

  }
  
  func showMissionPopup(_ level: Int) {
    PlayerStats.sharedInstance.saveCurrentLevel(level)
    
    theChosenLevel = Level(filename: "Level_\(PlayerStats.sharedInstance.getCurrentLevel())")
    
    PlayerStats.sharedInstance.saveCurrentCollectableType()
    switch PlayerStats.sharedInstance.getCurrentCollectableType() {
    case 1:
      collectableCandyType.texture = SKTexture(imageNamed: "Croissant-Highlighted")
    case 2:
      collectableCandyType.texture = SKTexture(imageNamed: "Cupcake-Highlighted")
    case 3:
      collectableCandyType.texture = SKTexture(imageNamed: "Danish-Highlighted")
    case 4:
      collectableCandyType.texture = SKTexture(imageNamed: "Donut-Highlighted")
    case 5:
      collectableCandyType.texture = SKTexture(imageNamed: "Macaroon-Highlighted")
    case 6:
      collectableCandyType.texture = SKTexture(imageNamed: "SugarCookie-Highlighted")
    default:
      print("Ooops, no such collectable candy!")
    }
    
    popupMissionTextLine1_1.text = "Collect at least \(theChosenLevel.collectableTarget)"
    popupMissionTextLine1_2.text = "chains of this candy."
    popupMissionTextLine2_1.text = "Earn a minimum of"
    popupMissionTextLine2_2.text = "\(theChosenLevel.targetScore) points."
    
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "popupMissionLayer") {
        if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
          if !someSpriteNode.hasActions() {
            someSpriteNode.run(SKAction.move(to: CGPoint(x: 540, y: 960), duration: 0.3))
          }
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
  
  func goToGameScene(_ level: Int) {
    print("Going to level: \(level)")
    let gameScene = GameScene(fileNamed: "GameScene")
    let transition = SKTransition.moveIn(with: SKTransitionDirection.up, duration: 0.5)
    //let skView = self.view as SKView!
    gameScene?.scaleMode = .aspectFill
    self.view?.presentScene(gameScene!, transition: transition)
  }
  
  override func update(_ currentTime: TimeInterval) {
    /* Called before each frame is rendered */
  }
  
  // respond to swipes
  func swipedRight(_ sender:UISwipeGestureRecognizer){
    //movePlayer(.Right)
  }
  
  func swipedLeft(_ sender:UISwipeGestureRecognizer){
    //movePlayer(.Left)
  }
  
  func swipedUp(_ sender:UISwipeGestureRecognizer){
    if !isPopupShown {
      moveLevelsHolder(.Up)
    }
  }
  
  func swipedDown(_ sender:UISwipeGestureRecognizer){
    if !isPopupShown {
      moveLevelsHolder(.Down)
    }
  }
  
  func moveLevelsHolder(_ theDirection: Direction) {
    switch theDirection {
      
    case Direction.Up:
      
      print("up")
      if !(levelsHolder?.hasActions())! {
        if pagination > 0 {
          pagination -= 1
          levelsHolder?.run(moveLevelsHolderUp!)
        }
      }
      
    case Direction.Down:
      
      print("down")
      if !(levelsHolder?.hasActions())! {
        if pagination < 8 {
          pagination += 1
          levelsHolder?.run(moveLevelsHolderDown!)
        }
      }
      
    case Direction.Right:
      
      print("right")
      
    case Direction.Left:
      
      print("left")
      
    }
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
  
  func setupCurrentWorldLevelList() {
    switch currentWorld {
    case 1:
      print("Setting up levels for world \(currentWorld)")
      
      // setting buttons texture according to the current world
      for buttonName in arrayOfLevelButtons {
        findChildByName(buttonName, doSpriteChildAction: .ChangeTextureTo01)
      }
      
      // setting button labels (numbering) acording to the current world
      currentLevelNumber = 1
      for labelName in arrayOfLevelButtonLabels {
        findChildByName(labelName, doLabelChildAction: .BounceLevelNumber)
        currentLevelNumber += 1
      }
      
      // hiding lock sprite from unlocked level buttons
      let highestUnlockedButton = PlayerStats.sharedInstance.getHighestUnlockedLevel()
      
      let unlockedLevelsCountInWorld = highestUnlockedButton
      
      var arrayOfUnlockedButtons: [String] = []
      
      var i = 1
      repeat {
        print(i)
        arrayOfUnlockedButtons.append("buttonLock\(i)")
        i = i + 1
      } while i <= unlockedLevelsCountInWorld
      
      for lockName in arrayOfUnlockedButtons {
        findChildByName(lockName, doSpriteChildAction: .Hide)
      }
      
      var arrayOfHiddenStarsButtons: [String] = []
      
      var j = unlockedLevelsCountInWorld + 1
      repeat {
        print(j)
        arrayOfHiddenStarsButtons.append("stars\(j)")
        j = j + 1
      } while j <= 36
      
      for lockName in arrayOfHiddenStarsButtons {
        findChildByName(lockName, doSpriteChildAction: .Hide)
      }
      
      var h = 1
      repeat {
        print(h)
        self.enumerateChildNodes(withName: "//*") {
          node, stop in
          if (node.name == "stars\(h)") {
            if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
              switch PlayerStats.sharedInstance.getStarsAchievedForLevel(h) {
              case 0:
                someSpriteNode.texture = SKTexture(imageNamed: "Stars0")
              case 1:
                someSpriteNode.texture = SKTexture(imageNamed: "Stars1")
              case 2:
                someSpriteNode.texture = SKTexture(imageNamed: "Stars2")
              case 3:
                someSpriteNode.texture = SKTexture(imageNamed: "Stars3")
              default:
                print("Ooops, no such stars!")
              }
            }
          }
        }
        h = h + 1
      } while h <= unlockedLevelsCountInWorld
      
      
      
    case 2:
      print("Setting up levels for world \(currentWorld)")

      // setting buttons texture according to the current world
      for buttonName in arrayOfLevelButtons {
        findChildByName(buttonName, doSpriteChildAction: .ChangeTextureTo02)
      }
      
      // setting button labels (numbering) acording to the current world
      currentLevelNumber = 37
      for labelName in arrayOfLevelButtonLabels {
        findChildByName(labelName, doLabelChildAction: .BounceLevelNumber)
        currentLevelNumber += 1
      }
      
      // hiding lock sprite from unlocked level buttons
      let highestUnlockedButton = PlayerStats.sharedInstance.getHighestUnlockedLevel()
      
      let unlockedLevelsCountInWorld = highestUnlockedButton - 36
      
      var arrayOfUnlockedButtons: [String] = []
      
      var i = 1
      repeat {
        print(i)
        arrayOfUnlockedButtons.append("buttonLock\(i)")
        i = i + 1
      } while i <= unlockedLevelsCountInWorld
      
      for lockName in arrayOfUnlockedButtons {
        findChildByName(lockName, doSpriteChildAction: .Hide)
      }
      
      var arrayOfHiddenStarsButtons: [String] = []
      
      var j = unlockedLevelsCountInWorld + 1
      repeat {
        print(j)
        arrayOfHiddenStarsButtons.append("stars\(j)")
        j = j + 1
      } while j <= 36
      
      for lockName in arrayOfHiddenStarsButtons {
        findChildByName(lockName, doSpriteChildAction: .Hide)
      }
      
      var h = 1
      repeat {
        print(h)
        self.enumerateChildNodes(withName: "//*") {
          node, stop in
          if (node.name == "stars\(h)") {
            if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
              switch PlayerStats.sharedInstance.getStarsAchievedForLevel(h + 36) {
              case 0:
                someSpriteNode.texture = SKTexture(imageNamed: "Stars0")
              case 1:
                someSpriteNode.texture = SKTexture(imageNamed: "Stars1")
              case 2:
                someSpriteNode.texture = SKTexture(imageNamed: "Stars2")
              case 3:
                someSpriteNode.texture = SKTexture(imageNamed: "Stars3")
              default:
                print("Ooops, no such stars!")
              }
            }
          }
        }
        h = h + 1
      } while h <= unlockedLevelsCountInWorld
      
      
      
      
    case 3:
      print("Setting up levels for world \(currentWorld)")

      // setting buttons texture according to the current world
      for buttonName in arrayOfLevelButtons {
        findChildByName(buttonName, doSpriteChildAction: .ChangeTextureTo03)
      }
      
      // setting button labels (numbering) acording to the current world
      currentLevelNumber = 73
      for labelName in arrayOfLevelButtonLabels {
        findChildByName(labelName, doLabelChildAction: .BounceLevelNumber)
        currentLevelNumber += 1
      }
      
      // hiding lock sprite from unlocked level buttons
      let highestUnlockedButton = PlayerStats.sharedInstance.getHighestUnlockedLevel()
      let unlockedLevelsCountInWorld = highestUnlockedButton - 72
      var arrayOfUnlockedButtons: [String] = []
      
      var i = 1
      repeat {
        print(i)
        arrayOfUnlockedButtons.append("buttonLock\(i)")
        i = i + 1
      } while i <= unlockedLevelsCountInWorld
      
      for lockName in arrayOfUnlockedButtons {
        findChildByName(lockName, doSpriteChildAction: .Hide)
      }
      
      var arrayOfHiddenStarsButtons: [String] = []
      
      var j = unlockedLevelsCountInWorld + 1
      repeat {
        print(j)
        arrayOfHiddenStarsButtons.append("stars\(j)")
        j = j + 1
      } while j <= 36
      
      for lockName in arrayOfHiddenStarsButtons {
        findChildByName(lockName, doSpriteChildAction: .Hide)
      }
      
      var h = 1
      repeat {
        print(h)
        self.enumerateChildNodes(withName: "//*") {
          node, stop in
          if (node.name == "stars\(h)") {
            if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
              switch PlayerStats.sharedInstance.getStarsAchievedForLevel(h) {
              case 0:
                someSpriteNode.texture = SKTexture(imageNamed: "Stars0")
              case 1:
                someSpriteNode.texture = SKTexture(imageNamed: "Stars1")
              case 2:
                someSpriteNode.texture = SKTexture(imageNamed: "Stars2")
              case 3:
                someSpriteNode.texture = SKTexture(imageNamed: "Stars3")
              default:
                print("Ooops, no such stars!")
              }
            }
          }
        }
        h = h + 1
      } while h <= unlockedLevelsCountInWorld
      
      
      
      
    case 4:
      print("Setting up levels for world \(currentWorld)")

      // setting buttons texture according to the current world
      for buttonName in arrayOfLevelButtons {
        findChildByName(buttonName, doSpriteChildAction: .ChangeTextureTo04)
      }
      
      // setting button labels (numbering) acording to the current world
      currentLevelNumber = 109
      for labelName in arrayOfLevelButtonLabels {
        findChildByName(labelName, doLabelChildAction: .BounceLevelNumber)
        currentLevelNumber += 1
      }
      
      // hiding lock sprite from unlocked level buttons
      let highestUnlockedButton = PlayerStats.sharedInstance.getHighestUnlockedLevel()
      let unlockedLevelsCountInWorld = highestUnlockedButton - 108
      var arrayOfUnlockedButtons: [String] = []
      
      var i = 1
      repeat {
        print(i)
        arrayOfUnlockedButtons.append("buttonLock\(i)")
        i = i + 1
      } while i <= unlockedLevelsCountInWorld
      
      for lockName in arrayOfUnlockedButtons {
        findChildByName(lockName, doSpriteChildAction: .Hide)
      }
      
      var arrayOfHiddenStarsButtons: [String] = []
      
      var j = unlockedLevelsCountInWorld + 1
      repeat {
        print(j)
        arrayOfHiddenStarsButtons.append("stars\(j)")
        j = j + 1
      } while j <= 36
      
      for lockName in arrayOfHiddenStarsButtons {
        findChildByName(lockName, doSpriteChildAction: .Hide)
      }
      
      var h = 1
      repeat {
        print(h)
        self.enumerateChildNodes(withName: "//*") {
          node, stop in
          if (node.name == "stars\(h)") {
            if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
              switch PlayerStats.sharedInstance.getStarsAchievedForLevel(h) {
              case 0:
                someSpriteNode.texture = SKTexture(imageNamed: "Stars0")
              case 1:
                someSpriteNode.texture = SKTexture(imageNamed: "Stars1")
              case 2:
                someSpriteNode.texture = SKTexture(imageNamed: "Stars2")
              case 3:
                someSpriteNode.texture = SKTexture(imageNamed: "Stars3")
              default:
                print("Ooops, no such stars!")
              }
            }
          }
        }
        h = h + 1
      } while h <= unlockedLevelsCountInWorld
      
      
      
      
    default:
      print("Ooops. No such world.")
    }
  }
  
  
  func setupFacebookTopPanel() {
    let gameViewController = self.view?.window?.rootViewController as! GameViewController
    
    if gameViewController.isUserSignedIn() {
      buttonFacebookLabel.text = "Invite"
      
      setupFacebookFriendsAccordingToTheirScores()
      
    } else {
      buttonFacebookLabel.text = "Log In"
    }
  }
  
  func setupFacebookFriendsAccordingToTheirScores() {
    let gameViewController = self.view?.window?.rootViewController as! GameViewController
    
    gameViewController.getFacebookUserFriendsList()
    
  }
  
  func updateFacebookFriendsPanelToNewScores(_ notif: Notification) {
    if PlayerStats.sharedInstance.getFacebookUserFriend("3").id != "0" || PlayerStats.sharedInstance.getFacebookUserFriend("3").score != "0" {
      print("Facebook Friends Playing this Game 3rd -- ID: \(PlayerStats.sharedInstance.getFacebookUserFriend("3").id) , Score: \(PlayerStats.sharedInstance.getFacebookUserFriend("3").score)")
      facebookFriendBestLevel3.text = PlayerStats.sharedInstance.getFacebookUserFriend("3").score
      
      let url = URL(string: "https://graph.facebook.com/\(PlayerStats.sharedInstance.getFacebookUserFriend("3").id)/picture?type=large&return_ssl_resources=1")
      facebookUser3.texture = SKTexture(image: UIImage(data: try! Data(contentsOf: url!))!)
      
    } else {
      print("Only 2 Facebook Friends have achieved any score yet. Trying to find them ... ")
      
      if PlayerStats.sharedInstance.getFacebookUserFriend("2").id != "0" || PlayerStats.sharedInstance.getFacebookUserFriend("2").score != "0" {
        print("Facebook Friends Playing this Game 2nd -- ID: \(PlayerStats.sharedInstance.getFacebookUserFriend("2").id) , Score: \(PlayerStats.sharedInstance.getFacebookUserFriend("2").score)")
        facebookFriendBestLevel2.text = PlayerStats.sharedInstance.getFacebookUserFriend("2").score
        
        let url = URL(string: "https://graph.facebook.com/\(PlayerStats.sharedInstance.getFacebookUserFriend("2").id)/picture?type=large&return_ssl_resources=1")
        facebookUser2.texture = SKTexture(image: UIImage(data: try! Data(contentsOf: url!))!)
        
      } else {
        print("Only 1 Facebook Friend has achieved any score yet. Trying to find him/her ... ")
        
        if PlayerStats.sharedInstance.getFacebookUserFriend("1").id != "0" || PlayerStats.sharedInstance.getFacebookUserFriend("1").score != "0" {
          print("Facebook Friends Playing this Game 1st -- ID: \(PlayerStats.sharedInstance.getFacebookUserFriend("1").id) , Score: \(PlayerStats.sharedInstance.getFacebookUserFriend("1").score)")
          facebookFriendBestLevel1.text = PlayerStats.sharedInstance.getFacebookUserFriend("1").score
          
          let url = URL(string: "https://graph.facebook.com/\(PlayerStats.sharedInstance.getFacebookUserFriend("1").id)/picture?type=large&return_ssl_resources=1")
          facebookUser1.texture = SKTexture(image: UIImage(data: try! Data(contentsOf: url!))!)
          
        } else {
          print("No Facebook Friends have achieved any score yet.")
        }
      }
    }
  }
  
}
