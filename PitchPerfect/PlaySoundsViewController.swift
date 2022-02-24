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
        case slow = 0, fast, chipmunk, vader, echo, reverb // Tag values from 0...5
    }
    
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

            configureUI(.playing)
    }

    // MARK: Stop Audio Button Pressed
    
    @IBAction func stopButtonPressed(_ sender: AnyObject) { // why sender is AnyObject and not UIButton? janko
        stopAudio() // call this function that is declared in extention ...+Audio.swift
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupAudio() // Adding the Audio Extension
        // Do any additional setup after loading the view.
    }
    
    // MARK: stop button disabled at this stage
    
    override func viewWillAppear(_ animated: Bool) { // 10. Adding the Audio Extension
        super.viewWillAppear(animated)
        configureUI(.notPlaying) // stop button disabled at this stage, janko
    }
    
    /*
    override func didReceiveMemoryWarning() {... deleted 
     */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
