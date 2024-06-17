/* eslint-disable @typescript-eslint/no-explicit-any */
import { useEffect, useState } from 'react'
import { ethers } from 'ethers'
import { CONTRACT_ABI, CONTRACT_ADDRESS } from './constants'
import type { BrowserProvider, JsonRpcSigner, Network } from 'ethers'

declare const window: Window & {
  ethereum?: any
}

const availableNetworks = [
  { name: 'Ethereum Mainnet', chainId: 1n },
  { name: 'Testnet - Sepolia', chainId: 11155111n },
  { name: 'Local - Anvil', chainId: 31337n },
  { name: 'Local - Ganache', chainId: 1337n },
]

function App() {
  const [hasMetaMaskInstalled, setHasMetaMaskInstalled] = useState<
    boolean | null
  >(null)

  useEffect(() => {
    setHasMetaMaskInstalled(!!window.ethereum)
  }, [])

  const [provider, setProvider] = useState<BrowserProvider | null>(null)

  const [accounts, setAccounts] = useState<Array<string>>([])
  const [contract, setContract] = useState<ethers.Contract | null>(null)
  const [network, setNetwork] = useState<Network | null>(null)

  const hasMetaMaskConnected = accounts.length > 0

  const onLoadProvider = async () => {
    if (!window.ethereum) {
      throw new Error('MetaMask is not installed')
    }

    const providerInstance = new ethers.BrowserProvider(window.ethereum)
    setProvider(providerInstance)
    return providerInstance
  }

  const onLoadSigner = async (provider: BrowserProvider) => {
    return await provider.getSigner()
  }

  const onLoadAccounts = async (provider: BrowserProvider) => {
    const accountsData = await provider.send('eth_requestAccounts', [])
    setAccounts(accountsData)
  }

  const onLoadContract = async (signer: JsonRpcSigner) => {
    const contractData = new ethers.Contract(
      CONTRACT_ADDRESS,
      CONTRACT_ABI,
      signer
    )
    setContract(contractData)
  }

  const onLoadNetwork = async (provider: BrowserProvider) => {
    const networkData = await provider.getNetwork()
    setNetwork(networkData)
  }

  const onLoadData = async () => {
    const provider = await onLoadProvider()
    const signer = await onLoadSigner(provider)

    await onLoadAccounts(provider)
    await onLoadContract(signer)
    await onLoadNetwork(provider)
  }

  const onConnectMetaMask = async () => {
    try {
      await onLoadData()
    } catch (error) {
      alert(error)
    }
  }

  const onSwitchNetwork = async (chainId: bigint) => {
    if (!provider) {
      return
    }

    try {
      await provider.send('wallet_switchEthereumChain', [
        { chainId: `0x${chainId.toString(16)}` },
      ])

      await onLoadData()
    } catch (error) {
      alert(error)
    }
  }

  const [inputContractAddress, setInputContractAddress] =
    useState(CONTRACT_ADDRESS)
  const [inputStoreValue, setInputStoreValue] = useState('')

  const handleContractStore = async (value: string) => {
    if (!contract) {
      throw new Error(`Contract hasn't been initialized`)
    }

    try {
      await contract.store(value)
      alert('Transaction sent (need to wait for confirming)')
    } catch (error) {
      alert(error)
    }
  }

  const handleContractRetrieve = async () => {
    if (!contract) {
      throw new Error(`Contract hasn't been initialized`)
    }

    try {
      alert(await contract.retrieve())
    } catch (error) {
      alert(error)
    }
  }

  if (hasMetaMaskInstalled === null) {
    return <div>Loading...</div>
  }

  if (hasMetaMaskInstalled === false) {
    return <div>Please install MetaMask first.</div>
  }

  return (
    <div>
      <h1>Simple Storage Contract</h1>

      <div>
        <h2>Connect MetaMask</h2>
        <p>
          Please connect your MetaMask wallet before proceeding with any
          operations.
        </p>
        {!hasMetaMaskConnected && (
          <button
            onClick={() => {
              onConnectMetaMask()
            }}
          >
            Connect MetaMask
          </button>
        )}
        {hasMetaMaskConnected && (
          <button disabled>MetaMask is connected</button>
        )}
      </div>

      <div>
        <h2>Switch Networks</h2>
        <p>
          The network switch feature is provided here for demonstration purposes
          only. The actual contract is deployed exclusively on the Sepolia
          Testnet.
        </p>
        <div>
          {availableNetworks.map(({ name, chainId }) => (
            <div key={chainId}>
              <button
                onClick={() => {
                  onSwitchNetwork(chainId)
                }}
              >
                {name}{' '}
                {network && chainId === network.chainId ? '(current)' : ''}
              </button>
            </div>
          ))}
        </div>
      </div>

      <div>
        <h2>Accounts</h2>
        <ul>
          {accounts.length === 0 && <li>No accounts available</li>}
          {accounts.map((account) => (
            <li key={account}>{account}</li>
          ))}
        </ul>
      </div>

      <div>
        <h2>Simple Storage Contract</h2>
        <div>
          <h3>Address</h3>
          <div>
            <input
              value={inputContractAddress}
              onChange={(event) => {
                setInputContractAddress(event.target.value)
              }}
              size={40}
            />
            <button
              onClick={() => {
                onLoadData()
              }}
              disabled={accounts.length === 0}
            >
              Update Address
            </button>
          </div>
          <div>Contract initialized: {contract ? 'Yes' : 'No'}</div>
        </div>
        <div>
          <h3>Interactions</h3>
          <div>
            <h4>Store</h4>
            <input
              value={inputStoreValue}
              onChange={(event) => {
                setInputStoreValue(event.target.value)
              }}
              size={10}
            />
            <button
              onClick={() => {
                handleContractStore(inputStoreValue)
              }}
            >
              store(uint256)
            </button>
          </div>
          <h4>Retrieve</h4>
          <button
            onClick={() => {
              handleContractRetrieve()
            }}
          >
            retrieve()
          </button>
        </div>
      </div>
    </div>
  )
}

export default App
