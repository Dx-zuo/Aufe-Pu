//
//  ReGModel.swift
//  Aufe Pu
//
//  Created by Dx on 16/10/20.
//  Copyright © 2016年 Dx. All rights reserved.
//

import Foundation
import Ji

class HomeModel {
    static func parseHomeModel(netData:String)->[Story]{
        let jidoc = Ji(htmlString: netData)
        let doc = jidoc?.rootNode?.xPath("//div[@class='shcoolhot_content']")

        var sortedStories = [Story]()
        for (index,i) in (doc?.enumerated())! {
            let Title = i.xPath("//span[@class='iconword']")[index].content
            let URLdata = i.firstDescendantWithName("a")!["href"]
            let Ico = i.xPath("//div[@class='shcoolhot_img']")[index].firstDescendantWithName("img")?["src"]
            let ActivityDate = i.xPath("//div[@class='timeclock']")[index].content
            let Score = i.xPath("//div[@class='timeclock']")[index+1].content
            let NatureID = i.xPath("//div[@class='hometext']")[index].content?.trim()
            let Remmum = i.xPath("//span[@class='joinnum']")[index].content
            let dataS = Story(ID: URLdata!, Title: Title!, ActivityDate: ActivityDate!.trim(), Ico: Ico!, Score: Score!.trim(), NatureID: (NatureID!.trim() as NSString).substring(to: 4),Remmum:(Remmum!.trim()))
            sortedStories.append(dataS)
//            print("\(index) Title :\(Title!)  \(URLdata!) \(Ico!) ActivityDate1:\(ActivityDate1!.trim()) Score:\(Score!.trim()) NatureID:\((NatureID as! NSString).substring(to: 4)) Remmum:\(Remmum!.trim())")
        }
        return sortedStories
    }
}
extension String{
    func trim() -> String {
        let str = NSCharacterSet.whitespacesAndNewlines
        return self.trimmingCharacters(in: str)
    }
}
