========================================================
EXPLANATION: receive() AND fallback() FUNCTIONS
========================================================

Code:

fallback() external payable {
    fund();
}

receive() external payable {
    fund();
}


PURPOSE
-------

These are special Solidity functions that are automatically
executed by the EVM when ETH is sent to the contract.

They allow the contract to properly handle unexpected
transactions or direct ETH transfers.


WHY THEY EXIST
--------------

Users may send ETH to a contract in several ways:

1. Calling a function
2. Sending ETH directly to the contract address
3. Calling a function that does not exist

Without receive() or fallback(), these transactions
might fail.

These functions define how the contract reacts.


RECEIVE FUNCTION
----------------

Code:

receive() external payable {
    fund();
}

The receive() function is executed when:

- ETH is sent to the contract
- No function data is included


Example:

User sends ETH directly from their wallet.

User Wallet
    |
    | send 1 ETH
    v
FundMe Contract


EVM checks transaction:

Is there function data?

Answer:

NO


Result:

receive() executes


Inside receive():

fund() is called

This means the ETH is treated as a normal funding transaction.


FALLBACK FUNCTION
-----------------

Code:

fallback() external payable {
    fund();
}

The fallback() function runs when:

- A function is called that does not exist
- ETH is sent with transaction data


Example:

User calls:

sendMoney()

But the contract does not have this function.


Result:

fallback() executes instead.


Inside fallback():

fund() is called


WHY BOTH FUNCTIONS ARE USED
---------------------------

Solidity separates these two situations:

1. ETH sent without data
2. ETH sent with data or invalid function call


Behavior Table:

ETH sent without data  -> receive()
ETH sent with data     -> fallback()


EXECUTION FLOW
--------------

ETH arrives at contract
        |
        v
Does transaction contain data?
        |
   +----+----+
   |         |
   NO       YES
   |         |
   v         v
receive()  fallback()
      \       /
       \     /
        v   v
        fund()


FINAL RESULT
------------

No matter how ETH arrives:

- direct transfer
- wrong function call
- manual funding

The contract always redirects the transaction to:

fund()


CONCEPTS LEARNED
----------------

From these functions we learn:

- special EVM entry points
- automatic contract execution
- handling unexpected transactions
- direct ETH transfers
- fallback safety mechanisms