//
//  EPubReaderContainer.swift
//  EPubReaderKit
//
//  Created by Heberti Almeida on 15/04/15.
//  Modified by Hosung, Lee on 2017. 7. 27
//  Copyright (c) 2015 EPub Reader. All rights reserved.
//

import UIKit
import FontBlaster

var readerConfig: EPubReaderConfig!
var book: FRBook!

/// Reader container
open class EPubReaderContainer: UIViewController {
    var centerNavigationController: UINavigationController!
	var centerViewController: EPubReaderCenter!
    //var audioPlayer: EPubReaderAudioPlayer!
    var shouldHideStatusBar = true
    var shouldRemoveEpub = true
    var epubPath: String!
    fileprivate var errorOnLoad = false

    // MARK: - Init
    
    /**
     Init a Container
     
     - parameter config:     A instance of `EPubReaderConfig`
     - parameter path:       The ePub path on system
     - parameter removeEpub: Should delete the original file after unzip? Default to `true` so the ePub will be unziped only once.
     
     - returns: `self`, initialized using the `EPubReaderConfig`.
     */
    public init(withConfig config: EPubReaderConfig, epubPath path: String, removeEpub: Bool = true) {
        super.init(nibName: nil, bundle: Bundle.frameworkBundle())
        
        readerConfig = config
        epubPath = path
        shouldRemoveEpub = removeEpub
        
		initialization()
    }
    
    required public init?(coder aDecoder: NSCoder) {
		super.init(coder: aDecoder)
        
        initialization()
    }
    
    /**
     Common Initialization
     */
    fileprivate func initialization() {
        EPubReader.shared.readerContainer = self
        
        book = FRBook()
        
        // Register custom fonts
        FontBlaster.blast(bundle: Bundle.frameworkBundle())

        // Register initial defaults
        EPubReader.defaults.register(defaults: [
            kCurrentFontFamily: EPubReaderFont.andada.rawValue,
            kNightMode: false,
            kCurrentFontSize: 2,
            kCurrentAudioRate: 1,
            kCurrentHighlightStyle: 0,
            kCurrentTOCMenu: 0,
            kCurrentMediaOverlayStyle: MediaOverlayStyle.default.rawValue,
            kCurrentScrollDirection: EPubReaderScrollDirection.defaultVertical.rawValue
            ])
    }
    
    /**
     Set the `EPubReaderConfig` and epubPath.
     
     - parameter config:     A instance of `EPubReaderConfig`
     - parameter path:       The ePub path on system
     - parameter removeEpub: Should delete the original file after unzip? Default to `true` so the ePub will be unziped only once.
     */
    open func setupConfig(_ config: EPubReaderConfig, epubPath path: String, removeEpub: Bool = true) {
        readerConfig = config
        epubPath = path
        shouldRemoveEpub = removeEpub
    }
    
    // MARK: - View life cicle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
        
        readerConfig.canChangeScrollDirection = isDirection(readerConfig.canChangeScrollDirection, readerConfig.canChangeScrollDirection, false)
        
        // If user can change scroll direction use the last saved
        if readerConfig.canChangeScrollDirection {
            var scrollDirection = EPubReaderScrollDirection(rawValue: EPubReader.currentScrollDirection) ?? .vertical

            if (scrollDirection == .defaultVertical && readerConfig.scrollDirection != .defaultVertical) {
                scrollDirection = readerConfig.scrollDirection
            }

            readerConfig.scrollDirection = scrollDirection
        }

		readerConfig.shouldHideNavigationOnTap = ((readerConfig.hideBars == true) ? true : readerConfig.shouldHideNavigationOnTap)

        centerViewController = EPubReaderCenter()
        EPubReader.shared.readerCenter = centerViewController
        
        centerNavigationController = UINavigationController(rootViewController: centerViewController)
        
        // add by hosung
        centerNavigationController.navigationBar.tintColor = UIColor.white
        centerNavigationController.navigationBar.barTintColor = UIColor(hexString: "#006400")
        centerNavigationController.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.white]
        //
        
        centerNavigationController.setNavigationBarHidden(readerConfig.shouldHideNavigationOnTap, animated: false)
        view.addSubview(centerNavigationController.view)
        addChildViewController(centerNavigationController)
        centerNavigationController.didMove(toParentViewController: self)

		if (readerConfig.hideBars == true) {
			readerConfig.shouldHideNavigationOnTap = false
			self.navigationController?.navigationBar.isHidden = true
			self.centerViewController.pageIndicatorHeight = 0
		}

        // Read async book
        guard !epubPath.isEmpty else {
            print("Epub path is nil.")
            errorOnLoad = true
            return
        }
        
        DispatchQueue.global(qos: .userInitiated).async {
            do {
                if let parsedBook = try FREpubParser().readEpub(
                    epubPath: self.epubPath,
                    removeEpub: self.shouldRemoveEpub
                )
                {
                    book = parsedBook
                }
            } catch let e as EPubReaderError {
                self.alert(message: e.localizedDescription)
                return
            } catch {
                self.alert(message: "Unknown Error")
                return
            }
           
            guard !self.errorOnLoad else { return }
        
            EPubReader.isReaderOpen = true
        
            // Reload data
            DispatchQueue.main.async(execute: {
                
                // Add audio player if needed
//                if book.hasAudio() || readerConfig.enableTTS {
//                    self.addAudioPlayer()
//                }
                
                self.centerViewController.reloadData()
                
                EPubReader.isReaderReady = true
                EPubReader.shared.delegate?.EPubReader?(
                    EPubReader.shared,
                    didFinishedLoading: book
                )
            })
        }

    }
    
    override open func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        if errorOnLoad {
            self.dismiss()
        }
    }
    
    /**
     Initialize the media player
     */
//    func addAudioPlayer() {
//        audioPlayer = EPubReaderAudioPlayer()
//        EPubReader.shared.readerAudioPlayer = audioPlayer;
//    }
    
    // MARK: - Status Bar
    
    override open var prefersStatusBarHidden: Bool {
        return readerConfig.shouldHideNavigationOnTap == false ? false : shouldHideStatusBar
    }
    
    override open var preferredStatusBarUpdateAnimation: UIStatusBarAnimation {
        return UIStatusBarAnimation.slide
    }
    
    override open var preferredStatusBarStyle: UIStatusBarStyle {
        return isNight(.lightContent, .default)
    }
    
}

extension EPubReaderContainer {
    func alert(message: String) {
         let alertController = UIAlertController(
            title: "Error",
            message: message,
            preferredStyle: UIAlertControllerStyle.alert
        )
        let action = UIAlertAction(
            title: "OK",
            style: UIAlertActionStyle.cancel
            )
        { [weak self]
            (result : UIAlertAction) -> Void in
            self?.dismiss()
        }
        alertController.addAction(action)
        self.present(alertController, animated: true, completion: nil)
   }
}
