//
//  ViewController.swift
//  ConcentrationRep
//
//  Created by Papa Saliou MBODJ on 03/01/2018.
//  Copyright © 2018 PSM. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    // this variable represent our Concentration Game. It contain the logic of the concentration game witch is UI independant.
    private lazy var game: Concentration = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
    var numberOfPairsOfCards: Int {
        return (cardButtons.count + 1) / 2
    }
    
    // this variable store the number of flips.
    private(set) var flipCount: Int = 0 {
        didSet {
            
            let attributes: [NSAttributedStringKey:Any] = [
                .strokeWidth : 5.0,
                .strokeColor: #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            ]
            
            let attributedString = NSAttributedString(string: "Flip count: \(flipCount)", attributes: attributes)
            flipCountLabel.attributedText = attributedString
        }
    }
    
    // All buttons (matching with cards) for the game
    @IBOutlet var cardButtons: [UIButton]!
    
    // UILabel to show both the score (in game evolution) and the choosen theme (on game start)
    @IBOutlet weak var flipCountLabel: UILabel! {
        didSet {
            flipCount = 0
            emojiChoices = initEmojiChoices()
        }
    }
 
    // This action is called every time a button is CardButtons is touchedUP.
    @IBAction func touchCard(_ sender: UIButton) {
       
        if sender.backgroundColor == #colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1) {
            flipCount += 1
        }
        
        if let cardNumber = cardButtons.index(of: sender) {
            game.chooseCard(at: cardNumber)
            updateViewFromModel()
        } else {
            print("button not is cardButton")
        }
    }
    
    // This action is game to restart the game.
    @IBAction func newGameTouched(_ sender: UIButton) {
        game = Concentration(numberOfPairsOfCards: numberOfPairsOfCards)
        emoji = [Card:String]()
        updateViewFromModel()
        flipCount = 0
        emojiChoices = initEmojiChoices()
    }
    
    // This function garanted matching between Views (Buttons) and Models (Cards).
    private func updateViewFromModel() {
        for index in cardButtons.indices {
            let button = cardButtons[index]
            let card = game.cards[index]
            if card.isFaceUp {
                button.setTitle(emoji(for: card), for: .normal)
                button.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            } else {
                button.setTitle("", for: .normal)
                button.backgroundColor = card.isMatched ? #colorLiteral(red: 1, green: 1, blue: 1, alpha: 0):#colorLiteral(red: 1, green: 0.5763723254, blue: 0, alpha: 1)
            }
        }
    }
    
    // This var store the emojies for the game.
    private lazy var emojiChoices: String = {
        return initEmojiChoices()
    }()
    
    
    // Variable that store all themes
    private(set) var themes: [Theme] = [Theme(name:"animals", contents: "🦑🦐🐥🐷🐸🐰🐡🐎🐓🐩🐁🐿🦋🕷🐌🐚🐴🦆🦇") ,
                                           Theme(name:"sports", contents: "⚽️🏀🏈⚾️🎾🏐🏉🎱🏑🏹🥊🥋⛷🏋️‍♂️🚴🏽‍♂️🏸🥅⛳️"),
                                           Theme(name:"voyages", contents: "🚗🚕✈️🚅🚔🚊⛴🚤🗺🏟🎡🏝🕌🕋🛤🛣🏞")
    ]
    
    // This function add a new theme to existing .
    func addTheme(with aNewOne: Theme) {
        themes.append(aNewOne)
    }
    
    // This function choose random theme from list of themes and return it.
    private func initEmojiChoices() -> String {
        let random = themes.count.arc4random
        flipCountLabel.text = themes[random].name
        return themes[random].contents
    }
    
    // Dictinnary of emoji for the game.
    private var emoji = [Card:String]()
    
    // this function return the emoji for a choosen card. Not that the same emoji is return for tuple of card that have the same identifier.
    private func emoji(for card: Card) -> String {
        if emoji[card] == nil, emojiChoices.count > 0 {
            let stringIndex = emojiChoices.index(emojiChoices.startIndex, offsetBy: emojiChoices.count.arc4random)
            emoji[card] = String(emojiChoices.remove(at: stringIndex))
        }
        return emoji[card] ?? "?"
    }
    
}

// Struct that define a Theme.
struct Theme {
    let name: String
    let contents: String
}

//MARK Extension
extension Int {
    // this var return a random number between 0 and the Int it self)
    var arc4random: Int {
        if self > 0 {
            return Int(arc4random_uniform(UInt32(self)))
        } else if self < 0 {
            return Int(arc4random_uniform(UInt32(-self)))
        } else {
            return 0
        }
    }
}
