export const CONTRACT_ADDRESS = '0x6b1Dc4d4faAC2b9d8545aEed2469Ed5838f88968' // on Sepolia

export const CONTRACT_ABI = [
  {
    type: 'function',
    name: 'addPerson',
    inputs: [
      { name: '_name', type: 'string', internalType: 'string' },
      {
        name: '_favoriteNumber',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
  {
    type: 'function',
    name: 'listOfPeople',
    inputs: [{ name: '', type: 'uint256', internalType: 'uint256' }],
    outputs: [
      { name: 'name', type: 'string', internalType: 'string' },
      {
        name: 'favoriteNumber',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'nameToFavoriteNumber',
    inputs: [{ name: '', type: 'string', internalType: 'string' }],
    outputs: [{ name: '', type: 'uint256', internalType: 'uint256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'retrieve',
    inputs: [],
    outputs: [{ name: '', type: 'uint256', internalType: 'uint256' }],
    stateMutability: 'view',
  },
  {
    type: 'function',
    name: 'store',
    inputs: [
      {
        name: '_favoriteNumber',
        type: 'uint256',
        internalType: 'uint256',
      },
    ],
    outputs: [],
    stateMutability: 'nonpayable',
  },
]
