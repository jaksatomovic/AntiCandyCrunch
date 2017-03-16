//
//  SettingsScene.swift
//  AntiCandyCrunch
//
//  Created by SANDOR NAGY on 12/08/16.
//  Copyright © 2016 Rebeloper. All rights reserved.
//

import SpriteKit
import Firebase
import SwiftKeychainWrapper

class SettingsScene: SKScene {
  
  var buttonFacebookLogInOutLabel: SKLabelNode!
  var buttonSoundOnOff: SKSpriteNode!
  var buttonMoreGames: SKSpriteNode!
  
  override func didMove(to view: SKView) {
    
    RateMyApp.sharedInstance.trackAppUsage()
  
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
    
    // get buttonFacebookLogInOutLabel
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "buttonFacebookLogInOutLabel") {
        if let someLabelNode:SKLabelNode = node as? SKLabelNode {
          self.buttonFacebookLogInOutLabel = someLabelNode
        }
      }
    }
    
    // get buttonSoundOnOff
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "buttonSoundOnOff") {
        if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
          self.buttonSoundOnOff = someSpriteNode
        }
      }
    }
    
    if PlayerStats.sharedInstance.getSoundState()  {
      buttonSoundOnOff.texture = SKTexture(imageNamed: "ButtonSoundOn")
    } else {
      buttonSoundOnOff.texture = SKTexture(imageNamed: "ButtonSoundOff")
    }
    
    
    setupFacebookButton()
    
    // get buttonMoreGames
    self.enumerateChildNodes(withName: "//*") {
      node, stop in
      if (node.name == "buttonMoreGames") {
        if let someSpriteNode:SKSpriteNode = node as? SKSpriteNode {
          self.buttonMoreGames = someSpriteNode
        }
      }
    }
    
    if !showMoreAppsButton {
      buttonMoreGames.alpha = 0.0
      buttonSoundOnOff.position.x = 0
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
        
        if name == "buttonRate"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          RateMyApp.sharedInstance.okButtonPressed()
          print("Rate button tapped. Going to the App Store. If your app is not yet on the App Store nothing will happen, but this is perfectly fine. The app will go to the app's page once it is live on the App Store.")
        }
        
        if name == "buttonGameCenter"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          GCHelper.sharedInstance.showGameCenter((self.view?.window?.rootViewController)!, viewState: .leaderboards)
        }
        
        if name == "buttonSoundOnOff"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          if PlayerStats.sharedInstance.getSoundState()  {
            PlayerStats.sharedInstance.setSound(false)
            buttonSoundOnOff.texture = SKTexture(imageNamed: "ButtonSoundOff")
            let gameViewController = self.view?.window?.rootViewController as! GameViewController
            gameViewController.backgroundMusic?.stop()
          } else {
            PlayerStats.sharedInstance.setSound(true)
            buttonSoundOnOff.texture = SKTexture(imageNamed: "ButtonSoundOn")
            let gameViewController = self.view?.window?.rootViewController as! GameViewController
            gameViewController.backgroundMusic?.play()
          }
        }
        
        if name == "buttonMoreGames"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          if !Chartboost.hasMoreApps(CBLocationSettings) {
            Chartboost.cacheMoreApps(CBLocationSettings)
          }
          Chartboost.showMoreApps(CBLocationSettings)
          Chartboost.cacheMoreApps(CBLocationSettings)
        }
        
        if name == "buttonFacebookLogInOut" || name == "buttonFacebookLogInOutLabel"
        {
          print("Touched \(name).")
          PlayerStats.sharedInstance.playButtonTapSoundOnNode(touchedNode)
          runButtonTappedAnimationOn(touchedNode)
          let gameViewController = self.view?.window?.rootViewController as! GameViewController
          
          if gameViewController.isUserSignedIn() {
            // log out
            gameViewController.logoutOfFacebook({ (result) in
              print("REBELOPER: Logged into Facebook - \(result)")
              self.buttonFacebookLogInOutLabel.text = "Log In"
            })
          } else {
            // log in
            gameViewController.loginToFacebook({ (result) in
              if result {
                print("REBELOPER: Logged into Facebook - \(result)")
                self.buttonFacebookLogInOutLabel.text = "Log Out"
              } else {
                print("REBELOPER: Logged into Facebook - \(result)")
                self.buttonFacebookLogInOutLabel.text = "Log In"
              }
            })
          }
        }
        
      }
    }
    
  }
  
  func setupFacebookButton() {
    buttonFacebookLogInOutLabel.fontName = kCustomFontName
    buttonFacebookLogInOutLabel.fontSize = CGFloat(kSettingsFacebookButtonLabelFontSize)
    
    let gameViewController = self.view?.window?.rootViewController as! GameViewController
    
    if gameViewController.isUserSignedIn() {
      buttonFacebookLogInOutLabel.text = "Log Out"
    } else {
      buttonFacebookLogInOutLabel.text = "Log In"
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
