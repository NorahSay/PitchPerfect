//
//  ViewController.swift
//  PitchPerfect
//
//  Created by Norah Say on 12/28/18.
//  Copyright © 2018 Norah Say. All rights reserved.
//

import UIKit
import AVFoundation

class RecordViewController: UIViewController, AVAudioRecorderDelegate {
    
    @IBOutlet weak var recordButton: UIButton!
    @IBOutlet weak var recordLabel: UILabel!
    
    var recording = false
    var recordSession : AVAudioSession!
    var audioRecorder : AVAudioRecorder!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //setting up session
        recordSession = AVAudioSession.sharedInstance()
        try! recordSession.setCategory(.playAndRecord, mode: .default, options: .defaultToSpeaker)
        recordSession.requestRecordPermission {(hasPermission) in
            if hasPermission {
                print("Accepted")
            }
        }
       
        
    }
    
    @IBAction func recordSound(_ sender: UIButton) {
        recording = !recording
        if recording {
            configureUI(isRecording: true)
            recordConfig()
            
        } else {
            configureUI(isRecording: false)
            audioRecorder.stop()
            try! recordSession.setActive(false)
        }
        
    }
    
    func configureUI(isRecording: Bool) {
        recordLabel.text = isRecording ? "Recording in progress" : "Tap to start recording"
        let buttonImage = isRecording ? "Stop" : "Record"
        recordButton.setImage(UIImage(named: buttonImage), for: .normal)
    }
    
    func getDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let documentDirectory = path[0]
        return documentDirectory
    }
    
    
    
    func recordConfig() {
        
        let filename = getDirectory().appendingPathComponent("record.m4a")
        let setting = [AVFormatIDKey : Int(kAudioFormatMPEG4AAC), AVSampleRateKey: 44100, AVNumberOfChannelsKey : 1, AVEncoderAudioQualityKey : AVAudioQuality.high.rawValue]
        
        do {
            audioRecorder = try AVAudioRecorder(url: filename, settings: setting)
            audioRecorder.delegate = self
            audioRecorder.isMeteringEnabled = true
            audioRecorder.prepareToRecord()
            audioRecorder.record()
        } catch {
            displayAlert(title: "Oops!", message: "Recording Failed")
        }
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        if flag {
            performSegue(withIdentifier: "chooseFilter", sender: audioRecorder.url)
            
        } else {
            displayAlert(title: "Error", message: "Recording was not successful")
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "chooseFilter" {
            let playSoundVC = segue.destination as! PlayViewController
            let recordedAudioURL = sender as! URL
            playSoundVC.recordedAudioURL  = recordedAudioURL
        }
    }
    
    func displayAlert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "dimiss", style: .default, handler: nil))
        present(alert, animated: true, completion: nil)
    }
    
    
    
    









}

