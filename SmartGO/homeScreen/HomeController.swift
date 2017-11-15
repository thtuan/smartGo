//
//  HomeController.swift
//  SmartGO
//
//  Created by thanh tuan on 8/8/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit
import FirebaseStorage
import Toaster
import NVActivityIndicatorView
import RxSwift
import RxCocoa

protocol HomeControllerInput {
    func loadDataTopicView(data: TodayVocabularyTopic?)
    func loadOutstandingData(data: [Listening])
}
class HomeController: UIViewController, HomeControllerInput, UITableViewDataSource, UITableViewDelegate{
    var homeLoading:NVActivityIndicatorView!
    var presenter: HomePresenterInput!
    
    var store: Storage!
    var router: HomeRouterInput!
    var currentIndex = 0
    var imageData: [Data] = []
    
    var dataTopic: TodayVocabularyTopic?
    var outstandingData: [Listening] = []
    //    var outstandingImageData: [Data] = []
    
    @IBOutlet var contentViewHeight: NSLayoutConstraint!
    @IBOutlet var outstandingTableHeight: NSLayoutConstraint!
    
    @IBOutlet weak var outstandingTableView: UITableView!
    
    @IBOutlet weak var imageTopicVocabulary: UIImageView!
    
    @IBOutlet weak var lblTodayVocabularyName: UILabel!
    
    @IBOutlet var contentHeightConstrant: NSLayoutConstraint!
    
    @IBOutlet var scrollview: UIScrollView!
    
    @IBOutlet weak var lblDescribe: UILabel!
    
    @IBOutlet weak var imageTodayType: UIImageView!
    
    @IBOutlet weak var homeContentView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        store = Storage.storage()
        homeLoading = rootActivityIndicatorView
        homeLoading.startAnimating()
        presenter.getTodayTopic()
        presenter.getOutstanding()
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "learnLesson"{
            //            let listeningVC = segue.destination as! ListeningController
            //            let indexPath = tableView.indexPathForSelectedRow
            //            if let index = indexPath {
            //                router?.navigationTo(source: self, destination: listeningVC, listening: lessonList[index.row])
            //                tableView.deselectRow(at: index, animated: true)
        }else if segue.identifier == "todayVocabulary"{
            let todayController = segue.destination as! TodayVocabularyPageController
            todayController.linkTopicToday = dataTopic?.link
        }else if segue.identifier == "outstandingSeque"{
            let listeningVC = segue.destination as! ListeningController
            let indexPath = outstandingTableView.indexPathForSelectedRow
            if let index = indexPath {
                listeningVC.router.setListening(data: outstandingData[index.row])
                outstandingTableView.deselectRow(at: index, animated: true)
            }
        }
        
        
    }
    
    
    func setUp() {
        let controller = self
        let presenter = HomePresenter()
        let interactor = HomeInteractor()
        let router = HomeRouter()
        
        controller.presenter = presenter
        presenter.view = controller
        presenter.interactor = interactor
        controller.router = router
    }
    
    func loadDataTopicView(data: TodayVocabularyTopic?) {
        
        self.dataTopic = data
        for imageURL in (data?.imageURL)!{
            
            let store = Storage.storage()
            let storeRef = store.reference(forURL: imageURL)
            storeRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                if let error = error {
                    Toast(text: error.localizedDescription).show()
                } else {
                    // Data for "images/island.jpg" is returned
                    self.imageData.append(data!)
                    
                }
            })
        }
        if let name = data?.name{
            self.lblTodayVocabularyName.text = name
        }
        if let describe = data?.describe{
            self.lblDescribe.text = describe
        }
        if data?.type == .hot{
            self.imageTodayType.image = UIImage(named: "hot")
            self.imageTodayType.isHidden = false
        }else if data?.type == .new{
            self.imageTodayType.image = UIImage(named: "new")
            self.imageTodayType.isHidden = false
        }else {
            self.imageTodayType.isHidden = true
        }
        setSlideImage()
        homeLoading.stopAnimating()
        homeContentView.isHidden = false
    }

    func loadOutstandingData(data: [Listening]) {
        self.outstandingData = data
        outstandingTableView.reloadData()
        outstandingTableView.layoutIfNeeded()
        
        outstandingTableHeight.constant = outstandingTableView.contentSize.height
        contentHeightConstrant.constant = 180 + 180 + outstandingTableView.contentSize.height
    }
    func adjustHeigtTable(){
        var height = self.outstandingTableView.contentSize.height
        let maxHeight = (self.outstandingTableView.superview?.frame.size.height)! - self.outstandingTableView.frame.origin.y
        
        // if the height of the content is greater than the maxHeight of
        // total space on the screen, limit the height to the size of the
        // superview.
        
        if (height > maxHeight){
            height = maxHeight;
        }
        
        // now set the frame accordingly
        UIView.animate(withDuration: 0.25, animations: { 
            var frame = self.outstandingTableView.frame
            frame.size.height = height
            self.outstandingTableView.frame = frame
        }, completion: nil)
        
        
        // if you have other controls that should be resized/moved to accommodate
        // the resized tableview, do that here, too
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return outstandingData.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "outstandingLessonCell", for: indexPath) as! OutstandingLessonCell
        cell.btnInfor.tag = indexPath.row
        if let name = outstandingData[indexPath.row].name {
            cell.lblNameOutstanding.text = name
        }
        
        if let describe = outstandingData[indexPath.row].describe {
            cell.lblDescribe.text = describe
        }
        if let imgURL = outstandingData[indexPath.row].urlImage{
            let storeRef = store.reference(forURL: imgURL)
            storeRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                if let error = error {
                    Toast(text: error.localizedDescription).show()
                } else {
                    let image = UIImage(data: data!)
                    cell.imageOutstanding.image = image
                }
            })
        }else {
            
        }
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "outstandingSeque", sender: nil)
    }
    @IBAction func showInforClick(_ sender: UIButton) {
//        let popover = self.storyboard?.instantiateViewController(withIdentifier: "popoverController") as! InformationPopoverController
////        popover.preferredContentSize = CGSize(width: UIScreen.main.bounds.width - 100, height: 100)
//        popover.modalPresentationStyle = .overCurrentContext
//        popover.infor = "hahaha"
        guard let name = outstandingData[sender.tag].name, let describe = outstandingData[sender.tag].describe else {
            return
        }
        
        let alertController = UIAlertController(title: name, message: describe, preferredStyle: UIAlertControllerStyle.actionSheet)
        let okAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: {(alert :UIAlertAction!) in
//            alertController.dismiss(animated: true, completion: nil)
        })
            alertController.addAction(okAction)
        alertController.popoverPresentationController?.sourceView = view
        alertController.popoverPresentationController?.sourceRect = sender.frame
        self.present(alertController, animated: true, completion: nil)
    }
    
}

extension HomeController{
    func setSlideImage(){
        Timer.scheduledTimer(timeInterval: 3, target: self, selector: #selector(self.changeSlide), userInfo: nil, repeats: true)
    }
    
    func changeSlide(){
        if imageData.count > 0 {
            let image = UIImage(data: imageData[currentIndex])
            UIView.transition(with: self.imageTopicVocabulary,
                              duration:0.5,
                              options: .transitionCrossDissolve,
                              animations: { self.imageTopicVocabulary.image = image },
                              completion: nil)
            //            self.imageTopicVocabulary.image = image
            if currentIndex >= imageData.count - 1{
                currentIndex = 0
            }else {
                currentIndex += 1
            }
        }
    }
}


