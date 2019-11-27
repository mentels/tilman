# TilManager

## Building

For development & testing:

```shell
mix escript.build 
```

For production:

```shell
MIX_ENV=prod mix escript.build 
```

Releasing:

```shell
make publish
```

## Running

* To add a new TIL:
  `TIL_PATH="path/to/til/" TIL_PATH=./til ./tilman --category elixir --title halo6 "jakiś tam content" --debug`

* To print version:
  `./tilman --version`

> `TIL_PATH` defaults to ".".