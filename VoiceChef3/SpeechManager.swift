//
//  SpeechManager.swift
//  VoiceChef3
//
//  Created by Annamaria Fidanza on 12/16/24.
//

import AVFoundation

@MainActor
class SpeechManager: NSObject, ObservableObject, @unchecked Sendable {
    private let synthesizer = AVSpeechSynthesizer()
    @Published var isSpeaking = false
    
    override init() {
        super.init()
        synthesizer.delegate = self
        configureAudioSession()
    }
    private func configureAudioSession() {
            do {
                try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default)
                try AVAudioSession.sharedInstance().setActive(true)
            } catch {
                print("Failed to configure audio session: \(error)")
            }
        }

    
    func speak(recipe: MealDetail) {
            if synthesizer.isSpeaking {
                synthesizer.stopSpeaking(at: .immediate)
            }
            
            var textToSpeak = "Recipe for \(recipe.strMeal).... "
            
            textToSpeak += "Let's start with the ingredients you need.... "
            for ingredient in recipe.ingredients {
                textToSpeak += "\(ingredient.amount) of \(ingredient.name).... "
            }
            
            textToSpeak += "Now, let's move on to the instructions.... "
            textToSpeak += recipe.strInstructions
                .replacingOccurrences(of: ".", with: ".... ")
                .replacingOccurrences(of: ",", with: "... ")
            
            let utterance = AVSpeechUtterance(string: textToSpeak)
            utterance.rate = 0.30
            utterance.pitchMultiplier = 1.0
            utterance.volume = 1.0
            
            utterance.prefersAssistiveTechnologySettings = false
            
            utterance.voice = AVSpeechSynthesisVoice(language: "en-US")
            
            isSpeaking = true
            synthesizer.speak(utterance)
        }

    
    func stopSpeaking() {
        synthesizer.stopSpeaking(at: .immediate)
        isSpeaking = false
    }
}

extension SpeechManager: AVSpeechSynthesizerDelegate {
    nonisolated func speechSynthesizer(_ synthesizer: AVSpeechSynthesizer, didFinish utterance: AVSpeechUtterance) {
        Task { @MainActor in
            self.isSpeaking = false
        }
    }
}

