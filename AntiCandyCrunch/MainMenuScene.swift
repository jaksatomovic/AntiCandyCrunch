//
//  MainMenuScene.swift
//  AntiCandyCrunch
//
//  Created by SANDOR NAGY on 20/07/16.
//  Copyright © 2016 Rebeloper. All rights reserved.
//

import SpriteKit

var currentWorld: Int = 1

class MainMenuScene: SKScene {
  
  var theChosenLevel: Level!
  
  var collectableCandyType: SKSpriteNode!
  var popupMissionTextLine1_1: SKLabelNode!
  var popupMissionTextLine1_2: SKLabelNode!
  var popupMissionTextLine2_1: SKLabelNode!
  var popupMissionTextLine2_2: SKLabelNode!
  
  enum SpriteChildAction: String {
    case Hide
  }
  
  var numberOfWorlds = 4
  var currentWorldNumber = 1
  
  var buttonBack: SKSpriteNode?
  var buttonNext: SKSpriteNode?
  
  var worldsMenu: SKNode!
  
  var isPopupShown = false
  
  var buttonAchievements: SKSpriteNode?
  
  var popupButtonMissionOKLabel: SKLabelNode!
  
  var popupTutorialLayer: SKSpriteNode!
  var tutorialTextMessageLine1Label: SKLabelNode!
  var tutorialTextMessageLine2Label: SKLabelNode!
  var buttonTutorialOK: SKSpriteNode!
  var buttonTutorialOKLabel: SKLabelNode!
  var buttonTutorialNeverShowAgainLabel: SKLabelNode!
  
  override func didMove(to view: SKView) {
    
    showAds()
    
    if logAllAvailableFonts {
      logAvailableFonts()
    }
    
    
    /* Setup your scene here */
    // Setup buttons
    buttonBack = self.childNode(withName: "buttonBack") as? SKSpriteNode
    buttonNext = self.childNode(withName: "buttonNext") as? SKSpriteNode
    buttonAchievements = self.childNode(withName: "buttonAchievements") as? SKSpriteNode
    
    buttonBack?.alpha = 0
    
    // grab the levelsMenu
    worldsMenu = self.childNode(withName: "worldsMenu")
    
    currentWorldNumber = 1
    
    //setupLockSpritesonButtons()
    
    // get collectableCandyType
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "collectableCandyType") {
        if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
          self.collectableCandyType = someSpriteNode
        }
      }
    }
    
    // get popupButtonMissionOKLabel
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "popupButtonMissionOKLabel") {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          self.popupButtonMissionOKLabel = someLabelNode
          self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kWorldMapMissionAlertOKButtonLabelFontSize))
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
    
    // get popupTutorialLayer
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "popupTutorialLayer") {
        if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
          self.popupTutorialLayer = someSpriteNode
        }
      }
    }
    
    // get tutorialTextMessageLine1Label
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "tutorialTextMessageLine1Label") {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          self.tutorialTextMessageLine1Label = someLabelNode
          self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertButtonSmallFontSize) - 20)
        }
      }
    }
    
    // get tutorialTextMessageLine2Label
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "tutorialTextMessageLine2Label") {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          self.tutorialTextMessageLine2Label = someLabelNode
          self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertButtonSmallFontSize) - 20)
        }
      }
    }
    
    // get buttonTutorialOK
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "buttonTutorialOK") {
        if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
          self.buttonTutorialOK = someSpriteNode
        }
      }
    }
    
    // get buttonTutorialOKLabel
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "buttonTutorialOKLabel") {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          self.buttonTutorialOKLabel = someLabelNode
          self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertButtonSmallFontSize) + 20)
        }
      }
    }
    
    // get buttonTutorialNeverShowAgainLabel
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "buttonTutorialNeverShowAgainLabel") {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          self.buttonTutorialNeverShowAgainLabel = someLabelNode
          self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertButtonSmallFontSize) - 20)
        }
      }
    }
    
    if !UserDefaults.standard.bool(forKey: "doNotShowTutorial") {
      popupTutorialLayer.run(SKAction.move(to: CGPoint(x: 540, y: 960), duration: 1.0))
    }
    
    
  }
  
  func logAvailableFonts() {
    for family: String in UIFont.familyNames
    {
      print("\(family)")
      for names: String in UIFont.fontNames(forFamilyName: family)
      {
        print("== \(names)")
      }
    }
  }
  
  /*
  func setupLockSpritesonButtons() {
    // hiding lock sprite from unlocked level buttons
    let highestUnlockedButton = PlayerStats.sharedInstance.getHighestUnlockedLevel()
    
    let unlockedWorlds = (highestUnlockedButton / 36) + 1
    
    var arrayOfUnlockedButtons: [String] = []
    
    var i = 1
    repeat {
      print(i)
      arrayOfUnlockedButtons.append("lockWorld\(i)")
      i = i + 1
    } while i <= unlockedWorlds
    
    for lockName in arrayOfUnlockedButtons {
      findChildByName(lockName, doSpriteChildAction: .Hide)
    }
  }*/
  
  func findChildByName (_ theName: String, doSpriteChildAction: SpriteChildAction) {
    
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == theName) {
        if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
          switch doSpriteChildAction {
          case SpriteChildAction.Hide:
            someSpriteNode.alpha = 0.0
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
            if !worldsMenu.hasActions() {
              PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
              runButtonTappedAnimationOn(touchedNode)
              worldsMenuHasMovedBy(-1)
              worldsMenu.run(SKAction.move(by: CGVector(dx: 1080, dy: 0), duration: 0.3))
            }
          }
        }
        
        if name == "buttonNext"
        {
          if !isPopupShown {
            print("Touched \(name).")
            if !worldsMenu.hasActions() {
              PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
              runButtonTappedAnimationOn(touchedNode)
              worldsMenuHasMovedBy(1)
              worldsMenu.run(SKAction.move(by: CGVector(dx: -1080, dy: 0), duration: 0.3))
            }
          }
        }
        
        if name == "buttonPlayWorld01"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          PlayerStats.sharedInstance.saveIsRandomLevel(false)
          currentWorld = 1
          goToWorldMapScene()
        }
        
        if name == "buttonPlayWorld02"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          if PlayerStats.sharedInstance.getHighestUnlockedLevel() <= 36 {
            showInsufficientLevelsWonActionSheet()
          } else {
            PlayerStats.sharedInstance.saveIsRandomLevel(false)
            currentWorld = 2
            goToWorldMapScene()
          }
          
        }
        
        if name == "buttonPlayWorld03"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          if PlayerStats.sharedInstance.getHighestUnlockedLevel() <= 72 {
            showInsufficientLevelsWonActionSheet()
          } else {
            PlayerStats.sharedInstance.saveIsRandomLevel(false)
            currentWorld = 3
            goToWorldMapScene()
          }
          
        }
        
        if name == "buttonPlayWorld04"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          isPopupShown = true
          PlayerStats.sharedInstance.saveIsRandomLevel(true)
          goToRandomLevel()
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
        
        if name == "buttonAchievements"
        {
          if !isPopupShown {
            PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
            runButtonTappedAnimationOn(touchedNode)
            print("Touched \(name).")
            goToAchievementsScene()
          }
        }
        
        if name == "buttonSettings"
        {
          if !isPopupShown {
            PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
            runButtonTappedAnimationOn(touchedNode)
            print("Touched \(name).")
            goToSettingsScene()
          }
        }
        
        if name == "buttonTutorialOK" || name == "buttonTutorialOKLabel"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          popupTutorialLayer.run(SKAction.move(to: CGPoint(x: 540, y: 3000), duration: 1.5))
        }
        
        if name == "buttonTutorialNeverShowAgainLabel"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          popupTutorialLayer.run(SKAction.move(to: CGPoint(x: 540, y: 3000), duration: 1.5))
          UserDefaults.standard.set(true, forKey: "doNotShowTutorial")
          UserDefaults.standard.synchronize()
        }
        
        
      }
    }
    
  }
  
  func setupLabel(_ label: SKLabelNode, fontName: String, fontSize:CGFloat) {
    label.fontName = fontName
    label.fontSize = fontSize
  }
  
  func goToWorldMapScene() {
    let worldMapScene = WorldMapScene(fileNamed: "WorldMapScene")
    let transition = SKTransition.moveIn(with: SKTransitionDirection.up, duration: 0.5)
    //let skView = self.view as SKView!
    worldMapScene?.scaleMode = .aspectFill
    self.view?.presentScene(worldMapScene!, transition: transition)
  }
  
  func goToGameScene(_ level: Int) {
    print("Going to level: \(level)")
    let gameScene = GameScene(fileNamed: "GameScene")
    let transition = SKTransition.moveIn(with: SKTransitionDirection.up, duration: 0.5)
    //let skView = self.view as SKView!
    gameScene?.scaleMode = .aspectFill
    self.view?.presentScene(gameScene!, transition: transition)
  }
  
  func goToAchievementsScene() {
    let achievementsScene = AchievementsScene(fileNamed: "AchievementsScene")
    let transition = SKTransition.moveIn(with: SKTransitionDirection.up, duration: 0.5)
    //let skView = self.view as SKView!
    achievementsScene?.scaleMode = .aspectFill
    self.view?.presentScene(achievementsScene!, transition: transition)
  }
  
  func goToSettingsScene() {
    let settingsScene = SettingsScene(fileNamed: "SettingsScene")
    let transition = SKTransition.moveIn(with: SKTransitionDirection.up, duration: 0.5)
    //let skView = self.view as SKView!
    settingsScene?.scaleMode = .aspectFill
    self.view?.presentScene(settingsScene!, transition: transition)
  }
  
  func goToRandomLevel() {
    showMissionPopup(Int(arc4random_uniform(108)) + 1)
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
  
  override func update(_ currentTime: TimeInterval) {
    /* Called before each frame is rendered */
  }
  
  func worldsMenuHasMovedBy(_ place:Int) {
    currentWorldNumber = currentWorldNumber + place
    
    if currentWorldNumber < 1 {
      currentWorldNumber = 1
    }
    
    if currentWorldNumber > numberOfWorlds {
      currentWorldNumber = numberOfWorlds
    }
    
    print(currentWorldNumber)
    
    if currentWorldNumber == 1 {
      buttonBack?.run(SKAction.fadeOut(withDuration: 0.3))
    }
    
    if currentWorldNumber == 2 {
      if buttonBack?.alpha == 0 {
        buttonBack?.run(SKAction.fadeIn(withDuration: 0.3))
      }
    }
    
    if currentWorldNumber == numberOfWorlds - 1 {
      if buttonNext?.alpha == 0 {
        buttonNext?.run(SKAction.fadeIn(withDuration: 0.3))
      }
    }
    
    if currentWorldNumber == numberOfWorlds {
      buttonNext?.run(SKAction.fadeOut(withDuration: 0.3))
    }
  }
  
  func showAds() {
    if !MKStoreKit.shared().isProductPurchased(noAdsInAppPurchaseID) {
      if !Chartboost.hasInterstitial(CBLocationMainMenu) {
        Chartboost.cacheInterstitial(CBLocationMainMenu)
      }
      Chartboost.showInterstitial(CBLocationMainMenu)
      Chartboost.cacheInterstitial(CBLocationMainMenu)
    }
  }
  
  func showInsufficientLevelsWonActionSheet() {
    
    let alertController: UIAlertController = UIAlertController(title: insufficientLevelsWonAlertTitle, message: insufficientLevelsWonAlertMessage, preferredStyle: .alert)
    
    //Create and an option action
    let okAction: UIAlertAction = UIAlertAction(title: "OK", style: .cancel) { action -> Void in
      
    }
    alertController.addAction(okAction)
    
    //Present the AlertController
    self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
  }
  
}
