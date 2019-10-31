//
//  ViewController.swift
//  GuessTheFlag
//
//  Created by Carlos C on 16/10/19.
//  Copyright © 2019 Carlos C. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var button1: UIButton!
    @IBOutlet var button2: UIButton!
    @IBOutlet var button3: UIButton!
    
    var countries = [String]()
    var score = 0
    var correctAnswer = 0
    var numberOfQuestions = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countries += ["estonia", "france", "germany", "ireland", "italy", "monaco", "nigeria", "poland", "russia", "spain", "uk", "us"]
        
        button1.layer.borderWidth = 1
        button2.layer.borderWidth = 1
        button3.layer.borderWidth = 1
        
        button1.layer.borderColor = UIColor.lightGray.cgColor
        button2.layer.borderColor = UIColor.lightGray.cgColor
        button3.layer.borderColor = UIColor.lightGray.cgColor
        
        askQuestion()
    }
    
    func askQuestion(action: UIAlertAction! = nil) {
        countries.shuffle()
        button1.setImage(UIImage(named: countries[0]), for: .normal)
        button2.setImage(UIImage(named: countries[1]), for: .normal)
        button3.setImage(UIImage(named: countries[2]), for: .normal)
        
        correctAnswer = Int.random(in: 0...2)
        numberOfQuestions += 1
        title = "Question: \(numberOfQuestions), Score: \(score), guess: " + countries[correctAnswer].uppercased()
    }
    
    @IBAction func buttonTapped(_ sender: UIButton) {
        var alertTitle: String
        
        if numberOfQuestions >= 10 {
            let ac = UIAlertController(title: "Game over!", message: "Your final score is \(score)", preferredStyle: .alert)
            score = 0
            numberOfQuestions = 0
            ac.addAction(UIAlertAction(title: "Play again?", style: .destructive, handler: askQuestion))
            present(ac, animated: true)
        }
        else {
            if sender.tag == correctAnswer {
                alertTitle = "Correct!"
                score += 1
            }
            else {
                alertTitle = "Wrong! That's the flag of \(countries[sender.tag].uppercased())"
                score -= 1
            }
            let ac = UIAlertController(title: alertTitle, message: "Your score is \(score)", preferredStyle: .alert)
            ac.addAction(UIAlertAction(title: "Continue", style: .default, handler: askQuestion))
            present(ac, animated: true)
        }
    }
}

