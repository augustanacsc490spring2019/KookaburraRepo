/// Copyright (c) 2018 Razeware LLC
///
/// Permission is hereby granted, free of charge, to any person obtaining a copy
/// of this software and associated documentation files (the "Software"), to deal
/// in the Software without restriction, including without limitation the rights
/// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
/// copies of the Software, and to permit persons to whom the Software is
/// furnished to do so, subject to the following conditions:
///
/// The above copyright notice and this permission notice shall be included in
/// all copies or substantial portions of the Software.
///
/// Notwithstanding the foregoing, you may not use, copy, modify, merge, publish,
/// distribute, sublicense, create a derivative work, and/or sell copies of the
/// Software in any work that is designed, intended, or marketed for pedagogical or
/// instructional purposes related to programming, coding, application development,
/// or information technology.  Permission for such use, copying, modification,
/// merger, publication, distribution, sublicensing, creation of derivative works,
/// or sale is expressly withheld.
///
/// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
/// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
/// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
/// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
/// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
/// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
/// THE SOFTWARE.

import GameKit

final class GameCenterHelper: NSObject, GKGameCenterControllerDelegate {
    
    var numberOfTotalWins = Int()
    var numberOfTotalLoses = Int()
    
    typealias CompletionBlock = (Error?) -> Void
    
    static let helper = GameCenterHelper()
    
    static var isAuthenticated: Bool {
        return GKLocalPlayer.local.isAuthenticated
    }
    
    var viewController: UIViewController?
    var currentMatchmakerVC: GKTurnBasedMatchmakerViewController?
    
    enum GameCenterHelperError: Error {
        case matchNotFound
    }
    
    var currentMatch: GKTurnBasedMatch?
    
    var canTakeTurnForCurrentMatch: Bool {
        guard let match = currentMatch else {
            return true
        }

        return match.isLocalPlayersTurn
    }
    
    override init() {
        super.init()
        
        GKLocalPlayer.local.authenticateHandler = { gcAuthVC, error in
            NotificationCenter.default.post(name: .authenticationChanged, object: GKLocalPlayer.local.isAuthenticated)
            
            if GKLocalPlayer.local.isAuthenticated {
                GKLocalPlayer.local.register(self)
            } else if let vc = gcAuthVC {
                print("init viewcont: \(self.viewController)")
                self.viewController?.present(vc, animated: true)
            }
            else {
                print("Error authentication to GameCenter: \(error?.localizedDescription ?? "none")")
            }
        }
    }
    
    func presentMatchmaker() {
        guard GKLocalPlayer.local.isAuthenticated else {
            return
        }
        
        let request = GKMatchRequest()
        
        request.minPlayers = 2
        request.maxPlayers = 2
        request.inviteMessage = "Would you like to play Alchemist Chess?"
        
        let vc = GKTurnBasedMatchmakerViewController(matchRequest: request)
        vc.turnBasedMatchmakerDelegate = self
        
        currentMatchmakerVC = vc
        print("mm viewcont: \(self.viewController)")

        viewController?.present(vc, animated: true)
    }
    
    func endTurn(_ model: GameModel, completion: @escaping CompletionBlock) {
        guard let match = currentMatch else {
            completion(GameCenterHelperError.matchNotFound)
            return
        }

        do {
            match.message = model.messageToDisplay

            match.endTurn(
                withNextParticipants: match.others,
                turnTimeout: GKExchangeTimeoutDefault,
                match: try JSONEncoder().encode(model),
                completionHandler: completion
            )
        } catch {
            completion(error)
        }
    }
    
    func win(completion: @escaping CompletionBlock) {
        guard let match = currentMatch else {
            completion(GameCenterHelperError.matchNotFound)
            return
        }

        match.currentParticipant?.matchOutcome = .won
        match.others.forEach { other in
            other.matchOutcome = .lost
        }
        
        //keeps track of number of total wins and loses
        if match.currentParticipant?.matchOutcome == .won {
            numberOfTotalWins += 1
        } else {
            numberOfTotalLoses += 1
        }

        match.endMatchInTurn(
            withMatch: match.matchData ?? Data(),
            completionHandler: completion
        )
    }
    
    
    //this method conects the number of total wins to the leader board Wins
    // we need to figure out where to call this method in order to save this data
    // when we call it we will put saveTotalWins(numberOfTotalWins)
    func saveTotalWins(number: Int){
        
        if GKLocalPlayer.local.isAuthenticated {
            
            let winReporter = GKScore(leaderboardIdentifier: "Wins")
            
            winReporter.value = Int64(number)
            
            let winArray : [GKScore] = [winReporter]
            
            GKScore.report(winArray, withCompletionHandler: nil)
        }
    }
    
    //this method conects the number of total loses to the leader board Loses
    // we need to figure out where to call this method in order to save this data
    // when we call it we will put saveTotalLoses(numberOfTotalLoses)
    func saveTotalLoses(number: Int){
        
        if GKLocalPlayer.local.isAuthenticated {
            
            let losesReporter = GKScore(leaderboardIdentifier: "Loses")
            
            losesReporter.value = Int64(number)
            
            let losesArray : [GKScore] = [losesReporter]
            
            GKScore.report(losesArray, withCompletionHandler: nil)
        }
    }
    
    //This function I got from a tutorial and needs some fixes and editing in order for us to be able to use in our game
//    func showLeaderBoard(){
//        let viewController = self.view.window?.rootViewController
//        let gvcv = GKGameCenterViewController()
//
//        gvcv.GameCenterDelegate = self
//
//        viewController?.presentViewController(gvcv, animated: true, completion: nil)
//    }
    
    //thismethod was also taken from the tutorial and is explained in this link //https://www.youtube.com/watch?v=TziN1O2x7pM 
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
    
}

extension GameCenterHelper: GKTurnBasedMatchmakerViewControllerDelegate {
    func turnBasedMatchmakerViewControllerWasCancelled(_ viewController: GKTurnBasedMatchmakerViewController) {
        viewController.dismiss(animated: true)
    }
    
    func turnBasedMatchmakerViewController(_ viewController: GKTurnBasedMatchmakerViewController, didFailWithError error: Error) {
        print("Matchmaker vc did fail with error: \(error.localizedDescription).")
    }
}

extension GameCenterHelper: GKLocalPlayerListener {
    func player(_ player: GKPlayer, wantsToQuitMatch match: GKTurnBasedMatch) {
        let activeOthers = match.others.filter { other in
            return other.status == .active
        }
        
        match.currentParticipant?.matchOutcome = .lost
        activeOthers.forEach { participant in
            participant.matchOutcome = .won
        }
        
        match.endMatchInTurn(
            withMatch: match.matchData ?? Data()
        )
    }
    
    func player(_ player: GKPlayer, receivedTurnEventFor match: GKTurnBasedMatch, didBecomeActive: Bool) {
        if let vc = currentMatchmakerVC {
            currentMatchmakerVC = nil
            vc.dismiss(animated: true)
        }
        
        guard didBecomeActive else {
            return
        }
        
        NotificationCenter.default.post(name: .presentGame, object: match)
    }
}

extension Notification.Name {
    static let presentGame = Notification.Name(rawValue: "presentGame")
    static let authenticationChanged = Notification.Name(rawValue: "authenticationChanged")
}
