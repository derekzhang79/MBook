//
//  SettingViewController.h
//  MBook
//
//  Created by Tom Callon (Hotmail) on 7/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingViewController : UIViewController
@property(nonatomic,retain)IBOutlet UILabel *showSwitchValue;
@property(nonatomic,retain)IBOutlet UILabel *message;
@property(nonatomic,retain)IBOutlet UILabel *downLoad;
-(IBAction)messageAcction:(id)sender;
-(IBAction)downLoadAcction:(id)sender;
@end
