//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by mairo on 10/02/2022.
//

import UIKit
import AVFoundation

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    
    var audioRecorder: AVAudioRecorder!
    
    @IBOutlet weak var recordButton: UIButton! // ex.7
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecording: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        stopRecording.isEnabled = false
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) { // ViewDidLoad and Friends 2:23
        super.viewWillAppear(animated)
        print("viewWillAppear called")
    }
    
    /*
    override func didReceiveMemoryWarning() { // not sure if this func was originally here
        super.didReceiveMemoryWarning()
        // dispose any resources that can be recreated
    } */
     
    @IBAction func recordAudio(_ sender: Any) {
        //print("record button was pressed")
        recordButton.isEnabled = false
        recordingLabel.text = "Recording in progress"
        stopRecording.isEnabled = true
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        print(filePath ?? "default nil ~ no path")
        
        let session = AVAudioSession.sharedInstance()
        try! session.setCategory(AVAudioSession.Category.playAndRecord, mode: AVAudioSession.Mode.default, options: AVAudioSession.CategoryOptions.defaultToSpeaker)

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:])
        audioRecorder.delegate = self // added as per 9. Adding Delegation...
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        // print("stop recording button was pressed")
        recordButton.isEnabled = true
        recordingLabel.text = "Tap to record"
        stopRecording.isEnabled = false
        
        audioRecorder.stop()
        let audioSession = AVAudioSession.sharedInstance()
        try! audioSession.setActive(false)
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        print("*finished recording")
    }
}

