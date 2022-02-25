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
    var audioRecorder: AVAudioRecorder! // to use and reference var within code
    
    // MARK: IBOutlets to reflect code changes in view/buttons
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecording: UIButton!
    
    // to to change status of buttons if !recording
    
    func configureUI(started recording: Bool) {
        recordButton.isEnabled = !recording
        recordingLabel.text = !recording ? "Tap to record" : "Recording"
        stopRecording.isEnabled = recording
    }
    
    // MARK: Do any additional setup after loading the view.
    
    // after loading set buttons to the state for !recording
    
    override func viewDidLoad() {
        super.viewDidLoad() // super class's implementation as requested by default
        configureUI(started: false)
    }
    
    // *alternativelly can set buttons to the state for !recording also in viewWillAppear below
    
    // now only includes super class's implementation as requested by default, otherwise does nothing, can also comment out whole function below
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        // configureUI(started: false) // *
    }
    
    // MARK: record button is pressed
     
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(started: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String // store audio via document's directory path
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance() // record&play.shared for apps on entire hardware by default
        try! session.setCategory(AVAudioSession.Category.playAndRecord,
                mode: AVAudioSession.Mode.default,
                options: AVAudioSession.CategoryOptions.defaultToSpeaker) // sets the audio session’s category, mode, and options. In forced way try!

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:]) // an object that records audio data to a file(file location to record to, The audio settings to use for the recording) as class properties
        audioRecorder.delegate = self // set the property audioRecorder of class RecordSoundsViewController as the delegate of the AVAudioRecorder
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // MARK: stop recording button is pressed
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(started: false)
        
        audioRecorder.stop() // stops the audio recorder
        let rSession = AVAudioSession.sharedInstance()
        try! rSession.setActive(false) // set the shared AVAudioSession to inactive
    }
    
    // MARK: sending the recorded Audio File to PlaySoundsViewController
    
    // we can call the stopRecording Segue (moving to PlaySoundsViewController) and send to it the path where the recorded file is located.
    
    // AVAudioRecorder knows that it can call the audioRecorderDidFinishRecording function because our class conforms to the AVAudioRecorderDelegate protocol.
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
            if flag == true {
                performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            } else {
                print("the recording failed")
            }
        
            // stopRecording is Storyboard Segue Identifier, the URL to which the recorder writes its data. Else recording failed.
    }

    // MARK: Notifies the view controller that a segue is about to be performed
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL // green one declared in PlaySoundsViewController.swift (line 23), white one here
        }
    }
    
    // func prepare(for...) belongs to UIViewController, which is super class for our class, therefore have to override this method and we use it to configure the new view controller prior to it being displayed.
    
        // if the stopRecording Segue set up in Storyboard.
    
            // for "let playSoundsVC = segue.destination" using a foreced up cast ~ "as! PlaySoundsViewController" where audio shall be played. We are sure about it!
    
            // we set/grab the sender, which is recorded audio URL.
    
            // we set the recordedAudioURL in the PlaySoundsViewController (.green one). Now the PlaySoundsViewController is receiving the recorded audio URL and we are ready for playback.
}

