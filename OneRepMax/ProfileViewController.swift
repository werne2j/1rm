//
//  ProfileViewController.swift
//  OneRepMax
//
//  Created by Jake on 7/3/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UIActionSheetDelegate, UITabBarDelegate, UIScrollViewDelegate, PNChartDelegate {

    weak var delegate: ChildVCDelegate?

    @IBOutlet var userImage: PFImageView!
    @IBOutlet weak var blurredImage: PFImageView!
    @IBOutlet weak var usernameLabel: UILabel!
    
    @IBOutlet weak var followingButton: UIButton!
    @IBOutlet weak var followersButton: UIButton!
    
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followerCount: UILabel!
    
    @IBOutlet weak var tabBar: UITabBar!
    
    var following : NSArray = []
    var followers : NSArray = []
    
    var benchPosts : Array<CGFloat> = []
    var benchPostDates : Array<String> = []
    
    var squatPosts : Array<CGFloat> = []
    var squatPostDates : Array<String> = []
    
    var deadliftPosts : Array<CGFloat> = []
    var deadliftPostDates : Array<String> = []
    
    var currentMaxView = UIView()
    var userBioView = UIView()
    var scrollView = UIScrollView()
    var pageControl = UIPageControl()
    
    var benchLabel = UILabel()
    var squatLabel = UILabel()
    var deadliftLabel = UILabel()
    
    var benchTitle : UILabel!
    var squatTitle : UILabel!
    var deadliftTitle : UILabel!
    
    var user = PFUser()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.addNavBar()
        
        self.userImage.layer.masksToBounds = true
        self.userImage.layer.cornerRadius = 45
        self.blurredImage.layer.masksToBounds = true
        
        self.getFollowing()
        self.getPosts()
        
        let mainViewSize = self.tabBar.layer.bounds.size
        let borderWidth = 0.5 as CGFloat
        let borderColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1).CGColor
        
        var bottomView = UIView(frame: CGRectMake(0, mainViewSize.height - borderWidth, mainViewSize.width, borderWidth))
        var topView = UIView(frame: CGRectMake(0, 0 - borderWidth, mainViewSize.width, borderWidth))
        
        bottomView.layer.backgroundColor = borderColor
        topView.layer.backgroundColor = borderColor
        
        self.tabBar.addSubview(bottomView)
        self.tabBar.addSubview(topView)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.tabBar.selectedItem = self.tabBar.items?.first as? UITabBarItem
        
        self.currentMaxView.removeFromSuperview()
        self.currentMax()
        
        self.scrollView.removeFromSuperview()
        self.pageControl.removeFromSuperview()
        self.benchTitle?.removeFromSuperview()
        self.squatTitle?.removeFromSuperview()
        self.deadliftTitle?.removeFromSuperview()
        
        self.getFollowing()
        self.getPosts()
        
        self.user = PFUser.currentUser()
        
        self.usernameLabel.text = user.objectForKey("username") as? String
        self.followingCount.text = String(self.following.count)
        self.followerCount.text = String(self.followers.count)
        
        
        if user.objectForKey("bench") != nil {
            self.benchLabel.text = String(user.objectForKey("bench") as Int)
        } else {
            self.benchLabel.text = "N/A"
        }
        
        if user.objectForKey("squat") != nil {
            self.squatLabel.text = String(user.objectForKey("squat") as Int)
        } else {
            self.squatLabel.text = "N/A"
        }
        
        if user.objectForKey("deadlift") != nil {
            self.deadliftLabel.text = String(user.objectForKey("deadlift") as Int)
        } else {
            self.deadliftLabel.text = "N/A"
        }
        
        self.userImage.image = UIImage(named: "icn_noimage")

        if (user.objectForKey("avatar") != nil) {
            var file = user.objectForKey("avatar") as PFFile

            file.getDataInBackgroundWithBlock({ (data, error) -> Void in
                var image = UIImage(data: data)
                
                self.userImage.image = UIImage(data: data)
                
                if self.blurredImage.image != image {
                    
//                    self.blurredImage.image = image.applyBlurWithRadius(10, tintColor: UIColor(white: 1, alpha: 0.2)
//                                                                          , saturationDeltaFactor: 1.5, maskImage: nil)
                     self.blurredImage.image = image?.applyDarkEffect()
                }

            })
        } else {
            
            self.blurredImage.image = nil
            
        }

    }


    func callActionSheet(sender: AnyObject) {

        var sheet: UIActionSheet = UIActionSheet()
        sheet.delegate = self
        sheet.addButtonWithTitle("Cancel")
        sheet.addButtonWithTitle("Edit Profile")
        sheet.addButtonWithTitle("Sign Out")
        sheet.cancelButtonIndex = 0
        sheet.showInView(self.view)

    }
    
    func actionSheet(actionSheet: UIActionSheet!, clickedButtonAtIndex buttonIndex: Int) {
        switch buttonIndex {
        case 1:
            self.performSegueWithIdentifier("showSetup", sender: self)
        case 2:
            PFUser.logOut()
            self.performSegueWithIdentifier("showLogin", sender: self)
            informDelegateToReset()
        default:
            break
        }
    }

    override func shouldPerformSegueWithIdentifier(identifier: String?, sender: AnyObject!) -> Bool {
        
        if identifier == "showLogin" || identifier == "showSetup" {
            return false
        }
        
        return true
    }
    
    func informDelegateToScrollMethod(sender: AnyObject) {
        self.delegate?.childVC(self, scrollButton:sender as UIBarButtonItem)
    }
    
    func informDelegateToReset() {
        self.delegate?.reset()
    }
    
    
    func addNavBar() {
        
        var navbar = UINavigationBar(frame: CGRectMake(0, 0, 320, 64))
        var navItem = UINavigationItem()

        var mainBarButton = UIBarButtonItem(image: UIImage(named: "Icon-5-Flipped"), style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("informDelegateToScrollMethod:"))
        var settingsBarButton = UIBarButtonItem(image: UIImage(named: "Settings"), style: UIBarButtonItemStyle.Bordered, target: self, action: Selector("callActionSheet:"))
        
        settingsBarButton.tintColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        mainBarButton.tintColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        
        navbar.translucent = false
        navItem.leftBarButtonItem = mainBarButton
        navItem.rightBarButtonItem = settingsBarButton
        navItem.title = "Profile"

        let titleDict: NSDictionary = [NSForegroundColorAttributeName: UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)]
        navbar.titleTextAttributes = titleDict
        
        navbar.barTintColor = UIColor(red: 0.145, green: 0.153, blue: 0.165, alpha: 1.0)
        
        navbar.items = [navItem]
        self.view.addSubview(navbar)
    }
    
    /* ------------------------- Parse requests ------------------------------ */
    
    func getFollowing() {
        
        var query2 = PFUser.query()
        query2.whereKey("following", equalTo: PFUser.currentUser())
        query2.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            if (error == nil) {
                self.followers = objects
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
        
        var followingRelation = PFUser.currentUser().objectForKey("following") as PFRelation!
        
        if followingRelation != nil {
            var query = followingRelation.query()
            
            query.findObjectsInBackgroundWithBlock {
                (objects: [AnyObject]!, error: NSError!) -> Void in
                if (error == nil) {
                    self.following = objects
                } else {
                    // Log details of the failure
                    NSLog("Error: %@ %@", error, error.userInfo!)
                }
            }
        }
    }
    
    func getPosts() {
        
        var query = PFQuery(className: "Post")
        query.includeKey("user")
        query.whereKey("user", equalTo: PFUser.currentUser())
        query.orderByAscending("createdAt")
        
        query.findObjectsInBackgroundWithBlock {
            (objects: [AnyObject]!, error: NSError!) -> Void in
            
            if (error == nil) {
                self.benchPosts = []
                self.benchPostDates = []
                self.squatPosts = []
                self.squatPostDates = []
                self.deadliftPosts = []
                self.deadliftPostDates = []
                
                let dateFormatter = NSDateFormatter()
                dateFormatter.dateStyle = NSDateFormatterStyle.ShortStyle
                
                for o in objects {
                    if o["lift"] as String == "bench" {
                        self.benchPosts.append(o.objectForKey("weight") as CGFloat)
                        
                        var string = dateFormatter.stringFromDate(o.createdAt)
                        self.benchPostDates.append(string)
                    } else if o["lift"] as String == "squat" {
                        self.squatPosts.append(o.objectForKey("weight") as CGFloat)
                        
                        var string = dateFormatter.stringFromDate(o.createdAt)
                        self.squatPostDates.append(string)
                    } else if o["lift"] as String == "deadlift" {
                        self.deadliftPosts.append(o.objectForKey("weight") as CGFloat)
                        
                        var string = dateFormatter.stringFromDate(o.createdAt)
                        self.deadliftPostDates.append(string)
                    }
                }
                
            } else {
                // Log details of the failure
                NSLog("Error: %@ %@", error, error.userInfo!)
            }
        }
    }
    
    /* ---------------------- Charts ------------------------------ */
    
    func userClickedOnLineKeyPoint(point: CGPoint, lineIndex: Int, keyPointIndex: Int)
    {
        println("Click Key on line \(point.x), \(point.y) line index is \(lineIndex) and point index is \(keyPointIndex)")
    }
    
    func userClickedOnLinePoint(point: CGPoint, lineIndex: Int)
    {
        println("Click Key on line \(point.x), \(point.y) line index is \(lineIndex)")
    }
    
    func userClickedOnBarCharIndex(barIndex: Int)
    {
        println("Click  on bar \(barIndex)")
    }

    func drawChart(view: UIView, data: Array<CGFloat>, date: Array<String>) {
    
        var lineChart:PNLineChart = PNLineChart(frame: CGRectMake(10, 15, 300, 160))
        lineChart.yLabelFormat = "%1.1f"
        lineChart.showLabel = true
        lineChart.backgroundColor = UIColor.clearColor()
        lineChart.xLabels = date
        lineChart.showCoordinateAxis = true
        lineChart.delegate = self
        
        // Line Chart Nr.1
        var data01Array: [CGFloat] = data
        var data01:PNLineChartData = PNLineChartData()
        data01.color = PNGreyColor
        data01.itemCount = data01Array.count
        data01.inflexionPointStyle = PNLineChartData.PNLineChartPointStyle.PNLineChartPointStyleCycle
        data01.getData = ({(index: Int) -> PNLineChartDataItem in
            var yValue:CGFloat = data01Array[index]
            var item = PNLineChartDataItem()
            item.y = yValue
            return item
        })
        
        lineChart.chartData = [data01]
        lineChart.strokeChart()
        
        lineChart.delegate = self
        
        view.addSubview(lineChart)
        
    }
    
    /* ---------------------- tabs ------------------------------ */
    
    func tabBar(tabBar: UITabBar, didSelectItem item: UITabBarItem!) {
        switch  item.tag {
        case 0:
            self.scrollView.removeFromSuperview()
            self.pageControl.removeFromSuperview()
            self.benchTitle?.removeFromSuperview()
            self.squatTitle?.removeFromSuperview()
            self.deadliftTitle?.removeFromSuperview()
            self.currentMax()
        case 1:
            self.currentMaxView.removeFromSuperview()
            self.buildCharts()
        default:
            print("butts")
        }
    }
    
    func currentMax() {
        
        self.currentMaxView.removeFromSuperview()
        
        self.currentMaxView = UIView(frame: CGRectMake(0, 335, 320, 230))
        
        var bench = UILabel(frame: CGRectMake(12.5, 35, 90, 30))
        bench.textColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
        bench.text = "Bench"
        bench.textAlignment = .Center
        self.currentMaxView.addSubview(bench)
        
        var squat = UILabel(frame: CGRectMake(115, 35, 90, 30))
        squat.textColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
        squat.text = "Squat"
        squat.textAlignment = .Center
        self.currentMaxView.addSubview(squat)
        
        var deadlift = UILabel(frame: CGRectMake(217.5, 35, 90, 30))
        deadlift.textColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
        deadlift.text = "Deadlift"
        deadlift.textAlignment = .Center
        self.currentMaxView.addSubview(deadlift)
        
        self.benchLabel = UILabel(frame: CGRectMake(12.5, 65, 90, 90))
        self.benchLabel.font = UIFont(name: benchLabel.font.fontName, size: 30)
        self.benchLabel.textColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        self.benchLabel.backgroundColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
        self.benchLabel.textAlignment = .Center
        self.benchLabel.layer.cornerRadius = 45
        self.benchLabel.layer.masksToBounds = true
        
        if user.objectForKey("bench") != nil {
            self.benchLabel.text = String(user.objectForKey("bench") as Int)
        } else {
            self.benchLabel.text = "N/A"
        }
        
        self.currentMaxView.addSubview(benchLabel)
        
        self.squatLabel = UILabel(frame: CGRectMake(115, 65, 90, 90))
        self.squatLabel.font = UIFont(name: squatLabel.font.fontName , size: 30)
        self.squatLabel.textColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        self.squatLabel.backgroundColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
        self.squatLabel.textAlignment = .Center
        self.squatLabel.layer.cornerRadius = 45
        self.squatLabel.layer.masksToBounds = true
        
        if user.objectForKey("squat") != nil {
            self.squatLabel.text = String(user.objectForKey("squat") as Int)
        } else {
            self.squatLabel.text = "N/A"
        }
        
        self.currentMaxView.addSubview(squatLabel)
       
        self.deadliftLabel = UILabel(frame: CGRectMake(217.5, 65, 90, 90))
        self.deadliftLabel.font = UIFont(name: deadliftLabel.font.fontName , size: 30)
        self.deadliftLabel.textColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        self.deadliftLabel.backgroundColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
        self.deadliftLabel.textAlignment = .Center
        self.deadliftLabel.layer.cornerRadius = 45
        self.deadliftLabel.layer.masksToBounds = true
        
        if user.objectForKey("deadlift") != nil {
            self.deadliftLabel.text = String(user.objectForKey("deadlift") as Int)
        } else {
            self.deadliftLabel.text = "N/A"
        }
        
        self.currentMaxView.addSubview(deadliftLabel)
        
        self.view.addSubview(self.currentMaxView)
        
    }

    func buildCharts() {
        
        self.scrollView.removeFromSuperview()
        self.benchTitle?.removeFromSuperview()
        self.squatTitle?.removeFromSuperview()
        self.deadliftTitle?.removeFromSuperview()
        
        self.scrollLabels()
        
        self.scrollView = UIScrollView(frame: CGRectMake(0, 360, 320, 230))
        self.scrollView.delegate = self
        self.scrollView.contentSize = CGSizeMake(960, 200)
        self.scrollView.pagingEnabled = true
        self.scrollView.showsHorizontalScrollIndicator = false
        self.view.addSubview(self.scrollView)
        
        var benchView = UIView(frame: CGRectMake(0, 0, 320, 200))
        if self.benchPosts.count != 0 {
            self.drawChart(benchView, data: self.benchPosts, date: self.benchPostDates)
            self.scrollView.addSubview(benchView)
        } else {
            var nodata = UILabel(frame: CGRectMake(100, 60, 120, 50))
            nodata.textColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
            nodata.text = "No Bench Data"
            nodata.textAlignment = .Center
            self.scrollView.addSubview(nodata)
        }
        
        var squatView = UIView(frame: CGRectMake(320, 0, 320, 200))
        if self.squatPosts.count != 0 {
            self.drawChart(squatView, data: self.squatPosts, date: self.squatPostDates)
            self.scrollView.addSubview(squatView)
        } else {
            var nodata = UILabel(frame: CGRectMake(420, 60, 120, 50))
            nodata.textColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
            nodata.text = "No Squat Data"
            nodata.textAlignment = .Center
            self.scrollView.addSubview(nodata)
        }
        
        var deadliftView = UIView(frame: CGRectMake(640, 0, 320, 200))
        if self.deadliftPosts.count != 0 {
            self.drawChart(deadliftView, data: self.deadliftPosts, date: self.deadliftPostDates)
            self.scrollView.addSubview(deadliftView)
        }
        else {
            var nodata = UILabel(frame: CGRectMake(730, 60, 140, 50))
            nodata.textColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
            nodata.text = "No Deadlift Data"
            nodata.textAlignment = .Center
            self.scrollView.addSubview(nodata)
        }
        
        var xOffset : CGFloat = self.scrollView.contentOffset.x as CGFloat
        
        self.benchTitle.frame = CGRectMake(135 - xOffset/3.2, 350, 50, 20)
        self.squatTitle.frame = CGRectMake(237 - xOffset/3.2, 350, 48, 20)
        self.deadliftTitle.frame = CGRectMake(330 - xOffset/3.2, 350, 60, 20)
        
        self.benchTitle.alpha = 1 - xOffset / 320
        
        if xOffset <= 320 {
            self.squatTitle.alpha = xOffset / 320
        } else {
            self.squatTitle.alpha = 1 - (xOffset - 320) / 320
        }
        self.deadliftTitle.alpha = (xOffset - 320) / 320
        
        self.pageControl.removeFromSuperview()
        
        self.pageControl = UIPageControl(frame: CGRectMake(160, 550, 0, 0))
        self.pageControl.numberOfPages = 3
        self.pageControl.pageIndicatorTintColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
        self.pageControl.currentPageIndicatorTintColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        self.view.addSubview(self.pageControl)
    }

    
    /* ---------------------- scrollview ------------------------------ */
    
    func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 && scrollView.contentOffset.x < 160 {
            self.pageControl.currentPage = 0
        } else if scrollView.contentOffset.x >= 160 && scrollView.contentOffset.x < 480 {
            self.pageControl.currentPage = 1
        } else if scrollView.contentOffset.x >= 480 {
            self.pageControl.currentPage = 2
        }
        
        var xOffset : CGFloat = self.scrollView.contentOffset.x as CGFloat
        
        self.benchTitle.frame = CGRectMake(135 - xOffset/3.2, 350, 50, 20)
        self.squatTitle.frame = CGRectMake(237 - xOffset/3.2, 350, 48, 20)
        self.deadliftTitle.frame = CGRectMake(330 - xOffset/3.2, 350, 60, 20)
        
        self.benchTitle.alpha = 1 - xOffset / 320
        
        if xOffset <= 320 {
            self.squatTitle.alpha = xOffset / 320
        } else {
            self.squatTitle.alpha = 1 - (xOffset - 320) / 320
        }
        self.deadliftTitle.alpha = (xOffset - 320) / 320
    }

    func scrollLabels() {
        self.benchTitle = UILabel(frame: CGRectMake(135, 350, 50, 20))
        self.benchTitle.text = "Bench"
        self.benchTitle.textColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
        self.view.addSubview(self.benchTitle)
        
        self.squatTitle = UILabel(frame: CGRectMake(237, 350, 50, 20))
        self.squatTitle.text = "Squat"
        self.squatTitle.textColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
        self.view.addSubview(self.squatTitle)
        
        self.deadliftTitle = UILabel(frame: CGRectMake(330, 350, 60, 20))
        self.deadliftTitle.text = "Deadlift"
        self.deadliftTitle.textColor = UIColor(red: 37/255, green: 39/255, blue: 42/255, alpha: 1.0)
        self.view.addSubview(self.deadliftTitle)
    }
    
    /* ------------------------ segue ---------------------------------------- */
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        if segue.identifier == "showFollowing" {
            
            let vc = segue.destinationViewController as FollowingTableViewController
            vc.following = self.following
            
        } else if segue.identifier == "showFollowers" {
            
            let vc = segue.destinationViewController as FollowersViewController
            vc.following = self.following
            
        }
    }
    
}
