//
//  AnswerViewController.swift
//  iQuiz
//
//  Created by Vaibava Venkatesan on 5/12/25.
//

import UIKit

class AnswerViewController: UIViewController {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var feedbackLabel: UILabel!
    @IBOutlet weak var answerLabel: UILabel!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var instructions: UILabel!
    
    var question: String = ""
    var options: [String] = []
    var answer: Int = -1
    var correct: Int = -1
    var allQuestions: [(question: String, options: [String], correct: Int)] = []
    var currIndex: Int = 0
    var score: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = question
        questionLabel.numberOfLines = 2
        instructions.isHidden = true
        feedbackLabel.text = (answer == correct) ? "Correct!" : "Wrong"
        if options.indices.contains(correct) {
            answerLabel.text = "Correct Answer: \(options[correct])"
        }
        gestures()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.gestureDisplay()
        }
    }

    @IBAction func nextQuestion(_ sender: UIButton) {
        performNext()
    }

    func gestures() {
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swipeRightfunc))
        swipeRight.direction = .right
        view.addGestureRecognizer(swipeRight)

        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swipeLeftfunc))
        swipeLeft.direction = .left
        view.addGestureRecognizer(swipeLeft)
    }

    @objc func swipeRightfunc() {
        performNext()
    }

    @objc func swipeLeftfunc() {
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }

    func performNext() {
        let nextIndex = currIndex + 1
        if nextIndex < allQuestions.count {
            performSegue(withIdentifier: "nextQSegue", sender: self)
        } else {
            performSegue(withIdentifier: "finalSegue", sender: self)
        }
    }
    
    func gestureDisplay(){
        instructions.isHidden = false
        instructions.text = "Swipe Right to Submit, Swipe Left to Return to Main"
        instructions.numberOfLines = 2
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "nextQSegue",
           let destination = segue.destination as? QuestionViewController {
            let nextIndex = currIndex + 1
            let nextQ = allQuestions[nextIndex]
            destination.question = nextQ.question
            destination.options = nextQ.options
            destination.correct = nextQ.correct
            destination.answer = nil
            destination.allQuestions = allQuestions
            destination.currIndex = nextIndex
            destination.score = (answer == correct) ? score + 1 : score
        }

        if segue.identifier == "finalSegue",
           let destination = segue.destination as? FinalViewController {
            destination.count = (answer == correct) ? score + 1 : score
            destination.total = allQuestions.count
        }
    }
}


