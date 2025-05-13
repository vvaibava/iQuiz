//
//  QuizType.swift
//  iQuiz
//
//  Created by Vaibava Venkatesan on 5/5/25.
//

import UIKit

// MARK: - Custom TableView Cell
class QuizTopicCell: UITableViewCell {
    @IBOutlet weak var topicTitleLabel: UILabel!
    @IBOutlet weak var topicDescriptionLabel: UILabel!
    @IBOutlet weak var topicImageView: UIImageView!
}


// MARK: - Main View Controller
class QuizListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tableView: UITableView!
    
    let quizTopics = ["Mathematics", "Marvel Superheroes", "Science"]
    let topicDescriptions = ["Challenge your math skills", "Test your Marvel knowledge", "Explore the world of science"]
    let topicImageNames = ["Math", "Marvel", "Science"]

    var selectedQuestions: [(question: String, options: [String], correct: Int)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quiz Topics"
        tableView.delegate = self
        tableView.dataSource = self
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizTopics.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    func tableView(_ tableView: UITableView, cellForRowAt idxPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuizTopicCell", for: idxPath) as? QuizTopicCell else {
            fatalError("Cell with identifier 'QuizTopicCell' not found or not of type QuizTopicCell")
        }

        cell.topicTitleLabel.text = quizTopics[idxPath.row]
        cell.topicDescriptionLabel.text = topicDescriptions[idxPath.row]
        cell.topicImageView.image = UIImage(named: topicImageNames[idxPath.row])

        return cell
    }


    func tableView(_ tableView: UITableView, didSelectRowAt idxPath: IndexPath) {
        print("Tapped row: \(idxPath.row)")
        
        switch idxPath.row {
        case 0:
            selectedQuestions = [
                ("What is 2 + 2?", ["3", "4", "5"], 1),
                ("What is 10 / 2?", ["3", "5", "10"], 1)
            ]
        case 1:
            selectedQuestions = [
                ("Who is Iron Man?", ["Tony Stark", "Bruce Wayne", "Clark Kent"], 0),
                ("What is Captain America's shield made of?", ["Adamantium", "Vibranium", "Titanium"], 1)
            ]
        case 2:
            selectedQuestions = [
                ("What planet is known as the Red Planet?", ["Earth", "Mars", "Jupiter"], 1),
                ("What gas do plants absorb from the atmosphere?", ["Oxygen", "Carbon Dioxide", "Nitrogen"], 1)
            ]
        default:
            selectedQuestions = []
        }

        performSegue(withIdentifier: "questionSegue", sender: self)
    }


    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "questionSegue",
           let destination = segue.destination as? QuestionViewController,
           let firstQ = selectedQuestions.first {
            destination.question = firstQ.question
            destination.options = firstQ.options
            destination.correct = firstQ.correct
            destination.allQuestions = selectedQuestions
            destination.currIndex = 0
            destination.score = 0
        }
    }

    @IBAction func settingsPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
    
    @IBAction func unwindSegue(segue: UIStoryboardSegue) {
        
    }
    
    @IBAction func unwindToMain(segue: UIStoryboardSegue) {

    }

}

