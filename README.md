<p align="center">
  <img src="docs/logo300.png" />
</p>

# nettis 

nettis is BA-zone whois builder that should be cheap to keep alive and cost
totally 0 to make.

Optimization:

* Grep value of found domain in a textual database, simplest storage
* Get return shell code and append/upsert/etc.
* On [file change](http://entrproject.org/) push to remote (git)

* Periodically check registered domains
* Once domain is alive (i.e. returns 200), get the hostname addr
* Use reverse IP to get other domains hosted on that server
* If it's logically zone domain, transfer to domains list and repeat the same
  process

* Bot never asleep and should have something to "do" all the time, (scan again)
* We are getting newest, but also older zone domains
* Good collection. Nice one!

## Installation

```
$ ...
```

## Usage

```


```

## Development

Includes: **CHANGELOG**

Remotes:

* Hostname to IP: [nic.ba](http://nic.ba/ajax.php?a=gethostbyname&host=nic.ba)

## Contributing

1. Fork it ( https://github.com/duraki/nettis/fork )
2. Create your feature branch (git checkout -b nettis-is-fun)
3. Commit your changes (git commit -am 'add: some stuff')
4. Push to the branch (git push origin nettis-is-fun)
5. Create a new Pull Request

## Contributors

- [[duraki]](https://github.com/duraki) Halis Duraki - creator, maintainer
