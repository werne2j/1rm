//
//  LeadersPagerViewController.swift
//  OneRepMax
//
//  Created by Jake on 9/2/14.
//  Copyright (c) 2014 Jake. All rights reserved.
//

import UIKit

class LeadersPagerViewController: PagerViewController {
    
    var navBarView : UIView!
    var benchTitle : UILabel!
    var squatTitle : UILabel!
    var deadliftTitle : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        self.addChildren()
        self.scrollSettings()
        
        self.benchTitle = UILabel(frame: CGRectMake(135, 6, 50, 20))
        self.benchTitle.text = "Bench"
        self.benchTitle.textColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        self.navigationController?.navigationBar.addSubview(self.benchTitle)
        
        self.squatTitle = UILabel(frame: CGRectMake(237, 6, 50, 20))
        self.squatTitle.text = "Squat"
        self.squatTitle.textColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        self.navigationController?.navigationBar.addSubview(self.squatTitle)
        
        self.deadliftTitle = UILabel(frame: CGRectMake(330, 6, 60, 20))
        self.deadliftTitle.text = "Deadlift"
        self.deadliftTitle.textColor = UIColor(red: 0.741, green: 0.745, blue: 0.761, alpha: 1)
        self.navigationController?.navigationBar.addSubview(self.deadliftTitle)
        
        
        self.pageControl = UIPageControl(frame: CGRectMake(160, 32, 0, 0))
        self.pageControl.numberOfPages = 3
        self.navigationController?.navigationBar.addSubview(self.pageControl)
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(true)
        
        self.navigationController?.navigationBar.addSubview(self.benchTitle)
        self.navigationController?.navigationBar.addSubview(self.squatTitle)
        self.navigationController?.navigationBar.addSubview(self.deadliftTitle)
        self.navigationController?.navigationBar.addSubview(self.pageControl)
        self.tabBarController?.navigationItem.title = nil
        
        self.scrollView.setContentOffset(CGPointMake(0, 0), animated: false)
        self.pageControl.currentPage = 0
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(true)
        self.benchTitle.removeFromSuperview()
        self.squatTitle.removeFromSuperview()
        self.deadliftTitle.removeFromSuperview()
        self.pageControl.removeFromSuperview()
    }
    
    func addChildren() {
        let vc1 : BenchLeadersViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Bench") as BenchLeadersViewController
        let vc2 : SquatLeadersViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Squat") as SquatLeadersViewController
        let vc3 : DeadliftLeadersViewController = self.storyboard?.instantiateViewControllerWithIdentifier("Deadlift") as DeadliftLeadersViewController
        
        self.addChildViewController(vc1)
        self.addChildViewController(vc2)
        self.addChildViewController(vc3)
    }

    func scrollSettings() {
        self.edgesForExtendedLayout = UIRectEdge.None
        self.automaticallyAdjustsScrollViewInsets = true
        self.extendedLayoutIncludesOpaqueBars = false
    }
    
    override func scrollViewDidScroll(scrollView: UIScrollView) {
        if scrollView.contentOffset.x > 0 && scrollView.contentOffset.x < 160 {
            self.pageControl.currentPage = 0
        } else if scrollView.contentOffset.x >= 160 && scrollView.contentOffset.x < 480 {
            self.pageControl.currentPage = 1
        } else if scrollView.contentOffset.x >= 480 {
            self.pageControl.currentPage = 2
        }
        
        var xOffset : CGFloat = self.scrollView.contentOffset.x as CGFloat
        
        self.benchTitle.frame = CGRectMake(135 - xOffset/3.2, 6, 50, 20)
        self.squatTitle.frame = CGRectMake(237 - xOffset/3.2, 6, 48, 20)
        self.deadliftTitle.frame = CGRectMake(330 - xOffset/3.2, 6, 60, 20)
        
        self.benchTitle.alpha = 1 - xOffset / 320
        
        if xOffset <= 320 {
            self.squatTitle.alpha = xOffset / 320
        } else {
            self.squatTitle.alpha = 1 - (xOffset - 320) / 320
        }
        self.deadliftTitle.alpha = (xOffset - 320) / 320
    }
}
