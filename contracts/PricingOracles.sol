pragma solidity 0.5.1;
import "github.com/oraclize/ethereum-api/oraclizeAPI_0.5.sol";

contract PricingOracles is usingOraclize {

   string public AGIPrice;

   string public sURL;
   uint public scheduleInSec;
   address payable public owner;

   event PriceUpdated(string price);
   event NewOraclizeQuery(string description);
   event URLUpdated (string url);
   event NewOwner (address owner);
   event NewSchedule(uint256 recurrenceInSec);
   
   constructor(string memory _sURL, uint256 _frequencyInSec) public {
       sURL = _sURL;
       scheduleInSec = _frequencyInSec;
       owner = msg.sender;
   }

   function updateURL(string memory _sURL) public {
       require(msg.sender == owner);
       sURL = _sURL;
       emit URLUpdated(sURL);
   }

   function updateSchedule(uint256 _frequencyInSec) public {
       require(msg.sender == owner);
       scheduleInSec = _frequencyInSec;
       emit NewSchedule(_frequencyInSec);
   }
   
   function updateOwner(address payable _owner) public {
       require(msg.sender == owner);
       owner = _owner;
       emit NewOwner(_owner);
   }

   function __callback(bytes32 myid, string memory result) public {
       if (msg.sender != oraclize_cbAddress()) revert();
       AGIPrice = result;
       
       emit PriceUpdated(result);
       
       if(scheduleInSec > 0) {
            updatePrice();
        }
   }

   function updatePrice() public {
       
       if(!(msg.sender == owner || msg.sender == oraclize_cbAddress())) revert();
       
       if (oraclize_getPrice("URL") > address(this).balance) {
           
           emit NewOraclizeQuery("Oraclize query was NOT sent, not enough fee");
       
       } else {
           
           emit NewOraclizeQuery("Oraclize query was sent, standing by for the answer..");
           
           if(scheduleInSec == 0) {
                oraclize_query("URL", sURL);
           }
           else {
               oraclize_query(scheduleInSec, "URL", sURL);
           }
       }
   }
   
   function() external payable { } // Directly to deposit into the contract
   
   function withdraw(uint256 amount) public {
       require(msg.sender == owner);
       require(address(this).balance >= amount);
       owner.transfer(amount);
   }
}