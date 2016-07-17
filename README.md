dump1090-vagrant
================

Introduction
------------

This repository augments the '[dump1090](https://github.com/MalcolmRobb/dump1090)'-repository with a `Vagrantfile` and deployment script.

Installation
------------

Provided you already have [`VirtualBox`](https://www.virtualbox.org/wiki/Downloads) and [`Vagrant`](https://www.vagrantup.com/downloads.html) installed, you should get a working [Debian Jessie 64-bit](https://atlas.hashicorp.com/debian/boxes/jessie64) environment with runnable Dump1090-binaries in `/usr/local/bin` by running `vagrant up` in the repository directory.

Don't forget to add your device in the VirtualBox "Ports" -> "USB" -> "USB Device Filters" settings.

Normal usage
------------

You can start Dump1090 by running `vagrant ssh` in the repository directory and then by running (e.g.) `dump1090 --net --interactive`.

For more information see Malcolm Robb's [documentation](https://github.com/MalcolmRobb/dump1090).

Credits
-------

[Dump1090](https://www.github.com/antirez/dump1090) was written by Salvatore Sanfilippo antirez@gmail.com and is released under the BSD three clause license. This repository uses the [Dump1090 adaption](https://github.com/MalcolmRobb/dump1090) done by Malcolm Robb.
