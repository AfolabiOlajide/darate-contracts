// SPDX-License-Identifier: MIT
pragma solidity ^0.8.9;

contract DarateOrganization {
    string public name;
    string public description;
    uint256 public totalAmountRaised;
    address public owner;
    Donator[] public donators;
    Invoice[] public invoiceIds;

    struct Donator {
        address donator;
        uint256 amountDonated;
    }

    struct Invoice {
        string invoiceId;
        string paymentTxHash;
    }

    constructor(address _owner, string memory _name, string memory _description) {
        owner = _owner;
        name = _name;
        description = _description;
    }

    function donate(address _donator, uint256 _amountDonated) public {
        totalAmountRaised += _amountDonated;
        donators.push(Donator({donator: _donator, amountDonated: _amountDonated}));
    }

    function addInvoiceId(string memory _invoiceId) public {
        invoiceIds.push(Invoice({invoiceId: _invoiceId, paymentTxHash: ""}));
    }

    function addPaymentTxHash(string memory _invoiceId, string memory _paymentTxHash) public {
        for (uint256 i = 0; i < invoiceIds.length; i++) {
            if (keccak256(abi.encodePacked(invoiceIds[i].invoiceId)) == keccak256(abi.encodePacked(_invoiceId))) {
                invoiceIds[i].paymentTxHash = _paymentTxHash;
                break;
            }
        }
    }

    function getInvoiceIds() public view returns (Invoice[] memory) {
        return invoiceIds;
    }

    function getDonators() public view returns (Donator[] memory) {
        return donators;
    }

    function withdraw() public {
        require(msg.sender == owner, "You are not the owner");
        payable(owner).transfer(address(this).balance);
    }
}