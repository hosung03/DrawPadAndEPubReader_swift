//
//  TOCViewController.swift
//  DrawPadAndEPubReader_swift
//
//  Created by mac on 2017. 7. 27..
//  Copyright © 2017년 hosung. All rights reserved.
//

import UIKit

protocol TOCViewControllerDelegate {
    func chapterListFromTOCVC(didSelectRowAtIndexPath indexPath: IndexPath, withTocReference reference: FRTocReference)
}

class TOCViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    public var delegate : TOCViewControllerDelegate?
    private var tocItems = [FRTocReference]()
    public var isDismissed : Bool = true
    
    @IBOutlet weak var tocTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tocTableView.tableFooterView = UIView()
        
        // Do any additional setup after loading the view.
        tocItems = book.flatTableOfContents
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tocItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TOCCell")!
        
        let tocReference = tocItems[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = tocReference.title.trimmingCharacters(in: .whitespacesAndNewlines)
        return cell
    }
    
    // MARK: - Table view delegate
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let tocReference = tocItems[(indexPath as NSIndexPath).row]
        
        if delegate != nil {
            delegate?.chapterListFromTOCVC(didSelectRowAtIndexPath: indexPath, withTocReference: tocReference)
        }
        
        dismissTOCVC()
    }

    func dismissTOCVC() {
        UIView.animate(withDuration: 0.3, animations: { () -> Void in
            self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
            self.view.layoutIfNeeded()
            self.view.backgroundColor = UIColor.clear
        }, completion: { (finished) -> Void in
            self.view.removeFromSuperview()
            self.removeFromParentViewController()
            self.isDismissed = true
        })
    }
}
