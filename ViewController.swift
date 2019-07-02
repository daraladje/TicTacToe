//
//  ViewController.swift
//  TicTacToe
//
//  Created by Dara Ladjevardian on 4/14/19.
//  Copyright © 2019 Dara Ladjevardian. All rights reserved.
//

import UIKit


class ViewController: UIViewController {

    
    //MARK: Properties
    @IBOutlet weak var loseLabel: UILabel!
    @IBOutlet weak var winLabel: UILabel!
    @IBOutlet weak var playAgainButton: UIButton!
    @IBOutlet weak var startLabel: UILabel!
    @IBOutlet weak var tieLabel: UILabel!
    
    var board = [0,0,0,0,0,0,0,0,0]
    var isPlaying = true
    var youStart = Bool.random()
    var yourTurn = true;
    var gameIsOver = false;
    var firstMove = true;
    var moveCount = 0;
    
    override func viewDidLoad() {
        super.viewDidLoad()
        startGame()
    }
    
    func startGame() {
        youStart = Bool.random()
        yourTurn = youStart;
        playAgainButton.isHidden = true
        playAgainButton.isEnabled = false
        winLabel.isHidden = true
        loseLabel.isHidden = true
        tieLabel.isHidden = true
        if youStart {
            startLabel.text = "You start!"
        }
        else {
            startLabel.text = "Computer Starts!"
            computerPlay();
        }
    }
    
    
    
    @IBAction func playGame(_ sender: AnyObject) {
        if isPlaying && yourTurn && board[sender.tag-1] == 0{
            sender.setBackgroundImage(UIImage(named: "X.png"), for: .normal)
            board[sender.tag-1] = 1
            if firstMove {
                firstMove = false
                startLabel.isHidden = true
            }
            moveCount = moveCount + 1
            if checkWin(grid: board){
                displayWin()
            }
            else if moveCount == 9 {
                tie();
            }
            yourTurn = false
            computerPlay();
        }
    }
    
    func computerPlay(){
        if isPlaying {
            let move = miniMAX( game : board, turn : true)
            board[move.0] = 2
            let button = self.view.viewWithTag(move.0+1) as? UIButton
            button!.setBackgroundImage(UIImage(named: "O.png"), for: .normal)
            moveCount = moveCount + 1
            if checkWin(grid: board){
                displayWin()
            }
            else if moveCount == 9 {
                tie()
            }
            yourTurn = true
        }
    }
    
    func miniMAX( game : [Int], turn : Bool) -> (Int,Int){
        var checkBoard = game
        var availableMoves: [Int] {
            return game.indices.filter { game[$0] == 0 }
        }
        if checkWin( grid : checkBoard ) && !turn {
            return (0, 1)
        }
        else if checkWin( grid : checkBoard ) && turn {
            return (0, -1)
        }
        else if availableMoves.count == 0 {
            return (0,0)
        }
        var score = 0
        var moves = [(Int,Int)]()
        for option in availableMoves {
            if turn{
                checkBoard[option] = 2
                let result = miniMAX(game : checkBoard, turn: false)
                score = result.1
            }
            else {
                checkBoard[option] = 1
                let result = miniMAX(game : checkBoard, turn: true)
                score = result.1
            }
            checkBoard[option] = 0
            moves.append((option, score))
        }
        var bestMove = -1
        var curScore = -1
        if turn {
            var maxVal = Int.min
            for move in moves {
                if move.1 > maxVal {
                    maxVal = move.1
                    bestMove = move.0
                }
            }
            curScore = maxVal
        }
        else {
            var minVal = Int.max
            for move in moves {
                if move.1 < minVal {
                    minVal = move.1
                    bestMove = move.0
                }
            }
            curScore = minVal
        }
        return (bestMove, curScore)
    }
    
    
    func tie(){
        tieLabel.isHidden = false
        playAgainButton.isHidden = false
        playAgainButton.isEnabled = true
        isPlaying = false;
    }
    func checkWin( grid : [Int] ) -> Bool{
        return ( grid[0] == grid[1] && grid[1] == grid[2] && grid[0] != 0 ) ||
               ( grid[0] == grid[3] && grid[3] == grid[6] && grid[0] != 0 ) ||
               ( grid[0] == grid[4] && grid[4] == grid[8] && grid[0] != 0 ) ||
               ( grid[1] == grid[4] && grid[4] == grid[7] && grid[1] != 0 ) ||
               ( grid[2] == grid[5] && grid[5] == grid[8] && grid[2] != 0 ) ||
               ( grid[2] == grid[4] && grid[4] == grid[6] && grid[2] != 0 ) ||
               ( grid[3] == grid[4] && grid[4] == grid[5] && grid[3] != 0 ) ||
               ( grid[6] == grid[7] && grid[7] == grid[8] && grid[6] != 0 )
    }
    
    
    func displayWin(){
        if yourTurn {
            winLabel.isHidden = false
        }
        else {
            loseLabel.isHidden = false
        }
        playAgainButton.isHidden = false
        playAgainButton.isEnabled = true
        isPlaying = false
    }

    @IBAction func playAgain(_ sender: Any) {
        moveCount = 0
        board = [0,0,0,0,0,0,0,0,0]
        for i in 1..<10 {
            let button = self.view.viewWithTag(i) as? UIButton
            button!.setBackgroundImage(nil, for: .normal)
        }
        isPlaying = true
        firstMove = true
        startLabel.isHidden = false
        startGame()
    }
    
}

