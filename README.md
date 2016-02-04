# Payeezy Apple Pay Cordova Plugin

## To install 

`cordova plugin add https://github.com/tabrindle/cordova-plugin-applepay.git`

## To Configure 

- Update your info in CDVApplePay.h with ApiKey, ApiSecret, MerchantToken, MerchantRef, ApplePayMerchantId and Environment

## Supported Platforms

- iOS

## Methods

- ApplePay.makePaymentRequest

## ApplePay.makePaymentRequest

Request a payment with ApplePay.

    ApplePay.makePaymentRequest(order, [successCallback], [errorCallback]);

### Example

    ApplePay.makePaymentRequest({
    	price: '19.99',
        prodID: '234234232',
        quantity: '2'
	});

