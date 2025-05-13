//
//  QuestionViewController.swift
//  iQuiz
//
//  Created by Vaibava Venkatesan on 5/12/25.
//

import UIKit

class QuestionViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var questionLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var submitButton: UIButton!
    @IBOutlet weak var instructions: UILabel!
    
    var question: String = ""
    var options: [String] = []
    var correct: Int = 0
    var answer: Int?
    var allQuestions: [(question: String, options: [String], correct: Int)] = []
    var currIndex: Int = 0
    var score: Int = 0

    override func viewDidLoad() {
        super.viewDidLoad()
        questionLabel.text = question
        questionLabel.numberOfLines = 2
        tableView.delegate = self
        tableView.dataSource = self
        instructions.isHidden = true
        
        gestures()
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.gestureDisplay()
        }
    }

    @IBAction func submitTapped(_ sender: UIButton) {
        submit()
    }

    func submit() {
        guard let _ = answer else {
            return
        }
        performSegue(withIdentifier: "answerSegue", sender: self)
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
        submit()
    }

    @objc func swipeLeftfunc() {
        performSegue(withIdentifier: "unwindToMain", sender: self)
    }
    
    func gestureDisplay(){
        instructions.isHidden = false
        instructions.text = "Swipe Right to Submit, Swipe Left to Return to Main"
        instructions.numberOfLines = 2
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return options.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt idxPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.textLabel?.text = options[idxPath.row]
        cell.accessoryType = (idxPath.row == answer) ? .checkmark : .none
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt idxPath: IndexPath) {
        answer = idxPath.row
        tableView.reloadData()
    }

    // MARK: - Navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "answerSegue",
           let destination = segue.destination as? AnswerViewController,
           let selected = answer {
            destination.question = question
            destination.options = options
            destination.answer = selected
            destination.correct = correct
            destination.allQuestions = allQuestions
            destination.currIndex = currIndex
            destination.score = score
        }
    }
}

