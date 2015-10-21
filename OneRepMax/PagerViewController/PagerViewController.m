//
//  ViewController.m
//  PageViewController
//
//  Created by Tom Fewster on 11/01/2012.
//

#import "PagerViewController.h"

typedef enum ScrollDirection {
    ScrollDirectionNone,
    ScrollDirectionRight,
    ScrollDirectionLeft,
    ScrollDirectionUp,
    ScrollDirectionDown,
    ScrollDirectionCrazy,
} ScrollDirection;

@interface PagerViewController ()
@property (assign) BOOL pageControlUsed;
@property (assign) NSUInteger page;
@property (assign) BOOL rotating;
@property (assign) BOOL pageAlreadyLoaded;
@property (nonatomic, assign) CGFloat lastContentOffset;
@property (nonatomic, assign) CGFloat startingOffset;

- (void)loadScrollViewWithPage:(int)page;
@end

@implementation PagerViewController

@synthesize scrollView;
@synthesize pageControl;
@synthesize pageControlUsed = _pageControlUsed;
@synthesize page = _page;
@synthesize rotating = _rotating;
@synthesize recentContentOffset;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	[self.scrollView setPagingEnabled:YES];
	[self.scrollView setScrollEnabled:YES];
	[self.scrollView setShowsHorizontalScrollIndicator:NO];
	[self.scrollView setShowsVerticalScrollIndicator:NO];
	[self.scrollView setDelegate:self];
    
    self.recentContentOffset = CGPointMake(320, 0);
}

- (BOOL)automaticallyForwardAppearanceAndRotationMethodsToChildViewControllers {
	return NO;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
	[viewController willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
	_rotating = YES;
}

- (void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration {
	
	UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
	[viewController willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
	
	self.scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [self.childViewControllers count], scrollView.frame.size.height);
	NSUInteger page = 0;
	for (viewController in self.childViewControllers) {
		CGRect frame = self.scrollView.frame;
		frame.origin.x = frame.size.width * page;
		frame.origin.y = 0;
		viewController.view.frame = frame;
		page++;
	}
	
	CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * _page;
    frame.origin.y = 0;
	[self.scrollView scrollRectToVisible:frame animated:NO];
	
}

- (void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation {
	_rotating = NO;
	UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
	[viewController didRotateFromInterfaceOrientation:fromInterfaceOrientation];
}

- (void)viewWillAppear:(BOOL)animated {
	[super viewWillAppear:animated];
	
	for (int i = 0; i <= [self.childViewControllers count]; i++) {
		[self loadScrollViewWithPage:i];
	}
	
	self.pageControl.currentPage = 1;
	_page = 1;
	[self.pageControl setNumberOfPages:[self.childViewControllers count]];
	
	UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
	if (viewController.view.superview != nil) {
		[viewController viewWillAppear:animated];
	}
	
	self.scrollView.contentSize = CGSizeMake(scrollView.frame.size.width * [self.childViewControllers count], scrollView.frame.size.height);
    
    self.scrollView.contentOffset = self.recentContentOffset;
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	if ([self.childViewControllers count]) {
		UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
		if (viewController.view.superview != nil) {
			[viewController viewDidAppear:animated];
		}
	}
}

- (void)viewWillDisappear:(BOOL)animated {
    
    self.recentContentOffset = self.scrollView.contentOffset;
    
	if ([self.childViewControllers count]) {
		UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
		if (viewController.view.superview != nil) {
			[viewController viewWillDisappear:animated];
		}
	}
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated {
	UIViewController *viewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
	if (viewController.view.superview != nil) {
		[viewController viewDidDisappear:animated];
	}
	[super viewDidDisappear:animated];
}

- (void)loadScrollViewWithPage:(int)page {
    if (page < 0)
        return;
    if (page >= [self.childViewControllers count])
        return;
    
	// replace the placeholder if necessary
    UIViewController *controller = [self.childViewControllers objectAtIndex:page];

    if (controller == nil) {
		return;
    }
	
	// add the controller's view to the scroll view
    if (controller.view.superview == nil) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = frame.size.width * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        [self.scrollView addSubview:controller.view];
    }
}

- (void)previousPage {
	if (_page - 1 > 0) {
	
		// update the scroll view to the appropriate page
		CGRect frame = self.scrollView.frame;
		frame.origin.x = frame.size.width * (_page - 1);
		frame.origin.y = 0;
		
		UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
		UIViewController *newViewController = [self.childViewControllers objectAtIndex:_page - 1];
		[oldViewController viewWillDisappear:YES];
		[newViewController viewWillAppear:YES];
		
		[self.scrollView scrollRectToVisible:frame animated:YES];
		
		self.pageControl.currentPage = _page - 1;
		// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
		_pageControlUsed = YES;
	}
}

- (void)nextPage {
	if (_page + 1 > self.pageControl.numberOfPages) {
		
		// update the scroll view to the appropriate page
		CGRect frame = self.scrollView.frame;
		frame.origin.x = frame.size.width * (_page + 1);
		frame.origin.y = 0;
		
		UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
		UIViewController *newViewController = [self.childViewControllers objectAtIndex:_page + 1];
		[oldViewController viewWillDisappear:YES];
		[newViewController viewWillAppear:YES];
		
		[self.scrollView scrollRectToVisible:frame animated:YES];
		
		self.pageControl.currentPage = _page + 1;
		// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
		_pageControlUsed = YES;
	}
}

- (IBAction)changePage:(id)sender {
    int page = (int)((UIPageControl *)sender).currentPage;
	
	// update the scroll view to the appropriate page
    CGRect frame = self.scrollView.frame;
    frame.origin.x = frame.size.width * page;
    frame.origin.y = 0;
    
	UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
	UIViewController *newViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
	[oldViewController viewWillDisappear:YES];
	[newViewController viewWillAppear:YES];
	
	[self.scrollView scrollRectToVisible:frame animated:YES];
	
	// Set the boolean used when scrolls originate from the UIPageControl. See scrollViewDidScroll: above.
    _pageControlUsed = YES;
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
	UIViewController *oldViewController = [self.childViewControllers objectAtIndex:_page];
	UIViewController *newViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
	[oldViewController viewDidDisappear:YES];
	[newViewController viewDidAppear:YES];
	
	_page = self.pageControl.currentPage;
}

#pragma mark -
#pragma mark UIScrollViewDelegate methods

- (void)scrollViewDidScroll:(UIScrollView *)sender {
    // We don't want a "feedback loop" between the UIPageControl and the scroll delegate in
    // which a scroll event generated from the user hitting the page control triggers updates from
    // the delegate method. We use a boolean to disable the delegate logic when the page control is used.
    if (_pageControlUsed || _rotating) {
        // do nothing - the scroll was initiated from the page control, not the user dragging
        return;
    }
    
    // direction of scroll view
    ScrollDirection scrollDirection;
    if (self.lastContentOffset > scrollView.contentOffset.x)
        scrollDirection = ScrollDirectionRight;
    else if (self.lastContentOffset < scrollView.contentOffset.x)
        scrollDirection = ScrollDirectionLeft;
    
    self.lastContentOffset = scrollView.contentOffset.x;

    
    // Switch the indicator when more than 50% of the previous/next page is visible
//    CGFloat pageWidth = self.scrollView.frame.size.width;
    int page;
    
    if (scrollDirection == 2 && self.startingOffset == 320.0) {
        
        if (!self.pageAlreadyLoaded) {
            page = 2;

            if (self.pageControl.currentPage != page) {
                UIViewController *oldViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
                UIViewController *newViewController = [self.childViewControllers objectAtIndex:page];
                [oldViewController viewWillDisappear:YES];
                [newViewController viewWillAppear:YES];
                self.pageControl.currentPage = page;
                [oldViewController viewDidDisappear:YES];
                [newViewController viewDidAppear:YES];
                _page = page;
            }
        }
        self.pageAlreadyLoaded = YES;
    
    } else if (scrollDirection == 1 && self.startingOffset == 640.0) {
        
        if (!self.pageAlreadyLoaded) {
            page = 1;

            if (self.pageControl.currentPage != page) {
                UIViewController *oldViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
                UIViewController *newViewController = [self.childViewControllers objectAtIndex:page];
                [oldViewController viewWillDisappear:YES];
                [newViewController viewWillAppear:YES];
                self.pageControl.currentPage = page;
                [oldViewController viewDidDisappear:YES];
                [newViewController viewDidAppear:YES];
                _page = page;
            }
        }
        self.pageAlreadyLoaded = YES;
    
    } else if (scrollDirection == 1 && self.startingOffset == 320.0) {
        
        if (!self.pageAlreadyLoaded) {
            page = 0;

            UIViewController *oldViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
            UIViewController *newViewController = [self.childViewControllers objectAtIndex:page];
            [oldViewController viewWillDisappear:YES];
            [newViewController viewWillAppear:YES];
            self.pageControl.currentPage = page;
            [oldViewController viewDidDisappear:YES];
            [newViewController viewDidAppear:YES];
            _page = page;
        }
        self.pageAlreadyLoaded = YES;
    
    } else if (scrollDirection == 2 && self.startingOffset == 0.0) {
        
        if (!self.pageAlreadyLoaded) {
            page = 1;

            if (self.pageControl.currentPage != page) {
                UIViewController *oldViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
                UIViewController *newViewController = [self.childViewControllers objectAtIndex:page];
                [oldViewController viewWillDisappear:YES];
                [newViewController viewWillAppear:YES];
                self.pageControl.currentPage = page;
                [oldViewController viewDidDisappear:YES];
                [newViewController viewDidAppear:YES];
                _page = page;
            }
        }
        self.pageAlreadyLoaded = YES;
    
    }
    
//	if (self.pageControl.currentPage != page) {
//        NSLog(@"%ld", (long)self.pageControl.currentPage);
//        NSLog(@"%d", page);
//    
//    UIViewController *oldViewController = [self.childViewControllers objectAtIndex:self.pageControl.currentPage];
//    UIViewController *newViewController = [self.childViewControllers objectAtIndex:page];
//
//    [oldViewController viewWillDisappear:YES];
//    [newViewController viewWillAppear:YES];
//    self.pageControl.currentPage = page;
//    [oldViewController viewDidDisappear:YES];
//    [newViewController viewDidAppear:YES];
//    _page = page;
//	}
}

// At the begin of scroll dragging, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    _pageControlUsed = NO;
    
    self.pageAlreadyLoaded = NO;
    self.startingOffset = self.scrollView.contentOffset.x;
}

// At the end of scroll animation, reset the boolean used when scrolls originate from the UIPageControl
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    _pageControlUsed = NO;
}

@end
