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
    
    func getQuestions(for topicTitle: String) -> [(question: String, options: [String], correct: Int)]? {
        guard let topic = quizTopics.first(where: { $0.title == topicTitle }) else {
            return nil
        }
        
        return topic.questions.map { question in
            let correctIndex = question.answers.firstIndex(of: question.answer) ?? 0
            return (question.text, question.answers, correctIndex)
        }
    }
}
