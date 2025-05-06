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

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quiz Topics"
        tableView.delegate = self
        tableView.dataSource = self
    }

    // MARK: - TableView Data Source

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizTopics.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuizTopicCell", for: indexPath) as? QuizTopicCell else {
            fatalError("Cell with identifier 'QuizTopicCell' not found or not of type QuizTopicCell")
        }

        cell.topicTitleLabel.text = quizTopics[indexPath.row]
        cell.topicDescriptionLabel.text = topicDescriptions[indexPath.row]
        cell.topicImageView.image = UIImage(named: topicImageNames[indexPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt idx: IndexPath) {
        print("Selected quiz: \(quizTopics[idx.row])")
        tableView.deselectRow(at: idx, animated: true)
    }
    
    @IBAction func settingsPressed(_ sender: UIBarButtonItem) {
        let alert = UIAlertController(title: "Settings", message: "Settings go here.", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
