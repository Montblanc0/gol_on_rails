# Game of Life (Rails Project)

My implementation of John Conway's [Game of Life](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life "Game of Life").

This project was made with Ruby v3.0.2 and Rails v7.0.4.2.

Database is PostgreSQL and caching is handled with Redis.

<p align="center"><img src="https://i.ibb.co/NKd3Pr4/gol.webp" alt="Game of Life (Rails Project)"></p>

## Game Instructions

This game follows the [original rules](https://en.wikipedia.org/wiki/Conway%27s_Game_of_Life#Rules) but also adds a "Pac-Man Effect" on every border.

After signing up or logging in, you will be redirected to the main page where you will be prompted to either generate a new board by selecting a size **from 10 to 40** or to import a JSON file to restore the state of a board.

If you're unhappy with the generated board, you may click on **RANDOM** to generate a new random board.

You can also **toggle the alive/dead state of any cell** while the game is not running.

Select your desired game *SPEED* by choosing from three different options:

 - **SLOW** -> 2000ms
 - **NORMAL** -> 1000ms (this is default)
 - **FAST** -> 500ms

Press **START** to start the game and watch as life evolves and the **GEN** count increases.

Press **STOP** to pause the game.

Press **NEXT** to load the next generation only.

You can also **CLEAR** the board and draw your own.

Finally, you can **EXPORT** the current board to a JSON file.

If the game reaches a **standstill**, it will stop and recommend that you generate a new board or make some custom changes.

## Development Setup

Make sure to have [Ruby v3.0.2](https://www.phusionpassenger.com/library/walkthroughs/deploy/ruby/ownserver/nginx/oss/install_language_runtime.html), [Rails](https://guides.rubyonrails.org/getting_started.html),  [PostgreSQL](https://www.postgresql.org/) and [Redis](https://redis.io/docs/getting-started/) installed on your machine.

Make sure to have both PostgreSQL and Redis services up and running.

You may need to change the `REDIS_URL` environment variable in `config/environments/development.rb`.

Change development variables in `config/database.yml` according to your PostgreSQL setup. 

Open a shell at the root of this project and run:

```shell
$ bundle install
$ ruby bin/rails db:prepare
$ ruby bin/rails server
```
Navigate to `http://localhost:3000`.
### Credits

Icons: [Alien icons by Freepik - Flaticon](https://www.flaticon.com/free-icons/alien)
