//
//  PlaySoundsViewController.swift
//  PitchPerfect
//
//  Created by mairo on 18/02/2022.
//

import UIKit
import AVFoundation

class PlaySoundsViewController: UIViewController {
    
    // MARK: Outlets

    @IBOutlet weak var slowSnail: UIButton!
    @IBOutlet weak var highChipmunk: UIButton!
    @IBOutlet weak var fastRabbit: UIButton!
    @IBOutlet weak var lowDartvart: UIButton!
    @IBOutlet weak var echoPapagay: UIButton!
    @IBOutlet weak var reverbHall: UIButton!
    @IBOutlet weak var stopButton: UIButton!
    
    var recordedAudioURL: URL!
    
    var audioFile:AVAudioFile! 
    var audioEngine:AVAudioEngine!
    var audioPlayerNode: AVAudioPlayerNode!
    var stopTimer: Timer!

    enum ButtonType: Int {
        case slow = 0, fast, chipmunk, vader, echo, reverb
    }
    
    // MARK: Play Sound Button Pressed
    
    @IBAction func playSoundForButton(_ sender: UIButton) {
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

            configureUI(.playing)
    }

    // MARK: Stop Audio Button Pressed
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) {
        stopAudio()
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio()
    }
    
    // MARK: stop button disabled at this stage
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        configureUI(.notPlaying)
    }
}
