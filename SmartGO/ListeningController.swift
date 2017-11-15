//
//  ListeningController.swift
//  SmartGO
//
//  Created by thanh tuan on 7/12/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit
import AVFoundation
import Toaster
import NVActivityIndicatorView
protocol ListeningControllerInput {
    func setAudioURL(url: URL)
    func showError(message:String)
    func setTranscript(url: URL)
    func setRunningSubURL(url: URL)
    func setDataModel(data: Listening?)
}
enum RecordStatus {
    case recording
    case stop
    case newRecord
}

enum TranscriptStatus {
    case show
    case hidden
}
enum PlayingStatus {
    case audio
    case record
}
class ListeningController: UIViewController, ListeningControllerInput, AVAudioPlayerDelegate,AVAudioRecorderDelegate {
    
    var activityIndicatorView: NVActivityIndicatorView?
    var transStatus: TranscriptStatus = TranscriptStatus.hidden
    var audioPlayer: AVAudioPlayer!
    var recordPlayer: AVAudioPlayer!
    
    var timer: Timer?
    var recordingSession: AVAudioSession!
    var audioRecorder: AVAudioRecorder?
    var audioFileName: URL?
    
    var recordStatus: RecordStatus = .stop
    var presenter: ListeningPresenterInput!
    var router: ListeningRouterInput!
    var content: String?
    var audioURL: URL?
    var subURL: URL?
    var runningSub: URL?
    var recordURL: URL?
    var playingStatus: PlayingStatus?
    var lyric:VTKaraokeLyric?
    var lyricParser: VTBasicKaraokeLyricParser?
    fileprivate var timingKeys:Array<CGFloat> = [CGFloat]()
    
    
    @IBOutlet weak var lyricPlayer: VTKaraokeLyricPlayerView!
    @IBOutlet weak var btnRecord: UIButton!
    @IBOutlet weak var cdImage: UIImageView!
    @IBOutlet weak var btnControl: UIButton!
    @IBOutlet weak var audioSlider: UISlider!
    @IBOutlet weak var transciptText: UITextView!
    
    @IBOutlet weak var btnPlayRecord: UIButton!
    
    @IBAction func showTranscript(_ sender: Any) {
        switch transStatus {
        case .hidden:
            transciptText.text = content
            transStatus = .show
        case .show:
            transciptText.text = "Click to show transcript"
            transStatus = .hidden
        }
    }
    
    @IBAction func clickController(_ sender: Any) {
        if audioPlayer != nil {
            if audioPlayer.isPlaying{
                pause(type: .audio)
            }else {
                play(type: .audio)
            }
        }else {
            guard let url = audioURL else {
                return
            }
            setAudio(url: url)
            play(type: .audio)
        }
        
    }
    
    @IBAction func playRecording(_ sender: Any) {
        if recordPlayer != nil {
            if recordPlayer.isPlaying{
                pause(type: .record)
            }else {
                play(type: .record)
            }
        }else {
            guard let url = recordURL else {
                return
            }
            setAudioRecorder(url: url)
            play(type: .record)
        }
    }
    
    @IBAction func sliderChanged(_ sender: Any) {
        audioPlayer.currentTime = TimeInterval(audioSlider.value / 10)
        lyricPlayer.setCurrentTime(audioPlayer.currentTime)
    }
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?)
    {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
        setUp()
    }
    
    required init?(coder aDecoder: NSCoder)
    {
        super.init(coder: aDecoder)
        setUp()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        lyricParser = VTBasicKaraokeLyricParser()
        self.view.isUserInteractionEnabled = false
        
        transciptText.layer.borderWidth = 1
        transciptText.layer.cornerRadius = 10
        if let audioUrl = router.getListening()?.urlAudio, let subUrl = router.getListening()?.urlSub, let audioName = router.getListening()?.name, let runningSubURL = router.getListening()?.urlRunnigSub{
            
            //            let x = self.view.center.x - 20
            //            let y = self.view.center.y - 100
            //            let frame = CGRect(x: x, y: y, width: 40, height: 40)
            activityIndicatorView = getActivityIndicatorView()
            activityIndicatorView?.startAnimating()
            presenter.downloadAudioFromURL(url: URL(string: audioUrl)!, filename: audioName, ext: ".mp3" )
            presenter.downloadSubFromURL(url: URL(string:subUrl)!, filename: audioName, ext: ".txt" )
            presenter.loadRunningSubFromURL(url: URL(string:runningSubURL)!, filename: audioName+"RunSub", ext: ".txt")
            
        }else {
            showError(message: "can't load data")
        }
        switch router.screenType {
        case .learning:
            setUpRecording()
        case.music:
            break
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    /**
        Record function area
     
     */
    
    func setUpRecording(){
        recordingSession = AVAudioSession.sharedInstance()
        do {
            try recordingSession.setCategory(AVAudioSessionCategoryRecord)
            try recordingSession.setActive(true)
            recordingSession.requestRecordPermission({ (allowed) in
                DispatchQueue.main.async {
                    if allowed {
                        self.btnRecord.isHidden = false
                        self.btnPlayRecord.isHidden = false
                        self.btnRecord.addTarget(self, action: #selector(self.goRecord), for: .touchUpInside)
                    }else {
                        self.btnRecord.isHidden = true
                        Toast(text: "Need permisson to record").show()
                    }
                }
                
            })
        }catch {
            btnRecord.isHidden = true
            // failed to record!
        }
    }
    
    /**
     Handle when click to record
    */
    func goRecord() {
        switch recordStatus {
        case .stop:
            startRecording()
            btnRecord.setImage(UIImage(named: "stop"), for: .normal)
            recordStatus = .recording
        case .recording:
            stopRecording()
            btnRecord.setImage(UIImage(named: "record"), for: .normal)
            recordStatus = .stop
        default:
            break
        }
    }
    /**
     Start record, you can speak now
    */
    func startRecording(){
        pause(type: .audio)
        if audioFileName == nil {
            if let name = router.getListening()?.name{
                audioFileName = getDirectory().appendingPathComponent(name + "+.caf")
            }else{
                audioFileName = getDirectory().appendingPathComponent("temp.caf")
            }
        }
        
        
        let settings = [AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                        AVSampleRateKey: 12000,
                        AVNumberOfChannelsKey: 1,
                        AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue]
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryRecord)
            try AVAudioSession.sharedInstance().setActive(true)
            if audioRecorder == nil{
                audioRecorder = try AVAudioRecorder(url: audioFileName!, settings: settings)
                audioRecorder?.prepareToRecord()
                audioRecorder?.delegate = self
            }
            audioRecorder?.record()
            
        } catch {
            btnRecord.isHidden = true
        }
    }
    
    /**
     Oh It's stop now, whatever you say will not record
    */
    func stopRecording() {
        if audioRecorder != nil {
            audioRecorder?.stop()
            setRecordURL(url: audioFileName!)
            guard let url = recordURL else {
                return
            }
            setAudioRecorder(url: url)
        }else{
            btnRecord.isHidden = true
        }
    }
    
    /**
     Get the base document directory in sandbox
     
     - returns: Return the url of directory
     
     */
    func getDirectory() -> URL {
        let path = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let musicDir = path[0]
        return musicDir
    }
    /*
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
    override func willMove(toParentViewController parent: UIViewController?) {
        super.willMove(toParentViewController: parent)
        pause(type: .audio)
        pause(type: .record)
    }
    /**
     Set audio url for media player
     
     - parameter url: The `url` will set for audio
    */
    func setAudio(url: URL) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            btnControl.setImage(UIImage.init(named: "play"), for: .normal)
            self.audioSlider.value = 0
            self.audioPlayer = try AVAudioPlayer(contentsOf: url)
            self.audioPlayer.volume = 1.0
            self.audioPlayer.delegate = self
            self.audioSlider.maximumValue = Float(self.audioPlayer.duration * 10)
            self.cdImage.removeRotateImage()
        } catch let error as NSError {
            print(error.localizedDescription)
            view.isUserInteractionEnabled = true
        } catch {
            print("AVAudioPlayer init failed")
            view.isUserInteractionEnabled = true
        }
    }
    
    func setAudioRecorder(url: URL) {
        do {
            try AVAudioSession.sharedInstance().setCategory(AVAudioSessionCategoryPlayback)
            try AVAudioSession.sharedInstance().setActive(true)
            btnPlayRecord.setImage(UIImage.init(named: "play"), for: .normal)
            self.recordPlayer = try AVAudioPlayer.init(contentsOf: url)
            self.recordPlayer.volume = 1.0
            self.recordPlayer.delegate = self
            self.cdImage.removeRotateImage()
        } catch let error as NSError {
            print(error.localizedDescription)
            view.isUserInteractionEnabled = true
        } catch {
            print("AVAudioPlayer init failed")
            view.isUserInteractionEnabled = true
        }
    }
    
    func showError(message: String) {
        Toast(text: message).show()
    }
    
    func setTranscript(url: URL) {
        if subURL == nil{
            subURL = url
        }
        do {
            content = try String(contentsOf: url, encoding: .utf8)
        } catch{
            
        }
    }
    
    func setRunningSubURL(url: URL) {
        if runningSub == nil {
            runningSub = url
        }
        do {
            let lyricContent = try String(contentsOf: url, encoding: .utf8)
            lyric =  lyricParser?.lyricFromLRCString(lyricContent)
        } catch {
            print(error.localizedDescription)
        }
        
        if let lyric = self.lyric, self.lyric?.content != nil {
            timingKeys = Array(lyric.content!.keys).sorted(by: <)
        }
        DispatchQueue.main.async {
            self.lyricPlayer.dataSource = self
            self.lyricPlayer.prepareToPlay()
        }
        
        
    }
    /**
     Set data for this screen
     
    */
    func setDataModel(data: Listening?) {
        router.setListening(data: data)
    }
    
    func setUp() {
        let controller = self
        let presenter = ListeningPresenter()
        let interactor = ListeningInteractor()
        let router = ListeningRouter()
        
        controller.presenter = presenter
        presenter.view = controller
        presenter.interactor = interactor
        controller.router = router
        
    }
    
    func play(type: PlayingStatus) {
        switch type {
        case .audio:
            if audioPlayer != nil{
                let playSuccess = audioPlayer.play()
                if playSuccess{
                    lyricPlayer.start()
                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
                    
                    btnControl.setImage(UIImage.init(named: "pause"), for: .normal)
                    cdImage.rotateImage()
                }else {
                    Toast(text: "Can't play").show()
                }
            }
        case .record:
            if recordPlayer != nil{
                let playSuccess = recordPlayer.play()
                if playSuccess{
                    //                    self.timer = Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.tick), userInfo: nil, repeats: true)
                    btnPlayRecord.setImage(UIImage.init(named: "pause"), for: .normal)
                    //                    cdImage.rotateImage()
                }else {
                    Toast(text: "Can't play").show()
                }
            }
        }
    }
    
    func pause(type: PlayingStatus) {
        switch type {
        case .audio:
            if audioPlayer != nil {
                audioPlayer.pause()
                lyricPlayer.pause()
                btnControl.setImage(UIImage.init(named: "play"), for: .normal)
                if timer != nil {
                    timer?.invalidate()
                }
                cdImage.pauseRotateImage()
            }
            
        case .record:
            if recordPlayer != nil {
                recordPlayer.pause()
                btnPlayRecord.setImage(UIImage.init(named: "play"), for: .normal)
            }
        }
    }
    
    func tick() {
        audioSlider.setValue(Float(audioPlayer.currentTime * 10), animated: true)
    }
    
    func setAudioURL(url: URL) {
        DispatchQueue.main.async {
            self.activityIndicatorView?.stopAnimating()
        }
        self.view.isUserInteractionEnabled = true
        audioURL = url
        
    }
    func setRecordURL(url: URL) {
        self.view.isUserInteractionEnabled = true
        recordURL = url
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        if player.isEqual(audioPlayer){
            if flag {
                cdImage.removeRotateImage()
                btnControl.setImage(UIImage.init(named: "play"), for: .normal)
                timer?.invalidate()
            }else {
                btnControl.setImage(UIImage.init(named: "play"), for: .normal)
                timer?.invalidate()
            }
        }
        if player.isEqual(recordPlayer){
            if flag {
                //                cdImage.removeRotateImage()
                btnPlayRecord.setImage(UIImage.init(named: "play"), for: .normal)
                //                timer?.invalidate()
            }else {
                btnPlayRecord.setImage(UIImage.init(named: "play"), for: .normal)
                //                timer?.invalidate()
            }
        }
        
    }
    
    func audioRecorderDidFinishRecording(_ recorder: AVAudioRecorder, successfully flag: Bool) {
        lyricPlayer.stop()
    }
}

extension ListeningController: VTLyricPlayerViewDataSource {
    
    func timesForLyricPlayerView(_ playerView: VTKaraokeLyricPlayerView) -> Array<CGFloat> {
        return timingKeys
    }
    
    func lyricPlayerView(_ playerView: VTKaraokeLyricPlayerView, atIndex:NSInteger) -> VTKaraokeLyricLabel {
        
        let lyricLabel          = playerView.reuseLyricView()
        lyricLabel.textColor    = UIColor(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0)
        lyricLabel.fillTextColor = UIColor.orange
        lyricLabel.font         = UIFont(name: "HelveticaNeue-Bold", size: 12.0)
        
        let key = timingKeys[atIndex]
        
        lyricLabel.text = self.lyric?.content![key]
        return lyricLabel
    }
    
    func lyricPlayerView(_ playerView: VTKaraokeLyricPlayerView, allowLyricAnimationAtIndex: NSInteger) -> Bool {
        return true
    }
}


