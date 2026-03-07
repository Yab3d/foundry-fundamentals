========================================================
🚀 FUNDMEE SMART CONTRACT DOCUMENTATION
========================================================

Project Description
-------------------

FundMe is a decentralized crowdfunding smart contract
built using Solidity and Chainlink Oracle integration.

Features:

✔ ETH Funding System  
✔ USD Minimum Funding Check  
✔ Owner Withdrawal Protection  
✔ Price Conversion Using Chainlink  
✔ Secure Withdraw Pattern  

Badges:

[Solidity] [DeFi] [Blockchain] [Security Checked]


========================================================
ARCHITECTURE
========================================================

Users
  │
  │ send ETH
  ▼
FundMe Contract
  ├── fund()
  ├── withdraw()
  ├── receive()
  ├── fallback()
  │
  ├── PriceConverter Library
  │        │
  │        └── Chainlink Oracle Price Feed
  │
  └── Storage Layer
           ├── mapping(address => amount)
           └── funders array


========================================================
FUNDING FLOW
========================================================

User Sends ETH
       │
       ▼
fund() function executes
       │
       ├── Check ETH value in USD
       ├── Update funding mapping
       └── Add sender to funders list


Example:

User sends:
0.002 ETH

ETH Price:
1 ETH = $2000

Converted Value:
0.002 × 2000 = $4

If value < $5 → Transaction Reverts


========================================================
WITHDRAW FUNCTION
========================================================

Function:

function withdraw() public onlyOwner


Purpose
-------

Allows contract owner to withdraw ALL ETH stored inside
the smart contract.


Execution Flow
--------------

withdraw()
   │
   ▼
onlyOwner modifier
   │
   ├── TRUE → Continue execution
   └── FALSE → Revert transaction


========================================================
CONTRACT STATE BEFORE WITHDRAW
========================================================

Example Data:

Funders:
A → 1 ETH
B → 2 ETH
C → 0.5 ETH

Mapping Storage:

addressToAmountFunded[A] = 1 ETH
addressToAmountFunded[B] = 2 ETH
addressToAmountFunded[C] = 0.5 ETH

Funders Array:

[A, B, C]

Contract Balance:

3.5 ETH


========================================================
STEP 1 — LOOP THROUGH FUNDERS
========================================================

Code:

for (uint256 i = 0; i < funders.length; i++)

Iteration Example:

Index 0 → A
Index 1 → B
Index 2 → C


Purpose:

Reset funding records for all contributors.


========================================================
STEP 2 — RESET FUNDING MAPPING
========================================================

Code:

addressToAmountFunded[funder] = 0;


Before Reset:

A → 1 ETH
B → 2 ETH
C → 0.5 ETH


After Reset:

A → 0
B → 0
C → 0


Reason:

Prepare contract for new funding cycle.


========================================================
STEP 3 — RESET FUNDERS ARRAY
========================================================

Code:

funders = new address;


Before:

[A, B, C]

After:

[]


========================================================
STEP 4 — SEND ETH TO OWNER
========================================================

Code:

(bool success,) = payable(msg.sender).call{
    value: address(this).balance
}("");


Meaning:

Send ALL contract ETH → Owner wallet


Example:

Contract Balance = 3.5 ETH
Owner receives = 3.5 ETH


========================================================
STEP 5 — VERIFY TRANSFER
========================================================

Code:

require(success, "Call failed");


If transfer fails:

Transaction reverts
No state changes are saved


========================================================
SECURITY PATTERN USED
========================================================

Checks → Effects → Interactions

Order:

1. Verify ownership
2. Update contract storage
3. Send ETH externally


Prevents:

Reentrancy attacks
Unauthorized withdrawals


========================================================
PRICE CONVERSION SYSTEM
========================================================

FundMe uses Chainlink Oracle.

Flow:

User Sends ETH
     │
     ▼
PriceConverter Library
     │
     ▼
Chainlink Price Feed
     │
     ▼
ETH → USD Conversion


========================================================
MATH PRECISION IN SOLIDITY
========================================================

Solidity uses:

18 decimal precision

Conversion Formula:

ethAmountInUsd =
(ethPrice * ethAmount) / 1e18


Reason:

Remove decimal overflow
Maintain financial accuracy


========================================================
SMART CONTRACT CONCEPTS USED
========================================================

✔ Smart contract ownership  
✔ Oracle integration  
✔ Fixed-point arithmetic  
✔ Secure ETH transfers  
✔ Mapping + Array storage  
✔ Gas efficient design  

========================================================