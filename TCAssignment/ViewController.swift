//
//  ViewController.swift
//  TCAssignment
//
//  Created by Benoy on 28/09/18.
//  Copyright © 2018 Benoy. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet private weak var label:UILabel!
    @IBOutlet private weak var textViewFirst:UITextView!
    @IBOutlet private weak var textViewSecond:UITextView!
    
    let dataProcessor = DataProcessor()
    override func viewDidLoad() {
        super.viewDidLoad()
        /*
         
         This should be called if we need to load the web-content from the local file
         
         dataProcessor.loadString()
         */
    }
    
    @IBAction private func didTapRequestButton( _ sender:UIButton){
        executeRequest()
    }
    
    private func executeRequest(){
        
        self.label.text = ""
        self.textViewFirst.text = ""
        self.textViewSecond.text = ""
        dataProcessor.tenthCharectorRequest(completion:{ str in
            DispatchQueue.main.async {
                self.label.text = str
            }
        })
        
        dataProcessor.everyTenthCharectorRequest(completion: {strs in
            var text = ""
            var coma = ""
            for str in strs{
                text += coma
                text += str
                coma = ","
            }
            DispatchQueue.main.async {
                self.textViewFirst.text = text
            }
        })
        
        dataProcessor.frequencyOfWordsRequest(completion: { dict in
            var text = ""
            var nl = ""
            for obj in dict{
                text += nl
                text += "\(obj.key)  : \(obj.value)"
                nl = "\n"
            }
            DispatchQueue.main.async {
                self.textViewSecond.text = text
            }
        })
    }


}

