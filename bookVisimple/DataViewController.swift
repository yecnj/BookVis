//
//  DataViewController.swift
//  bookVisimple
//
//  Created by ivader on 2018. 5. 30..
//  Copyright © 2018년 yeonj. All rights reserved.
//

import UIKit

class myTextView: UITextView{
    override func touchesEstimatedPropertiesUpdated(_ touches: Set<UITouch>) {
        print("touch")
    }
}

class DataViewController: UIViewController {

    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var PageTextView: myTextView!
    var preparedDraw: UIImage?
    @IBOutlet weak var drawView: DrawingView!
    
    var dataObject: String = ""
    var page_contents = ""

    override func viewDidLoad() {
        super.viewDidLoad()
        PageTextView.textContainerInset = UIEdgeInsets(top: 30, left: 30, bottom: 15, right: 30)
        drawView.image = preparedDraw
        drawView.isUserInteractionEnabled = true
        PageTextView.isUserInteractionEnabled = false
        PageTextView.isSelectable = true
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataLabel!.text = dataObject
        self.PageTextView.text = page_contents
    }


}

