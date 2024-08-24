// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract Crowding {

    struct Campaign {
        string CampaignName;
        string Description;
        address payable receiver;
        uint fundRaisingGoal;
        uint deadline; 
        uint amountRaised;
        uint campaign_ID;
        bool exists;
    }


    mapping(address => Campaign) private campaigns;

    
    modifier campaignExists(address _title) {
        require(campaigns[_title].exists, "Campaign does not exist");
        _;
    }
  

    //Events
    event CampaignCreated(address indexed campaignCreator);

    event DonationReceived(address indexed from, address indexed to, uint256 amount);

    event CampaignEnded(address indexed from, address indexed to, uint256 amount);


    //Create Campaign
    function createCampaign(
        string memory _title,
        string memory _description,
        string memory _benefactor,
        uint _goal,
        uint duration
    ) public campaignExists(_title) {
        require(!campaigns[_title].exists, "Account already exists"); 

        campaigns[_title] = Campaign(0, true);
        emit CampaignCreated(_title);
    }


    // Donate To Campaign
    function DonateToCampaign(
        address _to, uint256 _amount, 
        uint _campaignID,
        uint _fundRaisingGoal) 
        public payable campaignExists(msg.sender) {

        campaigns[msg.sender].balance -= _amount;
        campaigns[_to].balance += _amount;
        emit DonationReceived(msg.sender, _to, _amount);
    }
    
    function EndCampaign(
        address _to, uint256 _amount, 
        uint _campaignID,
        uint _fundRaisingGoal
    ) public{
        if (campaigns[msg.sender].balance < campaigns[_fundRaisingGoal]) {
            emit DonationReceived(msg.sender, _to, _amount);
        }

        
    }

}
