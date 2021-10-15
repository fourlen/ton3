
/**
 * This file was generated by TONDev.
 * TONDev is a part of TON OS (see http://ton.dev).
 */
pragma ton-solidity >= 0.35.0;
pragma AbiHeader expire;

// This is class that describes you smart contract.
contract TaskList {
    // Contract can have an instance variables.
    // In this example instance variable `timestamp` is used to store the time of `constructor` or `touch`
    // function call

    struct Task {
        string name;
        uint32 time;
        bool isCompleted;    
    }
    uint32 public timestamp;
    int8 currentId = -128;
    mapping (int8=> Task) taskList;

    // Contract can have a `constructor` – function that will be called when contract will be deployed to the blockchain.
    // In this example constructor adds current time to the instance variable.
    // All contracts need call tvm.accept(); for succeeded deploy
    constructor() public {
        // Check that contract's public key is set
        require(tvm.pubkey() != 0, 101);
        // Check that message has signature (msg.pubkey() is not zero) and
        // message is signed with the owner's private key
        require(msg.pubkey() == tvm.pubkey(), 102);
        // The current smart contract agrees to buy some gas to finish the
        // current transaction. This actions required to process external
        // messages, which bring no value (henceno gas) with themselves.
        tvm.accept();

        timestamp = now;
    }

    modifier checkOwnerAndAccept {
		require(msg.pubkey() == tvm.pubkey(), 102);
		tvm.accept();
		_;
	}

    function addTask(string name) public checkOwnerAndAccept {
        taskList[currentId] = Task(name, now, false);
        currentId++;
    }

    function getOpenTaskCount() public checkOwnerAndAccept returns(uint8) {
        uint8 count = 0;
        for (int8 i = -128; i < currentId; i++) {
            if (!taskList[i].isCompleted && taskList[i].name != "") {
                count++;
            }
        }
        return count;
    }

    function getTasks() public checkOwnerAndAccept returns(mapping(int8 => Task)) {
        return taskList;
    }

    function getTask(int8 id) public checkOwnerAndAccept returns(Task) {
        return taskList[id];
    }

    function deleteTask(int8 id) public checkOwnerAndAccept {
        delete taskList[id];
    }

    function makeCompleteTask(int8 id) public checkOwnerAndAccept {
        taskList[id].isCompleted = true;
    }
}