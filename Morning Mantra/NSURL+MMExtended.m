//
//  NSURL+MMExtended.m
//  Morning Mantra
//
//  Created by Christian Hatch on 7/23/14.
//  Copyright (c) 2014 Knot Labs. All rights reserved.
//

#import "NSURL+MMExtended.h"
#import "MMConstants.h"

@implementation NSURL (MMExtended)

+(NSURL *)libraryDirectoryURLWithDirectoryName:(NSString *)directory
{
    NSParameterAssert(directory);
    
    NSString *url = [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:directory];
    
    if (![[NSFileManager defaultManager] fileExistsAtPath:url isDirectory:nil])
    {
       
        NSError *error = nil;
        
        [[NSFileManager defaultManager] createDirectoryAtPath:url
                                  withIntermediateDirectories:YES
                                                   attributes:nil
                                                        error:&error];
        
        if (error)
        {
            DebugLog(@"error creating directory %@", error);
        }
    }
    
    return [NSURL fileURLWithPath:url];
}

+(NSURL *)libraryFileURLWithDirectory:(NSString *)directory
                             filename:(NSString *)filename
                            extension:(NSString *)extension
{
    
    NSParameterAssert(directory);
    NSParameterAssert(filename);
    
    NSString *url = filename;
    
    if (extension)
    {
        url = [NSString stringWithFormat:@"%@.%@", filename, extension];
    }
    
    return [NSURL URLWithString:url relativeToURL:[NSURL libraryDirectoryURLWithDirectoryName:directory]];
}

@end
