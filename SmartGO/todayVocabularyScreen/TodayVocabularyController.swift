//
//  TodayVocabularyController.swift
//  SmartGO
//
//  Created by thanh tuan on 8/7/17.
//  Copyright © 2017 thanh tuan. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseStorage
import Toaster

class TodayVocabularyController: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{
    
    
    var todayVocabularyObject:TodayVocabularyObject!
    var currentIndex: Int!
    var numberOfPage: Int!
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    @IBOutlet weak var lblKeyword: UITextView!
    
    @IBOutlet weak var lblSpeech: UILabel!
    
    @IBOutlet weak var pageControl: UIPageControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadDataView()
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
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return 4
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell =  collectionView.dequeueReusableCell(withReuseIdentifier: "todayCell", for: indexPath) as! TodayVocabularyCell
        if let imgURL = todayVocabularyObject.answer[indexPath.row].imageURL{
            let store = Storage.storage()
            let storeRef = store.reference(forURL: imgURL)
            storeRef.getData(maxSize: 1 * 1024 * 1024, completion: { (data, error) in
                if let error = error {
                    Toast(text: error.localizedDescription).show()
                } else {
                    // Data for "images/island.jpg" is returned
                    let image = UIImage(data: data!)
                    cell.answerImage.image = image
                    cell.answerImage.contentMode = .scaleAspectFit
                }
            })
        }
        
        if let describe = todayVocabularyObject.answer[indexPath.row].describe{
            cell.lblDescribe.text = describe
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.row == ((todayVocabularyObject.correctAnswer)! - 1) {
            let alert = UIAlertController(title: "Congratulation", message: "Correct answer", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Yeah", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }else {
            let alert = UIAlertController(title: "Oh no", message: "Wrong answer", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Try later", style: UIAlertActionStyle.default, handler: nil))
            self.present(alert, animated: true, completion: nil)
        }
    }
    
    
    func loadDataView(){
        pageControl.numberOfPages = numberOfPage
        pageControl.currentPage = currentIndex
        if let keyword = todayVocabularyObject.keyWord{
            lblKeyword.text = keyword
        }
        
        if let speech = todayVocabularyObject.speech{
            lblSpeech.text = speech
        }
        collectionView.reloadData()
    }
}
