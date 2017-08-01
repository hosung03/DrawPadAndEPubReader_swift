//
//  HighlightListViewController.swift
//  DrawPadAndEPubReader_swift
//
//  Created by Hosung, Lee on 2017. 7. 29..
//  Copyright © 2017년 hosung. All rights reserved.
//

import UIKit
import Material
import RealmSwift

class HighlightListViewController: UITableViewController{
    var highlights: Results<EPubHighLight>?

    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "EPub Highlight"
        let closeIcon = UIImage(readerImageNamed: "icon-navbar-close")?.ignoreSystemTint()
        self.navigationItem.leftBarButtonItem = UIBarButtonItem(image: closeIcon, style: .plain, target: self, action:#selector(closeHighlightListVC(_:)))
        
        //tableView.allowsSelection = false
        highlights = EPubHighLight.allByBookId(kBookName)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return highlights!.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "HightlightListCell", for: indexPath) as! HighlightListViewCell

        cell.deletegate = self

        cell.editBtn.tag = indexPath.row
        cell.trashBtn.tag = indexPath.row

        cell.dateText.text = highlights?[indexPath.row].date
        cell.highlightText.text = highlights?[indexPath.row].content
        cell.noteText.text = highlights?[indexPath.row].note
        
        return cell
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let highlight = highlights?[(indexPath as NSIndexPath).row]
        
        // if the page number is different between iOS and Android
        let isIOS = highlight?.currentPagerPostion.value == nil ? true : false
        if isIOS {
            EPubReader.shared.readerCenter?.changePageWith(page: (highlight?.page.value)!, andFragment: (highlight?.highlightId)!)
        } else {
            let page = (highlight?.page.value)! + 1
            EPubReader.shared.readerCenter?.changePageWith(page: page, andFragment: (highlight?.highlightId)!)
        }
        dismiss()
    }
    
    func closeHighlightListVC(_ sender: UIBarButtonItem){
        dismiss()
    }

}

extension HighlightListViewController : HighlightListViewCellDelegate {
    func editHighlight(rownum : Int) {
        let addNoteDialog = UIAlertController(title: "Save your note", message: "\n\n\n\n", preferredStyle: .alert)
        
        let titleTextField = TextField(frame:CGRect(x: 10, y:70, width: 250, height: 40))
        titleTextField.textColor = Color.black
        //titleTextField.placeholder = "Input your note.."
        titleTextField.placeholderActiveColor = Color.blue
        titleTextField.dividerActiveColor = Color.blue
        
        if highlights?[rownum].note != nil {
            titleTextField.text = highlights?[rownum].note
        } else {
            titleTextField.placeholder = "Input your note.."
        }
        
        addNoteDialog.view.addSubview(titleTextField)
        
        let saveAction = UIAlertAction(title: "Save", style: .default, handler: { (result : UIAlertAction) -> Void in
            let note : String = titleTextField.text!
            if note != "" {
                self.highlights?[rownum].updateNote(note)
                self.tableView.reloadData()
            }
        })
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive, handler: nil)
        
        addNoteDialog.addAction(saveAction)
        addNoteDialog.addAction(cancelAction)
        
        self.present(addNoteDialog, animated: true, completion: nil)
        
    }
    
    func deleteHighlight(rownum : Int) {
        highlights?[rownum].remove()
        self.tableView.reloadData()
    }
}
