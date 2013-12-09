//
//  main.m
//  MangaColorize
//
//  MIT License. Copyright (c) 2013 hetima. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HTMangaColorize.h"

void printHelp()
{
    fprintf(stdout, "usage: MangaColorize -i path -c path\n");
    fprintf(stdout, "  -i: image file path\n");
    fprintf(stdout, "  -c: color table image file path\n");
    
}

const char* processCommand(NSString* inputPath, NSString* mapPath)
{
    
    if(![[NSFileManager defaultManager]fileExistsAtPath:inputPath]){
        return "error: file not found.";
    }
    if(![[NSFileManager defaultManager]fileExistsAtPath:mapPath]){
        return "error: map file not found.";
    }
    
    NSImage* image=[[NSImage alloc]initWithContentsOfFile:inputPath];
    if (!image) {
        return "error: file is not image.";
    }
    
    NSImage* mapImage=[[NSImage alloc]initWithContentsOfFile:mapPath];
    if (!mapImage) {
        return "error: map file is not image.";
    }
    
    NSImage* output=[HTMangaColorize colorizeImage:image withMapImage:mapImage skipColoredSource:NO];
    
  /*
    HTMangaColorize* mc=[[HTMangaColorize alloc]init];
    [mc setMapPath:mapPath];
    [mc setSkipColoredSource:NO];

    NSImage* output=[mc colorizeImage:image];
#if !__has_feature(objc_arc)
    //[mc release];
#endif
   */
    
    if (output) {
        NSString* outputPath=[inputPath stringByAppendingPathExtension:@"color.tiff"];
        [[output TIFFRepresentation]writeToFile:outputPath atomically:YES];
    }else{
        return "error: fail to colorize.";
    }
    return nil;
}

int main(int argc, const char * argv[])
{

    @autoreleasepool {
        NSString* inputPath;
        NSString* mapPath;
        int i;
        for (i=1; i<argc; i++) {
            const char * param=argv[i];
            if (strcmp(param, "-i")==0 && i+1<argc) {
                inputPath=[[NSString stringWithUTF8String:argv[i+1]]stringByStandardizingPath];
                i++;
            }
            if (strcmp(param, "-c")==0 && i+1<argc) {
                mapPath=[[NSString stringWithUTF8String:argv[i+1]]stringByStandardizingPath];
                i++;
            }
        }
        
        if (!inputPath || !mapPath) {
            printHelp();
        }else{
            const char* result=processCommand(inputPath, mapPath);
            if (result) {
                fprintf(stdout, "%s\n", result);
            }
        }
    }
    
    return 0;
}

