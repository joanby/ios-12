//
//  Question.swift
//  05-QuizApp
//
//  Created by Juan Gabriel Gomila Salas on 3/7/18.
//  Copyright © 2018 Frogames. All rights reserved.
//

import Foundation

class Question : CustomStringConvertible, Codable {
    
    let question : String
    let answer: Bool
    let explanation : String
    
    /*enum CodingKeys : String, CodingKey {
        case questionText = "question"
        case answer = "answer"
        case answerExplanation = "explanation"
    }*/
    
    var description : String {
        let respuesta = (answer ? "Verdadera" : "Falsa")
        return """
        Pregunta:
        --------
            - \(question)
            - Respuesta : \(respuesta)
            - Explicación: \(explanation)
        """
    }
    
    init(text: String, correctAnswer: Bool, answer:String) {
        self.question = text
        self.answer = correctAnswer
        self.explanation = answer
    }
    
}

struct  QuestionsBank : Codable {
    var questions : [Question]
}
