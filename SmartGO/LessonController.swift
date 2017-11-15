//
//  LessonController.swift
//  SmartGO
//
//  Created by thanh tuan on 7/14/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit
import FirebaseStorage
import Toaster
import NVActivityIndicatorView
import GKFadeNavigationController

protocol LessonControllerInput {
    func setDataModel(listeningList: [Listening])
    func setView(listeningList: [Listening])
}

class LessonController: UIViewController, UITableViewDataSource, UITableViewDelegate, LessonControllerInput {
    
//    var navigationBarVisibility: GKFadeNavigationControllerNavigationBarVisibility?
//    var gkNavigationController: GKFadeNavigationController?
    
    var activityIndicatorView: NVActivityIndicatorView?
    var linkAudio: String!
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var imageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var imageBotConstraint: NSLayoutConstraint!
    
    var router: LessonRouterInput?
    var presenter: LessonPresenter?
    
    var lessonList: [Listening] = []
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
//        navigationBarVisibility = .hidden
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
//        navigationBarVisibility = .hidden
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        gkNavigationController = navigationController as? GKFadeNavigationController
//        gkNavigationController?.setNeedsNavigationBarVisibilityUpdate(animated: false)
        setUp()
        presenter?.getLessonList(link: linkAudio)
        let x = self.tableView.center.x - 20
        let y = self.tableView.center.y - 100
        let frame = CGRect(x: x, y: y, width: 40, height: 40)
        activityIndicatorView = NVActivityIndicatorView(frame: frame, type: .ballClipRotate, color: UIColor.init(red: 52/255, green: 152/255, blue: 219/255, alpha: 1.0), padding: CGFloat(0))
        self.tableView.addSubview(activityIndicatorView!)
        activityIndicatorView?.startAnimating()
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setDataModel(listeningList: [Listening]) {
        
    }
    
    func setView(listeningList: [Listening]) {
        self.lessonList = listeningList
        tableView.reloadData()
        activityIndicatorView?.stopAnimating()
        
    }
    
    func setUp() {
        let controller = self
        let presenter = LessonPresenter()
        let interactor = LessonInteractor()
        let router = LessonRouter()
        
        controller.presenter = presenter
        presenter.view = controller
        presenter.interactor = interactor
        controller.router = router
    }
    
    
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destinationViewController.
     // Pass the selected object to the new view controller.
        if segue.identifier == "lessonSeque"{
            let listeningVC = segue.destination as! ListeningController
            let indexPath = tableView.indexPathForSelectedRow
            if let index = indexPath {
                router?.navigationTo(source: self, destination: listeningVC, listening: lessonList[index.row])
                tableView.deselectRow(at: index, animated: true)
            }
        }
        
     }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lessonList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "LessonCell", for: indexPath) as! LessonViewCell
        
        if let name = lessonList[indexPath.row].name{
            cell.lblLesson.text = name
        }
        
        if let description = lessonList[indexPath.row].describe{
            cell.lblDescription.text = description
        }
        if let imgURL = lessonList[indexPath.row].urlImage{
            let store = Storage.storage()
            let storeRef = store.reference(forURL: imgURL)
            storeRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                if let error = error {
                    Toast(text: error.localizedDescription).show()
                } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)
                    cell.imgLesson.image = image
                    cell.imgLesson.contentMode = .scaleAspectFit
                }
            })
        }
        
        return cell
    }
    
    func tableView(_ tableView1: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: "lessonSeque", sender: self)
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

//extension LessonController: GKFadeNavigationControllerDelegate{
//    func preferredNavigationBarVisibility() -> GKFadeNavigationControllerNavigationBarVisibility {
//        return self.navigationBarVisibility!
//    }
//    
//    func setNavigationBarVisibility(navigationBarVisibility: GKFadeNavigationControllerNavigationBarVisibility) {
//        if (self.navigationBarVisibility != navigationBarVisibility) {
//            // Set the value
//            self.navigationBarVisibility = navigationBarVisibility;
//            
//            // Play the change
//            let navigationController = self.navigationController as! GKFadeNavigationController;
//            if ((navigationController.topViewController) != nil) {
//                navigationController.setNeedsNavigationBarVisibilityUpdate(animated: true)
//            }
//        }
//    }
//    
//}

//extension LessonController: UIScrollViewDelegate{
//    var kGKHeaderHeightL: CGFloat!{
//        get {
//            return CGFloat(150)
//        }
//    }
//    var kGKHeaderVisibleThreshold: CGFloat!{
//        get{
//           return CGFloat(44.0)
//        }
//    }
//    var kGKNavbarHeight: CGFloat!{
//        get{
//            return CGFloat(64.0)
//        }
//    }
//    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        let scrollOffsetY = kGKHeaderHeightL - scrollView.contentOffset.y
//        
//        if (scrollOffsetY > kGKHeaderHeightL) {
//            self.imageTopConstraint.constant = kGKHeaderHeightL-scrollOffsetY
//        } else {
//            self.imageTopConstraint.constant = (kGKHeaderHeightL-scrollOffsetY)/2.0
//            self.imageBotConstraint.constant = -(kGKHeaderHeightL-scrollOffsetY)/2.0
//        }
//        
//        if (scrollOffsetY-kGKNavbarHeight < kGKHeaderVisibleThreshold) {
//            self.setNavigationBarVisibility(navigationBarVisibility: .visible)
//        } else {
//            self.setNavigationBarVisibility(navigationBarVisibility: .hidden)
//        }
//    }
//    
//    override func viewDidAppear(_ animated: Bool) {
//        super.viewDidAppear(animated)
//        navigationController?.setNeedsStatusBarAppearanceUpdate()
//    }
//}
