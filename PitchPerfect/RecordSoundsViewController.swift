//
//  RecordSoundsViewController.swift
//  PitchPerfect
//
//  Created by mairo on 10/02/2022.
//

import UIKit
import AVFoundation // framework contains the AVAudioRecorder and AVFoundation classes

// MARK: class name: super class, protocol {...

class RecordSoundsViewController: UIViewController, AVAudioRecorderDelegate {
    var audioRecorder: AVAudioRecorder! // to use and reference var within code
    
    // MARK: IBOutlets to reflect code changes in view/buttons
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordingLabel: UILabel!
    @IBOutlet weak var stopRecording: UIButton!
    
    func configureUI(started recording: Bool) { // func for clean up
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
        super.viewWillAppear(animated) // super class's implementation
    }
        
    // MARK: record button is pressed
     
    @IBAction func recordAudio(_ sender: Any) {
        configureUI(started: true)
        
        let dirPath = NSSearchPathForDirectoriesInDomains(.documentDirectory,.userDomainMask, true)[0] as String // store audio viadocument's directory path
        let recordingName = "recordedVoice.wav"
        let pathArray = [dirPath, recordingName]
        let filePath = URL(string: pathArray.joined(separator: "/"))
        
        let session = AVAudioSession.sharedInstance() // record&play.shared for apps on entire hardware by default
        try! session.setCategory(AVAudioSession.Category.playAndRecord,
                mode: AVAudioSession.Mode.default,
                options: AVAudioSession.CategoryOptions.defaultToSpeaker) // sets the audio session’s category, mode, and options. In forced way try!

        try! audioRecorder = AVAudioRecorder(url: filePath!, settings: [:]) // an object that records audio data to a file(file location to record to, The audio settings to use for the recording) as class properties
        audioRecorder.delegate = self
        // set the property audioRecorder of class RecordSoundsViewController as the delegate of the AVAudioRecorder
        
        // the delegate object for the AVAudioRecorder
        
        // weak var delegate: AVAudioRecorderDelegate? { get set }
        
        // let `self`: RecordSoundsViewController
        
        audioRecorder.isMeteringEnabled = true
        audioRecorder.prepareToRecord()
        audioRecorder.record()
    }
    
    // MARK: stop recording button is pressed
    
    @IBAction func stopRecording(_ sender: Any) {
        configureUI(started: false) // clean up
        
        audioRecorder.stop() // stops the audio recorder
        let rSession = AVAudioSession.sharedInstance() // different let, same session???
        try! rSession.setActive(false) // set the shared AVAudioSession to inactive
    }
    
    // MARK: sending the recorded Audio File to PlaySoundsViewController
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
            if flag == true {
                performSegue(withIdentifier: "stopRecording", sender: audioRecorder.url)
            } else { // stopRecording is Storyboard Segue Identifier, the URL to which the recorder writes its data.
                print("the recording failed")
            }
    // we can call the stopRecording Segue (moving to PlaySoundsViewController) and send to it the path where the recorded file is located.
        
    // our class conforms to the protocol AVAudioRecorderDelegate that includes above function*, if mistyped: Rename to 'audioRecorderDidFinishRecording(_:successfully:)' to satisfy this requirement
        
    // *this function is already defined/included by default in the protocol by Apple (in this case, the AVAudioRecorderDelegate protocol). This way your class and the AVAudioRecorder are loosely coupled, and they can work together without having to know much about each other. Loose coupling of classes is really useful in building interchangeable pieces of code
        
    // AVAudioRecorder knows that it can call the audioRecorderDidFinishRecording function in our code, because our class conforms to the AVAudioRecorderDelegate protocol.
    }

    // MARK: Notifies the view controller that a segue is about to be performed
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "stopRecording" {
            let playSoundsVC = segue.destination as! PlaySoundsViewController
            let recordedAudioURL = sender as! URL
            playSoundsVC.recordedAudioURL = recordedAudioURL // green one declared in PlaySoundsViewController.swift, white one here
        }
    // func prepare(for...) belongs to UIViewController, which is super class for our class, therefore have to override this method and we use it to configure the new view controller prior to it being displayed.
    }
    
    // is this the stopRecording Segue set up in Storyboard? If yes:
    
    // we grab (2nd) view controller we are transitioning to, the destination from this handy destination property that's part of the Segue. Because this property is of type UIVIewController (click Option), but we know it is a PlaySoundsViewController, we can up cast it to a PlaySoundsViewController using a foreced up cast ~ as! PlaySoundsViewController
    
    // we grab the sender, which is recorded audio URL. When we look back to where we are performing the Segue, our sender is indeed the recorded audio URL (see func audioRecorderDidFinishRecording).
    
    // we set the recordedAudioURL in the PlaySoundsViewController (.green one). Now the PlaySoundsViewController is receiving the recorded audio URL and we are ready for playback.
}

