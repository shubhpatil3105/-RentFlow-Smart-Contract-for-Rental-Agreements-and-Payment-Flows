// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract RentFlow {
    struct Agreement {
        address landlord;
        address tenant;
        uint256 rentAmount;
        uint256 dueDate;
        bool active;
    }

    uint256 public agreementCounter;
    mapping(uint256 => Agreement) public agreements;

    event AgreementCreated(uint256 indexed id, address indexed landlord, address tenant, uint256 rentAmount, uint256 dueDate);
    event RentPaid(uint256 indexed id, address indexed tenant, uint256 amount);
    event AgreementTerminated(uint256 indexed id);

    function createAgreement(address tenant, uint256 rentAmount, uint256 dueDate) external returns (uint256) {
        agreementCounter++;
        agreements[agreementCounter] = Agreement(msg.sender, tenant, rentAmount, dueDate, true);
        emit AgreementCreated(agreementCounter, msg.sender, tenant, rentAmount, dueDate);
        return agreementCounter;
    }

    function payRent(uint256 id) external payable {
        Agreement storage agreement = agreements[id];
        require(agreement.active, "Agreement not active");
        require(msg.sender == agreement.tenant, "Only tenant can pay");
        require(msg.value == agreement.rentAmount, "Incorrect rent amount");

        payable(agreement.landlord).transfer(msg.value);
        emit RentPaid(id, msg.sender, msg.value);
    }

    function terminateAgreement(uint256 id) external {
        Agreement storage agreement = agreements[id];
        require(msg.sender == agreement.landlord || msg.sender == agreement.tenant, "Not authorized");
        agreement.active = false;
        emit AgreementTerminated(id);
    }
}
