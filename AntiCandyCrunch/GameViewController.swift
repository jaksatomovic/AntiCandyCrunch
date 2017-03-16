//
//  GameViewController.swift
//  AntiCandyCrunch
//
//  Created by SANDOR NAGY on 20/07/16.
//  Copyright (c) 2016 Rebeloper. All rights reserved.
//

import UIKit
import SpriteKit
import AVFoundation
import GoogleMobileAds
import FBSDKCoreKit
import FBSDKLoginKit
import FBSDKShareKit
import Firebase
import SwiftKeychainWrapper

class GameViewController: UIViewController, /*FBSDKLoginButtonDelegate,*/ FBSDKAppInviteDialogDelegate {
  
  @IBOutlet weak var bannerView: GADBannerView!
  @IBOutlet weak var loginView: UIView!
  
  var users = [User]()
  
  var tapGestureRecognizer: UITapGestureRecognizer!
  
  lazy var backgroundMusic: AVAudioPlayer? = {
    guard let url = Bundle.main.url(forResource: backgroundMusicName, withExtension: backgroundMusicExtension) else {
      return nil
    }
    do {
      let player = try AVAudioPlayer(contentsOf: url)
      player.numberOfLoops = -1
      return player
    } catch {
      return nil
    }
  }()
  
  override var prefersStatusBarHidden : Bool {
    return true
  }
  
  override var shouldAutorotate : Bool {
    return true
  }
  
  override var supportedInterfaceOrientations : UIInterfaceOrientationMask {
    return [UIInterfaceOrientationMask.portrait, UIInterfaceOrientationMask.portraitUpsideDown]
  }
  
  override func viewDidLoad() {
    
    NotificationCenter.default.addObserver(forName: NSNotification.Name.mkStoreKitProductPurchased,
                                                            object: nil, queue: OperationQueue.main) { (note) -> Void in
                                                              print ("Purchased product: \(note.object)")
                                                              
                                                              switch note.object as! String {
                                                              case stars1InAppPurchaseID:
                                                                PlayerStats.sharedInstance.updateOverallStarsWith(stars1InAppPurchaseCount)
                                                              case stars2InAppPurchaseID:
                                                                PlayerStats.sharedInstance.updateOverallStarsWith(stars2InAppPurchaseCount)
                                                              case stars3InAppPurchaseID:
                                                                PlayerStats.sharedInstance.updateOverallStarsWith(stars3InAppPurchaseCount)
                                                              case noAdsInAppPurchaseID:
                                                                self.hideAdMobBanner()
                                                              
                                                              default:
                                                                print("Ooops, no such collectable candy!")
                                                              }
                                                              
                                                              
    }
    
    NotificationCenter.default.addObserver(forName: NSNotification.Name.mkStoreKitDownloadCompleted,
                                                            object: nil, queue: OperationQueue.main) { (note) -> Void in
                                                              print ("Downloaded product: \((note as NSNotification).userInfo)")
    }
    
    NotificationCenter.default.addObserver(forName: NSNotification.Name.mkStoreKitDownloadProgress,
                                                            object: nil, queue: OperationQueue.main) { (note) -> Void in
                                                              print ("Downloading product: \((note as NSNotification).userInfo)")
    }
    
    NotificationCenter.default.addObserver(forName: NSNotification.Name.mkStoreKitRestoredPurchases,
                                                            object: nil, queue: OperationQueue.main) { (note) -> Void in
                                                              print ("Restored Purchases.")
                                                              self.showRestoredPurchasesAlert()
                                                              
    }
    
    NotificationCenter.default.addObserver(forName: NSNotification.Name.mkStoreKitRestoringPurchasesFailed,
                                                            object: nil, queue: OperationQueue.main) { (note) -> Void in
                                                              print ("Failed restoring purchases with error: \((note as NSNotification).userInfo)")
                                                              self.showRestorePurchasesFailedAlert()
    }
    
    
    NotificationCenter.default.addObserver(self, selector: #selector(saveScoreToFirebaseNotification(_:)), name:NSNotification.Name(rawValue: "SaveScoreToFirebaseNotification"), object: nil)
    
    super.viewDidLoad()
    
    /*
    facebookLoginButton.center = CGPointMake(self.view.center.x, self.view.center.y * 1.25)
    facebookLoginButton.
    facebookLoginButton.readPermissions = ["public_profile", "email"]
    self.view.addSubview(facebookLoginButton)
    facebookLoginButton.delegate = self
    */
    //var firstSceneName = "MainMenuScene"
    
    if let scene = MainMenuScene(fileNamed:"MainMenuScene") {
      // Configure the view.
      let skView = self.view as! SKView
      skView.isMultipleTouchEnabled = false
      //skView.showsFPS = true
      //skView.showsNodeCount = true
      
      /* Sprite Kit applies additional optimizations to improve rendering performance */
      skView.ignoresSiblingOrder = true
      
      /* Set the scale mode to scale to fit the window */
      scene.scaleMode = .aspectFill
      
      skView.presentScene(scene)
    }
 
    /*
    if let scene = MainMenuScene(fileNamed:"MainMenuScene") {
      // Configure the view.
      let skView = self.view as! SKView
      skView.multipleTouchEnabled = false
      skView.showsFPS = true
      skView.showsNodeCount = true
      
      /* Sprite Kit applies additional optimizations to improve rendering performance */
      skView.ignoresSiblingOrder = true
      
      /* Set the scale mode to scale to fit the window */
      scene.scaleMode = .AspectFill
      
      skView.presentScene(scene)
    }*/
    
    /*
    // Configure the view.
    let skView = view as! SKView
    skView.multipleTouchEnabled = false
    
    // Create and configure the scene.
    scene = GameScene(size: skView.bounds.size)
    scene.scaleMode = .AspectFill
    
    // Present the scene.
    skView.presentScene(scene)*/
    
    // setup player default values
    PlayerStats.sharedInstance.setupDefaultValues()
    
    // Start the background music.
    if PlayerStats.sharedInstance.getSoundState()  {
      backgroundMusic?.play()
    }

    if !MKStoreKit.shared().isProductPurchased(noAdsInAppPurchaseID) {
      print("Google Mobile Ads SDK version: " + GADRequest.sdkVersion())
      bannerView.adUnitID = adMobUnitID
      bannerView.rootViewController = self
      bannerView.load(GADRequest())
    } else {
      print("Not showing ads because the 'No Ads' IAP has been purchased.")
    }
    
    
    DataService.ds.REF_USERS.observe(.value, with: { snapshot in
      if let snapshot = snapshot.children.allObjects as? [FIRDataSnapshot] {
        for snap in snapshot {
          if logAllAppUsers {
            print("SNAP: \(snap)")
          }
          if let userDict = snap.value as? Dictionary<String, AnyObject> {
            let key = snap.key
            let user = User(userKey: key, userData: userDict)
            self.users.append(user)
          }
          
        }
      }
    })
    
    
  
  }
  
  override func viewDidAppear(_ animated: Bool) {
    if isUserSignedIn() {
      print("REBELOPER: Already logged into Facebook and Firebase")
      loginView.isHidden = true
    }
  }
  
  
  func saveScoreToFirebaseNotification(_ notification: Notification) {
    let score: String = (notification as NSNotification).userInfo?["ScoreToSaveToFirebase"]! as! String
    print("Score to be saved to Firebase: \(score)")
    
    saveFacebookUserInfoToDB(KeychainWrapper.defaultKeychainWrapper().stringForKey(kFirebaseUID)!)
  }

  func showRestoredPurchasesAlert() {
    let alertController = UIAlertController(title: "Success", message: "Your purchases have been restored.", preferredStyle: .alert)
    
    
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
      
    }
    alertController.addAction(OKAction)
    
    self.present(alertController, animated: true) {
    }
    
  }
  
  func showRestorePurchasesFailedAlert() {
    let alertController = UIAlertController(title: "Sorry", message: "Your purchases could not be restored. Try again later.", preferredStyle: .alert)
    
    
    let OKAction = UIAlertAction(title: "OK", style: .default) { (action) in
      
    }
    alertController.addAction(OKAction)
    
    self.present(alertController, animated: true) {
    }
  }
  
  func hideAdMobBanner() {
    if MKStoreKit.shared().isProductPurchased(noAdsInAppPurchaseID) {
      print("Hiding AdMob banner . . .")
      bannerView.isHidden = true
    }
  }
  /*
  func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    print("logged in")
  }
  
  func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
    print("logged out")
  }*/
  
  
  func isUserLoggedInIntoFacebook() -> Bool {
    if FBSDKAccessToken.current() == nil {
      return false
    } else {
      return true
    }
  }
  
  @IBAction func skipFacebookLoginTapped(_ sender: AnyObject) {
    print("REBELOPER: User Skipped Facebook Login")
    loginView.isHidden = true
  }
  
  @IBAction func facebookButtonTapped(_ sender: AnyObject) {
    loginToFacebook { (result) in
      print("REBELOPER: Logged into Facebook - \(result)")
    }
  }
  
  func loginToFacebook(_ completion: @escaping (_ result: Bool) -> Void) {
    let facebookLogin = FBSDKLoginManager()
    
    facebookLogin.logIn(withReadPermissions: ["public_profile", "user_friends"], from: self) { (result, error) in
      if error != nil {
        print("REBELOPER: Unable to authehticate with Facebook - \(error)")
        completion(false)
      } else if result?.isCancelled == true {
        print("REBELOPER: User Canceled Facebook authentication")
        completion(false)
      } else {
        print("REBELOPER: Successfully authenticated with Facebook")
        completion(true)
        let credential = FIRFacebookAuthProvider.credential(withAccessToken: FBSDKAccessToken.current().tokenString)
        self.firebaseAuth(credential)
      }
    }
  }
  
  func logoutOfFacebook(_ completion: (_ result: Bool) -> Void) {
    if let _ = KeychainWrapper.defaultKeychainWrapper().stringForKey(kFirebaseUID) {
      print("REBELOPER: Deleting existing keychain data for key \(kFirebaseUID)")
      KeychainWrapper.defaultKeychainWrapper().removeObjectForKey(kFirebaseUID)
    } else {
      print("REBELOPER: No data found in keychain for key \(kFirebaseUID). No need to delete.")
    }
    try! FIRAuth.auth()?.signOut()
    completion(true)
  }
  
  func firebaseAuth(_ credential: FIRAuthCredential) {
    FIRAuth.auth()?.signIn(with: credential, completion: { (user, error) in
      if error != nil {
        print("REBELOPER: Unable to authenticate with Firebase - \(error)")
      } else {
        print("REBELOPER: Successfully authentificated with Firebase")
        if let user = user {
          self.completeSignIn(user.uid)
        }
        
      }
    })
  }
  
  func completeSignIn(_ uid: String) {
    
    
    let kechainResult = KeychainWrapper.defaultKeychainWrapper().setString(uid, forKey: kFirebaseUID)
    print("REBELOPER: Data saved to keychain - \(kechainResult)")
    loginView.isHidden = true
    saveFacebookUserInfoToDB(uid)
  }
  
  func isUserSignedIn() -> Bool {
    if let _ = KeychainWrapper.defaultKeychainWrapper().stringForKey(kFirebaseUID) {
      return true
    } else {
      return false
    }
  }
  
  /*
  func facebookButtonLoginPressed() {
    
    let loginManager = FBSDKLoginManager()
    loginManager.logInWithReadPermissions(["public_profile", "user_friends"], fromViewController: self, handler: { (response:FBSDKLoginManagerLoginResult!, error: NSError!) in
      if(error == nil){
        print("No Error Logging in into Facebook.")
        NSNotificationCenter.defaultCenter().postNotificationName("goToMainMenuScene", object: nil)
        self.getFacebookUserInfo()
      }
    })
    
    
  }*/
  
  func saveFacebookUserInfoToDB(_ uid: String) {
    
    if(FBSDKAccessToken.current() != nil)
    {
      //print permissions, such as public_profile
      //print(FBSDKAccessToken.currentAccessToken().permissions)
      let graphRequest = FBSDKGraphRequest(graphPath: "me", parameters: ["fields" : "id"] /*["fields" : "email, id, name"]*/)

      graphRequest?.start(completionHandler: { (connection, result, error) -> Void in
        
        let resultdict = result as! NSDictionary
        
        /*let userEmail = result.valueForKey("email") as? String
        print("Current user Email is: \(userEmail)")
        let userName = result.valueForKey("name") as? String
        print("Current user Name is: \(userName)")*/
        let userFBid = resultdict.value(forKey: "id") as? String
        print("Current user FBID is: \(userFBid)")
        
        if !UserDefaults.standard.bool(forKey: "theFirstLaunchOfTheAppButUserMayBeInDB") {
          // first launch
          for dBUser in self.users {
            
            if dBUser.userFBid == userFBid {
              
              PlayerStats.sharedInstance.saveNewHighestUnlockedLevel(Int(dBUser.score)!)
              let starsToGive = Int(dBUser.userCurrentStars)! - kInitialStarsToGiveAtFirstLaunch
              PlayerStats.sharedInstance.updateOverallStarsWith(starsToGive)
              print("User with ID '\(dBUser.userFBid)' already in DB. Restored Scores to '\(dBUser.score)' and Stars to '\(dBUser.userCurrentStars)'")
              
            } else {
              
              print("We have a new user.")
              let url = URL(string: "https://graph.facebook.com/\(userFBid!)/picture?type=large&return_ssl_resources=1")
              
              let userData = ["userFBid": "\(userFBid!)",
                              "profileImageUrl": "\(url!)",
                              "score": "\(PlayerStats.sharedInstance.getHighestUnlockedLevel())",
                              "userCurrentStars": "\(PlayerStats.sharedInstance.getOverallStars())"]
              
              DataService.ds.createFirebaseDBUser(uid, userData: userData)
              
            }
          }
          
          UserDefaults.standard.set(true, forKey: "theFirstLaunchOfTheAppButUserMayBeInDB")
          UserDefaults.standard.synchronize()
          
        } else {
          // not first launch
          let url = URL(string: "https://graph.facebook.com/\(userFBid!)/picture?type=large&return_ssl_resources=1")
          
          let userData = ["userFBid": "\(userFBid!)",
                          "profileImageUrl": "\(url!)",
                          "score": "\(PlayerStats.sharedInstance.getHighestUnlockedLevel())",
                          "userCurrentStars": "\(PlayerStats.sharedInstance.getOverallStars())"]
          
          DataService.ds.createFirebaseDBUser(uid, userData: userData)
        }
        
        
        
        
        //let url = NSURL(string: "https://graph.facebook.com/\(FBid!)/picture?type=large&return_ssl_resources=1")
        //self.imageView.image = UIImage(data: NSData(contentsOfURL: url!)!)
        
        //let userEmail = result.valueForKey("email") as? String
        /*
        self.getFacebookScore(FBid!, completion: { (result) in
          print("FBUserName: \(userName) -- FBID: \(FBid) -- Score: \(result)")
          // PlayerStats.sharedInstance.saveNewHighestUnlockedLevel(result) // relpace this with iCloud
        })*/
        
      })
    } else {
      print("User is not logged in into Facebook.")
    }
  }
  
  func getFacebookUserFriendsList() {
    
    if(FBSDKAccessToken.current() != nil)
    {
      //print permissions, such as public_profile
      //print(FBSDKAccessToken.currentAccessToken().permissions)
      let graphRequest = FBSDKGraphRequest(graphPath: "/me/friends", parameters: ["fields" : "id, name"])
      graphRequest?.start (completionHandler: { (connection, result, error) -> Void in
        let resultdict = result as! NSDictionary
        //print("Result Dict: \(resultdict)")
        let data : NSArray = resultdict.object(forKey: "data") as! NSArray
        
        for i in 0..<data.count {
          let valueDict : NSDictionary = data[i] as! NSDictionary
          let id = valueDict.object(forKey: "id") as! String
          //print("the id value is \(id)")
          
          
          for dBUser in self.users {
            if dBUser.userFBid == id {
              print("Found your friend in DB with 'profileImageUrl' \(dBUser.profileImageUrl) and Score \(dBUser.score)")
              
              let score1 = Int(PlayerStats.sharedInstance.getFacebookUserFriend("1").score)!
              let score2 = Int(PlayerStats.sharedInstance.getFacebookUserFriend("2").score)!
              let score3 = Int(PlayerStats.sharedInstance.getFacebookUserFriend("3").score)!
              
              
              
              switch Int(dBUser.score)! {
              case 0 ..< score3:
                print("Your friend with id: \(dBUser.userFBid) has a score \(dBUser.score) that is less than the 3rd score")
              case score3 ..< score2:
                print("Your friend with id: \(dBUser.userFBid) has a score \(dBUser.score) that is the 3rd score")
                PlayerStats.sharedInstance.saveFacebookFriend("3", id: "\(dBUser.userFBid)", score: "\(dBUser.score)")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "updateFacebookFriendsPanelToNewScores"), object: nil)
              case score2 ..< score1:
                print("Your friend with id: \(dBUser.userFBid) has a score \(dBUser.score) that is the 2nd score")
                PlayerStats.sharedInstance.saveFacebookFriend("2", id: "\(dBUser.userFBid)", score: "\(dBUser.score)")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "updateFacebookFriendsPanelToNewScores"), object: nil)
              case score1 ... 108:
                print("Your friend with id: \(dBUser.userFBid) has a score \(dBUser.score) that is the 1st score")
                PlayerStats.sharedInstance.saveFacebookFriend("1", id: "\(dBUser.userFBid)", score: "\(dBUser.score)")
                NotificationCenter.default.post(name: Notification.Name(rawValue: "updateFacebookFriendsPanelToNewScores"), object: nil)
              default:
                print("Ooops, no such score.")
              }
              
              
              
            }
              
              
            
          }
          
        }
        
        let friends = resultdict.object(forKey: "data") as! NSArray
        print("Found \(friends.count) friends")
        
      })
      
    }

  }
  /*
  func getFacebookScore(userId: String, completion: (result: Int) -> Void) {
    
    let scoresRequest = FBSDKGraphRequest(graphPath: "/\(userId)/scores", parameters: ["fields" : "score"], HTTPMethod:"GET")
    scoresRequest.startWithCompletionHandler ({ (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
      let resultdict = result as! NSDictionary
      print("Score for Facebook App ID: \(facebookAppID) is: \(resultdict)")
      let data : NSArray = resultdict.objectForKey("data") as! NSArray
      for i in 0..<data.count {
        let valueDict : NSDictionary = data[i] as! NSDictionary
        let userDict = valueDict.objectForKey("user") as! NSDictionary
        let name = userDict.objectForKey("name") as! String
        let id = userDict.objectForKey("id") as! String
        let score = valueDict.objectForKey("score") as! Int
        
        print("Score for '\(name)' with id '\(id)' is '\(score)'.")
        completion(result: score)
      }
      
    })
    
  }
  */
  /*
  func getFacebookScore(userId: String) -> Int {
    
    var score = 999
    
    let scoresRequest = FBSDKGraphRequest(graphPath: "/\(userId)/scores", parameters: ["fields" : "score"], HTTPMethod:"GET")
    scoresRequest.startWithCompletionHandler ({ (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
      let resultdict = result as! NSDictionary
      //print("Score for \(facebookAppID) is: \(resultdict)")
      let data : NSArray = resultdict.objectForKey("data") as! NSArray
      for i in 0..<data.count {
        let valueDict : NSDictionary = data[i] as! NSDictionary
        let userDict = valueDict.objectForKey("user") as! NSDictionary
        let name = userDict.objectForKey("name") as! String
        let id = userDict.objectForKey("id") as! String
        score = valueDict.objectForKey("score") as! Int
        
        print("Score for '\(name)' with id '\(id)' is '\(score)'.")
        
      }

    })
    
    
    
  }*/
  /*
  func postFacebookScore(score: Int) {
    if isUserLoggedInIntoFacebook() {
      if FBSDKAccessToken.currentAccessToken().hasGranted("publish_actions") {
        print("Already have publish access granted.")
        postScoreToFacebook(score)
      } else {
        print("User hasn't already granted publish access. Asking now ...")
        let loginManager = FBSDKLoginManager()
        loginManager.logInWithPublishPermissions(["publish_actions"], fromViewController: self, handler: { (response:FBSDKLoginManagerLoginResult!, error: NSError!) in
          if(error == nil){
            print("No Error Logging in into Facebook (publish). Posting score: \(score)")
            self.postScoreToFacebook(score)
          }
          
        })
      }
    } else {
      print("User isn't logged in into Facebook. Asking now ...")
      let loginManager = FBSDKLoginManager()
      loginManager.logInWithPublishPermissions(["publish_actions"], fromViewController: self, handler: { (response:FBSDKLoginManagerLoginResult!, error: NSError!) in
        if(error == nil){
          print("No Error Logging in into Facebook (publish). Posting score: \(score)")
          self.postScoreToFacebook(score)
        }
        
      })
    }
    
    
  }
  
  func postScoreToFacebook(score: Int) {
    var params = [String : String]()
    params["score"] = String(score)
    let graphRequest = FBSDKGraphRequest(graphPath: "/me/scores", parameters: params, HTTPMethod: "POST")
    graphRequest.startWithCompletionHandler ({ (connection : FBSDKGraphRequestConnection!, result : AnyObject!, error : NSError!) -> Void in
      //let resultdict = result as! NSDictionary
      //print("Post Scores Result Dict: \(resultdict)")
      self.getFacebookUserInfo()
    })
  }
  */
  //MARK: FBSDKAppInviteDialogDelegate
  func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didCompleteWithResults results: [AnyHashable: Any]!) {
    if results != nil {
      print("invitation made with result \(results.description)")
      if results.description == "[didComplete: 1]" {
        print("we have a valid invite")
        if PlayerStats.sharedInstance.getStarsToGiveForFacebookInvite() > 0 {
          PlayerStats.sharedInstance.updateOverallStarsWith(PlayerStats.sharedInstance.getStarsToGiveForFacebookInvite())
          
          let alertController = UIAlertController(title: "Congratulations", message: "You have invited some Facebook friends. For this you have earned \(PlayerStats.sharedInstance.getStarsToGiveForFacebookInvite()) stars.", preferredStyle: .alert)
          let OKAction = UIAlertAction(title: "Great", style: .default) { (action) in
          }
          alertController.addAction(OKAction)
          self.present(alertController, animated: true) {
          }
          
          PlayerStats.sharedInstance.saveStarsToGiveForFacebookInvite(PlayerStats.sharedInstance.getStarsToGiveForFacebookInvite() - 5)
        }
      }
    }
  }
  func appInviteDialog(_ appInviteDialog: FBSDKAppInviteDialog!, didFailWithError error: Error!) {
    print("invite error made")
  }
  
  func openFacebookAppInvitePanel() {
    let content = FBSDKAppInviteContent()
    content.appLinkURL = URL(string: facebookAppLinkURL)
    content.appInvitePreviewImageURL = URL(string: facebookAppInvitePreviewImageURL)
    FBSDKAppInviteDialog.show(from: self, with: content, delegate: self)
  }
  
}
