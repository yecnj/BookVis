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

//    var pageData: [String] = BookContentsList //[String](repeating: "", count: 5)
    var contentsList: [String?] = [String?](repeating: nil, count: 64)
//    var book_contents = ""

    override init() {
        super.init()
        
        // Load text file
//        if let filepath = Bundle.main.path(forResource: "file1", ofType: "txt") {
//            do {
//                book_contents = try String(contentsOfFile: filepath)
//                print("file.txt Load Success!!")
//            } catch {
//                print("file.txt Found but Cannot Load!!")
//            }
//        } else {
//            // example.txt not found!
//            print("file.txt Not Found!!")
//        }
        
        // Create the data model.
//        let dateFormatter = DateFormatter()
//        pageData = dateFormatter.monthSymbols
    }

    func viewControllerAtIndex(_ index: Int, storyboard: UIStoryboard) -> DataViewController? {
        // Return the data view controller for the given index.
        if (BookContentsList.count == 0) || (index >= BookContentsList.count) {
            return nil
        }

        // Create a new view controller and pass suitable data.
        let dataViewController = storyboard.instantiateViewController(withIdentifier: "DataViewController") as! DataViewController
        
//        dataViewController.dataObject = self.pageData[index]
//        if let now = contentsList[index] {
//            dataViewController.page_contents = now
//        }
//        else {
//            let textView = dataViewController.PageTextView!
//            while textView.contentSize.height < textView.bounds.height {
//
//            }
//        }
        dataViewController.page_contents = BookContentsList[index]
//        dataViewController.page_contents = self.book_contents

        
        return dataViewController
    }

    func indexOfViewController(_ viewController: DataViewController) -> Int {
        // Return the index of the given data view controller.
        // For simplicity, this implementation uses a static array of model objects and the view controller stores the model object; you can therefore use the model object to identify the index.
        return BookContentsList.index(of: viewController.page_contents) ?? NSNotFound
    }

    // MARK: - Page View Controller Data Source

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! DataViewController)
        if (index == 0) || (index == NSNotFound) {
            return nil
        }
        
        index -= 1
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

    func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        var index = self.indexOfViewController(viewController as! DataViewController)
        if index == NSNotFound {
            return nil
        }
        
        index += 1
        if index == BookContentsList.count {
            return nil
        }
        return self.viewControllerAtIndex(index, storyboard: viewController.storyboard!)
    }

}

