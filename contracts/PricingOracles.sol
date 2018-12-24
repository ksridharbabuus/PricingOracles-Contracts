pragma solidity 0.5.1;
import "github.com/oraclize/ethereum-api/oraclizeAPI_0.5.sol";

contract PricingOracles is usingOraclize {

   string public AGIPrice;
   event LogConstructorInitiated(string nextStep);
   event LogPriceUpdated(string price);
   event LogNewOraclizeQuery(string description);
   event UpdateURL (string url);
   event UpdateOwner (address owner);
   
   string public sURL;
   uint public scheduleInSec;
   address payable public owner;

   constructor(string memory _sURL, uint256 _frequencyInSec) public {
       emit LogConstructorInitiated("Constructor was initiated. Call 'updatePrice()' to send the Oraclize Query.");
       sURL = _sURL;
       scheduleInSec = _frequencyInSec;
       owner = msg.sender;
   }

   function updateURL(string memory _sURL) public {
       require(msg.sender == owner);
       sURL = _sURL;
       emit UpdateURL(sURL);
   }

   function updateSchedule(uint256 _frequencyInSec) public {
       require(msg.sender == owner);
       scheduleInSec = _frequencyInSec;
   }
   
   function updateOwner(address payable _owner) public {
       require(msg.sender == owner);
       owner = _owner;
       emit UpdateOwner(_owner);
   }

   function __callback(bytes32 myid, string memory result) public {
       if (msg.sender != oraclize_cbAddress()) revert();
       AGIPrice = result;
       
       emit LogPriceUpdated(result);
       
       if(scheduleInSec > 0) {
            updatePrice();
        }
   }

   function updatePrice() public {
       
       if(!(msg.sender == owner || msg.sender == oraclize_cbAddress())) revert();
       
       if (oraclize_getPrice("URL") > address(this).balance) {
           
           emit LogNewOraclizeQuery("Oraclize query was NOT sent, please add some ETH to cover for the query fee");
       
       } else {
           
           emit LogNewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
           
           if(scheduleInSec == 0) {
                oraclize_query("URL", sURL);
           }
           else {
               oraclize_query(scheduleInSec, "URL", sURL);
           }
           //"json(https://api.pro.coinbase.com/products/ETH-USD/ticker).price"
       }
   }
   
   function() external payable { } // Directly to deposit into the contract
   
   function withdraw(uint256 amount) public {
       require(msg.sender == owner);
       require(address(this).balance >= amount);
       owner.transfer(amount);
   }
}