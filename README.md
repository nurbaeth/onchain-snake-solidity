# 🐍 Onchain Snake Game (Solidity)      
      
> Classic Snake game — fully on-chain. No UI. No frontend. No backend. Just smart contracts and your address.   
       
Welcome to the **first-ever Snake game built entirely in Solidity** — designed for Ethereum-compatible chains, playable by any address, and 100% trustless.    
           
## 🎮 How It Works   
       
Each player (address) has their own game session stored on-chain:   
       
- Move your snake with `move()` and `changeDirection()`. 
- Eat food to grow.    
- Hit walls or yourself? You're dead.  
- Everything is public. Everything is stored in the contract.  
    
🟩 This game has no rewards. No tokens. No RNG oracles. Just code.   
    
## 🧠 Contract Logic   
      
- Grid size: `10 x 10`   
- Snake starts in center, heading right.  
- Food position generated with `keccak256` pseudo-randomness.  
- All positions and game state are stored in `mapping(address => Game)`. 
 
## 🛠 Functions

| Function | Description |  
|---------|-------------|  
| `startGame()` | Start or restart your own game. |  
| `changeDirection(Direction)` | Change snake direction: `0=Up`, `1=Down`, `2=Left`, `3=Right`. |  
| `move()` | Moves the snake one step forward. |  
| `getSnake(address)` | Returns full snake body as an array of (x, y). |  
| `isAlive(address)` | Returns `true` if player is still alive. |

## ✨ Example

```solidity
contract SnakeBot {
    SnakeGame public game;

    constructor(address snakeGameAddress) {
        game = SnakeGame(snakeGameAddress);
    }

    function play() external {
        game.startGame();
        game.changeDirection(SnakeGame.Direction.Right);
        for (uint i = 0; i < 10; i++) {
            game.move();
        }
    }
}
