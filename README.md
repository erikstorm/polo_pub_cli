# polo_pub_cli

## Description:

Very simple cli app for checking  [Poloniex](https://poloniex.com/) prices from the public api. Compiled binary works on all platforms that have some version of [erlang](http://www.erlang.org/downloads) installed. If you want to compile yourself you need to install [elixir](https://elixir-lang.org/install.html).

## Install:

Get dependencies

`mix deps.get`

Compile

`mix escript.build`

Run 

`./polo_pub_cli`

## Usage:

`./polo_pub_cli [option] [CURRENCY_PAIR]`

## Options:

`--price` 	 Gets currency pair price.

`--watch` 	 Gets price every 15 seconds.

`--ticker` 	 Print exchange ticker.

`--help`  	 Show help message.

## Examples: 	
`./polo_pub_cli --price "BTC_ETH"`
          	
`./polo_pub_cli --watch "BTC_LTC"`

`./polo_pub_cli --ticker`



