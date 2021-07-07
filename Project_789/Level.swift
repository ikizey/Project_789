//
//  Level.swift
//  Project_789
//
//  Created by PrincePhoenix on 04.06.2021.
//

import UIKit

struct Level {
    var levels = [Int: String]()
    
    init?() {
        if let levelsURL = Bundle.main.url(forResource: "levels", withExtension: "txt") {
            let wordsString = try? String(contentsOf: levelsURL)
            if let words = wordsString?.components(separatedBy: "\n") {
                for (index, word) in words.enumerated() {
                    levels[index + 1] = word
                }
            }
        }
    }
}
