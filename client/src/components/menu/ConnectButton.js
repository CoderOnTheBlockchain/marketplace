import React, { useEffect, useState } from "react";
import getWeb3 from "../../getWeb3";

async function connect(onConnected) {
    if (!window.ethereum) {
      alert("Get MetaMask!");
      return;
    }
  
    const accounts = await window.ethereum.request({
      method: "eth_requestAccounts",
    });
  
    onConnected(accounts[0]);
};

async function checkIfWalletIsConnected(onConnected) {
    if (window.ethereum) {
      const accounts = await window.ethereum.request({
        method: "eth_accounts",
      });
  
      if (accounts.length > 0) {
        const account = accounts[0];
        onConnected(account);
        return;
      }
    }
}

function logout() {
    // todo
}

function Connect({ setUserAddress }) {
    return (
      <button onClick={() => connect(setUserAddress)}>
        Connect wallet
      </button>
    );
};

function Address({ userAddress }) {
    return (
        <button className="btn-main" onClick={ () => logout()}>
            {userAddress.substring(0, 5)}…{userAddress.substring(userAddress.length - 4)}
        </button>
    );
}

export default function ConnectButton() {
    const [userAddress, setUserAddress] = useState("");

    useEffect(() => {
        checkIfWalletIsConnected(setUserAddress);
    }, []);
    
    return userAddress ? (
        <Address userAddress={userAddress} />
    ) : (
        <Connect setUserAddress={setUserAddress}/>
    );
};
