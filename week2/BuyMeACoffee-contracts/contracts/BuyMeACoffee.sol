// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

// Deployed to Goerli at 0x89B9E9DECb22ba20519570a3AC13ddE85804F93D

contract BuyMeACoffee {
    // Event to emit when a Memo is created
    event NewMemo(
        address indexed from,
        uint256 timestamp,
        string name,
        string message
    );

    // Memo struct.
    struct Memo {
        address from;
        uint256 timestamp;
        string name;
        string message;
    }

    // List of all memos received from friends.
    Memo[] memos;

    // Address of contract deployer
    address payable owner;

    // Deploy logic.
    constructor() {
        owner = payable(msg.sender);
    }

    // Modifier that only allows owner to call a function.
    modifier onlyOwner {
        require(msg.sender == owner, "");
        _;
    }

    /**
    * @dev lets the owner set a different owner for the contract.
    * @param _newOwner address of the new owner.
    */
    function createNewOwner(address _newOwner) public onlyOwner{
        owner = payable(_newOwner);
    }

    /**
    * @dev buy a coffee for contract owner
    * @param _name name of the coffee buyer
    * @param _message a nice message from the coffee buyer
    */
    function buyCoffee(string memory _name, string memory _message) public payable {
        require(msg.value > 0, "You can't biy coffee with 0 eth");

        // Add the memo to storage
        memos.push(Memo(
            msg.sender,
            block.timestamp,
            _name,
            _message
        ));

        // Emit a log event when new memo is created!
        emit NewMemo(msg.sender, block.timestamp, _name, _message);
    }

    /**
    * @dev send the entire balance stored in this contract to the owner
    */
    function withdrawTips() public {
        require(owner.send(address(this).balance));

    }

    /**
    * @dev retrieve all the memos recieved and stored on the blockchain
    */
    function getMemos() public view returns(Memo[] memory) {
        return memos;
    }
}
