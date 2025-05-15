//
//  QuizType.swift
//  iQuiz
//
//  Created by Vaibava Venkatesan on 5/5/25.
//

import UIKit
import Network

class QuizTopicCell: UITableViewCell {
    @IBOutlet weak var topicTitleLabel: UILabel!
    @IBOutlet weak var topicDescriptionLabel: UILabel!
    @IBOutlet weak var topicImageView: UIImageView!
}

class QuizListViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    
    private let refreshControl = UIRefreshControl()
    private var timer: Timer?
    private var refreshInterval: TimeInterval {
        return TimeInterval(UserDefaults.standard.integer(forKey: "refreshInterval") * 60)
    }

    var quizTopics: [QuizTopic] {
        return QuizDataStore.shared.quizTopics
    }
    let topicImageNames = ["Math", "Marvel", "Science"]
    var selectedQuestions: [(question: String, options: [String], correct: Int)] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Quiz Topics"
        tableView.delegate = self
        tableView.dataSource = self
        refreshControl.addTarget(self, action: #selector(refreshData), for: .valueChanged)
        tableView.refreshControl = refreshControl
        if quizTopics.isEmpty {
            loadInitialData()
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
        refreshTimer()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        timer?.invalidate()
    }
    
    func loadInitialData() {
        let urlString = UserDefaults.standard.string(forKey: "urlString") ?? "http://tednewardsandbox.site44.com/questions.json"
        downloadData(from: urlString)
    }
    
    @objc func refreshData() {
        let urlString = UserDefaults.standard.string(forKey: "urlString") ?? "https://tednewardsandbox.site44.com/questions.json"
        downloadData(from: urlString)
    }
    
    func refreshTimer() {
        timer?.invalidate()
        let autoRefresh = UserDefaults.standard.bool(forKey: "autoRefresh")
        if autoRefresh {
            timer = Timer.scheduledTimer(
                timeInterval: refreshInterval,
                target: self,
                selector: #selector(refreshData),
                userInfo: nil,
                repeats: true
            )
        }
    }
    
    func downloadData(from urlString: String) {
        guard let url = URL(string: urlString) else {
            self.refreshControl.endRefreshing()
            self.showAlert(title: "Invalid URL", message: "Please try again")
            return
        }
        
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                URLSession.shared.dataTask(with: url) { data, _, error in
                    if let error = error {
                        DispatchQueue.main.async {
                            self.refreshControl.endRefreshing()
                            self.showAlert(title: "Download Error", message: error.localizedDescription)
                        }
                        return
                    }
                    
                    guard let data = data else {
                        DispatchQueue.main.async {
                            self.refreshControl.endRefreshing()
                            self.showAlert(title: "No Data", message: "No data was received.")
                        }
                        return
                    }
                    
                    do {
                        let topics = try JSONDecoder().decode([QuizTopic].self, from: data)
                        QuizDataStore.shared.quizTopics = topics
                        DispatchQueue.main.async {
                            self.tableView.reloadData()
                            self.refreshControl.endRefreshing()
                        }
                    } catch {
                        DispatchQueue.main.async {
                            self.refreshControl.endRefreshing()
                            self.showAlert(title: "Parse Error", message: "Can't parse Data")
                        }
                    }
                }.resume()
            } else {
                DispatchQueue.main.async {
                    self.refreshControl.endRefreshing()
                    self.showAlert(title: "No Internet", message: "Check your connection")
                }
            }
            monitor.cancel()
        }
        monitor.start(queue: .global(qos: .background))
    }
    
    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .default))
        present(alert, animated: true)
    }

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "questionSegue",
           let vc = segue.destination as? QuestionViewController,
           let first = selectedQuestions.first {
            vc.question = first.question
            vc.options = first.options
            vc.correct = first.correct
            vc.allQuestions = selectedQuestions
            vc.currIndex = 0
            vc.score = 0
        }
    }

    @IBAction func unwindToMain(segue: UIStoryboardSegue) {
        refreshTimer()
    }
    
    @IBAction func settingsPressed(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: "settingsSegue", sender: self)
    }
}

extension QuizListViewController: UITableViewDataSource, UITableViewDelegate {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return quizTopics.count
    }

    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 140
    }

    func tableView(_ tableView: UITableView, cellForRowAt idxPath: IndexPath) -> UITableViewCell {

        guard let cell = tableView.dequeueReusableCell(withIdentifier: "QuizTopicCell", for: idxPath) as? QuizTopicCell else {
            fatalError("QuizTopicCell not found.")
        }

        let topic = quizTopics[idxPath.row]
        cell.topicTitleLabel.text = topic.title
        cell.topicDescriptionLabel.text = topic.desc
        cell.topicImageView.image = UIImage(named: topicImageNames[idxPath.row])

        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt idxPath: IndexPath) {
        let topic = quizTopics[idxPath.row]
        guard let questions = QuizDataStore.shared.getQuestions(for: topic.title) else {
            showAlert(title: "Error", message: "Could not load questions for this topic")
            return
        }
        
        selectedQuestions = questions
        performSegue(withIdentifier: "questionSegue", sender: self)
    }
}
