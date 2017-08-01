//
//  HighlightListViewCell.swift
//  DrawPadAndEPubReader_swift
//
//  Created by Hosung, Lee on 2017. 7. 29..
//  Copyright © 2017년 hosung. All rights reserved.
//

import UIKit

protocol HighlightListViewCellDelegate {
    func editHighlight(rownum : Int)
    func deleteHighlight(rownum : Int)
}

class HighlightListViewCell: UITableViewCell {
    var deletegate : HighlightListViewCellDelegate?
    
    @IBOutlet weak var editBtn: UIButton!
    @IBOutlet weak var trashBtn: UIButton!
    @IBOutlet weak var dateText: UILabel!
    @IBOutlet weak var highlightText: UILabel!
    @IBOutlet weak var noteText: UILabel!
    @IBOutlet weak var cellBackgroundView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        editBtn.setImage(UIImage(named: "edit"), for: .normal)
        editBtn.contentMode = .center
        editBtn.imageView?.contentMode = .scaleAspectFit
        
        trashBtn.setImage(UIImage(named: "trash"), for: .normal)
        trashBtn.contentMode = .center
        trashBtn.imageView?.contentMode = .scaleAspectFit
        
        cellBackgroundView.backgroundColor = UIColor.white
        contentView.backgroundColor = UIColor.lightGray
        cellBackgroundView.layer.cornerRadius = 3.0
        cellBackgroundView.layer.masksToBounds = false
        cellBackgroundView.layer.shadowColor = UIColor.black.withAlphaComponent(0.2).cgColor
        cellBackgroundView.layer.shadowOffset = CGSize(width: 0, height: 0)
        cellBackgroundView.layer.shadowOpacity = 0.8
    }
    
//    override func setSelected(_ selected: Bool, animated: Bool) {
//        super.setSelected(selected, animated: animated)
//
//        // Configure the view for the selected state
//    }

    @IBAction func clickEditBtn(_ sender: UIButton) {
        let buttonTag = sender.tag
        if deletegate != nil {
            deletegate?.editHighlight(rownum: buttonTag)
        }
    }
    
    @IBAction func clickTrashBtn(_ sender: UIButton) {
        let buttonTag = sender.tag
        if deletegate != nil {
            deletegate?.deleteHighlight(rownum: buttonTag)
        }
    }
    
}
