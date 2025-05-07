// SPDX-License-Identifier: MIT
pragma solidity ^0.8.24;

contract SnakeGame {
    uint8 constant WIDTH = 10;
    uint8 constant HEIGHT = 10;

    enum Direction { Up, Down, Left, Right }

    struct Position {
        uint8 x;
        uint8 y;
    }

    struct Game {
        Position[] snake;
        Direction direction;
        Position food;
        bool alive;
    }

    mapping(address => Game) public games;

    function startGame() external {
        Game storage game = games[msg.sender];
        delete game.snake;

        game.snake.push(Position(5, 5));
        game.direction = Direction.Right;
        game.food = _generateFood();
        game.alive = true;
    }

    function changeDirection(Direction newDirection) external {
        require(games[msg.sender].alive, "Game not active");
        games[msg.sender].direction = newDirection;
    }

    function move() external {
        Game storage game = games[msg.sender];
        require(game.alive, "Game over");

        Position memory head = game.snake[0];
        Position memory newHead = head;

        if (game.direction == Direction.Up) newHead.y--;
        else if (game.direction == Direction.Down) newHead.y++;
        else if (game.direction == Direction.Left) newHead.x--;
        else if (game.direction == Direction.Right) newHead.x++;

        // Check wall collision
        if (newHead.x >= WIDTH || newHead.y >= HEIGHT) {
            game.alive = false;
            return;
        }

        // Check self collision
        for (uint i = 0; i < game.snake.length; i++) {
            if (game.snake[i].x == newHead.x && game.snake[i].y == newHead.y) {
                game.alive = false;
                return;
            }
        }

        // Move snake
        game.snake.unshift(newHead);

        // Check food
        if (newHead.x == game.food.x && newHead.y == game.food.y) {
            game.food = _generateFood();
        } else {
            game.snake.pop();
        }
    }

    function getSnake(address player) external view returns (Position[] memory) {
        return games[player].snake;
    }

    function isAlive(address player) external view returns (bool) {
        return games[player].alive;
    }

    function _generateFood() private view returns (Position memory) {
        // WARNING: not secure randomness
        uint256 rand = uint256(keccak256(abi.encodePacked(block.timestamp, blockhash(block.number - 1), msg.sender)));
        return Position(uint8(rand % WIDTH), uint8((rand / WIDTH) % HEIGHT));
    }
}
