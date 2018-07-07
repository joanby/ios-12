//
//  ViewController.swift
//  05-QuizApp
//
//  Created by Juan Gabriel Gomila Salas on 3/7/18.
//  Copyright © 2018 Frogames. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    
    @IBOutlet weak var labelQuestion: UILabel!
    
    @IBOutlet weak var labelQuestionNumber: UILabel!
    
    @IBOutlet weak var labelScore: UILabel!
    
    @IBOutlet weak var progressBar: UIView!
    
    var currentScore = 0
    
    var currentQuestionID = 0
    
    var correctQuestionsAnswered = 0
    
    let factory = QuestionsFactory()
    
    var currentQuestion : Question!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        startGame()
    }
    
    func startGame()  {
        currentScore = 0
        currentQuestionID = 0
        correctQuestionsAnswered = 0
        
        //El método shuffle reordena las preguntas para que cada partida sea diferente
        self.factory.questionsBank.questions.shuffle()
        
        askNextQuestion()
        
        updateUIElements()
    }
    
    func askNextQuestion() {
        if let newQuestion = factory.getQuestionAt(index: currentQuestionID){
            self.currentQuestion = newQuestion
            self.labelQuestion.text = self.currentQuestion.question
            self.currentQuestionID += 1
        } else {
            //Aquí la new Question es nula -> ya hemos hecho todas las preguntas
            gameOver()
        }
    }
    
    func gameOver(){
        //método que se llama cuando no hay más preguntas...
        let alert = UIAlertController(title: NSLocalizedString("game.over.title", comment: "Título del pop up de Game Over"), message: "\(NSLocalizedString("game.over.message1", comment: ""))\(self.correctQuestionsAnswered) / \(self.currentQuestionID). \(NSLocalizedString("game.over.message2", comment: ""))", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: .default) { (_) in
            self.startGame()
        }
        
        alert.addAction(okAction)
        
        present(alert, animated: true, completion: nil)
        
    }
    
    func updateUIElements(){
        self.labelScore.text = "\(NSLocalizedString("score.text", comment: "")): \(self.currentScore)"
        self.labelQuestionNumber.text = "\(self.currentQuestionID)/\(self.factory.questionsBank.questions.count)"
    
        for constraint in self.progressBar.constraints {
            if constraint.identifier == "barWidth" {
                constraint.constant = (self.view.frame.size.width)/CGFloat(self.factory.questionsBank.questions.count) * CGFloat(self.currentQuestionID)
            }
        }
    }

    @IBAction func buttonPressed(_ sender: UIButton) {
        var isCorrect : Bool
        if (sender.tag == 1){
            //El usuario ha clicado el botón true
            isCorrect = (self.currentQuestion.answer == true)
        }else {
            //El usuario ha clicado el botón false
            isCorrect = (self.currentQuestion.answer == false)
        }
        
        
        if(isCorrect){
            self.correctQuestionsAnswered += 1
            self.currentScore += 100*self.correctQuestionsAnswered
            ProgressHUD.showSuccess("\(NSLocalizedString("question.ok", comment: ""))\n\(self.currentQuestion.explanation)")
        }else {
            ProgressHUD.showError("\(NSLocalizedString("question.ko", comment: ""))\n\(self.currentQuestion.explanation)")
        }
        
        askNextQuestion()
        updateUIElements()
        
    }
    
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return UIStatusBarStyle.lightContent
    }
    
    override var prefersStatusBarHidden: Bool{
        return true
    }
}

