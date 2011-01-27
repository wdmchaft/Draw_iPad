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
//@synthesize variableArray;

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
	countArrayVariables = 0;
	
	CGFloat screensize_width = 2048;
	CGFloat screensize_height = 768;
	[tbl setFrame:CGRectMake(0, 0, screensize_width, screensize_height)];
	
	//TODO make this dynamic..
	[scroller setContentSize:CGSizeMake(screensize_width, screensize_height)];
	
	//NSString *path = @"/var/mobile/Applications/65134CBB-CBD0-4BA6-B6BC-EFB16BBFF600/Draw_iPad.app/simple.vcd";
	NSString *path = @"/Users/dennis/Downloads/simple.vcd";
	
	Parser *parse = [[Parser alloc] init];
	if ([parse parseFile:path]) {
		//[self setSignalArray:[parse searchForSymbolInDatastructure:@"$"]];
		[self setModuleArray:[parse data]];
		//[self setVariableArray:[[moduleArray objectAtIndex:0] variables]];
	} else {
		NSLog(@"FAIL");
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
	return [moduleArray count];
}

- (NSString *) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section { 
		return [[NSString alloc] initWithFormat:@"Module %@", [[moduleArray objectAtIndex:0] name]]; 	
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section { 
		NSInteger counter = 0;
		int modulePosition = 0;
		
		for (int i = 0; i < [[[moduleArray objectAtIndex:modulePosition] variables] count]; i++) {
			counter++;
			if ([[[[moduleArray objectAtIndex:modulePosition] variables] objectAtIndex:i] varArray]) {
				for (int y = 0; y < [[[[[moduleArray objectAtIndex:modulePosition] variables] objectAtIndex:i] varArray] count]; y++) {
					counter++;
				}
			}
		}
		NSLog(@"numberOfRows: %i", counter);
		return counter-1;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath: (NSIndexPath *)indexPath {
	int modulePosition = 0;
	BOOL arrayVariableIsFinished = NO;
		
	static NSString *CellIdentifier = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier]; 
	if (cell == nil) {
		cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease]; 
		
		NSMutableArray* varArray = [[moduleArray objectAtIndex:modulePosition] variables];
		VariableNode* variable = [varArray objectAtIndex:count];
		
		NSLog(@"Versuche Variable %@ mit Symbol %@ zu zeichnen", [variable varName], [variable symbol]);
		
		if ([variable varArray] == nil) {
			//mache was fuer normale variablen
			
			if (count < [varArray count]) {
				
				Draw2D* draw = [[Draw2D alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
				
				NSLog(@"ZEICHNE Variable %@ mit Symbol%@", [variable varName], [variable symbol]);
				
				[draw setSignals:[variable signals]];
				[draw setNameOfSignal:[variable varName]];
				
				[cell setBackgroundView:draw];
				
				count++;
				NSLog(@"drew auf yes");
			}
		} else {
			//mache was fuer array variablen
			NSMutableArray* arrayVariableArray = [variable varArray];
			if ([variable symbol] == nil) {
				
				NSLog(@"Versuche AVariable %@ mit Symbol %@ zu zeichnen", [variable varName], [variable symbol]);

				if (countArrayVariables < [arrayVariableArray count] && arrayVariableArray) {
					VariableNode* arrayVariable = [arrayVariableArray objectAtIndex:countArrayVariables];

					Draw2D* draw = [[Draw2D alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
				
					NSLog(@"ZEICHNE Variable %@ mit Symbol%@", [arrayVariable varName], [arrayVariable symbol]);

					[draw setSignals:[arrayVariable signals]];
					[draw setNameOfSignal:[arrayVariable varName]];
				
					[cell setBackgroundView:draw];
					countArrayVariables++;

				} else {
					countArrayVariables = 0;
					arrayVariableIsFinished = YES;
				}
			}
		}
		
		if (arrayVariableIsFinished) {
			count++;
		}
		
		/*
		if (moduleArray != nil && count < [[[moduleArray objectAtIndex:modulePosition] variables] count]) {
			
			Draw2D* draw = [[Draw2D alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
			Draw2D* drawSelected = [[Draw2D alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
	
			NSLog(@"VarName der variable: %@",[[[[moduleArray objectAtIndex:modulePosition] variables] objectAtIndex:count] varName]);

			if ([[[[moduleArray objectAtIndex:modulePosition] variables] objectAtIndex:count] signals]) {
				NSLog(@"in der if");
				[draw setSignals:[[[[moduleArray objectAtIndex:modulePosition] variables] objectAtIndex:count] signals]];
				[drawSelected setSignals:[[[[moduleArray objectAtIndex:modulePosition] variables] objectAtIndex:count] signals]];
				
				[cell drawRect:CGRectMake(0, 0, 0, 0)];
				
				[cell setBackgroundView:draw];
				[cell setSelectedBackgroundView:drawSelected];
				count++;
				NSLog(@"count in if: %i", count);
			} else {	
				NSLog(@"in der else");
				//NSMutableArray * varArrayFromVariableNode = [variable varArray];
				if (countArrayVariables < [[[[[moduleArray objectAtIndex:modulePosition] variables] objectAtIndex:count] varArray] count]) { 
					
					NSLog(@"countArrayVariables %i und Laenge von varArray %i", countArrayVariables, [[[[[moduleArray objectAtIndex:modulePosition] 
																											variables] objectAtIndex:count] 
																											varArray] count]);
					
					VariableNode *arrayVariable = [[[[[moduleArray objectAtIndex:modulePosition] variables] objectAtIndex:count] 
														varArray] objectAtIndex:countArrayVariables];
			
					[draw setSignals:[arrayVariable signals]];
					[drawSelected setSignals:[arrayVariable signals]];
					
					[cell drawRect:CGRectMake(0, 0, 0, 0)];

					[cell setBackgroundView:draw];
					[cell setSelectedBackgroundView:drawSelected];
					countArrayVariables++;
					NSLog(@"count in if unten: %i", countArrayVariables);

					
				} else {
					NSLog(@"hier ist %i und count = %i", countArrayVariables, count);
					countArrayVariables = 0;
					NSLog(@"UND DANN IST DER COUNTER 0");
					count++;
				}
				NSLog(@"ganz unten");
			}
		} else {
			[cell setText:@"Array empty.."];
			//cell.selectedBackgroundView = [[[Draw2D alloc] init] autorelease]; 
		}
		*/
		
		[[cell backgroundView] setBackgroundColor:[UIColor whiteColor]];
		[[cell selectedBackgroundView] setBackgroundColor:[UIColor orangeColor]];
		
		
		
	} // Configure the cell. 
	return cell;
}
@end
