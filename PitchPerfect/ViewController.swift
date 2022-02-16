//
//  ViewController.swift
//  PitchPerfect
//
//  Created by mairo on 10/02/2022.
//

import UIKit

class ViewController: UIViewController {
    
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
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // dispose any resources that can be recreated
    }
    */
     
    @IBAction func recordAudio(_ sender: Any) {
        print("record button was pressed")
        recordButton.isEnabled = false
        recordingLabel.text = "Recording in progress"
        stopRecording.isEnabled = true
    }
    
    @IBAction func stopRecording(_ sender: Any) {
        print("stop recording button was pressed")
        recordButton.isEnabled = true
        recordingLabel.text = "Tap to record"
        stopRecording.isEnabled = false
    }
    
}

