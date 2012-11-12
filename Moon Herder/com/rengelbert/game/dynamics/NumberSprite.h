//
//  NumberSprite.h
//  
//
//  Created by Rogerio Engelbert on 12/15/11.
//  Copyright (c) 2011 rengelbert.com. All rights reserved.
//

#import "GameSprite.h"

@class Game;

@interface NumberSprite : GameSprite {
    int _value;
    NSMutableArray * _textures;
    NSMutableArray * _numbers;
    
    NSString * _empty;
    CCSpriteBatchNode * _node;
    
    float _width;
    float _height;
    float _x;
    float _y;
}

@property int value;
@property float width;
@property float height;
@property float x;
@property float y;

-(id) initWithGame:(Game *)game withBatch:(CCSpriteBatchNode *)node at:(CGPoint)position withFrameName:(NSString *)root ;
-(void) showValue:(int) value;
-(void) hide;
-(void) show;
//-(void) convertToInt:(NSString)
@end

