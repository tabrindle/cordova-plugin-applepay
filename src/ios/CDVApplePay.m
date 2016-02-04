#import "CDVApplePay.h"

@implementation CDVApplePay

@synthesize paymentCallbackId;

- (void)canMakePayments:(CDVInvokedUrlCommand*)command
{
    
    if ([PKPaymentAuthorizationViewController canMakePayments]) {
        if ((floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_8_0)) {
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @"This device cannot make payments."];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            return;
        } else if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){9, 0, 0}]) {
            if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:kSupportedNetworks9 capabilities:(PKMerchantCapability3DS)]) {
                CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"This device can make payments and has a supported card"];
                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                return;
            } else {
                CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @"This device can make payments but has no supported cards"];
                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                return;
            }
        } else if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){8, 0, 0}]) {
            if ([PKPaymentAuthorizationViewController canMakePaymentsUsingNetworks:kSupportedNetworks8]) {
                CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString: @"This device can make payments and has a supported card"];
                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                return;
            } else {
                CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @"This device can make payments but has no supported cards"];
                [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
                return;
            }
        } else {
            CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @"This device cannot make payments."];
            [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
            return;
        }
    } else {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @"This device cannot make payments."];
        [self.commandDelegate sendPluginResult:result callbackId:command.callbackId];
        return;
    }
}

- (void)makePaymentRequest:(CDVInvokedUrlCommand*)command
{
    self.paymentCallbackId = command.callbackId;
    
    NSLog(@"ApplePay canMakePayments == %s", [PKPaymentAuthorizationViewController canMakePayments]? "true" : "false");
    if ([PKPaymentAuthorizationViewController canMakePayments] == NO) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @"This device cannot make payments."];
        [self.commandDelegate sendPluginResult:result callbackId:self.paymentCallbackId];
        return;
    }
    
    PKPaymentRequest *request = [PKPaymentRequest new];
    
    self.summaryItems = [self itemsFromArguments:command.arguments];
    
    request.paymentSummaryItems = self.summaryItems;
    
    if ([[NSProcessInfo processInfo] isOperatingSystemAtLeastVersion:(NSOperatingSystemVersion){9, 0, 0}]) {
        request.supportedNetworks = kSupportedNetworks9;
    } else {
        request.supportedNetworks = kSupportedNetworks8;
    }
    
    request.requiredBillingAddressFields = PKAddressFieldAll;
    request.requiredShippingAddressFields = PKAddressFieldNone;
    request.merchantCapabilities = PKMerchantCapability3DS;
    request.merchantIdentifier = kApplePayMerchantId;
    request.countryCode = @"US";
    request.currencyCode = @"USD";
    
    PKPaymentAuthorizationViewController *authVC = [[PKPaymentAuthorizationViewController alloc] initWithPaymentRequest:request];
    
    authVC.delegate = self;
    
    if (authVC == nil) {
        CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @"PKPaymentAuthorizationViewController was nil."];
        [self.commandDelegate sendPluginResult:result callbackId:self.paymentCallbackId];
        return;
    }
    
    [self.viewController presentViewController:authVC animated:YES completion:nil];
}


- (NSMutableArray *)itemsFromArguments:(NSArray *)arguments
{
    NSArray *itemDescriptions = [[arguments objectAtIndex:0] objectForKey:@"items"];
    
    NSMutableArray *items = [[NSMutableArray alloc] init];
    
    for (NSDictionary *item in itemDescriptions) {
        
        NSString *label = [item objectForKey:@"label"];
        NSDecimalNumber *amount = [NSDecimalNumber decimalNumberWithDecimal:[[item objectForKey:@"amount"] decimalValue]];
        
        PKPaymentSummaryItem *newItem = [PKPaymentSummaryItem summaryItemWithLabel:label amount:amount];
        
        [items addObject:newItem];
        
    }
    
    return items;
}

- (void)paymentAuthorizationViewController:(PKPaymentAuthorizationViewController *)controller
                       didAuthorizePayment:(PKPayment *)payment
                                completion:(void (^)(PKPaymentAuthorizationStatus status))completion
{
    PayeezyClient *paymentProcessor = [[PayeezyClient alloc] initWithApiKey:kApiKey
                                                                  apiSecret:kApiSecret
                                                              merchantToken:kMerchantToken
                                                                environment:kEnvironment ];
    
    
    [paymentProcessor submit3DSTransactionWithPaymentInfo:payment.token.paymentData
                                          transactionType:@"authorize"
                                          applicationData:nil
                                       merchantIdentifier:kApplePayMerchantId
                                              merchantRef:kMerchantRef
                                               completion:^(NSDictionary *response, NSError *error) {
                                                   
                                                   if(error){
                                                       NSLog(@"%@", [error localizedDescription]);
                                                       CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString: @"Payment not completed."];
                                                       [self.commandDelegate sendPluginResult:result callbackId:self.paymentCallbackId];
                                                       
                                                       completion(PKPaymentAuthorizationStatusFailure);
                                                   } else {
                                                       CDVPluginResult* result = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsDictionary:response];
                                                       [self.commandDelegate sendPluginResult:result callbackId:self.paymentCallbackId];
                                                       
                                                       completion(PKPaymentAuthorizationStatusSuccess);
                                                   }
                                               }];
}

- (void)paymentAuthorizationViewControllerDidFinish:(PKPaymentAuthorizationViewController *)controller
{
    [self.viewController dismissViewControllerAnimated:YES completion:nil];
}

@end
