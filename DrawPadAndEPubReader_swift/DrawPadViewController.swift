//
//  DrawPadViewController.swift
//  DrawPadAndEPubReader
//
//  Created by Hosung, Lee on 2017. 6. 14..
//  Copyright © 2017년 hosung. All rights reserved.
//
import UIKit
import Material
import RealmSwift

class DrawPadViewController: UIViewController, UIPopoverPresentationControllerDelegate {

    public var currentNoteId:Int = 0
    public var currentNote:DrawNote?
    // public var currentDrawpath:Results<DrawPath>?
    
    var notificationToken: NotificationToken? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("currentNoteId: \(currentNoteId)")
        
        let realm = try! Realm()
        if (currentNoteId>0){
            let predicate = NSPredicate(format: "id = %d", currentNoteId)
            currentNote = ((realm.objects(DrawNote.self).filter(predicate).first)!)
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
        } else if segue.identifier == "callColorDlg" {
            segue.destination.modalPresentationStyle = .overCurrentContext
            segue.destination.popoverPresentationController?.delegate = self
            (segue.destination as! ColorDialog).drawPadViewController = self
        } else if segue.identifier == "callBrushSizeDlg" {
            segue.destination.modalPresentationStyle = .overCurrentContext
            segue.destination.popoverPresentationController?.delegate = self
            (segue.destination as! BrushSizeDialog).drawPadViewController = self
            (segue.destination as! BrushSizeDialog).brushSize = Float(((self.view as? DrawPadView!)?.currentBrushSize)!)
        }
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    
    public func callColorSectionDlg() {
        self.performSegue(withIdentifier: "callColorDlg", sender: nil)
    }
    
    public func callBrushSizeDlg() {
        print("callBrushSizeDlg")
        self.performSegue(withIdentifier: "callBrushSizeDlg", sender: nil)
    }
    
    public func callBackImageDlg() {
        print("callBackImageDlg")
    }
    
    public func saveDrawNote() {
        print("saveDrawNote")
        
        if currentNote == nil {
            return
        }
        
        if (currentNote?.saved)!  {
            let drawpadview : DrawPadView? = self.view as? DrawPadView
            if drawpadview != nil {
                drawpadview?.saveDrawPaths()
            }
        } else {
            let saveDialog = UIAlertController(title: "Save", message: "\n\n\n", preferredStyle: .alert)
        
            let titleTextField = TextField(frame:CGRect(x: 10, y:70, width: 250, height: 30))
            titleTextField.textColor = Color.black
            titleTextField.placeholder = "Please input note title."
            titleTextField.placeholderActiveColor = Color.blue
            titleTextField.dividerActiveColor = Color.blue
            saveDialog.view.addSubview(titleTextField)

            let sliderAction = UIAlertAction(title: "OK", style: .default, handler: { (result : UIAlertAction) -> Void in
                let title : String = titleTextField.text!
                print("title: \(title)")
            })

            let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)

            saveDialog.addAction(sliderAction)
            saveDialog.addAction(cancelAction)
            
            self.present(saveDialog, animated: true, completion: nil)
        }
    }

    public func changeColor(color: UIColor) {
        let drawpadview : DrawPadView? = self.view as? DrawPadView
        if drawpadview != nil {
            drawpadview?.currentColor = color
        }
    }
    
    public func changeBrushSize(size: CGFloat) {
        let drawpadview : DrawPadView? = self.view as? DrawPadView
        if drawpadview != nil {
            drawpadview?.currentBrushSize = size
        }
    }
}
