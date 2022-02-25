//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by mairo on 10/02/2022.
//

import UIKit
import AVFoundation

// MARK: class name: super class, protocol {...

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder!
    
    // MARK: IBOutlets to reflect code changes in view/buttons
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecording: UIButton!
    
    func configureUI(started recording: Bool) {
        if recording == false {
            recordButton.isEnabled = true
            recordingLabel.text = "Tap to record"
            stopRecording.isEnabled = false
        } else {
            recordButton.isEnabled = false
            recordingLabel.text = "Recording in progress"
            stopRecording.isEnabled = true
        }
    }
    
    // MARK: Do any additional setup after loading the view.
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI(started: false)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
    }
        
    // MARK: record button is pressed
     
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(started: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord,
                mode: AVAudioSession.Mode.default,
                options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // MARK: stop recording button is pressed
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(started: false)
        
        audioRecorder.stop()
        let rSession = AVAudioSession.sharedInstance()
        try! rSession.setActive(false)
    }
    
    // MARK: sending the recorded Audio File to PlaySoundsViewController
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
            if flag == true {
                performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            } else {
                print("the recording failed")
            }
    }

    // MARK: Notifies the view controller that a segue is about to be performed
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL
        }
    }
}

