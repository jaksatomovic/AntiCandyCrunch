//
//  Extensions.swift
//  AntiCandyCrunch
//
//  Created by SANDOR NAGY on 30/06/16.
//  Copyright © 2016 Rebeloper. All rights reserved.
//

import Foundation
import UIKit

extension Dictionary {
  static func loadJSONFromBundle(_ filename: String) -> Dictionary <String, AnyObject>? {
    var dataOK: Data
    var dictionaryOK: NSDictionary = NSDictionary()
    if let path = Bundle.main.path(forResource: filename, ofType: "json") {
      let _: NSError?
      do {
        let data = try Data(contentsOf: URL(fileURLWithPath: path), options: NSData.ReadingOptions()) as Data!
        dataOK = data!
      }
      catch {
        print("Could not load level file: \(filename), error: \(error)")
        return nil
      }
      do {
        let dictionary = try JSONSerialization.jsonObject(with: dataOK, options: JSONSerialization.ReadingOptions()) as AnyObject!
        dictionaryOK = (dictionary as! NSDictionary as? Dictionary <String, AnyObject>)! as NSDictionary
      }
      catch {
        print("Level file '\(filename)' is not valid JSON: \(error)")
        return nil
      }
    }
    return dictionaryOK as? Dictionary <String, AnyObject>
  }
  
}

extension Dictionary {
  func sortedKeys(_ isOrderedBefore:(Key,Key) -> Bool) -> [Key] {
    return Array(self.keys).sorted(by: isOrderedBefore)
  }
  
  // Slower because of a lot of lookups, but probably takes less memory (this is equivalent to Pascals answer in an generic extension)
  func sortedKeysByValue(_ isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
    return sortedKeys {
      isOrderedBefore(self[$0]!, self[$1]!)
    }
  }
  
  // Faster because of no lookups, may take more memory because of duplicating contents
  func keysSortedByValue(_ isOrderedBefore:(Value, Value) -> Bool) -> [Key] {
    return Array(self)
      .sorted() {
        let (_, lv) = $0
        let (_, rv) = $1
        return isOrderedBefore(lv, rv)
      }
      .map {
        let (k, _) = $0
        return k
    }
  }
}

func saveJSONFromBundle(_ filename: String, dictionaryToBeSaved: Dictionary <String, AnyObject>?) {
  
  if let path = Bundle.main.path(forResource: filename, ofType: "json") {
    let _: NSError?
    // creating JSON out of the above dic
    var jsonData: Data!
    do {
      jsonData = try JSONSerialization.data(withJSONObject: dictionaryToBeSaved!, options: JSONSerialization.WritingOptions())
      let jsonString = String(data: jsonData, encoding: String.Encoding.utf8)
      print(jsonString)
    } catch {
      print("Dict to JSON conversion failed: \(error)")
    }
    
    // Write that JSON to the file created earlier
    let jsonFilePath = path
    do {
      let file = try FileHandle(forWritingTo: URL(fileURLWithPath: jsonFilePath))
      file.write(jsonData)
      print("JSON data was written to the file successfully to path: \(path)!")
    } catch {
      print("Couldn't write to file: \(error)")
    }
    
    
  }
}

extension UIColor {
  convenience init(red: Int, green: Int, blue: Int) {
    let newRed = CGFloat(red)/255
    let newGreen = CGFloat(green)/255
    let newBlue = CGFloat(blue)/255
    
    self.init(red: newRed, green: newGreen, blue: newBlue, alpha: 1.0)
  }
}

enum UIUserInterfaceIdiom : Int
{
  case unspecified
  case phone
  case pad
}

struct ScreenSize
{
  static let SCREEN_WIDTH         = UIScreen.main.bounds.size.width
  static let SCREEN_HEIGHT        = UIScreen.main.bounds.size.height
  static let SCREEN_MAX_LENGTH    = max(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
  static let SCREEN_MIN_LENGTH    = min(ScreenSize.SCREEN_WIDTH, ScreenSize.SCREEN_HEIGHT)
}

struct DeviceType
{
  static let IS_IPHONE_4_OR_LESS  = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH < 568.0
  static let IS_IPHONE_5          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 568.0
  static let IS_IPHONE_6          = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 667.0
  static let IS_IPHONE_6P         = UIDevice.current.userInterfaceIdiom == .phone && ScreenSize.SCREEN_MAX_LENGTH == 736.0
  static let IS_IPAD              = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1024.0
  static let IS_IPAD_PRO          = UIDevice.current.userInterfaceIdiom == .pad && ScreenSize.SCREEN_MAX_LENGTH == 1366.0
}
