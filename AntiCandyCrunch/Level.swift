//
//  Level.swift
//  AntiCandyCrunch
//
//  Created by SANDOR NAGY on 29/06/16.
//  Copyright © 2016 Rebeloper. All rights reserved.
//

import Foundation

let NumColumns = 9
let NumRows = 9

class Level {
  fileprivate var cookies = Array2D<Cookie>(columns: NumColumns, rows: NumRows)
  fileprivate var tiles = Array2D<Tile>(columns: NumColumns, rows: NumRows)
  
  var targetScore = 0
  var maximumMoves = 0
  
  var isTimed = false
  var time = 0
  
  //var collectableType = 0
  var collectableTarget = 0
  
  fileprivate var comboMultiplier = 0
  
  fileprivate var possibleSwaps = Set<Swap>()
  
  init(filename: String) {
    // 1
    guard let dictionary = Dictionary<String, AnyObject>.loadJSONFromBundle(filename) else { return }
    // 2
    guard let tilesArray = dictionary["tiles"] as? [[Int]] else { return }
    // 3
    for (row, rowArray) in tilesArray.enumerated() {
      // 4
      let tileRow = NumRows - row - 1
      // 5
      for (column, value) in rowArray.enumerated() {
        if value == 1 {
          tiles[column, tileRow] = Tile()
        }
      }
    }
    
    targetScore = dictionary["targetScore"] as! Int
    maximumMoves = dictionary["moves"] as! Int
    
    let isTimedInt = dictionary["isTimed"] as! Int
    if isTimedInt == 1 {
      isTimed = true
    } else {
      isTimed = false
    }
    time = dictionary["time"] as! Int
    
    //collectableType = Int(arc4random_uniform(6)) + 1
    collectableTarget = dictionary["collectableTarget"] as! Int
    
  }
  
  func tileAtColumn(_ column: Int, row: Int) -> Tile? {
    assert(column >= 0 && column < NumColumns)
    assert(row >= 0 && row < NumRows)
    return tiles[column, row]
  }
  
  func cookieAtColumn(_ column: Int, row: Int) -> Cookie? {
    assert(column >= 0 && column < NumColumns)
    assert(row >= 0 && row < NumRows)
    return cookies[column, row]
  }
  
  func shuffle() -> Set<Cookie> {
    var set: Set<Cookie>
    repeat {
      set = createInitialCookies()
      detectPossibleSwaps()
      print("possible swaps: \(possibleSwaps)")
    } while possibleSwaps.count == 0
    
    return set
  }
  
  fileprivate func createInitialCookies() -> Set<Cookie> {
    var set = Set<Cookie>()
    
    // 1
    for row in 0..<NumRows {
      for column in 0..<NumColumns {
        if tiles[column, row] != nil {
          // 2
          var cookieType: CookieType
          repeat {
            cookieType = CookieType.random()
          } while (column >= 2 &&
            cookies[column - 1, row]?.cookieType == cookieType &&
            cookies[column - 2, row]?.cookieType == cookieType)
            || (row >= 2 &&
              cookies[column, row - 1]?.cookieType == cookieType &&
              cookies[column, row - 2]?.cookieType == cookieType)
          
          // 3
          let cookie = Cookie(column: column, row: row, cookieType: cookieType)
          cookies[column, row] = cookie
          
          // 4
          set.insert(cookie)
        }
      }
    }
    return set
  }
  
  func performSwap(_ swap: Swap) {
    let columnA = swap.cookieA.column
    let rowA = swap.cookieA.row
    let columnB = swap.cookieB.column
    let rowB = swap.cookieB.row
    
    cookies[columnA, rowA] = swap.cookieB
    swap.cookieB.column = columnA
    swap.cookieB.row = rowA
    
    cookies[columnB, rowB] = swap.cookieA
    swap.cookieA.column = columnB
    swap.cookieA.row = rowB
  }
  
  fileprivate func hasChainAtColumn(_ column: Int, row: Int) -> Bool {
    let cookieType = cookies[column, row]!.cookieType
    
    // Horizontal chain check
    var horzLength = 1
    
    // Left
    var i = column - 1
    while i >= 0 && cookies[i, row]?.cookieType == cookieType {
      i -= 1
      horzLength += 1
    }
    
    // Right
    i = column + 1
    while i < NumColumns && cookies[i, row]?.cookieType == cookieType {
      i += 1
      horzLength += 1
    }
    if horzLength >= 3 { return true }
    
    // Vertical chain check
    var vertLength = 1
    
    // Down
    i = row - 1
    while i >= 0 && cookies[column, i]?.cookieType == cookieType {
      i -= 1
      vertLength += 1
    }
    
    // Up
    i = row + 1
    while i < NumRows && cookies[column, i]?.cookieType == cookieType {
      i += 1
      vertLength += 1
    }
    return vertLength >= 3
  }
  
  func detectPossibleSwaps() {
    var set = Set<Swap>()
    
    for row in 0..<NumRows {
      for column in 0..<NumColumns {
        if let cookie = cookies[column, row] {
          
          // Is it possible to swap this cookie with the one on the right?
          if column < NumColumns - 1 {
            // Have a cookie in this spot? If there is no tile, there is no cookie.
            if let other = cookies[column + 1, row] {
              // Swap them
              cookies[column, row] = other
              cookies[column + 1, row] = cookie
              
              // Is either cookie now part of a chain?
              if hasChainAtColumn(column + 1, row: row) ||
                hasChainAtColumn(column, row: row) {
                set.insert(Swap(cookieA: cookie, cookieB: other))
              }
              
              // Swap them back
              cookies[column, row] = cookie
              cookies[column + 1, row] = other
            }
          }
          
          if row < NumRows - 1 {
            if let other = cookies[column, row + 1] {
              cookies[column, row] = other
              cookies[column, row + 1] = cookie
              
              // Is either cookie now part of a chain?
              if hasChainAtColumn(column, row: row + 1) ||
                hasChainAtColumn(column, row: row) {
                set.insert(Swap(cookieA: cookie, cookieB: other))
              }
              
              // Swap them back
              cookies[column, row] = cookie
              cookies[column, row + 1] = other
            }
          }
          
        }
      }
    }
    
    possibleSwaps = set
  }
  
  func isPossibleSwap(_ swap: Swap) -> Bool {
    return possibleSwaps.contains(swap)
  }
  
  fileprivate func detectHorizontalMatches() -> Set<Chain> {
    // 1
    var set = Set<Chain>()
    // 2
    for row in 0..<NumRows {
      var column = 0
      while column < NumColumns-2 {
        // 3
        if let cookie = cookies[column, row] {
          let matchType = cookie.cookieType
          // 4
          if cookies[column + 1, row]?.cookieType == matchType &&
            cookies[column + 2, row]?.cookieType == matchType {
            // 5
            let chain = Chain(chainType: .horizontal)
            repeat {
              chain.addCookie(cookies[column, row]!)
              column += 1
            } while column < NumColumns && cookies[column, row]?.cookieType == matchType
            
            set.insert(chain)
            continue
          }
        }
        // 6
        column += 1
      }
    }
    return set
  }
  
  fileprivate func detectVerticalMatches() -> Set<Chain> {
    var set = Set<Chain>()
    
    for column in 0..<NumColumns {
      var row = 0
      while row < NumRows-2 {
        if let cookie = cookies[column, row] {
          let matchType = cookie.cookieType
          
          if cookies[column, row + 1]?.cookieType == matchType &&
            cookies[column, row + 2]?.cookieType == matchType {
            let chain = Chain(chainType: .vertical)
            repeat {
              chain.addCookie(cookies[column, row]!)
              row += 1
            } while row < NumRows && cookies[column, row]?.cookieType == matchType
            
            set.insert(chain)
            continue
          }
        }    
        row += 1
      }
    }
    return set
  }
  
  func removeMatches() -> Set<Chain> {
    let horizontalChains = detectHorizontalMatches()
    let verticalChains = detectVerticalMatches()
    
    removeCookies(horizontalChains)
    removeCookies(verticalChains)
    
    calculateScores(horizontalChains)
    calculateScores(verticalChains)
    
    return horizontalChains.union(verticalChains)
  }
  
  fileprivate func removeCookies(_ chains: Set<Chain>) {
    for chain in chains {
      for cookie in chain.cookies {
        cookies[cookie.column, cookie.row] = nil
      }
    }
  }
  
  func fillHoles() -> [[Cookie]] {
    var columns = [[Cookie]]()
    // 1
    for column in 0..<NumColumns {
      var array = [Cookie]()
      for row in 0..<NumRows {
        // 2
        if tiles[column, row] != nil && cookies[column, row] == nil {
          // 3
          for lookup in (row + 1)..<NumRows {
            if let cookie = cookies[column, lookup] {
              // 4
              cookies[column, lookup] = nil
              cookies[column, row] = cookie
              cookie.row = row
              // 5
              array.append(cookie)
              // 6
              break
            }
          }
        }
      }
      // 7
      if !array.isEmpty {
        columns.append(array)
      }
    }
    return columns
  }
  
  func topUpCookies() -> [[Cookie]] {
    var columns = [[Cookie]]()
    var cookieType: CookieType = .unknown
    
    for column in 0..<NumColumns {
      var array = [Cookie]()
      
      // 1
      var row = NumRows - 1
      while row >= 0 && cookies[column, row] == nil {
        // 2
        if tiles[column, row] != nil {
          // 3
          var newCookieType: CookieType
          repeat {
            newCookieType = CookieType.random()
          } while newCookieType == cookieType
          cookieType = newCookieType
          // 4
          let cookie = Cookie(column: column, row: row, cookieType: cookieType)
          cookies[column, row] = cookie
          array.append(cookie)
        }
        
        row -= 1
      }
      // 5
      if !array.isEmpty {
        columns.append(array)
      }
    }
    return columns
  }
  
  fileprivate func calculateScores(_ chains: Set<Chain>) {
    // 3-chain is 60 pts, 4-chain is 120, 5-chain is 180, and so on
    for chain in chains {
      //chain.score = 60 * (chain.length - 2)
      if chain.length == 3 {
        chain.score = -pointsToSubstractOn3Match * comboMultiplier
        comboMultiplier += 1
      } else {
        // save chain for achievemnts
        PlayerStats.sharedInstance.saveNewChainValueForCookieType(chain.firstCookie().cookieType)
        
        chain.score = pointsToGiveOn4Match * (chain.length - 3) * comboMultiplier
        comboMultiplier += 1
        /*
        if chain.firstCookie().cookieType.rawValue == collectableType {
          chain.collectableScore += 1
        }*/
        
        if chain.firstCookie().cookieType.rawValue == PlayerStats.sharedInstance.getCurrentCollectableType() {
          chain.collectableScore += 1
        }
        
      }
    }
  }
  
  func resetComboMultiplier() {
    comboMultiplier = 1
  }
  
}
