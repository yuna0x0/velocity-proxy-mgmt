# Management Script for PaperMC Velocity Proxy

## Content

The main purpose of this repository is to develop a PaperMC Velocity proxy management script.
Its driving goals are minimalism and feature completeness.

The script depends on `tmux` to fork the server into the background and communicate with it.
All the communication namely querying for online users and issuing commands in the console of the server is done using `tmux`.
While the server is offline, the script can listen on the Velocity port for incoming connections and start up the server as soon as a user connects.

## Installation

### Dependencies

* bash
* awk
* sed
* sudo -- privilege separation
* tmux -- communication with server

* netcat -- listen on the Velocity port for incoming connections while the server is down (optional)

### Build

```
make
```

### Installation

```
make install
```

### Build and Install with different arguments

```
make GAME=velocity \
  INAME=velocity \
  SERVER_ROOT=/srv/velocity \
  GAME_USER=velocity \
  MAIN_EXECUTABLE=velocity.jar \
  SERVER_START_CMD="java -Xms1G -Xmx1G -XX:+UseG1GC -XX:G1HeapRegionSize=4M -XX:+UnlockExperimentalVMOptions -XX:+ParallelRefProcEnabled -XX:+AlwaysPreTouch -XX:MaxInlineLevel=15 -jar ./velocity.jar"
```

```
make install \
  GAME=velocity \
  INAME=velocity
```

## FAQ

### Where are the Server Files Located

The server data is stored under /srv/velocity and the server runs as velocity user to increase security.
Use the velocity script under /usr/bin/velocityd to start or stop the server.

### How to configure the Server

Adjust the configuration file under /etc/conf.d/velocity to your liking.

## License

Copyright (c) [Gordian Edenhofer](https://github.com/Edenhofer)

Copyright (c) [yuna0x0](https://github.com/yuna0x0)

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
