//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by mairo on 18/02/2022.
//

import UIKit
import AVFoundation // AudioVideo framework

class PlaySoundsViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var slowSnail: UIButton! // create IBOutlets in code first
    @IBOutlet weak var highChipmunk: UIButton!
    @IBOutlet weak var fastRabbit: UIButton!
    @IBOutlet weak var lowDartvart: UIButton!
    @IBOutlet weak var echoPapagay: UIButton!
    @IBOutlet weak var reverbHall: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    //  connect them via the interface builder/ Control key in document outline/ drag from the PlaySoundsViewController down to the Slow Button/ from pop up the outlet for the Slow Button. 
    
    var recordedAudioURL: URL! // we set the recordedAudioURL in the PlaySoundsViewController (.green one). Now the PlaySoundsViewController is receiving the recorded audio URL and we are ready for playback.
    
    var audioFile:AVAudioFile! 
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!

    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb // *Tag values from 0...5
    }
    
    // Tagged properties in an enumeration will be used by our class extension ...+Audio
    
    // * Tags to distinguish UIButtons from each other, we use the Tag property of the button. attributes inspector > Tag property > set it from 0...5
    
    // MARK: Play Sound Button Pressed
    
    @IBAction func playSoundForButton(_ sender: UIButton) { // all 7 UIButtons wired up
        switch(ButtonType(rawValue: sender.tag)!) {
            case .slow:
                playSound(rate: 0.5)
            case .fast:
                playSound(rate: 1.5)
            case .chipmunk:
                playSound(pitch: 1000)
            case .vader:
                playSound(pitch: -1000)
            case .echo:
                playSound(echo: true)
            case .reverb:
                playSound(reverb: true)
            }
        
            // func playSound(rate: Float? = nil, pitch: Float? = nil, echo: Bool = false, reverb: Bool = false) { ... as core func declared in ext. ...+Audio.swift, called here. It does not asks for all parameters here when called. Because switch aclually calls all the parameters, wwitch must be exhaustive.


            configureUI(.playing)
    }

    // MARK: Stop Audio Button Pressed
    
    // also IBActions we wire up via the interface builder - Control key/ drag from the Slow button up to the PlaySoundsViewController/ in pop up window select the playSoundForButton function.
    
    // Troubleshooting IBOutlets and IBActions in connections inspector
    
    @IBAction func stopButtonPressed(_ sender: UIButton) {
        stopAudio() // stops audio - declared in ext. ...+Audio.swift
    }
    
    // what happens after ...loading View

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio() // Adding the Audio Extension - declared in ext. ...+Audio.swift
        // configureUI(.notPlaying) // *
    }
    
    // MARK: stop button disabled at this stage
    
    // what happens before loading... View
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated) // make sure to add a call to the super classes viewWillAppear function ~ super class's implementation as requested by default
        configureUI(.notPlaying) // stop button disabled at this stage - we need to configure the UI right before the view first appears on the screen. Therefore we call configureUI here in viewWillAppear. While declared in ext. ...+Audio
        // *alternativelly can write place configureUI(.notPlaying) to viewDidLoad()
    }
}
