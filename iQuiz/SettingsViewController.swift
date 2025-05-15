//
//  SettingsViewController.swift
//  iQuiz
//
//  Created by Vaibava Venkatesan on 5/14/25.
//

import UIKit
import Network

class SettingsViewController: UIViewController {
    
    @IBOutlet weak var urlText: UITextField!
    @IBOutlet weak var auto: UISwitch!
    @IBOutlet weak var interval: UIStepper!
    @IBOutlet weak var refreshIntervalLabel: UILabel!
    
    let url = "https://tednewardsandbox.site44.com/questions.json"

    override func viewDidLoad() {
        super.viewDidLoad()
        urlText.text = UserDefaults.standard.string(forKey: "urlString") ?? url
        let autoRefresh = UserDefaults.standard.bool(forKey: "autoRefresh")
        auto.isOn = autoRefresh
        let intervalStep = UserDefaults.standard.integer(forKey: "refreshInterval")
        interval.value = Double(intervalStep > 0 ? intervalStep : 5)
        updateInterval()
        interval.isEnabled = auto.isOn
    }
    
    func updateInterval() {
        let interval = Int(interval.value)
        refreshIntervalLabel.text = "\(interval) min"
    }
    
    @IBAction func autoRefresh(_ sender: UISwitch) {
        interval.isEnabled = sender.isOn
        UserDefaults.standard.set(sender.isOn, forKey: "autoRefresh")
    }
    
    @IBAction func refreshInterval(_ sender: UIStepper) {
        let interval = Int(sender.value)
        UserDefaults.standard.set(interval, forKey: "refreshInterval")
        updateInterval()
    }

    @IBAction func fetchData(_ sender: Any) {
        guard let urlString = urlText.text, !urlString.isEmpty else {
            showAlert(title: "Invalid Input", message: "Enter a valid URL")
            return
        }
        UserDefaults.standard.set(urlString, forKey: "urlString")
        checkNetwork(urlString: urlString)
    }

    func checkNetwork(urlString: String) {
        let monitor = NWPathMonitor()
        monitor.pathUpdateHandler = { path in
            if path.status == .satisfied {
                self.downloadData(from: urlString)
            } else {
                DispatchQueue.main.async {
                    self.showAlert(title: "No Internet", message: "Check your connection")
                }
            }
            monitor.cancel()
        }
        monitor.start(queue: .global(qos: .background))
    }

    func downloadData(from urlString: String) {
        guard let url = URL(string: urlString) else { return }

        URLSession.shared.dataTask(with: url) { data, _, error in
            if let error = error {
                DispatchQueue.main.async {
                    self.showAlert(title: "Download Error", message: error.localizedDescription)
                }
                return
            }
            guard let data = data else { return }

            do {
                let topics = try JSONDecoder().decode([QuizTopic].self, from: data)
                QuizDataStore.shared.quizTopics = topics
                DispatchQueue.main.async {
                    self.showAlert(title: "Success", message: "Quiz data downloaded")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2.0){
                        self.dismiss(animated: true)
                    }
                }
            } catch {
                DispatchQueue.main.async {
                    self.showAlert(title: "Parse Error", message: "Unable to decode quiz data")
                }
            }
        }.resume()
    }

    @IBAction func closePressed(_ sender: Any) {
        if let urlString = urlText.text, !urlString.isEmpty {
            UserDefaults.standard.set(urlString, forKey: "urlString")
        }
        
        dismiss(animated: true)
    }

    func showAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(.init(title: "OK", style: .default))
        present(alert, animated: true)
    }
}
