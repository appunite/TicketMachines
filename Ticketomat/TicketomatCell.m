//
//  TicketomatCell.m
//  Ticketomat
//
//  Created by Jacek Marchwicki on 11-10-19.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import "TicketomatCell.h"
#import "Notiffications.h"  
#import "MyMath.h"

@implementation TicketomatCell

@synthesize titleLabel = _titleLabel;
@synthesize descLabel = _descLabel;
@synthesize distanceLabel = _distanceLabel;
@synthesize compassImage = _compassImage;
@synthesize locator = _locator;

#define TITLE_LABEL_FONT_SIZE 16.0f
#define DESC_LABEL_FONT_SIZE 14.0f
#define SEPARATOR 3.0f
#define MAX_WIDTH 320.0f
#define DISTANCE_LABEL_FONT_SIZE 10.0f
#define DISTANCE_WIDGET_WIDTH 100.0f
#define COMPASS_WIDTH 20.0f
#define COMPASS_HEIGHT 20.0f
#define DISTANCE_LABEL_WIDTH (DISTANCE_WIDGET_WIDTH - COMPASS_WIDTH)


#define TITLE_LABEL_FONT [UIFont fontWithName:@"HelveticaNeue-Bold" size:TITLE_LABEL_FONT_SIZE]
#define DESC_LABEL_FONT [UIFont fontWithName:@"HelveticaNeue" size:DESC_LABEL_FONT_SIZE]
#define DISTANCE_LABEL_FONT [UIFont fontWithName:@"HelveticaNeue" size:DISTANCE_LABEL_FONT_SIZE]

-(void) calculate{
    if ([_locator haveLocation] == NO || _haveData == NO) {
        [_distanceLabel setHidden:YES];
        [_compassImage setHidden:YES];
        return;
    }
    [_distanceLabel setHidden:NO];
    
    CLLocationCoordinate2D cord1 = self->_position;
    CLLocationCoordinate2D cord2 = [_locator location];
    
    double dLatitude = cord1.latitude - cord2.latitude;
    double dLongtitue = cord1.longitude - cord2.longitude;
    
    double earthR = 6371; // km
    
    double a = sin(DEG2RAD(dLatitude)/2) * sin(DEG2RAD(dLatitude)/2) + sin(DEG2RAD(dLongtitue)/2) * sin(DEG2RAD(dLongtitue)/2) * cos(DEG2RAD(cord1.latitude)) * cos(DEG2RAD(cord2.latitude)); 
    double c = 2 * atan2(sqrt(a), sqrt(1-a)); 
    double distance = earthR * c;
    
    
    NSString * formated = [NSString stringWithFormat:@"%.3f km", distance];
    [self.distanceLabel setText:formated];
    double accuracy = [_locator accuracy] / 1000.0;
    if (distance < accuracy) {
        if (_dotImage == nil) {
            _dotImage = [UIImage imageNamed:@"Dot.png"]; // TODO
        }
        [_compassImage setImage:_dotImage];
        [_compassImage setHidden:NO];
    } else {
        if (_arrowImage == nil) {
                _arrowImage = [UIImage imageNamed:@"Right_arrow.png"]; // TODO
        }
        [_compassImage setImage:_arrowImage];
        if (! [_locator haveHeading]) {
            // not known course
            //[self.compassImage setHidden:NO];
            [self.compassImage setHidden:YES];
        } else {
            double alpha;
            if (dLatitude == 0.0) 
                alpha = M_PI_2;
            else 
                alpha = atan(fabs(dLongtitue / dLatitude));
            
            if (dLatitude > 0.0) {
                if (dLongtitue < 0.0) {
                    alpha = - alpha;
                }
            } else {
                if (dLongtitue > 0) {
                    alpha = M_PI-alpha;
                } else {
                    alpha = M_PI+alpha;
                }
            }
            double diffAlpha = - DEG2RAD([_locator heading]) + alpha - M_PI_2;
            if(diffAlpha < 0.0 || diffAlpha > M_PI * 2.0)
                diffAlpha = fabs((M_PI * 2.0) - fabs(diffAlpha));
            [self.compassImage setHidden:NO];
            [self setDirection:diffAlpha];
        }
    }
}

-(void)setDirection:(CGFloat) angle {
    CGAffineTransform transform = CGAffineTransformMakeRotation(angle);
    [_compassImage setTransform:transform];
}

- (void)onLocationChange:(id)sender {
    [self calculate];
}

- (void)onHeadingChange:(id)sender {
    [self calculate];
}

- (void)addObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onLocationChange:) name:LocationChangedNotifficationName object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onHeadingChange:) name:HeadingChangedNotifficationName object:nil];
}
- (void)removeObservers {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:LocationChangedNotifficationName object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:HeadingChangedNotifficationName object:nil];
}

- (void)dealloc {
    [self removeObservers];
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        _haveData = NO;
        _arrowImage = nil;
        _dotImage = nil;
        self.titleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.titleLabel.font = TITLE_LABEL_FONT;
		self.titleLabel.textAlignment = UITextAlignmentLeft;
        [self.contentView addSubview:self.titleLabel];
        
        self.descLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.descLabel.textAlignment = UITextAlignmentLeft;
        self.descLabel.font = DESC_LABEL_FONT;
        [self.contentView addSubview:self.descLabel];
        
        self.distanceLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.distanceLabel.textAlignment = UITextAlignmentRight;
        self.distanceLabel.font = DISTANCE_LABEL_FONT;
        [self.contentView addSubview:self.distanceLabel];
        self.compassImage = [[UIImageView alloc] init];
        [self.contentView addSubview:self.compassImage];
        
        [self addObservers];
        
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)setTicketomatData:(Ticketomat *)ticketomat {
    self->_haveData = YES;
    [self.titleLabel setText:[ticketomat title]];
    [self.descLabel setText:[ticketomat desc]];
    self->_position = CLLocationCoordinate2DMake([[ticketomat lat]doubleValue], [[ticketomat lng] doubleValue]);
    [self calculate];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    NSInteger top = 0;
    [_titleLabel setFrame:CGRectMake(0.0, top, self.contentView.bounds.size.width, TITLE_LABEL_FONT_SIZE)];
    top += TITLE_LABEL_FONT_SIZE + SEPARATOR;
    [_descLabel setFrame:CGRectMake(0.0, top, self.contentView.bounds.size.width - DISTANCE_WIDGET_WIDTH, DESC_LABEL_FONT_SIZE)];
    [_distanceLabel setFrame:CGRectMake(self.contentView.bounds.size.width - DISTANCE_WIDGET_WIDTH, top, DISTANCE_LABEL_WIDTH, DISTANCE_LABEL_FONT_SIZE)];
    
    
    double x = self.contentView.bounds.size.width - COMPASS_WIDTH;
    double y = TITLE_LABEL_FONT_SIZE + SEPARATOR - ((COMPASS_HEIGHT - DISTANCE_LABEL_FONT_SIZE) /2.0f);
    double width = COMPASS_WIDTH;
    double height = COMPASS_HEIGHT;
    [_compassImage setTransform:CGAffineTransformMakeRotation(0.0)];
    [_compassImage setFrame:CGRectMake(x, y, width, height)];
    [self calculate];
    
    top += DESC_LABEL_FONT_SIZE + SEPARATOR;
    [self.contentView setFrame:CGRectMake(0.0, 0.0, self.contentView.bounds.size.width, top)];
}

+(CGFloat) getHeight {
    return 50.0;
}

@end
