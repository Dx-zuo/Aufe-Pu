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
        let aaa = jidoc?.rootNode?.descendantsWithAttributeName("class", attributeValue: "shcoolhot_content")
//        print(aaa?.enumerated())
        var sortedStories = [Story]()
        for (index,i) in (aaa?.enumerated())! {
            let Title = i.xPath("//span[@class='iconword']")[index].content
            let URLdata = i.firstDescendantWithName("a")!["href"]
            let Ico = i.xPath("//div[@class='shcoolhot_img']")[index].firstDescendantWithName("img")?["src"]
//            let Ico = i.firstDescendantWithName("img")!["src"]
            
//            let ActivityDate = i.xPath("//div[@class='timeclock']")[index].content
            let ActivityDate = i.firstDescendantWithAttributeName("class", attributeValue: "timeclock")?.content
            print("\(index) ----- \(i.firstDescendantWithAttributeName("class", attributeValue: "timeclock")?.content?.trim())")
//            let ActivityDate = i.firstChildWithAttributeName("class", attributeValue: "timeclock")?.content
//            let Score = i.xPath("//div[@class='timeclock']")[1].content
            let Score = ""
//            let NatureID = i.xPath("//div[@class='hometext']")[index].content?.trim()
            let NatureID = i.firstDescendantWithAttributeName("class", attributeValue: "hometext")?.content
//            let Remmum = i.xPath("//span[@class='joinnum']")[index].content?.trim()
//
            let Remmum = i.firstDescendantWithAttributeName("class", attributeValue: "joinnum")?.content
//            print(Remmum)
            let dataS = Story(ID: URLdata!, Title: Title!, ActivityDate: (ActivityDate?.trim())!, Ico: Ico!, Score: Score.trim(), NatureID: (NatureID!.trim() as NSString).substring(to: 4),Remmum:(Remmum!.trim()))
//            print(dataS)

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
