//
//  Settings.swift
//  AntiCandyCrunch
//
//  Created by SANDOR NAGY on 22/07/16.
//  Copyright © 2016 Rebeloper. All rights reserved.
//

import UIKit

//------- In-App Purchase IDs -------//

// IMPORTANT: Remember to modify these in the MKStoreKitConfigs.plist file too!!!
// You will be able to edit the amount of coins the user will get for the IAP

let stars1InAppPurchaseID = "com.Rebeloper.AntiCandyCrunch.Stars1" // consumable
let stars2InAppPurchaseID = "com.Rebeloper.AntiCandyCrunch.Stars2" // consumable
let stars3InAppPurchaseID = "com.Rebeloper.AntiCandyCrunch.Stars3" // consumable
let noAdsInAppPurchaseID = "com.Rebeloper.AntiCandyCrunch.NoAds" // non-consumable

let stars1InAppPurchaseCount = 39
let stars2InAppPurchaseCount = 99
let stars3InAppPurchaseCount = 199

//------- Leaderboard ID -------//

let leaderboardID = "com.Rebeloper.AntiCandyCrunch.Scores"

//------- AdMob Ad unit ID -------//

let adMobUnitID = "ca-app-pub-3940256099942544/2934735716"

//------- Chartboost IDs -------//

let chartboostAppID = "57ab701543150f70e9b57226"
let chartboostAppSignature = "6c86fcf938ffced4236bddfe3b2318ee98e6d15d"

let showMoreAppsButton = true

//------- Facebook App ID -------//

let facebookAppID = "542308005966264"

//------- Facebook App Invite URLs -------//

let facebookAppLinkURL = "https://fb.me/542402359290162"
let facebookAppInvitePreviewImageURL = "http://i65.tinypic.com/3509xn8.png" // Use tinypic.com or photobucket.com for free image hosting. The suggested image size is 1,200 x 628 pixels with an image ratio of 1.9:1

//------- Log All App Users -------//

let logAllAppUsers = false

//------- Log Fonts -------//

let logAllAvailableFonts = false

//------- Custom Font Name -------//
// To find out the actual name of your custom font:
// 1. Set 'logAllAvailableFonts' to 'true'
// 2. Run the app
// 3. Find the Font Name in the Log
// 4. Copy it here

let kCustomFontName = "Pusab"

// IMPORTANT: You will also need to add the font FILE NAME into your Info.plist file under 'Fonts provided by application'

//------- Font Sizes For Labels / Button Texts -------//

let kSettingsFacebookButtonLabelFontSize = 72
let kWorldMapLevelLabelFontSize = 160
let kWorldMapMissionTextFontSize = 40
let kWorldMapFacebookButtonLabelFontSize = 100
let kWorldMapFacebookFriendScoreLabelFontSize = 40
let kWorldMapLockedLevelAlertTitleLabelFontSize = 90
let kWorldMapLockedLevelAlertTextLabelFontSize = 70
let kWorldMapLockedLevelAlertButtonLabelFontSize = 160
let kWorldMapMissionAlertOKButtonLabelFontSize = 160
let kGameSceneCountdownLabelFontSize = 70
let kGameSceneScoresLabelFontSize = 50
let kGameSceneAlertTextFontSize = 40
let kGameSceneAlertButtonSmallFontSize = 90
let kGameSceneAlertButtonBigFontSize = 130 // must be higher than 50

//------- Initial Stars -------//

let kInitialStarsToGiveAtFirstLaunch = 100

//------- Share Text Score -------//

// text that will be displayed when user taps on "Share"
let shareScoreTextFirstPart = "Wow! I am at level "
let shareScoreTextSecondPart = " in 'Anti Candy Crunch'!!! Download it from the App Store now!"

//------- Share Text Achievement -------//

// text that will be displayed when user taps on "Share"
let shareAchievementTextFirstPart = "Wow! I have completed the achievement: '"
let shareAchievementTextSecondPart = "' in 'Anti Candy Crunch'!!! Download it from the App Store now!"

//------- App ID -------//

let appID = "1125825308"

//------- Rate Popup -------//

let rateAlertTitle = "Rate the app"
let rateAlertMessagePart1 = "If you found"

// IMPORTANT: Next comes the name of the App that will be fetched by code from the Info.plist file; please go and set it up at the 'Bundle Display Name' now!!!

let rateAlertMessagePart2 = "useful, please take a moment to rate it"
let rateAlertOKTitle = "Rate it now"
let rateAlertCancelTitle = "Don't bother me again"
let rateAlertRemindLaterTitle = "Remind me later"
let rateAlertPromptAfterDays = 1.0 // Ex. '1.5' means one and a half days
let rateAlertPromptAfterUses = 3
let rateAlertDaysBeforeReminding = 1.0

//------- Chain Score Colors -------//

// set up the colors of the numbers that appear when chains are made
let animatedScoreWrongChainColor = UIColor(red: 231, green: 76, blue: 60)
let animatedScoreRightChainColor = UIColor(red: 255, green: 255, blue: 255)

//------- Music & Sounds File Names -------//

let backgroundMusicName = "BackgroundMusic"
let backgroundMusicExtension = "mp3"
let chompSoundFile = "Chomp.wav"
let kaChingSoundFile = "Ka-Ching.wav"
let scrapeSoundFile = "Scrape.wav"
let dripSoundFile = "Drip.wav"
let soundTap = "Tap.wav"

//------- Points -------//

let pointsToGiveOn4Match = 100
let pointsToSubstractOn3Match = 15

//------- Show Tiles -------//

let showTiles = false

//------- Achievement Milestones  -------//

let achievementMilestoneChains1 = 9
let achievementMilestoneChains2 = 59
let achievementMilestoneChains3 = 499
let achievementMilestoneChains4 = 999

// set this up in seconds
let achievementMilestoneTime1 = 540 // 9 minutes
let achievementMilestoneTime2 = 3540 // 59 minutes
let achievementMilestoneTime3 = 29940 // 499 minutes

let achievementMilestoneMoves1 = 999
let achievementMilestoneMoves2 = 4999
let achievementMilestoneMoves3 = 9999

//------- Initial Stars -------//

let kInitialStarsToGiveAtFacebookInvite = 50 // this will be decreased by 5 on every new Invite till it drops under 0

//------- Achievement Text  -------//

let kAchievementTextLine1FontSize = 48
let kAchievementTextLine2FontSize = 64

let achievementTextLine1_1 = "Gather 9 chains of"
let achievementTextLine1_2 = "this candy!"

let achievementTextLine2_1 = "Gather 59 chains of"
let achievementTextLine2_2 = "this candy!"

let achievementTextLine3_1 = "Gather 499 chains of"
let achievementTextLine3_2 = "this candy!"

let achievementTextLine4_1 = "Gather 999 chains of"
let achievementTextLine4_2 = "this candy!"

let achievementTextLine5_1 = "Gather 9 chains of"
let achievementTextLine5_2 = "this candy!"

let achievementTextLine6_1 = "Gather 59 chains of"
let achievementTextLine6_2 = "this candy!"

let achievementTextLine7_1 = "Gather 499 chains of"
let achievementTextLine7_2 = "this candy!"

let achievementTextLine8_1 = "Gather 999 chains of"
let achievementTextLine8_2 = "this candy!"

let achievementTextLine9_1 = "Gather 9 chains of"
let achievementTextLine9_2 = "this candy!"

let achievementTextLine10_1 = "Gather 59 chains of"
let achievementTextLine10_2 = "this candy!"

let achievementTextLine11_1 = "Gather 499 chains of"
let achievementTextLine11_2 = "this candy!"

let achievementTextLine12_1 = "Gather 999 chains of"
let achievementTextLine12_2 = "this candy!"

let achievementTextLine13_1 = "Gather 9 chains of"
let achievementTextLine13_2 = "this candy!"

let achievementTextLine14_1 = "Gather 59 chains of"
let achievementTextLine14_2 = "this candy!"

let achievementTextLine15_1 = "Gather 499 chains of"
let achievementTextLine15_2 = "this candy!"

let achievementTextLine16_1 = "Gather 999 chains of"
let achievementTextLine16_2 = "this candy!"

let achievementTextLine17_1 = "Gather 9 chains of"
let achievementTextLine17_2 = "this candy!"

let achievementTextLine18_1 = "Gather 59 chains of"
let achievementTextLine18_2 = "this candy!"

let achievementTextLine19_1 = "Gather 499 chains of"
let achievementTextLine19_2 = "this candy!"

let achievementTextLine20_1 = "Gather 999 chains of"
let achievementTextLine20_2 = "this candy!"

let achievementTextLine21_1 = "Gather 9 chains of"
let achievementTextLine21_2 = "this candy!"

let achievementTextLine22_1 = "Gather 59 chains of"
let achievementTextLine22_2 = "this candy!"

let achievementTextLine23_1 = "Gather 499 chains of"
let achievementTextLine23_2 = "this candy!"

let achievementTextLine24_1 = "Gather 999 chains of"
let achievementTextLine24_2 = "this candy!"

let achievementTextLine25_1 = "Play the game for"
let achievementTextLine25_2 = "9 minutes!"

let achievementTextLine26_1 = "Play the game for"
let achievementTextLine26_2 = "59 minutes!"

let achievementTextLine27_1 = "Play the game for"
let achievementTextLine27_2 = "499 minutes!"

let achievementTextLine28_1 = "Make 999 moves"
let achievementTextLine28_2 = "in the game!"

let achievementTextLine29_1 = "Make 4999 moves"
let achievementTextLine29_2 = "in the game!"

let achievementTextLine30_1 = "Make 9999 moves"
let achievementTextLine30_2 = "in the game!"

//------- 'Insufficient Funds' Alert Text -------//

let insufficientFundsAlertTitle = "Insufficient Funds"
let insufficientFundsAlertMessage = "You have not enough stars. Would you like to buy some from the Shop?"

//------- 'Insufficient Leveles Won' Alert Text -------//

let insufficientLevelsWonAlertTitle = "World Locked"
let insufficientLevelsWonAlertMessage = "You have not enough Levels Won. You need to clear all the levels in the previous World to unlock this one."


























