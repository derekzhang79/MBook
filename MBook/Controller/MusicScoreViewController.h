//
//  MusicScoreViewController.h
//  MBook
//
//  Created by Tom Callon (Hotmail) on 7/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol showMScoreViewControllerDelegate <NSObject>

-(void)showMScoreViewController;

@end


@interface MusicScoreViewController : UIViewController

{
    id<showMScoreViewControllerDelegate> delegate;    

}

@property (nonatomic, retain) id<showMScoreViewControllerDelegate> delegate;

- (IBAction)backButton:(id)sender;

@end
