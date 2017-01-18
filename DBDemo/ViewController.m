//
//  ViewController.m
//  DBDemo
//
//  Created by Kishan Panchotiya on 24/10/16.
//  Copyright © 2016 Kishan Panchotiya. All rights reserved.
//

#import "ViewController.h"
#import "WebHelper.h"

@interface ViewController ()
{
    
    IBOutlet UILabel *lblStatus;
    IBOutlet UIProgressView *progressView;
    NSArray* aryURLS;
    __block int intImageIndex;
}
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    aryURLS = @[
                @"http://ipadapp.niravmodi.com//uploads/products//product/11_technical.jpg",
                @"http://ipadapp.niravmodi.com//uploads/products/product_id_11/product_synopsis/11_synopsis.pdf",
                @"http://ipadapp.niravmodi.com//uploads/products/product_id_11/product_gia_cert/11_1_certi.pdf",
                @"http://ipadapp.niravmodi.com//uploads/products/product_id_11/product_gia_cert/11_2_certi.pdf",
                @"http://ipadapp.niravmodi.com//uploads/products/product_id_11/product_gia_cert/11_3_certi.pdf",
                @"http://ipadapp.niravmodi.com//uploads/products/product_id_11/product_gia_cert/11_4_certi.pdf",
                @"http://ipadapp.niravmodi.com//uploads/products/product_id_11/product_gia_cert/11_5_certi.pdf",
                @"http://ipadapp.niravmodi.com//uploads/products/product_id_11/product_gia_cert/11_6_certi.pdf"];
    intImageIndex = 0;    
    lblStatus.text = [NSString stringWithFormat:@"Downloading %d of %d files ...",(intImageIndex+1), (int)aryURLS.count];

}

-(void)fetchImages{
    if(intImageIndex >= aryURLS.count){
        dispatch_async(dispatch_get_main_queue(), ^{
            lblStatus.text = [NSString stringWithFormat:@"Download Completed, %d files downloaded",(int)aryURLS.count];
        });
        return;
    }
    
    NSString* strURL = aryURLS[intImageIndex];
    
    [[WebHelper sharedManager] downloadFileWithURL:strURL WithCompletion:^(BOOL success) {
        if(success){
            NSLog(@"Completion Successfully)");
            intImageIndex++;
            dispatch_async(dispatch_get_main_queue(), ^{
                lblStatus.text = [NSString stringWithFormat:@"Downloading %d of %d files ...",(intImageIndex+1), (int)aryURLS.count];
            });
            [self fetchImages];
        }else{
            NSLog(@"Completion Failed)");
            dispatch_async(dispatch_get_main_queue(), ^{
                lblStatus.text = [NSString stringWithFormat:@"Download Failed, %d files downloaded",intImageIndex];
            });
            return;
        }
    } WithProgress:^(double progress) {
        NSLog(@"Progress (%f))",progress);
        dispatch_async(dispatch_get_main_queue(), ^{
            progressView.progress = progress;
        });
    }];
}

-(void)callAPI{
    
    NSDictionary* dicRequest = @{@"deviceToken":@"088191C2-5050-4C55-8FC8-7B077033B9A2",
                                 };
    
    NSString *strUrl = @"http://ipadappv2.niravmodi.com/services/v1/getProductDetails.php?";
    
    [[WebHelper sharedManager] callWebServiceWithType:strUrl withPath:nil WithRequestPara:dicRequest OnCompletion:^(id response) {
        
        NSDictionary *dic = response;
        
        
        NSLog(@"dic%@",dic.description);
        
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"API Response"
                                                                       message:dic.description
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                              handler:^(UIAlertAction * action) {}];
        
        [alert addAction:defaultAction];
        [self presentViewController:alert animated:YES completion:nil];
        
        
        
    } OnError:^(id error) {
        
    }];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionDownload:(id)sender {
    
     [self fetchImages];
}

- (IBAction)actionAPICall:(id)sender {
        [self callAPI];
}
@end
