//
//  ViewController.m
//  PDFDocViewerMapped
//
//  Created by William Thompson on 3/7/18.
//  Copyright © 2018 William Thompson. All rights reserved.
//

#import "ViewController.h"

@import WebKit;

@interface ViewController ()
{
    NSData* _pdfData;
}
@property (weak, nonatomic) IBOutlet WKWebView *wkview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationItem.prompt = @"Important";
    self.title = @"Health Announcement";
    
    //14 megabyte PDF.
    NSString *pdfFileName = @"BillsPictures";
    
    [self copyFileToDocumentsDir:pdfFileName];
    _pdfData = [self getPDFData:pdfFileName];
    if (_pdfData)
    {
        [self showPreviewOf:pdfFileName];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

-(NSString*)docPathWFileNameFor:(NSString*)inFileName
{
    NSString *docPath = [ViewController getDocumentsDir];
    return [[docPath stringByAppendingPathComponent:inFileName] stringByAppendingPathExtension:@"pdf"];
}

-(void)copyFileToDocumentsDir:(NSString*)inFileName
{
    NSString *sourcePathWithFilePDF = [[NSBundle mainBundle] pathForResource:inFileName ofType:@"pdf"];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    NSString *destPathhWithDocFile = [self docPathWFileNameFor:inFileName];
    
    NSError *errors;
    
    if ([fm fileExistsAtPath:destPathhWithDocFile])
    {
        [fm removeItemAtPath:destPathhWithDocFile error:&errors];
    }
    
    if (![fm fileExistsAtPath:destPathhWithDocFile])
    {
        BOOL rVal = [fm copyItemAtPath:sourcePathWithFilePDF
                                toPath:destPathhWithDocFile
                                 error:&errors];
        
        if (!rVal)
        {
            NSLog(@"ERROR: %@",errors);
        }
    }
}

-(NSData*)getPDFData:(NSString*)inFileWithPath
{
    NSString *docFileWithPath = [self docPathWFileNameFor:inFileWithPath];
    
    NSFileManager *fm = [NSFileManager defaultManager];
    
    if ([fm fileExistsAtPath:docFileWithPath])
    {
        NSError *errors;
        NSData *docFileData = [NSData dataWithContentsOfFile:docFileWithPath
                                                     options:NSDataReadingMappedAlways
                                                       error:&errors];
        return docFileData;
    }
    
    return nil;
}

-(void)showPreviewOf:(NSString*)inFileWithPath
{
    NSString *docFileWithPath = [self docPathWFileNameFor:inFileWithPath];
    NSURL *fileUrl = [NSURL fileURLWithPath:docFileWithPath];
    [self.wkview loadData:_pdfData
                 MIMEType:@"application/pdf"
    characterEncodingName:@"utf-8"
                  baseURL:fileUrl];
    
}


+(NSString*)getDocumentsDir
{
    return NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
}

-(IBAction)backClicked:(id)sender
{
   if ( [self.wkview canGoBack] )
   {
       [self.wkview goBack];
   }
}

@end
