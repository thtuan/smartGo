//
//  CheckSpeakController.swift
//  SmartGO
//
//  Created by thanh tuan on 8/2/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit
import Speech
import CircleProgressView
import NVActivityIndicatorView
import RxSwift
import RxCocoa

class CheckSpeakController: UIViewController, UITableViewDataSource {
    var contentCell: [String] = ["Can I help you?","Yeah, I want to buy some orange juice","Here you are","Thank you, oh I forgot, how much is it?", "10 thousand vnd plz" ]
    var timer: Timer?
    var audioEngine:AVAudioEngine?
    var speechRecognizer: SFSpeechRecognizer?
    var request: SFSpeechAudioBufferRecognitionRequest?
    var recognitionTask: SFSpeechRecognitionTask?
    var percent = 0
    var indicatorView: NVActivityIndicatorView?
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        requestSpeechAuthorization()
        // Do any additional setup after loading the view.
        indicatorView = rootActivityIndicatorView
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
     }
     */
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contentCell.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "checkspeak", for: indexPath) as! CheckSpeakViewCell
        cell.actionCell = self
        cell.lblContent.text = contentCell[indexPath.row]
        cell.btnSpeak.tag = indexPath.row
        return cell
    }
}

extension CheckSpeakController: ActionCellProtocol{
    func pressButton(sender: UIButton) {
        recordAndRecognizeSpeech(row: sender.tag)
    }
}

extension CheckSpeakController{
    func recordAndRecognizeSpeech(row: Int){
        
        guard let node = self.audioEngine?.inputNode else {return}
        let recordingFormat = node.outputFormat(forBus: 0)
        node.installTap(onBus: 0, bufferSize: 1024, format: recordingFormat) { (buffer, _) in
            self.request?.append(buffer)
        }
        
        audioEngine?.prepare()
        do {
            
            try audioEngine?.start()
            self.timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
            self.percent = 0
            self.indicatorView?.startAnimating()
            self.contentCell[row] = "now you can speak"
            self.tableView.reloadData()
            self.view.isUserInteractionEnabled = false
        } catch  {
            print(error.localizedDescription)
        }
        
        recognitionTask = speechRecognizer?.recognitionTask(with: request!, resultHandler: { (result, error) in
            if let result = result{
                self.contentCell[row] = ""
                let bestString = result.bestTranscription.formattedString
                self.contentCell[row] = bestString
                self.tableView.reloadData()
                print(bestString)
            } else if let error = error{
                print(error.localizedDescription)
            }
            
        })
    }
    func requestSpeechAuthorization() {
        audioEngine = AVAudioEngine()
        speechRecognizer = SFSpeechRecognizer(locale: Locale.init(identifier: "en-US"))
        request = SFSpeechAudioBufferRecognitionRequest()
        SFSpeechRecognizer.requestAuthorization { authStatus in
            OperationQueue.main.addOperation {
                switch authStatus {
                case .authorized:
                    print("authorized")
                //                    self.startButton.isEnabled = true
                case .denied:
                    print("denied")
                case .restricted:
                    print("restricted")
                case .notDetermined:
                    print("not determined")
                }
            }
        }
    }
    
    func tick() {
        percent += 1
        if percent >= 500{
            indicatorView?.stopAnimating()
            self.view.isUserInteractionEnabled = true
            timer?.invalidate()
            audioEngine?.stop()
            if let node = audioEngine?.inputNode {
                node.removeTap(onBus: 0)
            }
            request?.endAudio()
            recognitionTask?.cancel()
        }
        
    }
    
}
