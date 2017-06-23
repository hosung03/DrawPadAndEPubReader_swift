//
//  DrawPadViewController.swift
//  DrawPadAndEPubReader
//
//  Created by mac on 2017. 6. 14..
//  Copyright © 2017년 hosung. All rights reserved.
//
import UIKit
import RealmSwift

class DrawPadViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    public var currentNoteId:Int = 0
    public var currentNote:DrawNote?
    public var currentDrawpath:Results<DrawPath>?
    
    var notificationToken: NotificationToken? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("currentNoteId: \(currentNoteId)")
        
        let realm = try! Realm()
        if (currentNoteId>0){
            let predicate = NSPredicate(format: "id = %d", currentNoteId)
            currentNote = ((realm.objects(DrawNote.self).filter(predicate).first)!)
        } else {
            
        }
        
        if currentNote==nil {
            return
        }
        
        notificationToken = currentNote?.paths.addNotificationBlock { [weak self] (changes: RealmCollectionChange) in
            let drawpadview : DrawPadView? = self?.view as? DrawPadView
            if drawpadview != nil {
                print("notification")
                if self?.currentNote?.paths.count != 0 {
                    drawpadview?.setNeedsDisplay()
                } else {
                    drawpadview?.clearCanvas()
                }
            }
        }
        
        let drawpadview : DrawPadView? = self.view as? DrawPadView
        if drawpadview != nil {
            drawpadview?.currentNote = currentNote
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        let realm = try! Realm()
        let predicate = NSPredicate(format: "id = %d", currentNoteId)
        let drawnote = realm.objects(DrawNote.self).filter(predicate).first
        if drawnote != nil {
            let result = drawnote?.paths.filter("TRUEPREDICATE")
            result?.forEach { drawpath in
                if drawpath.saved == false {
                    drawpath.points.forEach { point in
                        try! realm.write {
                            realm.delete(point)
                        }
                    }
                    try! realm.write {
                        realm.delete(drawpath)
                    }
                }
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "popoverSegue" {
            segue.destination.modalPresentationStyle = .popover
            segue.destination.popoverPresentationController?.delegate = self
            (segue.destination as! PopoverViewController).drawPadViewController = self
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    public func callColorDlg() {
        print("callColorDlg")
    }
    
    public func callBrushSizeDlg() {
        print("callBrushSizeDlg")
    }
    
    public func callBackImageDlg() {
        print("callBackImageDlg")
    }
    
    public func saveDrawNote() {
        print("saveDrawNote")
    }

}
