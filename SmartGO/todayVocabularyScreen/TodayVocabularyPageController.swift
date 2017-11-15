//
//  TodayVocabularyPageController.swift
//  SmartGO
//
//  Created by thanh tuan on 8/8/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit
protocol TodayVocabularyPageControllerInput {
    func setTodayVocabularyData(data: TodayVocabularyDTO)
}

class TodayVocabularyPageController: UIPageViewController,TodayVocabularyPageControllerInput {
    var todayVocabularyDTO: TodayVocabularyDTO?
    var presenter: TodayVocabularyPresenterInput!
    var router: TodayVocabularyRouterInput!
    var loadedController: [UIViewController] = []
    var linkTopicToday: String!
    var currentLesson = 0
    override func viewDidLoad() {
        super.viewDidLoad()
        setUp()
        dataSource = self
        presenter.getTopicToday(link: linkTopicToday)
        
        // Do any additional setup after loading the view.
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
    
    func setUp() {
        let nodataController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "loadingController")
        setViewControllers([nodataController], direction: .forward, animated: true, completion: nil)
        let controller = self
        let presenter = TodayVocabularyPresenter()
        let interactor = TodayVocabularyInteractor()
        let router = TodayVocabularyRouter()
        
        controller.presenter = presenter
        presenter.view = controller
        presenter.interactor = interactor
        controller.router = router
    }
    
    func setTodayVocabularyData(data: TodayVocabularyDTO) {
        self.todayVocabularyDTO = data
        currentLesson = 0
        guard todayVocabularyDTO?.listOfToday != nil && (todayVocabularyDTO?.listOfToday.count)! > 0 else {
            return
        }
        
        let currentTodayVocabularyController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vocabularyController") as! TodayVocabularyController
        currentTodayVocabularyController.todayVocabularyObject = todayVocabularyDTO?.listOfToday[currentLesson]
        currentTodayVocabularyController.currentIndex = 0
        currentTodayVocabularyController.numberOfPage = todayVocabularyDTO?.listOfToday.count
        loadedController.append(currentTodayVocabularyController)
        setViewControllers([currentTodayVocabularyController], direction: .forward, animated: true, completion: nil)
        
    }

}

extension TodayVocabularyPageController: UIPageViewControllerDataSource{
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        currentLesson = (viewController as! TodayVocabularyController).currentIndex
        if currentLesson == 0{
            return nil
        }else {
            guard todayVocabularyDTO?.listOfToday != nil && (todayVocabularyDTO?.listOfToday.count)! > 1 else {
                return nil
            }
            return loadedController[currentLesson - 1]
        }
    }
    
    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
           currentLesson = (viewController as! TodayVocabularyController).currentIndex
        if currentLesson == (todayVocabularyDTO?.listOfToday.count)! - 1{
            return nil
        }else {
            guard todayVocabularyDTO?.listOfToday != nil && (todayVocabularyDTO?.listOfToday.count)! > 1 else {
                return nil
            }
            
            if loadedController.count - 1 > currentLesson{
                return loadedController[currentLesson + 1]
            }else {
                let todayVocabularyController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "vocabularyController") as! TodayVocabularyController
                todayVocabularyController.todayVocabularyObject = todayVocabularyDTO?.listOfToday[currentLesson + 1]
                todayVocabularyController.currentIndex = currentLesson + 1
                todayVocabularyController.numberOfPage = todayVocabularyDTO?.listOfToday.count
                loadedController.append(todayVocabularyController)
                return todayVocabularyController
            }
            
        }
    }
    
}
