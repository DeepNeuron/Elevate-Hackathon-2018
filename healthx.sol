pragma solidity ^0.4.23;

contract HealthXV1 {
	uint256 DATA_PAYMENT = 100000;

	address owner;

	constructor() {
		owner = msg.sender;
		validSigners[owner] = true;
	}

	/* data submission */
	mapping (address => bool) public validSigners;

	event SignerAdded(address _addr);
	event DataSubmission(address _addr, bytes msg);

	modifier onlyOwner {
		require(msg.sender == owner);
		_;
	}

	function changeOwner(address _addr) public onlyOwner {
		owner = _addr;
	}

	function addSigner(address _addr) public onlyOwner {
		validSigners[_addr] = true;
		emit SignerAdded(_addr);
	}

	function submitData(bytes m, address patient) public {
		//require(verifyMessage(m, v, r, s));
		require(validSigners[msg.sender]);
		patient.transfer(DATA_PAYMENT);
		emit DataSubmission(msg.sender, m);
	}

	function verifyMessage(bytes m, uint8 v, bytes32 r, bytes32 s) internal returns (bool) {
		bytes memory prefix = "\x19Ethereum Signed Message:\n32";
		address signer = ecrecover(keccak256(prefix,m), v, r, s);
		return validSigners[signer];
	}

	/* data access */
	uint256 ACCESS_PAYMENT = 1000;
	mapping (address => bool) accessList;

	function getAccess() public payable {
		require(msg.value > ACCESS_PAYMENT);
		accessList[msg.sender] = true;
	}
}