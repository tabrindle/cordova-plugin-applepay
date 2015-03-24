
cordova plugin add https://github.com/tabrindle/cordova-plugin-applepay.git

## Supported Platforms

- iOS

## Methods

- ApplePay.setMerchantId
- ApplePay.makePaymentRequest

## ApplePay.setMerchantId

Set your merchant ID from Apple.

	ApplePay.setMerchantId("merchant.my.id");

## ApplePay.makePaymentRequest

Request a payment with ApplePay.

    ApplePay.makePaymentRequest(order, [successCallback], [errorCallback]);


### Example

	ApplePay.setMerchantId("merchant.com.marketamerica.shopapp");
	 
    ApplePay.makePaymentRequest({
    	price: '19.99',
        prodID: '234234232',
        quantity: '2'
	});

