//
//  GameScene.swift
//  AntiCandyCrunch
//
//  Created by SANDOR NAGY on 20/07/16.
//  Copyright (c) 2016 Rebeloper. All rights reserved.
//

import SpriteKit

class GameScene: SKScene {
  
  var level: Level!
  
  let TileWidth: CGFloat = 96.0
  let TileHeight: CGFloat = 108.0
  
  var gameLayer: SKNode!
  let cookiesLayer = SKNode()
  let tilesLayer = SKNode()
  
  fileprivate var swipeFromColumn: Int?
  fileprivate var swipeFromRow: Int?
  
  var swipeHandler: ((Swap) -> ())?
  
  var selectionSprite = SKSpriteNode()
  
  
  let swapSound = SKAction.playSoundFileNamed(chompSoundFile, waitForCompletion: false)
  //let invalidSwapSound = SKAction.playSoundFileNamed("Error.wav", waitForCompletion: false)
  let matchSound = SKAction.playSoundFileNamed(kaChingSoundFile, waitForCompletion: false)
  let fallingCookieSound = SKAction.playSoundFileNamed(scrapeSoundFile, waitForCompletion: false)
  let addCookieSound = SKAction.playSoundFileNamed(dripSoundFile, waitForCompletion: false)
  
  var countdownValue = 0
  var score = 0
  var collectableAmount = 0
  
  var countdownIndicator: SKSpriteNode!
  var countdownLabel: SKLabelNode!
  var scoreAndTargetLabel: SKLabelNode!
  var collectableCandyLabel: SKLabelNode!
  var collectableCandy: SKSpriteNode!
  
  var timer = Timer()
  
  var levelStarsAchievedCount = 0
  
  var isShuffling = false
  
  let cropLayer = SKCropNode()
  let maskLayer = SKNode()
  
  var isGamePaused = false
  
  //// GAME OVER ////
  var theChosenLevel: Level!
  
  var collectableCandyType: SKSpriteNode!
  var popupMissionTextLine1_1: SKLabelNode!
  var popupMissionTextLine1_2: SKLabelNode!
  var popupMissionTextLine2_1: SKLabelNode!
  var popupMissionTextLine2_2: SKLabelNode!
  
  var gameOverTitle: SKSpriteNode!
  
  var star1: SKSpriteNode!
  var star2: SKSpriteNode!
  var star3: SKSpriteNode!
  
  var bounceUpAnimation: SKAction!
  
  var gameOverTextTitleLabel: SKLabelNode!
  var gameOverTextMessageLine1Label: SKLabelNode!
  var gameOverTextMessageLine2Label: SKLabelNode!
  
  var buttonGameOverPlayNextOrRetryLabel: SKLabelNode!
  var buttonGameOverShare: SKSpriteNode!
  var buttonGameOverShareLabel: SKLabelNode!
  //////////////////
  
  var achievementBadge: SKSpriteNode!
  var achievementTextMessageLine1Label: SKLabelNode!
  var achievementTextMessageLine2Label: SKLabelNode!
  
  var starsLabel: SKLabelNode!
  var popupPauseTextLine1: SKLabelNode!
  var popupPauseTextLine2: SKLabelNode!
  
  var timeToGive = 0
  var movesToGive = 0
  
  var popupButtonPauseGetLabel: SKLabelNode!
  
  var shopTextMessageItem1: SKLabelNode!
  var shopTextMessageItem2: SKLabelNode!
  var shopTextMessageItem3: SKLabelNode!
  var shopTextMessageItem4: SKLabelNode!
  var shopTextMessageItem5: SKLabelNode!
  
  var popupPauseLayer: SKSpriteNode!
  var popupMissionLayer: SKSpriteNode!
  var popupGameOverLayer: SKSpriteNode!
  var popupAchievementLayer: SKSpriteNode!
  var popupShopLayer: SKSpriteNode!
  
  var worldsMenu: SKNode!
  var numberOfWorlds = 5
  var currentWorldNumber = 1
  
  var buttonBack: SKSpriteNode?
  var buttonNext: SKSpriteNode?
  
  var shareImage: UIImage!
  
  var buttonShopBuyItem01Label: SKLabelNode!
  var buttonShopBuyItem02Label: SKLabelNode!
  var buttonShopBuyItem03Label: SKLabelNode!
  var buttonShopBuyItem04Label: SKLabelNode!
  var buttonShopBuyItem05Label: SKLabelNode!
  
  var buttonAchievementOKLabel: SKLabelNode!
  var buttonAchievementShareLabel: SKLabelNode!
  
  var popupButtonMissionOKLabel: SKLabelNode!
  
  var topPanel: SKSpriteNode!
  
  var gameLayerInitialPosition: CGPoint!
  
    override func didMove(to view: SKView) {
      
      swipeHandler = handleSwipe
      
        /* Setup your scene here */
      
      // grab the gameLayer
      gameLayer = self.childNode(withName: "gameLayer")
      gameLayerInitialPosition = CGPoint(x: 540.0, y: 900.0)
      
      let layerPosition = CGPoint(
        x: -TileWidth * CGFloat(NumColumns) / 2,
        y: -TileHeight * CGFloat(NumRows) / 2)
      
      tilesLayer.position = layerPosition
      tilesLayer.zPosition = 101
      gameLayer.addChild(tilesLayer)
      /*
      gameLayer.addChild(cropLayer)
      
      maskLayer.position = layerPosition
      cropLayer.maskNode = maskLayer*/
      
      cookiesLayer.position = layerPosition
      cookiesLayer.zPosition = 102
      gameLayer.addChild(cookiesLayer)
      //cropLayer.addChild(cookiesLayer)
      
      level = Level(filename: "Level_\(PlayerStats.sharedInstance.getCurrentLevel())")
      addTiles()
      
      // Setup topPanel
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "topPanel") {
          if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
            self.topPanel = someSpriteNode
            if DeviceType.IS_IPHONE_4_OR_LESS {
              someSpriteNode.position.y = 810 + 960
            } else if DeviceType.IS_IPAD {
              someSpriteNode.position.y = 720 + 960
            } else if DeviceType.IS_IPAD_PRO {
              someSpriteNode.position.y = 720 + 960
            }
          }
        }
      }
      
      // get countdownIndicator
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "countdownIndicator") {
          if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
            self.countdownIndicator = someSpriteNode
          }
        }
      }
      
      // get countdownLabel
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "countdownLabel") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.countdownLabel = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneCountdownLabelFontSize))
          }
        }
      }
      
      // get scoreAndTargetLabel
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "scoreAndTargetLabel") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.scoreAndTargetLabel = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneScoresLabelFontSize))
          }
        }
      }
      
      // get collectableCandyLabel
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "collectableCandyLabel") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.collectableCandyLabel = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneScoresLabelFontSize))
          }
        }
      }
      
      // get collectableCandy
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "collectableCandy") {
          if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
            self.collectableCandy = someSpriteNode
          }
        }
      }
      
      // get starsLabel
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "starsLabel") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.starsLabel = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneScoresLabelFontSize))
          }
        }
      }
      
      // get popupPauseTextLine1
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "popupPauseTextLine1") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.popupPauseTextLine1 = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertTextFontSize))
          }
        }
      }
      
      // get popupPauseTextLine2
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "popupPauseTextLine2") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.popupPauseTextLine2 = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertTextFontSize))
          }
        }
      }
      
      // get popupButtonPauseGetLabel
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "popupButtonPauseGetLabel") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.popupButtonPauseGetLabel = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertButtonBigFontSize))
          }
        }
      }
      
      // get shopTextMessageItem1
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "shopTextMessageItem1") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.shopTextMessageItem1 = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertTextFontSize))
            self.shopTextMessageItem1.text = "Get \(stars1InAppPurchaseCount) stars!"
          }
        }
      }
      
      // get shopTextMessageItem2
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "shopTextMessageItem2") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.shopTextMessageItem2 = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertTextFontSize))
            self.shopTextMessageItem2.text = "Get \(stars2InAppPurchaseCount) stars!"
          }
        }
      }
      
      // get shopTextMessageItem3
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "shopTextMessageItem3") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.shopTextMessageItem3 = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertTextFontSize))
            self.shopTextMessageItem3.text = "Get \(stars3InAppPurchaseCount) stars!"
          }
        }
      }
      
      // get shopTextMessageItem4
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "shopTextMessageItem4") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.shopTextMessageItem4 = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertTextFontSize))
          }
        }
      }
      
      // get shopTextMessageItem5
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "shopTextMessageItem5") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.shopTextMessageItem5 = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertTextFontSize))
          }
        }
      }
      
      // get shopButtons labels
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "buttonShopBuyItem01Label") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.buttonShopBuyItem01Label = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertButtonBigFontSize))
          }
        }
        
        if (node.name == "buttonShopBuyItem02Label") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.buttonShopBuyItem02Label = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertButtonBigFontSize))
          }
        }
        
        if (node.name == "buttonShopBuyItem03Label") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.buttonShopBuyItem03Label = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertButtonBigFontSize))
          }
        }
        
        if (node.name == "buttonShopBuyItem04Label") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.buttonShopBuyItem04Label = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertButtonBigFontSize))
          }
        }
        
        if (node.name == "buttonShopBuyItem05Label") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.buttonShopBuyItem05Label = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertButtonBigFontSize - 50))
          }
        }
      }
      
      
      beginGame()
      
      swipeFromColumn = nil
      swipeFromRow = nil
      
      let _ = SKLabelNode(fontNamed: "GillSans-BoldItalic")
      
      
      ///// GAME OVER /////
      // get gameOverTitle
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "gameOverTitle") {
          if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
            self.gameOverTitle = someSpriteNode
          }
        }
      }
      
      // get star1
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "star1") {
          if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
            self.star1 = someSpriteNode
          }
        }
      }
      
      // get star2
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "star2") {
          if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
            self.star2 = someSpriteNode
          }
        }
      }
      
      // get star3
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "star3") {
          if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
            self.star3 = someSpriteNode
          }
        }
      }
      
      star1.setScale(0.0)
      star2.setScale(0.0)
      star3.setScale(0.0)
      
      bounceUpAnimation = SKAction.sequence([SKAction.scale(to: 1.1, duration: 0.3), SKAction.scale(to: 0.95, duration: 0.2), SKAction.scale(to: 1.0, duration: 0.2)])
      
      // get gameOverTextTitleLabel
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "gameOverTextTitleLabel") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.gameOverTextTitleLabel = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertTextFontSize + 20))
          }
        }
      }
      
      // get gameOverTextMessageLine1Label
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "gameOverTextMessageLine1Label") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.gameOverTextMessageLine1Label = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertTextFontSize))
          }
        }
      }
      
      // get gameOverTextMessageLine2Label
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "gameOverTextMessageLine2Label") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.gameOverTextMessageLine2Label = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertTextFontSize))
          }
        }
      }
      
      // get buttonGameOverPlayNextOrRetryLabel
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "buttonGameOverPlayNextOrRetryLabel") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.buttonGameOverPlayNextOrRetryLabel = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertButtonBigFontSize))
          }
        }
      }
      
      // get buttonGameOverShareLabel
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "buttonGameOverShareLabel") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.buttonGameOverShareLabel = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertButtonSmallFontSize))
          }
        }
      }
      
      // get buttonGameOverShare
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "buttonGameOverShare") {
          if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
            self.buttonGameOverShare = someSpriteNode
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
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertTextFontSize))
          }
        }
      }
      
      // get popupMissionTextLine1_2
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "popupMissionTextLine1_2") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.popupMissionTextLine1_2 = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertTextFontSize))
          }
        }
      }
      
      // get popupMissionTextLine2_1
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "popupMissionTextLine2_1") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.popupMissionTextLine2_1 = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertTextFontSize))
          }
        }
      }
      
      // get popupMissionTextLine2_2
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "popupMissionTextLine2_2") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.popupMissionTextLine2_2 = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertTextFontSize))
          }
        }
      }
      
      // get popupButtonMissionOKLabel
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "popupButtonMissionOKLabel") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.popupButtonMissionOKLabel = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertButtonBigFontSize))
          }
        }
      }
      
      ////////////////////
      
      // get achievementBadge
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "AchievementBadge") {
          if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
            self.achievementBadge = someSpriteNode
          }
        }
      }
      
      
      // get achievementTextMessageLine1Label
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "achievementTextMessageLine1Label") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.achievementTextMessageLine1Label = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertTextFontSize))
          }
        }
      }
      
      // get achievementTextMessageLine2Label
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "achievementTextMessageLine2Label") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.achievementTextMessageLine2Label = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertTextFontSize))
          }
        }
      }
      
      // get buttonAchievementOKLabel
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "buttonAchievementOKLabel") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.buttonAchievementOKLabel = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertButtonBigFontSize))
          }
        }
      }
      
      // get buttonAchievementShareLabel
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "buttonAchievementShareLabel") {
          if let someLabelNode:SKLabelNode = node as? SKLabelNode {
            self.buttonAchievementShareLabel = someLabelNode
            self.setupLabel(someLabelNode, fontName: kCustomFontName, fontSize: CGFloat(kGameSceneAlertButtonSmallFontSize))
          }
        }
      }
      
      // get popopLayers
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "popupPauseLayer") {
          if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
            self.popupPauseLayer = someSpriteNode
          }
        }
        
        if (node.name == "popupMissionLayer") {
          if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
            self.popupMissionLayer = someSpriteNode
          }
        }
        
        if (node.name == "popupGameOverLayer") {
          if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
            self.popupGameOverLayer = someSpriteNode
          }
        }
        
        if (node.name == "popupAchievementLayer") {
          if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
            self.popupAchievementLayer = someSpriteNode
          }
        }
        
        if (node.name == "popupShopLayer") {
          if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
            self.popupShopLayer = someSpriteNode
          }
        }
      }
      
      
      // get worldsMenu
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "worldsMenu") {
          if let someNode:SKNode = node {
            self.worldsMenu = someNode
          }
        }
      }
      
      // get buttonBack
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "buttonBack") {
          if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
            self.buttonBack = someSpriteNode
          }
        }
      }
      buttonBack?.alpha = 0
      
      // get buttonNext
      self.enumerateChildNodes(withName: "//*") {
        node, stop in
        if (node.name == "buttonNext") {
          if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
            self.buttonNext = someSpriteNode
          }
        }
      }
      
      NotificationCenter.default.addObserver(self, selector: #selector(GameScene.achievementCompletedNotification(_:)), name:NSNotification.Name(rawValue: "AchievementCompletedNotification"), object: nil)
      
      
      
    }
  
  func setupLabel(_ label: SKLabelNode, fontName: String, fontSize:CGFloat) {
    label.fontName = fontName
    label.fontSize = fontSize
  }
  
  override func willMove(from view: SKView) {
    NotificationCenter.default.removeObserver(self)
  }
  
  func achievementCompletedNotification(_ notification: Notification){
    //Take Action on Notification
    print("Achievement completed: \((notification as NSNotification).userInfo?["CompletedAchievemenet"]!)")
    let achievementNumber: String = (notification as NSNotification).userInfo?["CompletedAchievemenet"]! as! String
    print("Achievement completed: \(achievementNumber)")
    
    var theLine1 = ""
    var theLine2 = ""
    
    switch achievementNumber {
    case "1":
      theLine1 = achievementTextLine1_1
      theLine2 = achievementTextLine1_2
    case "2":
      theLine1 = achievementTextLine2_1
      theLine2 = achievementTextLine2_2
    case "3":
      theLine1 = achievementTextLine3_1
      theLine2 = achievementTextLine3_2
    case "4":
      theLine1 = achievementTextLine4_1
      theLine2 = achievementTextLine4_2
    case "5":
      theLine1 = achievementTextLine5_1
      theLine2 = achievementTextLine5_2
    case "6":
      theLine1 = achievementTextLine6_1
      theLine2 = achievementTextLine6_2
    case "7":
      theLine1 = achievementTextLine7_1
      theLine2 = achievementTextLine7_2
    case "8":
      theLine1 = achievementTextLine8_1
      theLine2 = achievementTextLine8_2
    case "9":
      theLine1 = achievementTextLine9_1
      theLine2 = achievementTextLine9_2
    case "10":
      theLine1 = achievementTextLine10_1
      theLine2 = achievementTextLine10_2
    case "11":
      theLine1 = achievementTextLine11_1
      theLine2 = achievementTextLine11_2
    case "12":
      theLine1 = achievementTextLine12_1
      theLine2 = achievementTextLine12_2
    case "13":
      theLine1 = achievementTextLine13_1
      theLine2 = achievementTextLine13_2
    case "14":
      theLine1 = achievementTextLine14_1
      theLine2 = achievementTextLine14_2
    case "15":
      theLine1 = achievementTextLine15_1
      theLine2 = achievementTextLine15_2
    case "16":
      theLine1 = achievementTextLine16_1
      theLine2 = achievementTextLine16_2
    case "17":
      theLine1 = achievementTextLine17_1
      theLine2 = achievementTextLine17_2
    case "18":
      theLine1 = achievementTextLine18_1
      theLine2 = achievementTextLine18_2
    case "19":
      theLine1 = achievementTextLine19_1
      theLine2 = achievementTextLine19_2
    case "20":
      theLine1 = achievementTextLine20_1
      theLine2 = achievementTextLine20_2
    case "21":
      theLine1 = achievementTextLine21_1
      theLine2 = achievementTextLine21_2
    case "22":
      theLine1 = achievementTextLine22_1
      theLine2 = achievementTextLine22_2
    case "23":
      theLine1 = achievementTextLine23_1
      theLine2 = achievementTextLine23_2
    case "24":
      theLine1 = achievementTextLine24_1
      theLine2 = achievementTextLine24_2
    case "25":
      theLine1 = achievementTextLine25_1
      theLine2 = achievementTextLine25_2
    case "26":
      theLine1 = achievementTextLine26_1
      theLine2 = achievementTextLine26_2
    case "27":
      theLine1 = achievementTextLine27_1
      theLine2 = achievementTextLine27_2
    case "28":
      theLine1 = achievementTextLine28_1
      theLine2 = achievementTextLine28_2
    case "29":
      theLine1 = achievementTextLine29_1
      theLine2 = achievementTextLine29_2
    case "30":
      theLine1 = achievementTextLine30_1
      theLine2 = achievementTextLine30_2
    default:
      print("Ooops, no such achievement number.")
    }
    
    // TODO: show achievement completed alert layer
    showAchievmentPopupBadgeName("AchievementBadge\(achievementNumber)", line1: theLine1, line2: theLine2)
  }
  
  func addSpritesForCookies(_ cookies: Set<Cookie>) {
    for cookie in cookies {
      let sprite = SKSpriteNode(imageNamed: cookie.cookieType.spriteName)
      sprite.size = CGSize(width: TileWidth, height: TileHeight)
      sprite.position = pointForColumn(cookie.column, row:cookie.row)
      cookiesLayer.addChild(sprite)
      cookie.sprite = sprite
      
      // Give each cookie sprite a small, random delay. Then fade them in.
      sprite.alpha = 0
      sprite.xScale = 0.5
      sprite.yScale = 0.5
      
      sprite.run(
        SKAction.sequence([
          SKAction.wait(forDuration: 0.25, withRange: 0.5),
          SKAction.group([
            SKAction.fadeIn(withDuration: 0.25),
            SKAction.scale(to: 1.0, duration: 0.25)
            ])
          ]))
    }
  }
  
  func pointForColumn(_ column: Int, row: Int) -> CGPoint {
    return CGPoint(
      x: CGFloat(column)*TileWidth + TileWidth/2,
      y: CGFloat(row)*TileHeight + TileHeight/2)
  }
  
  func beginGame() {
    level.resetComboMultiplier()
    shuffle()
    setupStats()
    updateLabels()
  }
  
  func removeAllCookieSprites() {
    cookiesLayer.removeAllChildren()
  }
  
  func shuffle() {
    removeAllCookieSprites()
    let newCookies = level.shuffle()
    addSpritesForCookies(newCookies)
  }
  
  func runButtonTappedAnimationOn(_ node: SKNode) {
    node.run(SKAction.sequence([SKAction.scale(by: 1.1, duration: 0.1), SKAction.scale(by: 0.9, duration: 0.1)]))
  }
    
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
    print("-")
    // 1
    guard let touch = touches.first else { return }
    let location = touch.location(in: cookiesLayer)
    // 2
    let (success, column, row) = convertPoint(location)
    if success {
      // 3
      if let cookie = level.cookieAtColumn(column, row: row) {
        showSelectionIndicatorForCookie(cookie)
        // 4
        swipeFromColumn = column
        swipeFromRow = row
      }
    }
    
    ////// GAME OVER ///////
    for touch in touches {
      let positionInScene = touch.location(in: self)
      let touchedNode = self.atPoint(positionInScene)
      
      if let name = touchedNode.name
      {
        
        if name == "buttonGameOverPlayNextOrRetry" || name == "buttonGameOverPlayNextOrRetryLabel"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          setupMissionPopup(PlayerStats.sharedInstance.getCurrentLevel())
          self.enumerateChildNodes(withName: "//*") {
            node, stop in
            if (node.name == "popupMissionLayer") {
              if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
                if !someSpriteNode.hasActions() {
                  self.moveOnScreen(someSpriteNode)
                }
              }
            }
          }
          
        }
        
        if name == "buttonGameOverShare" || name == "buttonGameOverShareLabel"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          shareScore()
        }
        
        if name == "buttonMissionOK" || name == "popupButtonMissionOKLabel"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          goToGameScene(PlayerStats.sharedInstance.getCurrentLevel())
        }
        
        if name == "buttonMissionCancel"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          self.enumerateChildNodes(withName: "//*") {
            node, stop in
            if (node.name == "popupGameOverLayer") {
              if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
                if !someSpriteNode.hasActions() {
                  self.moveOnScreen(someSpriteNode)
                }
              }
            }
          }
        }
        
        if name == "buttonShuffle"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          if !isGamePaused {
            if PlayerStats.sharedInstance.getOverallStars() >= 4 {
              isShuffling = true
              shuffle()
              decrementCountdownValue()
              PlayerStats.sharedInstance.updateOverallStarsWith(-4)
              self.updateLabels()
            } else {
              isGamePaused = true
              self.showInsufficientCoinsActionSheet()
            }
            
          }
        }
        
        if name == "buttonPause"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          isGamePaused = true
          setupPauseMenu()
          self.enumerateChildNodes(withName: "//*") {
            node, stop in
            if (node.name == "popupPauseLayer") {
              if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
                if !someSpriteNode.hasActions() {
                  if someSpriteNode.position.y < 0 {
                    self.moveOnScreen(someSpriteNode)
                    // move gamelayer
                    self.gameLayer.run(SKAction.move(to: CGPoint(x: 540, y: -3000), duration: 0.3))
                    if self.level.isTimed {
                      // stop timer
                      self.timer.invalidate()
                    }
                  }
                }
              }
            }
          }
          
        }
        
        if name == "buttonPauseResumePlay"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          isGamePaused = false
          self.enumerateChildNodes(withName: "//*") {
            node, stop in
            if (node.name == "popupPauseLayer") {
              if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
                if !someSpriteNode.hasActions() {
                  self.moveEveryPannelOffScreen()
                  self.gameLayer.run(SKAction.move(to: self.gameLayerInitialPosition, duration: 0.3))
                  if self.level.isTimed{
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(GameScene.updateCounter), userInfo: nil, repeats: true)
                  }
                }
              }
            }
          }
          
        }
        
        if name == "buttonPauseGoToMainMenu"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          if level.isTimed {
            timer.invalidate()
          }
          goToMainMenuScene()
        }
        
        if name == "buttonAchievementOK" || name == "buttonAchievementOKLabel"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          if level.isTimed {
            timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(GameScene.updateCounter), userInfo: nil, repeats: true)
          }
          self.enumerateChildNodes(withName: "//*") {
            node, stop in
            if (node.name == "popupAchievementLayer") {
              if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
                if !someSpriteNode.hasActions() {
                  self.moveEveryPannelOffScreen()
                  self.gameLayer.run(SKAction.move(to: self.gameLayerInitialPosition, duration: 0.3))
                }
              }
            }
          }
        }
        
        if name == "buttonAchievementShare" || name == "buttonAchievementShareLabel"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          shareAchievement()
        }
        
        if name == "buttonPauseGet" || name == "popupButtonPauseGetLabel"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          if PlayerStats.sharedInstance.getOverallStars() >= 4 {
            isGamePaused = false
            self.enumerateChildNodes(withName: "//*") {
              node, stop in
              if (node.name == "popupPauseLayer") {
                if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
                  if !someSpriteNode.hasActions() {
                    self.moveEveryPannelOffScreen()
                    self.gameLayer.run(SKAction.move(to: self.gameLayerInitialPosition, duration: 0.3))
                    if self.level.isTimed{
                      if self.countdownValue <= self.level.time * 2 / 3 {
                        PlayerStats.sharedInstance.updateOverallStarsWith(-4)
                        self.countdownValue += self.timeToGive
                        self.updateLabels()
                      }
                      self.timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(GameScene.updateCounter), userInfo: nil, repeats: true)
                    } else {
                      if self.countdownValue <= self.level.maximumMoves * 2 / 3 {
                        PlayerStats.sharedInstance.updateOverallStarsWith(-4)
                        self.countdownValue += self.movesToGive
                        self.updateLabels()
                      }
                    }
                  }
                }
              }
            }
          } else {
            showInsufficientCoinsActionSheet()
          }
          
        }
        
        if name == "buttonPauseShop" {
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          self.enumerateChildNodes(withName: "//*") {
            node, stop in
            if (node.name == "popupShopLayer") {
              if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
                if !someSpriteNode.hasActions() {
                  self.moveOnScreen(someSpriteNode)
                }
              }
            }
          }
        }
        
        if name == "buttonBack"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          if !worldsMenu.hasActions() {
            worldsMenuHasMovedBy(-1)
            worldsMenu.run(SKAction.move(by: CGVector(dx: 1080, dy: 0), duration: 0.3))
          }
        }
        
        if name == "buttonNext"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          if !worldsMenu.hasActions() {
            worldsMenuHasMovedBy(1)
            worldsMenu.run(SKAction.move(by: CGVector(dx: -1080, dy: 0), duration: 0.3))
          }
        }
        
        if name == "buttonShopBack" {
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          self.enumerateChildNodes(withName: "//*") {
            node, stop in
            if (node.name == "popupShopLayer") {
              if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
                if !someSpriteNode.hasActions() {
                  self.isGamePaused = false
                  self.moveEveryPannelOffScreen()
                  self.starsLabel.text = String(format: "%ld", PlayerStats.sharedInstance.getOverallStars())
                  self.gameLayer.run(SKAction.move(to: self.gameLayerInitialPosition, duration: 0.3))
                  if self.level.isTimed{
                    self.timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(GameScene.updateCounter), userInfo: nil, repeats: true)
                  }
                }
              }
            }
          }
        }
        
        if name == "buttonShopBuyItem01" || name == "buttonShopBuyItem01Label"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          MKStoreKit.shared().initiatePaymentRequestForProduct(withIdentifier: stars1InAppPurchaseID)
        }
        
        if name == "buttonShopBuyItem02" || name == "buttonShopBuyItem02Label"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          MKStoreKit.shared().initiatePaymentRequestForProduct(withIdentifier: stars2InAppPurchaseID)
        }
        
        if name == "buttonShopBuyItem03" || name == "buttonShopBuyItem03Label"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          MKStoreKit.shared().initiatePaymentRequestForProduct(withIdentifier: stars3InAppPurchaseID)
        }
        
        if name == "buttonShopBuyItem04" || name == "buttonShopBuyItem04Label"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          MKStoreKit.shared().initiatePaymentRequestForProduct(withIdentifier: noAdsInAppPurchaseID)
        }
        
        if name == "buttonShopBuyItem05" || name == "buttonShopBuyItem05Label"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          MKStoreKit.shared().restorePurchases()
        }
        
        

        
      }
    }
    ////////////////////////
    
    
  }
  
  override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
    // 1
    guard swipeFromColumn != nil else { return }
    
    // 2
    guard let touch = touches.first else { return }
    let location = touch.location(in: cookiesLayer)
    
    let (success, column, row) = convertPoint(location)
    if success {
      
      // 3
      var horzDelta = 0, vertDelta = 0
      if column < swipeFromColumn! {          // swipe left
        horzDelta = -1
      } else if column > swipeFromColumn! {   // swipe right
        horzDelta = 1
      } else if row < swipeFromRow! {         // swipe down
        vertDelta = -1
      } else if row > swipeFromRow! {         // swipe up
        vertDelta = 1
      }
      
      // 4
      if horzDelta != 0 || vertDelta != 0 {
        trySwapHorizontal(horzDelta, vertical: vertDelta)
        hideSelectionIndicator()
        // 5
        swipeFromColumn = nil
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
    if selectionSprite.parent != nil && swipeFromColumn != nil {
      hideSelectionIndicator()
    }
    
    swipeFromColumn = nil
    swipeFromRow = nil
  }
  
  override func touchesCancelled(_ touches: Set<UITouch>, with event: UIEvent?) {
    if touches.first != nil {
      touchesEnded(touches, with: event)
    }
    super.touchesCancelled(touches, with: event)
  }
  
  func trySwapHorizontal(_ horzDelta: Int, vertical vertDelta: Int) {
    // 1
    let toColumn = swipeFromColumn! + horzDelta
    let toRow = swipeFromRow! + vertDelta
    // 2
    guard toColumn >= 0 && toColumn < NumColumns else { return }
    guard toRow >= 0 && toRow < NumRows else { return }
    // 3
    if let toCookie = level.cookieAtColumn(toColumn, row: toRow),
      let fromCookie = level.cookieAtColumn(swipeFromColumn!, row: swipeFromRow!) {
      // 4
      if let handler = swipeHandler {
        let swap = Swap(cookieA: fromCookie, cookieB: toCookie)
        handler(swap)
      }
    }
  }
  
  func addTiles() {
    for row in 0..<NumRows {
      for column in 0..<NumColumns {
        if level.tileAtColumn(column, row: row) != nil {
          let tileNode = SKSpriteNode(imageNamed: "Tile")
          if showTiles {
            tileNode.alpha = 0.0
          }
          tileNode.size = CGSize(width: TileWidth, height: TileHeight)
          tileNode.position = pointForColumn(column, row: row)
          tilesLayer.addChild(tileNode)
        }
      }
    }
    
    for row in 0...NumRows {
      for column in 0...NumColumns {
        let topLeft     = (column > 0) && (row < NumRows)
          && level.tileAtColumn(column - 1, row: row) != nil
        let bottomLeft  = (column > 0) && (row > 0)
          && level.tileAtColumn(column - 1, row: row - 1) != nil
        let topRight    = (column < NumColumns) && (row < NumRows)
          && level.tileAtColumn(column, row: row) != nil
        let bottomRight = (column < NumColumns) && (row > 0)
          && level.tileAtColumn(column, row: row - 1) != nil
        
        // The tiles are named from 0 to 15, according to the bitmask that is
        // made by combining these four values.
        let value = Int(topLeft.hashValue) | Int(topRight.hashValue) << 1 | Int(bottomLeft.hashValue) << 2 | Int(bottomRight.hashValue) << 3
        
        // Values 0 (no tiles), 6 and 9 (two opposite tiles) are not drawn.
        if value != 0 && value != 6 && value != 9 {
          let name = String(format: "Tile_%ld", value)
          let tileNode = SKSpriteNode(imageNamed: name)
          tileNode.size = CGSize(width: TileWidth, height: TileHeight)
          var point = pointForColumn(column, row: row)
          point.x -= TileWidth/2
          point.y -= TileHeight/2
          tileNode.position = point
          tilesLayer.addChild(tileNode)
        }
      }
    }
  }
  
  func convertPoint(_ point: CGPoint) -> (success: Bool, column: Int, row: Int) {
    if point.x >= 0 && point.x < CGFloat(NumColumns)*TileWidth &&
      point.y >= 0 && point.y < CGFloat(NumRows)*TileHeight {
      return (true, Int(point.x / TileWidth), Int(point.y / TileHeight))
    } else {
      return (false, 0, 0)  // invalid location
    }
  }
  
  func animateSwap(_ swap: Swap, completion: @escaping () -> ()) {
    let spriteA = swap.cookieA.sprite!
    let spriteB = swap.cookieB.sprite!
    
    spriteA.zPosition = 100
    spriteB.zPosition = 90
    
    let Duration: TimeInterval = 0.3
    
    let moveA = SKAction.move(to: spriteB.position, duration: Duration)
    moveA.timingMode = .easeOut
    spriteA.run(moveA, completion: completion)
    
    let moveB = SKAction.move(to: spriteA.position, duration: Duration)
    moveB.timingMode = .easeOut
    spriteB.run(moveB)
    
    if PlayerStats.sharedInstance.getSoundState()  {
      run(swapSound)
    }
    
  }
  
  func handleSwipe(_ swap: Swap) {
    view!.isUserInteractionEnabled = false
    
    level.performSwap(swap)
    
    animateSwap(swap, completion: handleMatches)
  }

  func showSelectionIndicatorForCookie(_ cookie: Cookie) {
    if selectionSprite.parent != nil {
      selectionSprite.removeFromParent()
    }
    
    if let sprite = cookie.sprite {
      let texture = SKTexture(imageNamed: cookie.cookieType.highlightedSpriteName)
      selectionSprite.size = CGSize(width: TileWidth, height: TileHeight)
      selectionSprite.run(SKAction.setTexture(texture))
      
      sprite.addChild(selectionSprite)
      selectionSprite.alpha = 1.0
    }
  }
  
  func hideSelectionIndicator() {
    selectionSprite.run(SKAction.sequence([
      SKAction.fadeOut(withDuration: 0.3),
      SKAction.removeFromParent()]))
  }
  
  func handleMatches() {
    let chains = level.removeMatches()
    if chains.count == 0 {
      beginNextTurn()
      return
    }
    animateMatchedCookies(chains) {
      let columns = self.level.fillHoles()
      for chain in chains {
        self.score += chain.score
        self.collectableAmount += chain.collectableScore
      }
      self.updateLabels()
      self.animateFallingCookies(columns) {
        let columns = self.level.topUpCookies()
        self.animateNewCookies(columns) {
          self.handleMatches()
        }
      }
    }
  }
  
  func beginNextTurn() {
    level.resetComboMultiplier()
    level.detectPossibleSwaps()
    view!.isUserInteractionEnabled = true
    if !level.isTimed {
      decrementCountdownValue()
    }
  }
  
  func animateMatchedCookies(_ chains: Set<Chain>, completion: @escaping () -> ()) {
    for chain in chains {
      
      if chain.length == 3 {
        animateScoreForChain(chain, goodChain: false)
      } else {
        animateScoreForChain(chain, goodChain:  true)
      }
      
      for cookie in chain.cookies {
        if let sprite = cookie.sprite {
          if sprite.action(forKey: "removing") == nil {

            sprite.texture = SKTexture(imageNamed: "MatchCircle\(Int(arc4random_uniform(2))+1)")
            sprite.alpha = 0.7
            
            let animationDuration = Double(arc4random_uniform(1))+1
            let scaleSize = CGFloat(arc4random_uniform(3))+3
            
            let scaleCircleAction = SKAction.scale(to: scaleSize, duration: animationDuration)
            scaleCircleAction.timingMode = .easeOut
            let fadeOutCircleAction = SKAction.fadeOut(withDuration: animationDuration)
            fadeOutCircleAction.timingMode = .easeOut
            let scaleAction = SKAction.scale(to: 0.1, duration: 0.3)
            scaleAction.timingMode = .easeOut
            sprite.run(SKAction.sequence([scaleCircleAction, fadeOutCircleAction, scaleAction, SKAction.removeFromParent()]),
                             withKey:"removing")
          }
        }
      }
    }
    if PlayerStats.sharedInstance.getSoundState()  {
      run(matchSound)
    }
    
    run(SKAction.wait(forDuration: 0.3), completion: completion)
  }
  
  func animateFallingCookies(_ columns: [[Cookie]], completion: @escaping () -> ()) {
    // 1
    var longestDuration: TimeInterval = 0
    for array in columns {
      for (idx, cookie) in array.enumerated() {
        let newPosition = pointForColumn(cookie.column, row: cookie.row)
        // 2
        let delay = 0.05 + 0.15*TimeInterval(idx)
        // 3
        let sprite = cookie.sprite!
        let duration = TimeInterval(((sprite.position.y - newPosition.y) / TileHeight) * 0.1)
        // 4
        longestDuration = max(longestDuration, duration + delay)
        // 5
        let moveAction = SKAction.move(to: newPosition, duration: duration)
        moveAction.timingMode = .easeOut
        if PlayerStats.sharedInstance.getSoundState()  {
          sprite.run(
            SKAction.sequence([
              SKAction.wait(forDuration: delay),
              SKAction.group([moveAction, fallingCookieSound])]))
        } else {
          sprite.run(
            SKAction.sequence([
              SKAction.wait(forDuration: delay),
              SKAction.group([moveAction])]))
        }
        
      }
    }
    // 6
    run(SKAction.wait(forDuration: longestDuration), completion: completion)
  }
  
  func animateNewCookies(_ columns: [[Cookie]], completion: @escaping () -> ()) {
    // 1
    var longestDuration: TimeInterval = 0
    
    for array in columns {
      // 2
      let startRow = array[0].row + 1
      
      for (idx, cookie) in array.enumerated() {
        // 3
        let sprite = SKSpriteNode(imageNamed: cookie.cookieType.spriteName)
        sprite.size = CGSize(width: TileWidth, height: TileHeight)
        sprite.position = pointForColumn(cookie.column, row: startRow)
        cookiesLayer.addChild(sprite)
        cookie.sprite = sprite
        // 4
        let delay = 0.1 + 0.2 * TimeInterval(array.count - idx - 1)
        // 5
        let duration = TimeInterval(startRow - cookie.row) * 0.1
        longestDuration = max(longestDuration, duration + delay)
        // 6
        let newPosition = pointForColumn(cookie.column, row: cookie.row)
        let moveAction = SKAction.move(to: newPosition, duration: duration)
        moveAction.timingMode = .easeOut
        sprite.alpha = 0
        if PlayerStats.sharedInstance.getSoundState() {
          sprite.run(
            SKAction.sequence([
              SKAction.wait(forDuration: delay),
              SKAction.group([
                SKAction.fadeIn(withDuration: 0.05),
                moveAction,
                addCookieSound])
              ]))
        } else {
          sprite.run(
            SKAction.sequence([
              SKAction.wait(forDuration: delay),
              SKAction.group([
                SKAction.fadeIn(withDuration: 0.05),
                moveAction])
              ]))
        }
        
        
      }
    }
    // 7
    run(SKAction.wait(forDuration: longestDuration), completion: completion)
  }
  
  func animateScoreForChain(_ chain: Chain, goodChain: Bool) {
    // Figure out what the midpoint of the chain is.
    let firstSprite = chain.firstCookie().sprite!
    let lastSprite = chain.lastCookie().sprite!
    let centerPosition = CGPoint(
      x: (firstSprite.position.x + lastSprite.position.x)/2,
      y: (firstSprite.position.y + lastSprite.position.y)/2 - 8)
    
    // Add a label for the score that slowly floats up.
    let scoreLabel = SKLabelNode(fontNamed: kCustomFontName)
    scoreLabel.fontSize = 160
    scoreLabel.alpha = 0.8
    scoreLabel.text = String(format: "%ld", chain.score)
    scoreLabel.position = centerPosition
    
    var scoreLabelPosition: CGPoint = CGPoint.zero
    
    if !goodChain {
      scoreLabel.fontColor = animatedScoreWrongChainColor
      scoreLabelPosition = CGPoint(x: topPanel.position.x, y: topPanel.position.y)
    } else {
      scoreLabel.fontColor = animatedScoreRightChainColor
      scoreLabelPosition = CGPoint(x: topPanel.position.x - 50, y: topPanel.position.y)
      
    }
    
    scoreLabel.zPosition = 300
    cookiesLayer.addChild(scoreLabel)
    
    let scaleDownAction = SKAction.scale(to: 0.1, duration: 0.1)
    let scaleUpAction = SKAction.scale(to: 2.0, duration: 0.4)
    let scaleToNormalAction = SKAction.scale(to: 1.0, duration: 0.2)
    scaleToNormalAction.timingMode = .easeOut
    
    let moveAction = SKAction.move(to: scoreLabelPosition, duration: 0.5)
    moveAction.timingMode = .easeOut
    let scaleDownSlowlyAction = SKAction.scale(to: 0.1, duration: 0.4)
    
    let groupActtion = SKAction.group([moveAction, scaleDownSlowlyAction])
    
    scoreLabel.run(SKAction.sequence([scaleDownAction, scaleUpAction, scaleToNormalAction, groupActtion, SKAction.removeFromParent()]))
  }
  
  func setupStats() {
    if level.isTimed {
      countdownValue = level.time
      timeToGive = level.time / 3
      timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(GameScene.updateCounter), userInfo: nil, repeats: true)
    } else {
      countdownValue = level.maximumMoves
      movesToGive = level.maximumMoves / 3
    }
    
    score = 0
    collectableAmount = 0
    
    switch PlayerStats.sharedInstance.getCurrentCollectableType() {
    case 1:
      collectableCandy.texture = SKTexture(imageNamed: "Croissant-Highlighted")
    case 2:
      collectableCandy.texture = SKTexture(imageNamed: "Cupcake-Highlighted")
    case 3:
      collectableCandy.texture = SKTexture(imageNamed: "Danish-Highlighted")
    case 4:
      collectableCandy.texture = SKTexture(imageNamed: "Donut-Highlighted")
    case 5:
      collectableCandy.texture = SKTexture(imageNamed: "Macaroon-Highlighted")
    case 6:
      collectableCandy.texture = SKTexture(imageNamed: "SugarCookie-Highlighted")
    default:
      print("Ooops, no such collectable candy!")
    }
    
  }
  
  func updateCounter() {
    decrementCountdownValue()
  }
  
  func updateLabels() {
      
    if level.isTimed {
      var seconds = String(countdownValue%60)
      if countdownValue%60 < 10 {
        seconds = "0" + String(countdownValue%60)
      }
      countdownLabel.text = String(format: String(countdownValue / 60) + ":" + seconds)
      
      
      if countdownValue <= -1 {
        countdownLabel.text = "0:00"
        gameOverAndWon(false)
      } else {
        countdownIndicator.zRotation = (-150 + ((150 / CGFloat(level.time)) * (CGFloat(level.time) - CGFloat(countdownValue)))) * CGFloat(M_PI) / 180.0
      }
      
    } else {
      countdownLabel.text = String(format: "%ld", countdownValue)
      
      if countdownValue <= 0 {
        countdownLabel.text = "0"
        gameOverAndWon(false)
      } else {
        countdownIndicator.zRotation = (-150 + ((150 / CGFloat(level.maximumMoves)) * (CGFloat(level.maximumMoves) - CGFloat(countdownValue)))) * CGFloat(M_PI) / 180.0
      }
    }
    
    
    scoreAndTargetLabel.text = String(format: "%ld/%ld", score, level.targetScore)
    collectableCandyLabel.text = String(format: "%ld/%ld", collectableAmount, level.collectableTarget)
    starsLabel.text = String(format: "%ld", PlayerStats.sharedInstance.getOverallStars())
  }
  
  func decrementCountdownValue() {
    
    if isShuffling {
      if level.isTimed {
        countdownValue -= 10
      } else {
        countdownValue -= 1
      }
      isShuffling = false
    } else {
      countdownValue -= 1
    }
    updateLabels()
    
    if score >= level.targetScore && collectableAmount >= level.collectableTarget {
      
      var countdownInitialValue = 0
      if level.isTimed {
        countdownInitialValue = level.time
      } else {
        countdownInitialValue = level.targetScore
      }
      
      if Float(countdownValue) >= Float(countdownInitialValue) * 0.0 {
        levelStarsAchievedCount = 1
      }
      
      if Float(countdownValue) >= Float(countdownInitialValue) * 0.25 {
        levelStarsAchievedCount = 2
      }
      
      if Float(countdownValue) >= Float(countdownInitialValue) * 0.35 {
        levelStarsAchievedCount = 3
      }
      
      PlayerStats.sharedInstance.setStarsAchieved(levelStarsAchievedCount, forLevel: PlayerStats.sharedInstance.getCurrentLevel())
      
      print("Achieved \(PlayerStats.sharedInstance.getStarsAchievedForLevel(PlayerStats.sharedInstance.getCurrentLevel())) stars in level \(PlayerStats.sharedInstance.getCurrentLevel()).")
      
      if level.isTimed {
        PlayerStats.sharedInstance.saveOverallTime(countdownInitialValue - countdownValue)
        PlayerStats.sharedInstance.checkForAchievementsForTime()
      } else {
        PlayerStats.sharedInstance.saveOverallMoves(countdownInitialValue - countdownValue)
        PlayerStats.sharedInstance.checkForAchievementsForMoves()
      }
      
      gameOverAndWon(true)
    }
    
  }
  
  func gameOverAndWon(_ winStatus: Bool) {
    timer.invalidate()
    PlayerStats.sharedInstance.saveCurrentLevelWinStatus(winStatus)
    if winStatus {
      PlayerStats.sharedInstance.saveNewHighestUnlockedLevel(PlayerStats.sharedInstance.getCurrentLevel())
      GCHelper.sharedInstance.reportLeaderboardIdentifier(leaderboardID, score: PlayerStats.sharedInstance.getCurrentLevel())
      
      let gameViewController = self.view?.window?.rootViewController as! GameViewController
      
      if gameViewController.isUserSignedIn() {
        var dataDict = Dictionary<String, String>()
        dataDict["ScoreToSaveToFirebase"] = "\(PlayerStats.sharedInstance.getCurrentLevel())"
        NotificationCenter.default.post(name: Notification.Name(rawValue: "SaveScoreToFirebaseNotification"), object: nil, userInfo: dataDict)
      }
      
    } else {
      
    }
    
    goToGameOverScene()
  }
  
  func goToGameOverScene() {
    /*
    let gameOverScene = GameOverScene(fileNamed: "GameOverScene")
    let transition = SKTransition.moveInWithDirection(SKTransitionDirection.Up, duration: 0.5)
    //let skView = self.view as SKView!
    gameOverScene?.scaleMode = .AspectFill
    self.view?.presentScene(gameOverScene!, transition: transition)*/
 /*
    let gameOverScene = GameOverScene(fileNamed: "GameOverScene")
    //let transition = SKTransition.flipVerticalWithDuration(1.0)
    let skView = self.view as SKView!
    gameOverScene?.scaleMode = .AspectFill
    skView.presentScene(gameOverScene!)*/
    
    
    // show ad
    showAds()
    
    // setup game over panel
    setupGameOverStats()
    
    // moving gamelayer down
    gameLayer.run(SKAction.move(to: CGPoint(x: 540, y: -1000), duration: 0.3))
    
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "popupGameOverLayer") {
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
  
  func goToMainMenuScene() {
    let mainMenuScene = MainMenuScene(fileNamed: "MainMenuScene")
    let transition = SKTransition.moveIn(with: SKTransitionDirection.up, duration: 0.5)
    //let skView = self.view as SKView!
    mainMenuScene?.scaleMode = .aspectFill
    self.view?.presentScene(mainMenuScene!, transition: transition)
  }
  
  ////// GAME OVER ///////
  func goToGameScene(_ level: Int) {
    print("Going to level: \(level)")
    let gameScene = GameScene(fileNamed: "GameScene")
    let transition = SKTransition.moveIn(with: SKTransitionDirection.up, duration: 0.5)
    //let skView = self.view as SKView!
    gameScene?.scaleMode = .aspectFill
    self.view?.presentScene(gameScene!, transition: transition)
  }
  
  func setupMissionPopup(_ level: Int) {
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
    
  }
  
  func setupGameOverStats() {
    if PlayerStats.sharedInstance.getCurrentLevelWinStatus() {
      print("We have a winner!")
      
      gameOverTitle.texture = SKTexture(imageNamed: "TitleYouWin")
      
      switch PlayerStats.sharedInstance.getStarsAchievedForLevel(PlayerStats.sharedInstance.getCurrentLevel()) {
      case 1:
        star1.run(SKAction.sequence([SKAction.wait(forDuration: 0.1), bounceUpAnimation]))
        star2.run(SKAction.sequence([SKAction.wait(forDuration: 0.3), bounceUpAnimation, SKAction.scale(to: 0.0, duration: 0.2)]))
        star3.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), bounceUpAnimation, SKAction.scale(to: 0.0, duration: 0.2)]))
        PlayerStats.sharedInstance.updateOverallStarsWith(1)
      case 2:
        star1.run(SKAction.sequence([SKAction.wait(forDuration: 0.1), bounceUpAnimation]))
        star2.run(SKAction.sequence([SKAction.wait(forDuration: 0.3), bounceUpAnimation]))
        star3.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), bounceUpAnimation, SKAction.scale(to: 0.0, duration: 0.2)]))
        PlayerStats.sharedInstance.updateOverallStarsWith(2)
      case 3:
        star1.run(SKAction.sequence([SKAction.wait(forDuration: 0.1), bounceUpAnimation]))
        star2.run(SKAction.sequence([SKAction.wait(forDuration: 0.3), bounceUpAnimation]))
        star3.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), bounceUpAnimation]))
        PlayerStats.sharedInstance.updateOverallStarsWith(3)
      default:
        print("Ooops, no such stars count.")
      }
      
      if !PlayerStats.sharedInstance.getIsRandomLevel() {
        // unlocking next level
        if PlayerStats.sharedInstance.getCurrentLevel() == PlayerStats.sharedInstance.getHighestUnlockedLevel() {
          PlayerStats.sharedInstance.saveNewHighestUnlockedLevel(PlayerStats.sharedInstance.getHighestUnlockedLevel() + 1)
        } else {
          print("You did not play the last level, so no need to unlock anything.")
        }
        
        // setup of currentLevel for next gameplay (when Next button is tapped)
        PlayerStats.sharedInstance.saveCurrentLevel(PlayerStats.sharedInstance.getCurrentLevel() + 1)
        
        gameOverTextTitleLabel.text = "Congratulations!"
        gameOverTextMessageLine1Label.text = "You have unlocked"
        gameOverTextMessageLine2Label.text = "level \(PlayerStats.sharedInstance.getHighestUnlockedLevel())!"
      } else {
        // we have been playing a random level
        // setup of currentLevel for next gameplay (when Next button is tapped)
        PlayerStats.sharedInstance.saveCurrentLevel(Int(arc4random_uniform(108)) + 1)
        
        gameOverTextTitleLabel.text = "Congratulations!"
        gameOverTextMessageLine1Label.text = "You have completed the"
        gameOverTextMessageLine2Label.text = "random level \(PlayerStats.sharedInstance.getHighestUnlockedLevel())!"
      }
      
      buttonGameOverPlayNextOrRetryLabel.text = "Next"
      
    } else {
      print("We don't have a winner.")
      
      star1.run(SKAction.sequence([SKAction.wait(forDuration: 0.1), bounceUpAnimation, SKAction.scale(to: 0.0, duration: 0.2)]))
      star2.run(SKAction.sequence([SKAction.wait(forDuration: 0.3), bounceUpAnimation, SKAction.scale(to: 0.0, duration: 0.2)]))
      star3.run(SKAction.sequence([SKAction.wait(forDuration: 0.5), bounceUpAnimation, SKAction.scale(to: 0.0, duration: 0.2)]))
      
      gameOverTitle.texture = SKTexture(imageNamed: "TitleYouFailed")
      
      gameOverTextTitleLabel.text = "Sorry"
      gameOverTextMessageLine1Label.text = "You have failed"
      gameOverTextMessageLine2Label.text = "this level."
      
      buttonGameOverPlayNextOrRetryLabel.text = "Retry"
      
      buttonGameOverShare.alpha = 0.0
    }
  }
  ////////////////////////
  
  func showAchievmentPopupBadgeName(_ badgeName: String, line1: String, line2: String) {
    if level.isTimed {
      timer.invalidate()
    }
    print(badgeName)
    achievementBadge.texture = SKTexture(imageNamed: badgeName)
    achievementTextMessageLine1Label.text = line1
    achievementTextMessageLine2Label.text = line2
    
    // show the achievement popover
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "popupAchievementLayer") {
        if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
          if !someSpriteNode.hasActions() {
            someSpriteNode.run(SKAction.move(to: CGPoint(x: 540, y: 960), duration: 0.3))
            self.gameLayer.run(SKAction.move(to: CGPoint(x: 540, y: -1000), duration: 0.3))
          }
        }
      }
    }
    
  }
  
  func setupPauseMenu() {
    if PlayerStats.sharedInstance.getOverallStars() >= 4 {
      if level.isTimed {
        if countdownValue <= level.time * 2 / 3 {
          var seconds = String(timeToGive%60)
          if timeToGive%60 < 10 {
            seconds = "0" + String(timeToGive%60)
          }
          var timeToGiveString: String = ""
          timeToGiveString = String(format: String(timeToGive / 60) + ":" + seconds)
          popupPauseTextLine1.text = String(format: "Buy \(timeToGiveString) extra time")
          popupPauseTextLine2.text = String(format: "for only 4 stars.")
          popupButtonPauseGetLabel.text = "Get"
        } else {
          popupPauseTextLine1.text = String(format: "It's too early to")
          popupPauseTextLine2.text = String(format: "get extra time.")
          popupButtonPauseGetLabel.text = "Ok"
        }
        
        
      } else {
        if countdownValue <= level.maximumMoves * 2 / 3 {
          popupPauseTextLine1.text = String(format: "Buy \(movesToGive) extra moves")
          popupPauseTextLine2.text = String(format: "for only 4 stars.")
          popupButtonPauseGetLabel.text = "Get"
        } else {
          popupPauseTextLine1.text = String(format: "It's too early to")
          popupPauseTextLine2.text = String(format: "get extra moves.")
          popupButtonPauseGetLabel.text = "Ok"
        }
        
      }
    } else {
      popupPauseTextLine1.text = String(format: "You don't have")
      popupPauseTextLine2.text = String(format: "enough stars.")
      popupButtonPauseGetLabel.text = "Buy"
    }
    
    
  }
  
  func showAds() {
    if !MKStoreKit.shared().isProductPurchased(noAdsInAppPurchaseID) {
      if !Chartboost.hasInterstitial(CBLocationGameOver) {
        Chartboost.cacheInterstitial(CBLocationGameOver)
      }
      Chartboost.showInterstitial(CBLocationGameOver)
      Chartboost.cacheInterstitial(CBLocationGameOver)
    }
  }
  
  func moveEveryPannelOffScreen() {
    let moveOut = SKAction.move(to: CGPoint(x: 540, y: -1000), duration: 0.3)
    popupPauseLayer.run(moveOut)
    popupMissionLayer.run(moveOut)
    popupGameOverLayer.run(moveOut)
    popupAchievementLayer.run(moveOut)
    popupShopLayer.run(moveOut)
  }
  
  func moveOnScreen(_ node: SKSpriteNode) {
    moveEveryPannelOffScreen()
    let moveIn = SKAction.move(to: CGPoint(x: 540, y: 960), duration: 0.3)
    node.run(moveIn)
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
  
  func showInsufficientCoinsActionSheet() {
    
    if level.isTimed {
      timer.invalidate()
    }
    
    let alertController: UIAlertController = UIAlertController(title: insufficientFundsAlertTitle, message: insufficientFundsAlertMessage, preferredStyle: .alert)
    
    //Create and add the Cancel action
    let cancelAction: UIAlertAction = UIAlertAction(title: "Return to Play", style: .default) { action -> Void in
      //Do some stuff
      self.isGamePaused = false
      if self.level.isTimed{
        self.timer = Timer.scheduledTimer(timeInterval: 1, target:self, selector: #selector(GameScene.updateCounter), userInfo: nil, repeats: true)
      }
    }
    
    alertController.addAction(cancelAction)
    
    //Create and an option action
    let goToShopAction: UIAlertAction = UIAlertAction(title: "Go to Shop", style: .cancel) { action -> Void in
      self.goToShop()
    }
    alertController.addAction(goToShopAction)
    
    //Present the AlertController
    self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
  }
  
  func goToShop() {
    self.gameLayer.run(SKAction.move(to: CGPoint(x: 540, y: -1000), duration: 0.3))
    
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "popupShopLayer") {
        if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
          if !someSpriteNode.hasActions() {
            self.moveOnScreen(someSpriteNode)
          }
        }
      }
    }
  }
  
  func shareScore()
  {
    loadImageForScoreShare(facebookAppInvitePreviewImageURL)
  }
  
  func openShareScoreController() {
    let vc = self.view?.window?.rootViewController
    
    let myText = shareScoreTextFirstPart + String(PlayerStats.sharedInstance.getCurrentLevel()) + shareScoreTextSecondPart
    
    let activityVC:UIActivityViewController = UIActivityViewController(activityItems: [shareImage, myText], applicationActivities: nil)
    
    // added for iPad
    activityVC.popoverPresentationController?.sourceView = self.view
    
    vc?.present(activityVC, animated: true, completion: nil)
  }
  
  func loadImageForScoreShare(_ urlString:String)
  {
    let imgURL: URL = URL(string: urlString)!
    let request: URLRequest = URLRequest(url: imgURL)
    
    let session = URLSession.shared
    let task = session.dataTask(with: request, completionHandler: {
      (data, response, error) -> Void in
      
      if (error == nil && data != nil)
      {
        func display_image()
        {
          self.shareImage = UIImage(data: data!)
          self.openShareScoreController()
        }
        
        DispatchQueue.main.async(execute: display_image)
      } else {
        // alert no image
      }
      
    })
    
    task.resume()
  }
  
  func shareAchievement()
  {
    loadImageForAchievementShare(facebookAppInvitePreviewImageURL)
  }
  
  func openShareAchievementController() {
    let vc = self.view?.window?.rootViewController
    
    let myText = shareAchievementTextFirstPart + achievementTextMessageLine1Label.text! + " " + achievementTextMessageLine2Label.text! + shareAchievementTextSecondPart
    
    let activityVC:UIActivityViewController = UIActivityViewController(activityItems: [ shareImage, myText], applicationActivities: nil)
    
    // added for iPad
    activityVC.popoverPresentationController?.sourceView = self.view
    
    vc?.present(activityVC, animated: true, completion: nil)
  }
  
  func loadImageForAchievementShare(_ urlString:String)
  {
    let imgURL: URL = URL(string: urlString)!
    let request: URLRequest = URLRequest(url: imgURL)
    
    let session = URLSession.shared
    let task = session.dataTask(with: request, completionHandler: {
      (data, response, error) -> Void in
      
      if (error == nil && data != nil)
      {
        func display_image()
        {
          self.shareImage = UIImage(data: data!)
          self.openShareAchievementController()
        }
        
        DispatchQueue.main.async(execute: display_image)
      } else {
        // alert no image
      }
      
    })
    
    task.resume()
  }
  
}
