/**
 *  Copyright (c) 2013, Inmite s.r.o. (www.inmite.eu).
 *
 * All rights reserved. This source code can be used only for purposes specified
 * by the given license contract signed by the rightful deputy of Inmite s.r.o.
 * This source code can be used only by the owner of the license.
 *
 * Any disputes arising in respect of this agreement (license) shall be brought
 * before the Municipal Court of Prague.
 *
 */


#import "IMTViewController.h"
#import "CryptedResources.h"

@interface IMTViewController ()
@property (nonatomic,assign) IBOutlet UIImageView *imageView;
@property (nonatomic,assign) IBOutlet UILabel *label;
@end

@implementation IMTViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.imageView.image = [UIImage cryptedImageNamed:@"inmite.cri"];
    self.label.text = [NSString stringWithContentsOfCryptedFile:[[NSBundle mainBundle] pathForResource:@"text" ofType:@"crs"]
                                                       encoding:NSUTF8StringEncoding];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    self.imageView.image = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
    return UIInterfaceOrientationIsPortrait(toInterfaceOrientation);
}

@end
