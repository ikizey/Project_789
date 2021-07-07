//
//  ViewController.swift
//  Project_789
//
//  Created by PrincePhoenix on 03.06.2021.
//

import UIKit

class ViewController: UIViewController {
    
    let alphabet = "abcefhijklmnopqrstuvwxyz" //no d, g
    
    var hp: Int = 7 {
        didSet {
            HPLabel.text = "HP: \(hp)"
            if hp <= 0 {
                gameOver()
            }
        }
    }
    
    var level: Int = 0 {
        didSet {
            hp = 7
            levelLabel.text = "Level: \(level)"
            rightLetters = [String]()
        }
    }
    var levels: [Int: String]!
    
    var rightLetters: [String]! {
        didSet {
            updateWordLabel()
            if Set(rightLetters.joined()) == Set((wordLabel.text)!) {
                nextLevel()
            }
        }
    }
    
    var levelLabel: UILabel!
    var HPLabel: UILabel!
    var wordLabel: UILabel!
    var guessWordButton: UIButton!
    var alphabetButtons = [UIButton]()
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = .white
        
        levelLabel = UILabel()
        levelLabel.translatesAutoresizingMaskIntoConstraints = false
        levelLabel.text = "Level: \(level)"
        levelLabel.font = UIFont.systemFont(ofSize: 30)
        levelLabel.textAlignment = .center
        view.addSubview(levelLabel)
        
        HPLabel = UILabel()
        HPLabel.translatesAutoresizingMaskIntoConstraints = false
        HPLabel.text = "HP: \(hp)"
        HPLabel.font = UIFont.systemFont(ofSize: 36)
        HPLabel.textAlignment = .center
        view.addSubview(HPLabel)
        
        wordLabel = UILabel()
        wordLabel.translatesAutoresizingMaskIntoConstraints = false
        wordLabel.text = "???????"
        wordLabel.font = UIFont.systemFont(ofSize: 44)
        wordLabel.textAlignment = .center
        view.addSubview(wordLabel)
        
        guessWordButton = UIButton(type: .system)
        guessWordButton.translatesAutoresizingMaskIntoConstraints = false
        guessWordButton.setTitle("Guess Word", for: .normal)
        guessWordButton.addTarget(self, action: #selector(guessWord), for: .touchUpInside)
        view.addSubview(guessWordButton)
        
        let buttonsView = UIView()
        buttonsView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(buttonsView)
        
        NSLayoutConstraint.activate([
            wordLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            wordLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
                        
            HPLabel.bottomAnchor.constraint(equalTo: wordLabel.topAnchor, constant: -20),
            HPLabel.centerXAnchor.constraint(equalTo: wordLabel.centerXAnchor),

            levelLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            levelLabel.bottomAnchor.constraint(equalTo: HPLabel.topAnchor, constant: -20),

            guessWordButton.topAnchor.constraint(equalTo: wordLabel.bottomAnchor, constant: 5),
            guessWordButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            
            buttonsView.widthAnchor.constraint(equalToConstant: 400),
            buttonsView.heightAnchor.constraint(equalToConstant: 150),
            buttonsView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -10)
        ])
        
        buttonsView.backgroundColor = .green
        
        let width = 50
        let height = 50
        
        let rows = 3
        let columns = 8
        
        for row in 0..<rows {
            for column in 0..<columns {
                let button = UIButton()
                let index = alphabet.index(alphabet.startIndex, offsetBy: row * columns + column)
                let letter = String(alphabet[index])
                button.setTitle(letter, for: .normal)
                button.addTarget(self, action: #selector(guessLetter), for: .touchUpInside)
                let frame = CGRect(x: column * width, y: row * height, width: width, height: height)
                button.frame = frame
                button.backgroundColor = .blue
                alphabetButtons.append(button)
                buttonsView.addSubview(button)
            }
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        
        levels = loadLevels()
        nextLevel()
    }
    
    func nextLevel(_ action: UIAlertAction? = nil) {
        level = hp == 0 ? 1 : level + 1
        for button in alphabetButtons {
            button.backgroundColor = .blue
            button.isUserInteractionEnabled = true
        }
        
    }
    
    @objc func guessWord() {
        let ac = UIAlertController(title: "Guess whole word", message: nil, preferredStyle: .alert)
        ac.addTextField()
        
        ac.addAction(UIAlertAction(title: "Enter", style: .default, handler: { [weak self, weak ac] action in
            guard let answer = ac?.textFields?[0].text else { return }
            if answer.lowercased() == self!.levels[self!.level] {
                self!.nextLevel()
            } else {
                self!.hp -= 1
            }
        }))
        present(ac, animated: true)
    }
    
    @objc func guessLetter(_ sender: UIButton) {
        sender.isUserInteractionEnabled = false
        let letter = (sender.titleLabel?.text)!
        if (levels[level]?.contains(letter))! {
            sender.backgroundColor = .green
            rightLetters.append(letter)
        } else {
            sender.backgroundColor = .red
            hp -= 1
        }
    }

    func updateWordLabel() {
        var word = ""
        for charLetter in levels[level]! {
            let letter = String(charLetter)
            word += (rightLetters.contains(letter) ? letter : "?")
        }
        wordLabel.text = word
    }
    
    func gameOver() {
        let ac = UIAlertController(title: "Game Over", message: "You get to level \(level)", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Start new game", style: .default, handler: nextLevel))
        present(ac, animated: true)
    }
    
    func loadLevels() -> [Int: String] {
        var levels = [Int: String]()
        
        if let levelsURL = Bundle.main.url(forResource: "levels", withExtension: "txt") {
            let wordsString = try? String(contentsOf: levelsURL)
            if let words = wordsString?.components(separatedBy: "\n") {
                for (index, word) in words.enumerated() {
                    levels[index + 1] = word
                }
            }
        }
        return levels
    }
}
    


