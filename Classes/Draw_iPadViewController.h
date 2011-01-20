//
//  Draw_iPadViewController.h
//  Draw_iPad
//
//  Created by Dennis Hübner on 30.11.10.
//  Copyright 2010 huebys inventions. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Draw_iPadViewController : UIViewController {
	IBOutlet UIScrollView *scroller;
	IBOutlet UITableView *tbl;
	NSMutableArray *moduleArray;
	NSMutableArray *variableArray;
	NSMutableArray *signalArray;
	int count;
}

@property (nonatomic, retain) IBOutlet UIScrollView *scroller;
@property (nonatomic, retain) IBOutlet UITableView *tbl;
@property (nonatomic, retain) NSMutableArray *moduleArray;
@property (nonatomic, retain) NSMutableArray *variableArray;
@property (nonatomic, retain) NSMutableArray *signalArray;



@end

