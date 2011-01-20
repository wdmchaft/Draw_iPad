//
//  Draw_iPadViewController.m
//  Draw_iPad
//
//  Created by Dennis Hübner on 30.11.10.
//  Copyright 2010 huebys inventions. All rights reserved.
//

#import "Draw_iPadViewController.h"
#import "Draw2D.h"
#import "Parser.h"
#import	"ModuleNode.h"
#import	"SignalNode.h"
#import "VariableNode.h"

@implementation Draw_iPadViewController

@synthesize scroller;
@synthesize moduleArray;
@synthesize tbl;
@synthesize signalArray;
@synthesize variableArray;

/*
// The designated initializer. Override to perform setup that is required before the view is loaded.
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
        // Custom initialization
    }
    return self;
}
*/

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView {
}
*/



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	count = 0;
	
	CGFloat screensize_width = 2048;
	CGFloat screensize_height = 768;
	[tbl setFrame:CGRectMake(0, 0, screensize_width, screensize_height)];
	
	//TODO make this dynamic..
	[scroller setContentSize:CGSizeMake(screensize_width, screensize_height)];
	
	//NSString *path = @"/var/mobile/Applications/65134CBB-CBD0-4BA6-B6BC-EFB16BBFF600/Draw_iPad.app/simple.vcd";
	NSString *path = @"/Users/dennis/Downloads/very_simple.vcd";
	Parser *parse = [[Parser alloc] init];
	if ([parse parseFile:path]) {
		//[self setSignalArray:[parse searchForSymbolInDatastructure:@"!"]];
		[self setModuleArray:[parse data]];
		[self setVariableArray:[[moduleArray objectAtIndex:0] variables]];
	}
	[super viewDidLoad];
}


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Return YES for supported orientations
	
	
	//Einfach auf YES stelllen:D
    return (YES);
}


- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
	
	//TODO clean up variables..
}

- (void)dealloc {
    [super dealloc];
}

#pragma mark Table view methods

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	return 1;
}

-(NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
	//if (section == 0) {
		return @"Modul A"; 
	//} 
	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
	//if (section == 0) {
		return [variableArray count];
	//} 
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease]; 
		if (moduleArray != nil && count < 2) {
			Draw2D* draw = [[Draw2D alloc] initWithFrame:CGRectMake(0, 30, 100, 100)];
			
			ModuleNode* module = [moduleArray objectAtIndex:0];
			variableArray = [module variables];
			
			VariableNode* variable = [variableArray objectAtIndex:count];
			
			[draw setSignals:[variable signals]];
			[draw drawRect:CGRectMake(0, 30, 100, 100)];
			
			[cell setBackgroundView:draw];
			//[cell setSelectedBackgroundView:draw];
			
			count++;
		} else {
			[cell setText:@"Array empty.."];
			//cell.selectedBackgroundView = [[[Draw2D alloc] init] autorelease]; 
		}
		[[cell backgroundView] setBackgroundColor:[UIColor whiteColor]];
		[[cell selectedBackgroundView] setBackgroundColor:[UIColor orangeColor]];
	} // Configure the cell. 
	return cell;
}
@end
