# dockerizing-4g

What about [open5gs](https://github.com/open5gs/open5gs) and [srsRAN](https://github.com/srsran/srsran_4g) in a docker?

## Usage

```sh
docker compose up --force-recreate --build

# rebuild without cache or just docker system prune -a
docker compose build --no-cache

# see log of service (ue)
docker compose logs ue -f
```
