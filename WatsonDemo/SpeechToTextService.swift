
//
//  SpeechToTextService.swift
//  WatsonDemo
//
//  Created by Etay Luz on 11/15/16.
//  Copyright © 2016 Etay Luz. All rights reserved.
//

import Foundation

import AVFoundation
import SpeechToTextV1

protocol SpeechToTextServiceDelegate: class {
    func didFinishTranscribingSpeech(withText text: String)
}

class SpeechToTextService {

    // MARK: - Properties
    weak var delegate: SpeechToTextServiceDelegate?
    var speechToTextSession = SpeechToTextSession(username: GlobalConstants.dennisNotoBluemixUsernameSTT,
                                                  password: GlobalConstants.dennisNotoBluemixPasswordSTT)
    var textTranscription: String?


    // MARK: - Init
    init(delegate: SpeechToTextServiceDelegate) {
        self.delegate = delegate

//        speechToTextSession.onResults = { results in print(results.bestTranscript)
//            if let bestTranscript = results.bestTranscript as String? {
//                print("my textttt>>>>>>>\(bestTranscript)")
//                //let truncated = bestTranscript.substring(to: bestTranscript.index(before: bestTranscript.endIndex))
//                delegate.didFinishTranscribingSpeech(withText: bestTranscript)
//            }
//        }
    }

    func startRecording() {
        
        speechToTextSession.connect()
        var settings = RecognitionSettings(contentType: .opus)
        settings.interimResults = false
        settings.continuous = true
        //settings.inactivityTimeout = -1
        settings.smartFormatting = true

        speechToTextSession.onConnect = { print("connected") }
        
        speechToTextSession.startRequest(settings: settings)
        speechToTextSession.startMicrophone()
        
        
        
    }

    func finishRecording() {
        
        speechToTextSession.onResults = { results in print(results.bestTranscript)
            if let bestTranscript = results.bestTranscript as String? {
                print("my textttt>>>>>>>\(bestTranscript)")
                
                let trimmedString = bestTranscript.trimmingCharacters(in: .whitespacesAndNewlines)
                //print(trimmedString)
                //let truncated = bestTranscript.substring(to: bestTranscript.index(before: bestTranscript.endIndex))
                self.delegate?.didFinishTranscribingSpeech(withText: trimmedString)
            }
        }
        
        speechToTextSession.stopMicrophone()
        speechToTextSession.stopRequest()
        speechToTextSession.disconnect()
    }

}
