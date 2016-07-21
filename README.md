dump1090-vagrant
================

Introduction
------------

This repository augments the '[dump1090](https://github.com/MalcolmRobb/dump1090)'- and '[multimon-ng](https://github.com/EliasOenal/multimon-ng)'-repositories with a `Vagrantfile` and deployment script.

Installation
------------

Provided you already have [`VirtualBox`](https://www.virtualbox.org/wiki/Downloads) and [`Vagrant`](https://www.vagrantup.com/downloads.html) installed, you should get a working [Debian Jessie 64-bit](https://atlas.hashicorp.com/debian/boxes/jessie64) environment with runnable Dump1090-binaries in `/usr/local/bin` by running `vagrant up` in the repository directory.

Don't forget to add your RTL SDR device in the VirtualBox "Ports" -> "USB" -> "USB Device Filters" settings.

Normal usage
------------

You can login to the virtual machine using `vagrant ssh`.

You can start Dump1090 by running running `start-dump1090.sh`, which will start Dump1090 in interactive mode with networking support.

For more information see Malcolm Robb's [documentation](https://github.com/MalcolmRobb/dump1090).

You can start MultimonNG by running `start-multimon-ng-POCSAG-NL.sh`, which will start MultimonNG monitoring Dutch pager messages using the POCSAG  demodulators (i.e. POCSAG512, POCSAG1200 and POCSAG2400).

Credits
-------

[Dump1090](https://www.github.com/antirez/dump1090) was written by Salvatore Sanfilippo antirez@gmail.com and is released under the BSD three clause license. This repository uses the [Dump1090 adaption](https://github.com/MalcolmRobb/dump1090) done by Malcolm Robb.

[MultimonNG](https://www.github.com/EliasOenal/multimonNG) was written by Tom Sailer and adapted by Elias Oenal and is released under the GNU General public license.
