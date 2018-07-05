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
    
    var pageViewController: UIPageViewController?
    var pageViewSleep: Bool = false
    var pageViewSleepTime: Date = Date()

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

        self.addChildViewController(self.pageViewController!)
        self.view.addSubview(self.pageViewController!.view)
        
        // Add ToolBar
        self.view.addSubview(ToolBar)
        let img1 = resizeImage(image: UIImage(named: "highlighter_icon.png")!, newWidth: 50)
        let item1 = UIBarButtonItem(title: "<", style: .plain, target: self, action: #selector(goPreviousPage))
        let item2 = UIBarButtonItem(title: ">", style: .plain, target: self, action: #selector(goNextPage))
        let item3 = UIBarButtonItem(image:  img1, style: .plain, target: self, action: #selector(startAction))
        ToolBar.items?.append(item1)
        ToolBar.items?.append(item2)
        ToolBar.items?.append(item3)
        
        // Add Scroll Bar
        self.view.addSubview(PageScroll)
        
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
    
    @objc
    func startAction(barButtonItem: UIBarButtonItem) {
        // TODO
        print("Button Pressed!")
    }

    @objc
    func goPreviousPage(barButtonItem: UIBarButtonItem) {
        goToPreviousPage()
    }
    
    @objc
    func goNextPage(barButtonItem: UIBarButtonItem) {
        goToNextPage()
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
        let currentLeftViewController = self.pageViewController!.viewControllers![0] as! DataViewController
        var viewControllers: [UIViewController]
        
        let currentRightViewController = self.modelController.pageViewController(self.pageViewController!, viewControllerAfter: currentLeftViewController)!
        
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

