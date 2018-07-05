//
//  ModelController.swift
//  bookVisimple
//
//  Created by ivader on 2018. 5. 30..
//  Copyright © 2018년 yeonj. All rights reserved.
//

import UIKit

/*
 A controller object that manages a simple model -- a collection of month names.
 
 The controller serves as the data source for the page view controller; it therefore implements pageViewController:viewControllerBeforeViewController: and pageViewController:viewControllerAfterViewController:.
 It also implements a custom method, viewControllerAtIndex: which is useful in the implementation of the data source methods, and in the initial configuration of the application.
 
 There is no need to actually create view controllers for each page in advance -- indeed doing so incurs unnecessary overhead. Given the data model, these methods create, configure, and return a new view controller on demand.
 */


class ModelController: NSObject, UIPageViewControllerDataSource {
    var contentsList: [String?] = [String?](repeating: nil, count: 64)
    var ImageContentsList = [UIImage?](repeatElement(nil, count: 6))

    override init() {
        super.init()
    }

    func viewControllerAtIndex(_ index: Int, storyboard: UIStoryboard) -> DataViewController? {
        if (BookContentsList.count == 0) || (index >= BookContentsList.count) {
            return nil
        }

        let dataViewController = storyboard.instantiateViewController(withIdentifier: "DataViewController") as! DataViewController
        dataViewController.page_contents = BookContentsList[index]
        
        return dataViewController
    }

    func indexOfViewController(_ viewController: DataViewController) -> Int {
        return BookContentsList.index(of: viewController.page_contents) ?? NSNotFound
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! DataViewController)
        
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        if (index % 2 == 0){
            let rightViewController = pageViewController.viewControllers![1] as! DataViewController
            ImageContentsList[index + 1] = rightViewController.drawView?.image
            ImageContentsList[index] = (viewController as! DataViewController).drawView?.image
        }
        
        index -= 1
        
        let loadViewController = self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
        loadViewController!.preparedDraw = ImageContentsList[index]
        return loadViewController
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! DataViewController)
        
        if index == NSNotFound {
            return nil
        }
        
        if (index % 2 == 1){
            let leftViewController = pageViewController.viewControllers![0] as! DataViewController
            ImageContentsList[index - 1] = leftViewController.drawView?.image
            ImageContentsList[index] = (viewController as! DataViewController).drawView?.image
        }
        
        index += 1
        if index == BookContentsList.count {
            return nil
        }
        
        let loadViewController = self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
        loadViewController!.preparedDraw = ImageContentsList[index]
        return loadViewController
    }

}

