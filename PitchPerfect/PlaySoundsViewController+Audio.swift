//
//  PlaySoundsViewController+Audio.swift
//  PitchPerfect
//
//  Created by mairo on 21/02/2022.
//

// import Foundation
import UIKit
import AVFoundation

// MARK: - PlaySoundsViewController: AVAudioPlayerDelegate

extension PlaySoundsViewController: AVAudioPlayerDelegate {
    
    // MARK: Alerts
    
    // to have the alert messages in a single place, can use them thoroughout code
    
    struct Alerts {
        static let DismissAlert = "Dismiss"
        static let RecordingDisabledTitle = "Recording Disabled"
        static let RecordingDisabledMessage = "You've disabled this app from recording your microphone. Check Settings."
        static let RecordingFailedTitle = "Recording Failed"
        static let RecordingFailedMessage = "Something went wrong with your recording."
        static let AudioRecorderError = "Audio Recorder Error"
        static let AudioSessionError = "Audio Session Error"
        static let AudioRecordingError = "Audio Recording Error"
        static let AudioFileError = "Audio File Error" // used in func setupAudio()
        static let AudioEngineError = "Audio Engine Error" // used in func playSound()
    }
    
    // MARK: PlayingState (raw values correspond to sender tags)
    
    // enum used by the configureUI function to set the button states depending on not/Playing
    
    enum PlayingState { case notPlaying, playing }
    
    // MARK: Audio Functions
    
    // function for Audio Extension that we called/added in override func viewDidLoad() {... in PlaySoundsViewController.swift file. Occurs after loading because viewDidLoad.
    
    // it does initialize (recording) audio file
    
    // try to load the audio recording file past in from RecordSoundViewController. If loading the audio fails, we present an alert message to the user.
    
    func setupAudio() {
        do {
            audioFile = try AVAudioFile(forReading: recordedAudioURL as URL)
        } catch {
            showAlert(Alerts.AudioFileError, message: String(describing: error))
        }
    }
    
    // play sounds as per given effect
    
    func playSound(rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, reverb: Bool = false) {
        
        // initialize audio engine components
        
        audioEngine = AVAudioEngine() // this class uses audio player nodes to make changes to the audio output
        
        // node for playing audio
        
        audioPlayerNode = AVAudioPlayerNode()
        audioEngine.attach(audioPlayerNode)
        
        // above 3 lines, grab the AVAudioEngine and create a AVAudioPlayerNode
        
        // node for adjusting rate/pitch
        
        let changeRatePitchNode = AVAudioUnitTimePitch() // *** summary: an object that provides a good-quality playback rate and pitch shifting independently of each other.
        
        // value binding inside of an if statement, for pitch and rate as they are optionals
        
        // if the pitch variable is not nil then execute this if statement, otherwise we'll skip over this code and go on to the next if statement (to if let rate).
        
        if let pitch = pitch {
            changeRatePitchNode.pitch = pitch
        }
       
        // if the rate variable is not nil, then we'll execute this if statement. Otherwise we'll skip it and move on to the next line of code (to audioEngine.attach(...).
        
        if let rate = rate {
            changeRatePitchNode.rate = rate
        }
        audioEngine.attach(changeRatePitchNode) // *** that's why changeRatePitchNode is used for both rate and pitch
        
        // node for echo
        let echoNode = AVAudioUnitDistortion()
        echoNode.loadFactoryPreset(.multiEcho2)
        audioEngine.attach(echoNode)
        
        // node for reverb
        let reverbNode = AVAudioUnitReverb()
        reverbNode.loadFactoryPreset(.largeHall)
        reverbNode.wetDryMix = 50
        audioEngine.attach(reverbNode)
        
        // connect all nodes. Above we create also echo and reverb nodes, but we only use them if the echo or reverb parameters were passed in and set to true. We can have either echo and reverb, just just one of them, or neither. Node changeRatePitchNode is there always as it can have any value (if not nil).
        
        // we have all nodes ("mix buttons") plus node for playing audio declared in line 65: audioPlayerNode = AVAudioPlayerNode()
        
        if echo == true && reverb == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, reverbNode, audioEngine.outputNode)
        } else if echo == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, echoNode, audioEngine.outputNode)
        } else if reverb == true {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, reverbNode, audioEngine.outputNode)
        } else {
            connectAudioNodes(audioPlayerNode, changeRatePitchNode, audioEngine.outputNode)
        }
        
        // schedule to play and start the engine
        
        // in below 2 lines we tell the audio player to stop playing any current audio and schedule our recorded audio for playback. This ensures that the recorded audio is in memory and ready to be played.
        
        audioPlayerNode.stop()
        audioPlayerNode.scheduleFile(audioFile, at: nil) { // The scheduleFile function takes a closure that it runs when the audio file is ready to start playing. The code in this closure sets a timer to fire when the audio is done playing, that resets the buttons to the notPlaying state *.
            
            var delayInSeconds: Double = 0
            
            //  if audio has some time perform nested condition
    
            if let lastRenderTime = self.audioPlayerNode.lastRenderTime, let playerTime = self.audioPlayerNode.playerTime(forNodeTime: lastRenderTime) {
                if let rate = rate { // if rate is !nil, adjust audio length by rate value
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate) / Double(rate)
                } else { // else play audio in normal lenght
                    delayInSeconds = Double(self.audioFile.length - playerTime.sampleTime) / Double(self.audioFile.processingFormat.sampleRate)
                }
            }
            
            // * schedule a stop timer for when audio finishes playing
            
            self.stopTimer = Timer(timeInterval: delayInSeconds, target: self, selector: #selector(PlaySoundsViewController.stopAudio), userInfo: nil, repeats: false)
            RunLoop.main.add(self.stopTimer!, forMode: RunLoop.Mode.default)
        }
        
        // in do-catch we try to start the audio engine in the audio node playback
        
        do {
            try audioEngine.start()
        } catch {
            showAlert(Alerts.AudioEngineError, message: String(describing: error))
            return
        }
        
        // when the execution reaches this point, the audio would be playing
        
        audioPlayerNode.play()
    }
    
    // the stopAudio function is in charge of stopping the audio.
    // Collectivelly code in this func stopAudio() does stop the audioPlayerNode and the audioEngine itself.
    
    @objc func stopAudio() {
        
        if let audioPlayerNode = audioPlayerNode {
            audioPlayerNode.stop()
        }
        
        if let stopTimer = stopTimer {
            stopTimer.invalidate()
        }
        
        // above two lines: remember that timer that we set back in the playSound function. We don't want it to fire as we're stopping the the sound here. So this if statement invalidates that timer.
        
        configureUI(.notPlaying)
                        
        if let audioEngine = audioEngine {
            audioEngine.stop()
            audioEngine.reset()
        }
    }
    
    // MARK: Connect List of Audio Nodes
    
    // helper function to connect a set of audio notes together in the audioEngine. Cuts down on the duplication of code in the playSound function.
    
    func connectAudioNodes(_ nodes: AVAudioNode...) {
        for x in 0..<nodes.count-1 {
            audioEngine.connect(nodes[x], to: nodes[x+1], format: audioFile.processingFormat)
        }
    }
    
    // MARK: UI Functions

    // convenience function to reset the buttons to the proper state when playing or not playing music
    
    func configureUI(_ playState: PlayingState) {
        switch(playState) {
        case .playing:
            setPlayButtonsEnabled(false)
            stopButton.isEnabled = true
        case .notPlaying:
            setPlayButtonsEnabled(true)
            stopButton.isEnabled = false
        }
        
        // configureUI itself uses another helper function (below one) to toggle the playback buttons. If you pass in false, they get disabled. If you pass in true they'll all be enabled.
    }
    
    func setPlayButtonsEnabled(_ enabled: Bool) {
        slowSnail.isEnabled = enabled
        highChipmunk.isEnabled = enabled
        fastRabbit.isEnabled = enabled
        lowDartvart.isEnabled = enabled
        echoPapagay.isEnabled = enabled
        reverbHall.isEnabled = enabled
    }
    
    // displays an alert to the user using UIAlertController if something goes wrong.

    func showAlert(_ title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: Alerts.DismissAlert, style: .default, handler: nil))
        self.present(alert, animated: true, completion: nil)
    }
}
