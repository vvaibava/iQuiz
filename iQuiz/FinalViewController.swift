//
//  FinalViewController.swift
//  iQuiz
//
//  Created by Vaibava Venkatesan on 5/12/25.
//

import UIKit

class FinalViewController: UIViewController {

    @IBOutlet weak var resLabel: UILabel!
    @IBOutlet weak var scoreLabel: UILabel!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    
    
    var count: Int = 0
    var total: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        scoreLabel.text = "You got \(count) out of \(total) correct."
        let percent = Double(count) / Double(total)
        switch percent {
        case 1.0:
            resLabel.text = "Perfect"
        case 0.7...0.99:
            resLabel.text = "Great"
        case 0.4...0.69:
            resLabel.text = "Almost"
        default:
            resLabel.text = "Try Again!"
        }
        
    }
    
    
    @IBAction func backTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "unwindSegue", sender: self)
    }
    
    @IBAction func nextTapped(_ sender: UIButton) {
        performSegue(withIdentifier: "thankYouSegue", sender: self)
    }

}
