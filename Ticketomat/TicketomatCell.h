//
//  TicketomatCell.h
//  Ticketomat
//
//  Created by Jacek Marchwicki on 11-10-19.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Ticketomat.h"
#import <CoreLocation/CoreLocation.h>
#import <QuartzCore/QuartzCore.h>
#import "Locator.h"

@interface TicketomatCell : UITableViewCell {
    UILabel *_titleLabel;
	UILabel *_descLabel;
    UILabel *_distanceLabel;
    UIImageView *_compassImage;
    CLLocationCoordinate2D _position;
    Boolean _haveData;
    UIImage *_arrowImage;
    UIImage *_dotImage;
    Locator *_locator;
}
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UILabel *distanceLabel;
@property (nonatomic, strong) UIImageView *compassImage;
@property (nonatomic, strong) Locator *locator;
-(void)setTicketomatData:(Ticketomat *)ticketomat;
+(CGFloat) getHeight;
-(void)setDirection:(CGFloat) direction;
@end
