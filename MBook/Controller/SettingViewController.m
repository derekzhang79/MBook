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

@synthesize listData=_listData;
@synthesize showSwitchValue;
@synthesize message;
@synthesize downLoad;

typedef enum {
    BACKGROUDN_LIGHT_SECTION = 0,
    MESSAGE_PUSH_SECTION = 1,
    GPRS_DOWNLOAD_SECTION = 2,
    ABOUTUS_SECTION=3,
    FEEDBACK_SECTION = 4
} MORE_SELECTION;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        self.title = NSLocalizedString(@"设置", @"设置");


    }
    return self;
}


-(void)dealloc{
   
    [super dealloc];
    [_listData release];

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

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [self optionListInit];
    UISwitch *switchButton  = [[UISwitch alloc]initWithFrame:CGRectMake(203, 13, 79, 27)];
    [switchButton setOn:NO];
    [switchButton addTarget:self action:@selector(switchAction:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:switchButton];
}


- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    return 5;
    
}

- (void)optionListInit
{
    NSArray *array = [[NSArray alloc] initWithObjects:@"背景灯长亮", @"消息推送", @"GPRS下载",@"意见反馈", @"关于我们",  nil];
    self.listData = array;
     [array release];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
     
    static NSString *CellIdentifier =@"more";
    
    UITableViewCell *cell=[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell==nil) {
        
        cell=[[[UITableViewCell alloc ]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
        [cell.textLabel setText:[NSString stringWithFormat:@"%@",[self.listData objectAtIndex:indexPath.row]]];
        cell.accessoryType = UITableViewCellAccessoryNone;
        [cell.textLabel setFont:[UIFont systemFontOfSize:14]];
        
        
        ///选择了的Cell 的背景颜色
        cell.selectedBackgroundView = [[[UIView alloc] initWithFrame:cell.frame] autorelease];
        cell.selectedBackgroundView.backgroundColor = [UIColor colorWithRed:0x2F/255.0 green:0x76/255.0 blue:0xB9/255.0 alpha:1.0];
    
    }
    
//    
//    UIImage *image = nil;
//    switch ([indexPath row]) {
//        case BACKGROUDN_LIGHT_SECTION:
//            image = [UIImage imageNamed:@"press.png"];
//            break;
//        case MESSAGE_PUSH_SECTION:
//            image = [UIImage imageNamed:@"press.png"];
//            break;
//        case GPRS_DOWNLOAD_SECTION:
//            image = [UIImage imageNamed:@"press.png"];
//            break;
//        case ABOUTUS_SECTION:
//            image = [UIImage imageNamed:@"press.png"];
//            break;
//        case FEEDBACK_SECTION:
//            image = [UIImage imageNamed:@"press.png"];
//            break;
//        default:
//            break;
//    }
//    cell.imageView.image = image;
      cell.textLabel.backgroundColor = [UIColor clearColor];
//      cell.contentView.backgroundColor = [UIColor clearColor];	

    
    //set backgroudView
    UIImageView *imageView = nil;
    
    if (0 == [indexPath row] )
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"helptable_top.png"]];
    else if (4 == [indexPath row])
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"helptable_bottom.png"]];
    else
        imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"helptable_middle.png"]];
    
    cell.backgroundView=imageView;
    cell.backgroundView.backgroundColor = [UIColor clearColor];
    
    [imageView release];

    

    
    
    
    
    return cell;

}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    typedef enum {
        BACKGROUDN_LIGHT_SECTION = 0,
        MESSAGE_PUSH_SECTION = 1,
        GPRS_DOWNLOAD_SECTION = 2,
        ABOUTUS_SECTION=3,
        FEEDBACK_SECTION = 4
    } MORE_SELECTION;
    NSUInteger row = [indexPath row];
    switch (row) {
        case BACKGROUDN_LIGHT_SECTION:
            NSLog(@"BACKGROUDN_LIGHT_SECTION");
            break;
        case MESSAGE_PUSH_SECTION:
            NSLog(@"MESSAGE_PUSH_SECTION");
            break;
        case GPRS_DOWNLOAD_SECTION:
            NSLog(@"GPRS_DOWNLOAD_SECTION");
            break;
        case ABOUTUS_SECTION:
            NSLog(@"ABOUTUS_SECTION");
            break;
        case FEEDBACK_SECTION:
            NSLog(@"FEEDBACK_SECTION");
            break;
            default:
            break;
    }
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}




- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
