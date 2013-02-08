//
//  DrawLayer.h
//  MoonHerderCocos2d
//
//  Created by Roger Engelbert on 2/5/13.
//  Copyright 2013 Done With Computers. All rights reserved.
//

#import "GameManager.h"

@interface DrawLayer : CCNode {
    
    float _length;
    CGPoint _startPoint;
    CGPoint _touchPoint;
    
	GameManager * _manager;
	CGSize _screenSize;
	int _blinkStateTime;
	int _blinkStateEnergy;
	BOOL _blinking;
	float _blinkTimer;
	int _blinkCount;
}
@property float length;
@property CGPoint startPoint;
@property CGPoint touchPoint;

+(DrawLayer *) create;
-(id) init;


-(void) setBlinking:(BOOL) var;
-(void) drawBar:(int) orientation;
-(void) drawLine:(Line *) line;
-(void) drawQuadBezier:(CGPoint) origin  control:(CGPoint) control  destination:(CGPoint) destination  segments:(int) segments;
@end
