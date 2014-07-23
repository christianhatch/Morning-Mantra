//
//  NSURL+MMExtended.h
//  Morning Mantra
//
//  Created by Christian Hatch on 7/23/14.
//  Copyright (c) 2014 Knot Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSURL (MMExtended)

///Returns an NSURL object which refers a directory with the passed in name in the library folder of the app.
+(NSURL *)libraryDirectoryURLWithDirectoryName:(NSString *)directory;

///Returns an NSURL object which refers a file with the passed in filename in the passed in directory name in the library folder of the app.
+(NSURL *)libraryFileURLWithDirectory:(NSString *)directory
                             filename:(NSString *)filename
                            extension:(NSString *)extension;

@end
