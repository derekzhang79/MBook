//
//  MusicScoreViewController.m
//  MBook
//
//  Created by Tom Callon (Hotmail) on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MusicScoreViewController.h"
#import "MScorePlayViewController.h"

@interface MusicScoreViewController ()

@end

@implementation MusicScoreViewController
@synthesize delegate;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    if (interfaceOrientation ==UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight) {

        [self.navigationController popViewControllerAnimated:YES];
                if (delegate && [delegate respondsToSelector:@selector(showMScoreViewController)]){
            [delegate showMScoreViewController];
        }
    }else {
        NSLog(@"man man man man man ");
    }
    
    return (interfaceOrientation == UIInterfaceOrientationPortrait||interfaceOrientation== UIInterfaceOrientationLandscapeLeft||interfaceOrientation==UIInterfaceOrientationLandscapeRight);
}

- (IBAction)backButton:(id)sender {
    
    [self.navigationController popViewControllerAnimated:YES];
}
@end
