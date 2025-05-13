//
//  ThankYouViewController.swift
//  iQuiz
//
//  Created by Vaibava Venkatesan on 5/12/25.
//

import UIKit

class ThankYouViewController: UIViewController {
    
    @IBOutlet weak var thankYouLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        thankYouLabel.text = "Thank you for playing!"
    }
}


