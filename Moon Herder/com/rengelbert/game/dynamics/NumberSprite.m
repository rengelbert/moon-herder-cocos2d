//
//  NumberSprite.m
//  FroggerSparrow
//
//  Created by Rogerio Engelbert on 12/15/11.
//  Copyright (c) 2011 rengelbert.com. All rights reserved.
//

#import "NumberSprite.h"
#import "Game.h"

@implementation NumberSprite

@synthesize value = _value, width = _width, height = _height, x = _x, y = _y;


-(void) dealloc {
    
    [_empty release];
    
    [_textures removeAllObjects];
    [_numbers removeAllObjects];
    
    [_textures release];
    [_numbers release];
    
    _textures = _numbers = nil;
    
    [super dealloc];
}

-(id) initWithGame:(Game *)game  withBatch:(CCSpriteBatchNode *)node at:(CGPoint)position withFrameName:(NSString *) root {
    self = [super initWithGame:game];
    if (self != nil) {
        _skin = nil;
        
        _node = node;
        _x = position.x;
        _y = position.y;
        
        _textures = [[NSMutableArray array] retain];
        _numbers = [[NSMutableArray array] retain];
        
        int i;
        NSString * fileName;
      
        for (i = 0; i < 10; i++) {
            fileName = [NSString stringWithFormat:@"%@%i.png", root, i];
            [_textures addObject:[[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:fileName]];
        }
        
        float w = ((CCSpriteFrame *) [_textures objectAtIndex:0]).rect.size.width;
        _width = w * 10;
        _height = ((CCSpriteFrame *) [_textures objectAtIndex:0]).rect.size.height;
        
        
        _empty = [[NSString stringWithFormat:@"%@0.png", root] retain];
       
        CCSprite * img;
        for (i = 0; i < 10; i++) {
            img = [CCSprite spriteWithSpriteFrame:[_textures objectAtIndex:0]];
            img.position = ccp(position.x + i * (w + 2), position.y);
            img.visible = NO;
            [_numbers addObject:img];
            [_node addChild:img];
        }
       
    }
    return self;
}

-(void) showValue:(int) value {
    
    NSString *string = [NSString stringWithFormat:@"%i", value];
    int len = [string length];
    if (len > 10) return;
    
    [self hide];
    
    char texture_char;
    CCSprite * number;
    
    float w;
    for (int i = 0; i < 10; i++) {
        int texture_index;
        number = (CCSprite *)[_numbers objectAtIndex:i];
        w = number.textureRect.size.width;
        if (i < len) {
            texture_char = [string characterAtIndex:i];
            texture_index = atoi(&texture_char);
            if (texture_index < _textures.count) {
                [number setDisplayFrame:[_textures objectAtIndex:texture_index]];
            }
            number.visible = YES;
        } else {
            number.visible = NO;
        }
        
    }
    
    _width = w * len;
}

-(void) reset {
    
    CCSpriteFrame * emptyFrame = [[CCSpriteFrameCache sharedSpriteFrameCache] spriteFrameByName:_empty];
    
    for (int i = 0; i < [_numbers count]; i++) {
        
        [(CCSprite *)[_numbers objectAtIndex:i] setDisplayFrame:emptyFrame];
    }

}

-(void) show {
    for (int i = 0; i < [_numbers count]; i++) {
        ((CCSprite *) [_numbers objectAtIndex:i]).visible = YES;
    }   
}

-(void) hide {
    for (int i = 0; i < [_numbers count]; i++) {
        ((CCSprite *) [_numbers objectAtIndex:i]).visible = NO;
    }  
}

@end

