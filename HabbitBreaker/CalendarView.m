//
//  CalendarView.m
//  HabbitBreaker
//
//  Created by serg on 11/29/12.
//  Copyright (c) 2012 OleksandrYatsenko. All rights reserved.
//

#import "CalendarView.h"

@implementation CalendarView

enum {
    MONDAY = 0,
    TUESDAY, // 1
    WEDNESDAY,// 2
    THURSDAY,// 3
    FRIDAY,// 4
    SATURDAY,// 5
    SUNDAY// 6
};

enum {
    FIRST_WEEK = 0,
    LAST_WEEK = 5
};

@synthesize monthStart, daysInMonth;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setMonthStart:(NSInteger)newValue
{
    // according gregorian calendar first day of week is Sunday (Sunday: 1, Monday: 2)
    //
    if (newValue == 1) {
        monthStart = 6;
    }
    else {
        monthStart = newValue - 2;
    }
}


- (void)drawRect:(CGRect)rect
{
    CGContextRef context = UIGraphicsGetCurrentContext();
    [self drawWeek:context];
    [self drawMonth:context];
}

static char *font = "Helvetica";

static const char *week[] = {"Mo", "Tu", "We", "Th", "Fr", "Sa", "Su"};

static float start_x = 20.5;
static float step_x = 45.5;

- (void)drawWeek:(CGContextRef)context
{
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, /* white */ 1.0, 1.0, 1.0, 1.0);
    CGContextSelectFont(context, font, 11.0, kCGEncodingMacRoman);
    CGAffineTransform transform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
    CGContextSetTextMatrix(context, transform);
    
    float x = start_x;
    float y = 10.0;
    
    for (int i = MONDAY; i <= SUNDAY; i++) {
        CGContextShowTextAtPoint(context, x, y, week[i], strlen(week[i]));
        x += step_x;
    }
}

static const char *days[] = {" 0", " 1", " 2", " 3", " 4", " 5", " 6", " 7", " 8", " 9", "10",
                             "11", "12", "13", "14", "15", "16", "17", "18", "19", "20",
                             "21", "22", "23", "24", "25", "26", "27", "28", "29", "30", "31"};

- (void)drawMonth:(CGContextRef)context
{
    CGContextSetTextDrawingMode(context, kCGTextFill);
    CGContextSetRGBFillColor(context, /* white */ 1.0, 1.0, 1.0, 1.0);
	CGContextSelectFont(context, font, 9.0, kCGEncodingMacRoman);
    CGAffineTransform transform = CGAffineTransformMake(1.0, 0.0, 0.0, -1.0, 0.0, 0.0);
    CGContextSetTextMatrix(context, transform);
    
    float step_y = 24.6;
    
    float x = start_x + step_x * monthStart;
    float y = 32.0;
    
    float margin_x = 12.0;
    float margin_y = 4.0;
    
    int index = 1;
    bool dayShouldChange = true;
    
    for (int week = FIRST_WEEK; week <= LAST_WEEK; week++) {
        for (int day = MONDAY; day <= SUNDAY; day++) {
            
            // only once at loop
            //
            if (week == FIRST_WEEK && dayShouldChange) {
                day = monthStart;
                dayShouldChange = false;
            }
            
            if (index <= daysInMonth) {
                CGContextShowTextAtPoint(context, x + margin_x, y - margin_y, days[index], strlen(days[index]));
            }
                        
            NSInteger highlightIndex = [self.highlightDays indexOfObject:@(index)];
            if (highlightIndex != NSNotFound) {
                
                NSNumber *color = [self.highlightColors objectAtIndex:highlightIndex];
                
                CGContextSetTextDrawingMode(context, kCGTextFillStroke);
                CGContextSelectFont(context, font, 14.0, kCGEncodingMacRoman);
                if (color.boolValue) { /* YES = green, NO = red */
                    CGContextSetRGBStrokeColor(context, /* green */ 0.0, 1.0, 0.0, 1.0);
                    CGContextSetRGBFillColor(context, /* green */ 0.0, 1.0, 0.0, 1.0);
                } else {
                    CGContextSetRGBStrokeColor(context, /* red */ 1.0, 0.0, 0.0, 1.0);
                    CGContextSetRGBFillColor(context, /* red */ 1.0, 0.0, 0.0, 1.0);
                }
                
                const char *points = [[self.highlightPoints objectAtIndex:highlightIndex] UTF8String];
                
                CGContextShowTextAtPoint(context, x - margin_x, y + margin_y, points, strlen(points));

                
                // reset text settings
                CGContextSelectFont(context, font, 9.0, kCGEncodingMacRoman);
                CGContextSetRGBFillColor(context, /* white */ 1.0, 1.0, 1.0, 1.0);
                CGContextSetTextDrawingMode(context, kCGTextFill);
            }
            
            index++;
            x += step_x;
            
            if (day == SUNDAY) {
                x = start_x;
                y += step_y;
            }
        }
    }
}


@end
