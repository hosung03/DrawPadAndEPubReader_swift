//
//  ViewController.swift
//  DrawPadAndEPubReader
//
//  Created by Hosung, Lee on 2017. 6. 7..
//  Copyright © 2017년 hosung. All rights reserved.
//

import UIKit
import Material
import RealmSwift

class ListItem {
    var title : String?
    
    init(title : String) {
        self.title = title
    }
}

class EPubItem : ListItem {
    var filename : String?
    var img : String?
    
    init(title : String, filename : String, img : String) {
        super.init(title: title)
        self.filename = filename
        self.img = img
    }
}

class DrawNoteItem : ListItem {
    var noteid : Int?
    
    init(title : String, noteid : Int) {
        super.init(title: title)
        self.noteid = noteid
    }
}


class ViewController:  UIViewController {
    fileprivate var collectionView: UICollectionView!
    
    static let serverURL: String = "127.0.0.1"
    static let realmID:String = "demo@localhost.io"
    static let realmPasswd:String = "demo1234"
    
    static let syncServerURL = URL(string: "realm://\(serverURL):9080/~/DrawPad")!
    static let syncAuthURL = URL(string: "http://\(serverURL):9080")!
    
    static let DEFAULT_USER_NAME = "test"
    static let DEFAULT_USER_EMAIL = "test@localhost.io"
    static let DEFAULT_USER_PASSWORD = "1234"
    
    static let DEFAULT_NOTE_TITLE = "New Note"
    
    static var isSynced:Bool = false
    static var userEmail:String? = nil
    
    var isLoad:Bool = false
    var isViewMenu:Bool = false
    
    fileprivate var epublist = [EPubItem]()
    fileprivate var drawnotlist = [DrawNoteItem]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if ViewController.userEmail == nil {
            self.performSegue(withIdentifier: "goLogin", sender: self)
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if ViewController.userEmail != nil {
            if !isLoad {
                getEPubList()
                getDrawNotesList()
                prepareCollectionView()
                isLoad = true
            } else {
                self.epublist.removeAll()
                self.drawnotlist.removeAll()
                getEPubList()
                getDrawNotesList()
                collectionView.reloadData()
            }
        }
    }
    
    public func goDrawPadViewController(no:Int) {
        self.performSegue(withIdentifier: "goDrawPad", sender: no)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "goDrawPad" {
            let drawpadViewController = segue.destination as! DrawPadViewController
            drawpadViewController.currentNoteId = sender as! Int
        }
    }
    
    public static func showAlert(viewcontroller: UIViewController, title: String, message: String) {
        DispatchQueue.main.async {
            let controller = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let action = UIAlertAction(title: "Close", style: UIAlertActionStyle.default)
            controller.addAction(action)
            viewcontroller.present(controller, animated: true, completion: nil)
        }
    }
    
    public static func createInitialDataIfNeeded(){
        let realm = try! Realm()
        if realm.isEmpty {
            try! realm.write {
                let userProfile = UserProfile()
                userProfile.id = 1
                userProfile.name = ViewController.DEFAULT_USER_NAME
                userProfile.email = ViewController.DEFAULT_USER_EMAIL
                userProfile.passwd = ViewController.DEFAULT_USER_PASSWORD
                realm.add(userProfile)
                
                let drawNote = DrawNote()
                drawNote.id = 1
                drawNote.saved = true
                drawNote.user = ViewController.DEFAULT_USER_EMAIL
                drawNote.title = "welcome"
                realm.add(drawNote)
            }
        }
    }
}


extension ViewController {
    fileprivate func getEPubList(){
        if let list = Bundle.main.path(forResource: "EPubList", ofType: "plist") {
            let list = (NSArray(contentsOfFile: list) as! [String])
            list.forEach { item in
                let item_content = item.components(separatedBy: "|")
                if item_content.count == 3 {
                    let epubitem = EPubItem.init(title: item_content[0], filename: item_content[1], img: item_content[2])
                    self.epublist.append(epubitem)
                }
            }
        }
    }
    
    func getDrawNotesList() {
        let realm = try! Realm()
        
        let predicate = NSPredicate(format: "user = %@ and saved = true", ViewController.userEmail!)
        let results = realm.objects(DrawNote.self).filter(predicate)
        
        results.forEach { drawnote in
            if(drawnote.title == nil) {
                drawnote.title = "unknow note"
            }
            let drawnoteitem = DrawNoteItem.init(title: (drawnote.title)!, noteid: drawnote.id )
            self.drawnotlist.append(drawnoteitem)
        }
    }
    
    fileprivate func prepareCollectionView() {
        let columns: CGFloat = 2
        let w: CGFloat = (view.bounds.width - 30) / columns
        
        let layout = UICollectionViewFlowLayout()
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 10
        let edge = UIEdgeInsetsMake(10, 10, 10, 10)
        layout.sectionInset = edge
        layout.scrollDirection = .vertical
        layout.itemSize = CGSize(width: w, height: w)
        layout.headerReferenceSize = CGSize(width: view.frame.size.width, height: 50)
        
        collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(CollectionViewCell.self, forCellWithReuseIdentifier: "CollectionViewCell")
        collectionView.register(CollectionViewHeader.self, forSupplementaryViewOfKind: UICollectionElementKindSectionHeader, withReuseIdentifier: "CollectionViewHeader")
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        view.layout(collectionView).edges()
        collectionView.reloadData()
    }
}


extension ViewController: UICollectionViewDataSource {
    @objc
    open func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 2
    }
    
    @objc
    open func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if section == 0 {
            return self.epublist.count
        } else {
            return self.drawnotlist.count
        }
    }
    
    @objc
    open func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "CollectionViewCell", for: indexPath) as! CollectionViewCell
        if indexPath.section == 0 {
            cell.populateCell(self.epublist[indexPath.item].title!,imageName: UIImage(named: self.epublist[indexPath.item].img!)!)
        } else {
            cell.populateCell(self.drawnotlist[indexPath.item].title!, imageName: UIImage(named: "ic_pen_128")!)
        }
        cell.imageView.contentMode = .scaleToFill
        return cell
    }
    
}

extension ViewController: UICollectionViewDelegate {
    @objc
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if indexPath.section == 0 {
            print("epub selected")
        } else {
            print("drawpad selected")
            goDrawPadViewController(no: self.drawnotlist[indexPath.item].noteid!)
        }
    }
    
    @objc
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        var reusableView : UICollectionReusableView? = nil
        
        if (kind == UICollectionElementKindSectionHeader) {
            let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "CollectionViewHeader", for: indexPath) as! CollectionViewHeader
            
            if indexPath.section == 0 {
                headerView.title?.text = "EPub List"
                headerView.addButton?.isHidden = true
            } else if indexPath.section == 1 {
                headerView.title?.text = "DrawNote List"
                headerView.addButton?.isHidden = false
                headerView.setVC(vc: self)
            }
            
            reusableView = headerView
        }
        return reusableView!
    }
}

