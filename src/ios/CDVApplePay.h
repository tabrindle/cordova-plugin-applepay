#import <UIKit/UIKit.h>
#import <Cordova/CDVPlugin.h>
#import <PassKit/PassKit.h>
#import <AddressBook/AddressBook.h>
#import <PayeezyClient/PayeezyClient.h>

#ifndef DEBUG
    #define kApiKey                 @"********************************"
    #define kApiSecret              @"****************************************************************"
    #define kMerchantToken          @"fdoa-************************************************"
    #define kMerchantRef            @"Acme Sock"
    #define kApplePayMerchantId     @"merchant.com.app.test"
    #define kEnvironment            @"CERT"
#else
    #define kApiKey                 @"********************************"
    #define kApiSecret              @"****************************************************************"
    #define kMerchantToken          @"fdoa-************************************************"
    #define kMerchantRef            @"Company"
    #define kApplePayMerchantId     @"merchant.com.app.prod"
    #define kEnvironment            @"PROD"
#endif

#define kSupportedNetworks8     @[PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkAmex]
#define kSupportedNetworks9     @[PKPaymentNetworkVisa, PKPaymentNetworkMasterCard, PKPaymentNetworkAmex, PKPaymentNetworkDiscover]

@interface CDVApplePay : CDVPlugin <PKPaymentAuthorizationViewControllerDelegate>

@property (nonatomic, strong) NSString* paymentCallbackId;
@property (nonatomic) NSMutableArray* summaryItems;

- (void)makePaymentRequest:(CDVInvokedUrlCommand*)command;
- (void)canMakePayments:(CDVInvokedUrlCommand*)command;
@end
