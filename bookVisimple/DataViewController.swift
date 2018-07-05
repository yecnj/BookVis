//
//  DataViewController.swift
//  bookVisimple
//
//  Created by ivader on 2018. 5. 30..
//  Copyright © 2018년 yeonj. All rights reserved.
//

import UIKit

class DataViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var PageTextView: UITextView!
//    @IBOutlet weak var ContentsView: UIView!
    
    var dataObject: String = ""
    var page_contents = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
//        ContentsView.frame.size.height = 0.7
        PageTextView.textContainerInset = UIEdgeInsets(top: 30, left: 30, bottom: 15, right: 30)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataLabel!.text = dataObject
        self.PageTextView.text = page_contents
    }


}

