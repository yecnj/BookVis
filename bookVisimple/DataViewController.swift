//
//  DataViewController.swift
//  bookVisimple
//re
//  Created by ivader on 2018. 5. 30..
//  Copyright © 2018년 yeonj. All rights reserved.
//

import UIKit

class DataViewController: UIViewController, UITextViewDelegate{

    @IBOutlet weak var dataLabel: UILabel!
    @IBOutlet weak var textView: UITextView!
    @IBOutlet weak var drawView: DrawingView!

    var dataString: String = ""
    var dataObject: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        textView.delegate = self
        textView.isEditable = false
        textView.isSelectable = true
        
        drawView.isUserInteractionEnabled = true
        drawView.backgroundColor = UIColor(white: 1, alpha: 0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.dataLabel!.text = dataObject
    }

}

