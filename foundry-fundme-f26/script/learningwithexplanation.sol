/*
-----------------------------------------------------------
FUND FUNCTION EXPLANATION
-----------------------------------------------------------

Purpose:
This function allows users to fund the contract by sending ETH.
However, the contract enforces a minimum funding requirement
of $5 worth of ETH using a Chainlink price feed.

Important Concept:
- payable: Allows the function to receive ETH.
- msg.value: The amount of ETH sent with the transaction.
- msg.sender: The address of the user calling the function.

Execution Flow:

1. User Calls fund()
   A user calls the fund() function and sends ETH with the transaction.

   Example:
   User sends 0.002 ETH.

2. Capture ETH Amount
   Solidity automatically stores the sent ETH in:

   msg.value

3. Convert ETH → USD
   The contract converts the ETH value to USD using the Chainlink
   price feed via the PriceConverter library:

   msg.value.getConversionRate(s_priceFeed)

   Example:
   If the price of ETH = $2000

   0.002 ETH × 2000 = $4

4. Minimum Funding Check
   The contract checks whether the USD value is greater than or equal
   to the minimum required funding amount.

   MINIMUM_USD = $5

   If the sent ETH is worth less than $5:
   The transaction is reverted and the user sees the error message:

   "You need to spend more ETH!"

5. Record the Funding
   If the requirement is satisfied:

   addressToAmountFunded[msg.sender] += msg.value

   This updates the mapping that stores how much ETH each
   address has contributed.

6. Store the Funder Address
   funders.push(msg.sender)

   This adds the user's address to the funders array so the contract
   can keep track of all contributors.

Summary:
- The function ensures users send at least $5 worth of ETH.
- It records how much each address has funded.
- It also stores the list of all funders.
-----------------------------------------------------------
*/

/*
-----------------------------------------------------------
FUND FUNCTION (the code)
-----------------------------------------------------------

function fund() public payable {
    require(msg.value.getConversionRate(s_priceFeed) >= MINIMUM_USD, "You need to spend more ETH!");
    addressToAmountFunded[msg.sender] += msg.value;
    funders.push(msg.sender);
}
*/