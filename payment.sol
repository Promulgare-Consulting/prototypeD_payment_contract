pragma solidity ^0.4.24;

contract Payment{

    // The owner is the person who publishes the contract
    address public owner; 
  
    struct purchaseRecord {
        uint skuPurchase;
        uint quantityPurchase;
        uint pricePurchase;
        uint paymentPurchase;
    }
  
  
    //    {userId: {invoiceId: purchaseRecord}}
    mapping(uint => mapping(uint => purchaseRecord)) public purchases;
  
    // This function is called at the time that the contract is created
    constructor() public {
	    // Set the account that deployed the contract to receive payments as the owner
        owner  = msg.sender;
    }
  
    function purchase(uint userId, uint invoiceId, uint sku, uint quantity, uint price, uint payment) payable public {
        // check payment amount
        if(payment==(price*quantity)) {
            // record payment
            purchases[userId][invoiceId].skuPurchase=sku;
            purchases[userId][invoiceId].quantityPurchase=quantity;
            purchases[userId][invoiceId].pricePurchase=price;
            purchases[userId][invoiceId].paymentPurchase=payment;
        }
        // send the money to owner
        owner.transfer(payment);
    }

    // if for any reason there is money left in the contract, this function will release it to the owner
    function empty() public {
	    // Only owner can transfer out the balance back to their account
        if(msg.sender == owner) {
            owner.transfer(address(this).balance);
        }
    }

}
