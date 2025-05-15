//
//  QuizDataStore.swift
//  iQuiz
//
//  Created by Vaibava Venkatesan on 5/14/25.
//

import Foundation

struct QuizTopic: Codable {
    let title: String
    let desc: String
    let questions: [QuizQuestion]
}

struct QuizQuestion: Codable {
    let text: String
    let answer: String
    let answers: [String]
}

class QuizDataStore {
    static let shared = QuizDataStore()
    var quizTopics: [QuizTopic] = []
}
