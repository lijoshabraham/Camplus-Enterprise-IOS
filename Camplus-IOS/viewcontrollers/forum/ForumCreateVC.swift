//
//  ForumCtreateVC.swift
//  Camplus-IOS
//
//  Created by yadhukrishnan E on 11/04/20.
//  Copyright © 2020 Yadhukrishnan Ekambaran. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class ForumCreateVC: UIViewController {

    @IBOutlet weak var tfTitle: UITextField!
    @IBOutlet weak var tvDescription: UITextView!
    @IBOutlet weak var cvCategory: UICollectionView!
    @IBOutlet weak var btnSubmit: UIButton!
    
    var interactionDelegate: InteractionDelegate!
    
    var categories: [Category] = []
    
    var forum: Forum!
    
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupTextView()
        setupSubmit()
        getCategoriesFromDB()
    }
    
    func setupColletionView() {
        cvCategory.delegate = self
        cvCategory.dataSource = self
        tvDescription.delegate = self
    }
    
    func setupSubmit() {
        btnSubmit.layer.cornerRadius = 4
    }
    
    func setupTextView() {
        tvDescription.layer.borderColor = UIColor(hexa: "#00000017")?.cgColor
        tvDescription.layer.borderWidth = 0.4
        tvDescription.layer.cornerRadius = 4
    }

    func getCategoriesFromDB() {
        let dbService = FirestoreService()
        dbService.getForumCategories(serviceId: FirestoreService.SERVICE_ID_GET_CATEGORIES, self);
    }
    
    @IBAction func onSubmitClicked(_ sender: Any) {
        if !validateData() {
            let alert = AlertControler.showOKAlert(message: "You need to fill all the fields")
            self.present(alert, animated: true) {
                
            }
            return
        }
        
        let title = tfTitle.text
        let description = tvDescription.text
        let categories = getCategories()
        
        forum = Forum()
        forum.title = title
        forum.description = description
        forum.categories = categories
        forum.timestamp = Date().millisecondsSince1970
        forum.user_id = appDelegate.userDetails.userId!
        forum.user_name = appDelegate.userDetails.userName
        
        let firestoreService = FirestoreService()
        firestoreService.sendForumToDB(serviceId: FirestoreService.SERVICE_ID_CREATE_FORUM, forum: forum, firebaseDelegate: self)
    }
    
    func getCategories() -> [String] {
        var catArray: [String] = []
        for category in categories {
            if (category.selectStatus == true) {
                catArray.append(category.title)
            }
        }
        
        return catArray
    }
    
    func validateData() -> Bool {
        let title = tfTitle.text
        let description = tvDescription.text
        let categories = getCategories()
        
        if let title = title, title.count > 0, let desc = description, desc.count > 0, categories.count > 0 {
            return true
        } else {
            return false
        }
    }
}

extension ForumCreateVC: UICollectionViewDataSource, UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        categories.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let category = categories[indexPath.row]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "cell_category", for: indexPath) as! ForumCategoryCell
        cell.setCategory(category: category)
        return cell;
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let cell = collectionView.cellForItem(at: indexPath) as! ForumCategoryCell
        cell.itemSelected(categories[indexPath.row])
    }
}

extension ForumCreateVC: FirebaseDelegate {
    
    func writingFailed(serviceID: Int) {
        print("------------ ForumCreateVC -- writingFailed -----------")
    }
    
    func wrote(serviceID: Int, docId: String) {
        print("------------ ForumCreateVC -- wrote -----------")
        self.forum.id = docId
        self.interactionDelegate.itemAdded(item: self.forum)
        self.navigationController?.popViewController(animated: true)
    }
    
    func readingFailed(serviceID: Int) {
        print("------------ ForumCreateVC -- readingFailed -----------")
    }
    
    func read(serviceID: Int, data: NSObject) {
        print("------------ ForumCreateVC -- read -----------")
        categories = data as! [Category]
        setupColletionView()
    }
}

extension ForumCreateVC: UITextViewDelegate {
    
    func textViewDidBeginEditing(_ textView: UITextView) {
        let description = textView.text!
        if (description == "Description") {
            textView.text = ""
            textView.textColor = UIColor.black
        }
    }
    
}


