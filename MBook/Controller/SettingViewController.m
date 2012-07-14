//
//  SettingViewController.m
//  MBook
//
//  Created by Tom Callon (Hotmail) on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "SettingViewController.h"

@interface SettingViewController ()

@end

@implementation SettingViewController
@synthesize showSwitchValue;
@synthesize message;
@synthesize downLoad;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"设置", @"设置");


    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    UISwitch *switchButton  = [[UISwitch alloc]initWithFrame:CGRectMake(203, 13, 79, 27)];
    [switchButton setOn:NO];
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchButton];
}
-(IBAction)messageAcction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        message.text = @"开";
    }else {
        message.text = @"关";
    }

}
-(IBAction)downLoadAcction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButton = [switchButton isOn];
    if (isButton) {
        downLoad.text = @"开";
    }else{
        downLoad.text = @"关";
    }
    
}

-(void)switchAction:(id)sender{
    UISwitch *switchButton = (UISwitch*)sender;
    BOOL isButtonOn = [switchButton isOn];
    if (isButtonOn) {
        showSwitchValue.text = @"开";
    }else {
        showSwitchValue.text = @"关";
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
