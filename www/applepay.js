var ApplePay = function() {};

ApplePay.GenericSuccessCallback = function(response) {
    console.log('Success');
    console.log(response);
};

ApplePay.GenericFailureCallback = function(response) {
    console.log('Failure');
    console.log(response);
};

ApplePay.prototype.setMerchantId: function(merchantId, SuccessCallback, FailureCallback) {
    console.log('setMerchantId');
    if (SuccessCallback && FailureCallback) {
        cordova.exec(SuccessCallback, FailureCallback, 'ApplePay', 'setMerchantId', [merchantId]);
    } else {
        cordova.exec(ApplePay.GenericSuccessCallback, ApplePay.GenericFailureCallback, 'ApplePay', 'setMerchantId', [merchantId]);
    }
};

ApplePay.prototype.makePaymentRequest: function(order, SuccessCallback, FailureCallback) {
    console.log('makePaymentRequest');
    if (SuccessCallback && FailureCallback) {
        cordova.exec(SuccessCallback, FailureCallback, 'ApplePay', 'makePaymentRequest', [order]);
    } else {
        cordova.exec(ApplePay.GenericSuccessCallback, ApplePay.GenericFailureCallback, 'ApplePay', 'makePaymentRequest', [order]);
    }
};

var ApplePay = new ApplePay();
module.exports = ApplePayApplePay;
