//
//  DataProcessor.swift
//  TCAssignment
//
//  Created by Benoy on 28/09/18.
//  Copyright © 2018 Benoy. All rights reserved.
//

import Foundation

struct Constants{
    
    static let url = "https://www.truecaller.com"
    static let interval = 10
}

extension String{
    subscript (i: Int) -> String {
        return  String(self[index(startIndex, offsetBy: i)])
    }
}

class DataProcessor{
    
    /*
     
     I was not sure if we can keep the Web page content in a file and re-use it instead of dowloading every time
     The follwing code serves the same puropse
     
    private var webContent:String = ""
    func loadString(){

        guard let path = Bundle.main.path(forResource: "data", ofType: "txt"), let str = try? String(contentsOfFile: path) else{
            return
        }
        webContent = str
    }
     
     */
    
    func tenthCharectorRequest(completion:@escaping (String)->()){
        
        DispatchQueue.global(qos: .default).async {
            
            let wbString = self.downloadData()
            let str = wbString[Constants.interval ]
            completion(str)
        }
    }
    
    func everyTenthCharectorRequest(completion:@escaping ([String])->()){
        
        /* Using GCD to execute the request in different thread */
        DispatchQueue.global(qos: .default).async {
            let strs = self.getChahretorAtEvery(nThIndex: Constants.interval)
            completion(strs)
        }
    }
    
    func frequencyOfWordsRequest(completion:@escaping ([String:Int])->()){
        
        /* Using GCD to execute the request in different thread */
        DispatchQueue.global(qos: .default).async {
            let frequency = self.getFrequencyOfWords()
            completion(frequency)
        }
    }
    
    /* All the helper methods are running in different cucurrent que, so that the main/UI thred is not blocked */
  
    private func getChahretorAtEvery(nThIndex:Int)->[String]{
        
        let wbString = downloadData()
        var strs:[String] = [String]()
        var idx = nThIndex - 1
        while idx < wbString.count{
            let chr = wbString[idx]
            if chr != " " {
                strs.append(chr)
            }
            idx += nThIndex
        }

        return strs
    }
    
    private func getFrequencyOfWords()->[String:Int]{
        
        var table:[String:Int] = [String:Int]()        
        let wbString = downloadData()
        let lines = wbString.components(separatedBy: "\n")
        var words:[String] = [String]()
        for line in lines{
            let wrd = line.components(separatedBy: " ")
            words.append(contentsOf: wrd)
        }
        for word in words{
            if table[word] != nil{
                table[word] = table[word]! + 1
            }else{
                table[word] = 1
            }
        }
        
        return table
    }
    
    private func downloadData()->String{
        guard let url = URL(string: Constants.url) , let data = try? Data(contentsOf: url) else{
            return ""
        }
        let str = String(data: data, encoding: .utf8)
        return str ?? ""
    }
    
}
