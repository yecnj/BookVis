//
//  RootViewController.swift
//  bookVisimple
//
//  Created by ivader on 2018. 5. 30..
//  Copyright © 2018년 yeonj. All rights reserved.
//

import UIKit

class RootViewController: UIViewController, UIPageViewControllerDelegate {

    @IBOutlet weak var ToolBar: UIToolbar!
    @IBOutlet weak var PageScroll: UISlider!
    @IBOutlet weak var nowIndex: UIBarButtonItem!
    
    var pageViewController: UIPageViewController?
    var pageViewSleep: Bool = false
    var pageViewSleepTime: Date = Date()

    var prev_index: Int = 0
    var now_index: Int = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        // Configure the page view controller and add it as a child view controller.
        self.pageViewController = UIPageViewController(transitionStyle: .pageCurl, navigationOrientation: .horizontal, options: nil)
        self.pageViewController!.delegate = self

        let startingViewController: DataViewController = self.modelController.viewControllerAtIndex(0, storyboard: self.storyboard!)!
        let viewControllers = [startingViewController]
        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: false, completion: {done in })

        self.pageViewController!.dataSource = self.modelController
        self.pageViewController!.gestureRecognizers[0].addTarget(self, action: #selector(updateScrollBar2))

        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        
        // Add ToolBar
        self.view.addSubview(ToolBar)
        ToolBar.items![0].title = "1  / \(BookContentsList.count)"
        PageScroll.isContinuous = true
        PageScroll.minimumValue = 0
        PageScroll.maximumValue = Float(BookContentsList.count - 1)
        PageScroll.addTarget(self, action: #selector(valueChanged), for: .valueChanged)
        
        
        // Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
        var pageViewRect = self.view.bounds
        if UIDevice.current.userInterfaceIdiom == .pad {
            pageViewRect = pageViewRect.insetBy(dx: 0.0, dy: 0.0)
        }
        self.pageViewController!.view.frame = pageViewRect

        self.pageViewController!.didMove(toParentViewController: self)
        
        // Start Applepen detect
        self.scheduledTimerWithTimeInterval()
    }
    
    func resizeImage(image: UIImage, newWidth: CGFloat) -> UIImage {
        let scale = newWidth / image.size.width
        let newHeight = image.size.height * scale
        
        UIGraphicsBeginImageContext(CGSize(width: newWidth, height: newHeight))
        
        image.draw(in: CGRect(x: 0, y: 0,width: newWidth, height: newHeight))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage!
    }
    
    // To make the value of PageScroll discrete
    @objc
    func valueChanged(sender: UISlider) {
        sender.setValue(roundf(PageScroll.value), animated: true)
        self.now_index = Int(sender.value)
        ToolBar.items![0].title = "\(self.now_index + 1)  / \(BookContentsList.count)"
        if now_index != prev_index {
            let diff = now_index - prev_index
            if (diff > 0) && (prev_index % 2 == 1) {
                goToNextPage()
            }
            else if (diff < 0) && (prev_index % 2 == 0) {
                goToPreviousPage()
            }
            prev_index = now_index
        }
    }

    @objc
    func updateScrollBar2(sender: UIGestureRecognizer) {
        if sender.state == .ended {
            let viewController = self.pageViewController!.viewControllers![0]
            let index = self.modelController.indexOfViewController(viewController as! DataViewController)
            updateScrollBar(index)
        }
    }
    
    func updateScrollBar(_ _now_index: Int) {
        PageScroll.value = Float(_now_index)
        self.now_index = _now_index
        ToolBar.items![0].title = "\(self.now_index + 1)  / \(BookContentsList.count)"
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    // Applepen detect codes
    var timer = Timer()
    
    func scheduledTimerWithTimeInterval(){
        // Scheduling timer to Call the function "updateCounting" with the interval of 1 seconds
        timer = Timer.scheduledTimer(timeInterval: 0.5, target: self, selector: #selector(updateCounting), userInfo: nil, repeats: true)
    }
    
    @objc func updateCounting(){
//        print(pageViewSleep)
        if(!pageViewSleep){
            self.pageViewController!.dataSource = self.modelController
            self.pageViewController!.delegate = self
        } else {
//            print(Date().timeIntervalSince(self.pageViewSleepTime))
            if (Date().timeIntervalSince(self.pageViewSleepTime) > 0.2){
                self.pageViewSleep = false
            }
        }
    }
    
    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        self.pageViewController!.dataSource = nil
        self.pageViewController!.delegate = nil
        self.pageViewSleep = true
        self.pageViewSleepTime = Date()
    }
    
    
    var modelController: ModelController {
        // Return the model controller object, creating it if necessary.
        // In more complex implementations, the model controller may be passed to the view controller.
        if _modelController == nil {
            _modelController = ModelController()
        }
        return _modelController!
    }

    var _modelController: ModelController? = nil

    // MARK: - UIPageViewController delegate methods

    func pageViewController(_ pageViewController: UIPageViewController, spineLocationFor orientation: UIInterfaceOrientation) -> UIPageViewControllerSpineLocation {
        if (orientation == .portrait) || (orientation == .portraitUpsideDown) || (UIDevice.current.userInterfaceIdiom == .phone) {
            // In portrait orientation or on iPhone: Set the spine position to "min" and the page view controller's view controllers array to contain just one view controller. Setting the spine position to 'UIPageViewControllerSpineLocationMid' in landscape orientation sets the doubleSided property to true, so set it to false here.
            let currentViewController = self.pageViewController!.viewControllers![0]
            let viewControllers = [currentViewController]
            self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })

            self.pageViewController!.isDoubleSided = false
            return .min
        }
//        print("Called!!")
        // In landscape orientation: Set set the spine location to "mid" and the page view controller's view controllers array to contain two view controllers. If the current page is even, set it to contain the current and next view controllers; if it is odd, set the array to contain the previous and current view controllers.
        let currentViewController = self.pageViewController!.viewControllers![0] as! DataViewController
        var viewControllers: [UIViewController]

        let indexOfCurrentViewController = self.modelController.indexOfViewController(currentViewController)
//        print(indexOfCurrentViewController)
        if (indexOfCurrentViewController == 0) || (indexOfCurrentViewController % 2 == 0) {
            let nextViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerAfter: currentViewController)
            viewControllers = [currentViewController, nextViewController!]
        } else {
            let previousViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerBefore: currentViewController)
            viewControllers = [previousViewController!, currentViewController]
        }
        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })

        return .mid
    }

    func goToNextPage() {
        let currentRightViewController = self.pageViewController!.viewControllers![1] as! DataViewController
        var viewControllers: [UIViewController]
        
        guard let nextLeftViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerAfter: currentRightViewController) else { return }
        guard let nextRightViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerAfter: nextLeftViewController) else { return }

        viewControllers = [nextLeftViewController, nextRightViewController]

        self.pageViewController!.setViewControllers(viewControllers, direction: .forward, animated: true, completion: {done in })
    }

    func goToPreviousPage() {
        let currentLeftViewController = self.pageViewController!.viewControllers![0] as! DataViewController
        var viewControllers: [UIViewController]
        
        guard let prevRightViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerBefore: currentLeftViewController) else { return }
        guard let prevLeftViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerBefore: prevRightViewController) else { return }

        viewControllers = [prevLeftViewController, prevRightViewController]
        
        self.pageViewController!.setViewControllers(viewControllers, direction: .reverse, animated: true, completion: {done in })
    }
}

