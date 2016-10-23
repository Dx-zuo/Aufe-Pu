//
//  HomeTableViewController.swift
//  Aufe Pu
//
//  Created by Dx on 16/10/19.
//  Copyright © 2016年 Dx. All rights reserved.
//

import UIKit
import SwiftyJSON
import Alamofire
import YYWebImage
import YYImage
import ESPullToRefresh
import MBProgressHUD
import DZNEmptyDataSet
struct Story  {
    let ID             :String
    let Title          :String
    let ActivityDate  :String
    let Ico            :String
    let Score          :String
    let NatureID       : String
    let Remmum         : String
}

class HomeTableViewController: UITableViewController,UITextFieldDelegate,DZNEmptyDataSetSource,DZNEmptyDataSetDelegate{
    

    let PostCellIdentifier = "HomeCell"
    let ShowBrowserIdentifier = "ShowBrowser"
    let PullToRefreshString = "Pull to Refresh"
    let FetchErrorMessage = "Could Not Fetch Posts"
    var AnyTop : Int = 100
    var ApiURl = "http://i.ancai.cc/StudentWX/Index/ActivityList"
    var pageIndex :Int = 1
    let StoryLimit: UInt = 30
    var retrievingStories: Bool!

    var stories: [Story]! = []

    @IBOutlet weak var Segmented: UISegmentedControl!
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        retrievingStories = false

    }

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureUI()

        DispatchQueue.global().async {
            
            DispatchQueue.main.async {
                
                self.retrieveStories()
                
            }
            
        }
        let botton = UIBarButtonItem()
        botton.title = "你好"
        botton.style = .done
        
        self.navigationItem.setLeftBarButton(botton, animated: true)
    }
    func configureUI() {
        tableView.emptyDataSetSource = self
        tableView.emptyDataSetDelegate = self
        tableView.tableFooterView = UIView()
        Segmented.selectedSegmentIndex = 0
        Segmented.addTarget(self, action: #selector(HomeTableViewController.segmentDidchange), for: UIControlEvents.valueChanged)
        
        refreshControl?.addTarget(self, action: #selector(retrieveStories), for: .valueChanged)
        refreshControl?.attributedTitle = NSAttributedString(string: PullToRefreshString)
        tableView.register(UINib(nibName: "HomeTableViewCell", bundle: nil), forCellReuseIdentifier: PostCellIdentifier)
        self.tableView.rowHeight = 130;
        self.navigationController?.navigationBar.tintColor = UIColor(red: 199.0/255.0, green: 67.0/255.0, blue: 99.0/255.0, alpha: 0.8)
        //

        
        //
        self.tableView.es_addPullToRefresh {
            [weak self] in
            self?.stories.removeAll()
            self?.refresh(pageIndexID: 1)
            
        }
        self.tableView.es_addInfiniteScrolling {
            [weak self] in
            self?.pageIndex += 1
            self?.refresh(pageIndexID: (self?.pageIndex)!)
            self?.tableView.es_stopLoadingMore()
            /// If no more data
            self?.tableView.es_noticeNoMoreData()
        }
    }
    func refresh(pageIndexID:Int) {
        DispatchQueue.global().async {
            
            DispatchQueue.main.async {
        let url = "\(self.ApiURl)?pageIndex=\(pageIndexID)"
        Alamofire.request(url).responseString { (DataResponse) in
            switch DataResponse.result{
            case .success(let data):
                let Dochtml = HomeModel.parseHomeModel(netData: data)
                var storiesMap = [Int:Story]()
                var sortedStories = [Story]()
                for (index,storyArr) in Dochtml.enumerated() {
                    storiesMap[index] = storyArr
                    sortedStories.append(storiesMap[index]!)
                }
                self.pageIndex += 1
                self.stories.append(contentsOf: sortedStories)
                self.tableView.reloadData()
                self.retrievingStories = false
                self.tableView.es_stopPullToRefresh(completion: true)
                self.tableView.es_stopPullToRefresh(completion: true, ignoreFooter: false)
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
            }
            
        }
    
    }
    func retrieveStories()  {
        let hud = MBProgressHUD.showAdded(to: self.view, animated: true)
        hud.mode = MBProgressHUDMode.text
        hud.labelText = "加载中"
        hud.detailsLabelText = "正在加载和解析页面 请稍等"
        hud.dimBackground = true
        UIApplication.shared.isNetworkActivityIndicatorVisible = true
        let URL = "\(ApiURl)\(AnyTop)"
        Alamofire.request(ApiURl).responseString { (DataResponse) in
            switch DataResponse.result{
            case .success(let data):
                let Dochtml = HomeModel.parseHomeModel(netData: data)
                var storiesMap = [Int:Story]()
                var sortedStories = [Story]()
                for (index,storyArr) in Dochtml.enumerated() {
                    storiesMap[index] = storyArr
                    sortedStories.append(storiesMap[index]!)
                }
                hud.hide(animated: true)

                self.stories = sortedStories
                self.tableView.reloadData()
                
                self.retrievingStories = false
                UIApplication.shared.isNetworkActivityIndicatorVisible = false
            case .failure(let error):
                hud.hide(animated: true)
                print(error.localizedDescription)
            }
        }
    }
    


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    


    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return stories.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: PostCellIdentifier, for: indexPath) as! HomeTableViewCell
        guard stories.count != 0 else {
            return cell
        }
        let story = stories[(indexPath as NSIndexPath).row]

        cell.TitleLabel.text = story.Title
        cell.ActivityNatrueLabel.text = story.NatureID
        
        cell.Score.text = story.Score
        cell.ActivityDate.text = story.ActivityDate
        cell.RenCode.text = story.Remmum
        let url = "http://i.ancai.cc\(story.Ico)"
        let imageurl = NSURL(string: String(url.characters.filter { $0 != " " })) as URL?
        cell.iconImage.layer.cornerRadius = 5
        cell.iconImage.yy_setImage(with: imageurl, placeholder: nil, options: YYWebImageOptions.progressiveBlur, progress: { (receivedSize, expectedSize) in
            
            }, transform: { (imagea, url) -> UIImage? in
                imagea.yy_draw(in: cell.iconImage.frame, with: UIViewContentMode.center, clipsToBounds: true)
                return imagea.yy_image(byRoundCornerRadius: 8)
            }) { (image, url, from, stage, error) in
        }
        cell.iconImage.clipsToBounds = true
        cell.iconImage.layer.masksToBounds  = true

        return cell
    }
    func ActivityDatea(ActivityDate:String) -> String {
        
        return (ActivityDate as NSString).substring(to: 9)
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let story = stories[(indexPath as NSIndexPath).row]
        let arr = ["ID":story.ID,"Title":story.Title] as [String : Any]
        self.performSegue(withIdentifier: "Webid", sender: arr)
        }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Webid"{
            let vc = segue.destination as! WebViewController
            let data = sender as! [String : Any]
            vc.webID = data["ID"] as! String
            vc.Webtitle = data["Title"] as! String
        }else{
            if segue.identifier == "searchid"{
                let vc = segue.destination as! WebViewController
                vc.hidesBottomBarWhenPushed = true
                vc.webID = "/StudentWX/Index/ActivityList?key=1111"
                vc.Webtitle = "搜索"
            
            }
        }
        
    }
    func segmentDidchange(segmented:UISegmentedControl){
        if segmented.selectedSegmentIndex == 1 {
            ApiURl = "http://i.ancai.cc/StudentWX/Index/ZyActivityList"
            stories.removeAll()
            retrieveStories()
        }else{
            ApiURl = "http://i.ancai.cc/StudentWX/Index/ActivityList"
            stories.removeAll()
            retrieveStories()
            
        }
        
    }
    func emptyDataSetShouldDisplay(scrollView: UIScrollView!) -> Bool {
        // 数据为空时是否显示
        return true
    }
    func emptyDataSetShouldAllowScroll(scrollView: UIScrollView!) -> Bool {
        // 数据为空时是否可以上下拉动
        return true
    }
    func title(forEmptyDataSet scrollView: UIScrollView!) -> NSAttributedString! {
        // 数据为空是显示的文字
        return NSAttributedString(
            string: "没有数据",
            attributes:
            [ NSFontAttributeName : UIFont(name: "HelveticaNeue", size: 17)!,
              NSForegroundColorAttributeName : UIColor.red ])
    }
}
