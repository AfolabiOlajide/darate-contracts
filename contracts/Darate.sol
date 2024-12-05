// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

import { DarateCampaign } from "./DarateCampaign.sol";
import { DarateOrganization } from "./DarateOrganization.sol";

contract Darate {
    address public owner;

    struct Campaign {
        address campaignAddress;
        address owner;
        string title;
        uint256 creationTime;
    }

    struct Organization {
        address organizationAddress;
        address owner;
        string name;
        uint256 creationTime;
    }

    Campaign[] public campaigns;
    Organization[] public organizations;
    mapping(address => Campaign[]) public userCampaigns;
    mapping(address => address) public userOrganization;
    mapping(address => bool) public userHasOrganization;

    modifier userHasNoOrganization() {
        require(!userHasOrganization[msg.sender], "You already have an organization");
        _;
    }

    constructor() {
        owner = msg.sender;
    }
    
    function createCampaign(string memory _title, string memory _description, string memory _category, uint256 _targetAmount) public {
        DarateCampaign newCampaign = new DarateCampaign(msg.sender, _title, _description, _category, _targetAmount);
        address campaignAddress = address(newCampaign);
        Campaign memory campaign = Campaign({
            campaignAddress: campaignAddress, 
            owner: msg.sender, 
            title: _title, 
            creationTime: block.timestamp
        });
        campaigns.push(campaign);
        userCampaigns[msg.sender].push(campaign);
    }

    function createOrganization(string memory _name, string memory _description) public userHasNoOrganization {
        DarateOrganization newOrganization = new DarateOrganization(msg.sender, _name, _description);
        address organizationAddress = address(newOrganization);
        Organization memory organization = Organization({
            organizationAddress: organizationAddress, 
            owner: msg.sender, 
            name: _name, 
            creationTime: block.timestamp
        });
        organizations.push(organization);
        userOrganization[msg.sender] = organizationAddress;
        userHasOrganization[msg.sender] = true;
    }

    function getUserCampaigns() public view returns (Campaign[] memory) {
        return userCampaigns[msg.sender];
    }

    function getUserOrganization() public view returns (address) {
        return userOrganization[msg.sender];
    }

    function getAllCampaigns() public view returns (Campaign[] memory) {
        return campaigns;
    }

    function getAllOrganizations() public view returns (Organization[] memory) {
        return organizations;
    }
}