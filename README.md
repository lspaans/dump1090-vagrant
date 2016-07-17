dump1090-vagrant
================

Introduction
------------

This repository augments the '[dump1090](https://github.com/MalcolmRobb/dump1090)'-repository with a `Vagrantfile` and deployment script.

Installation
------------

Provided you already have [`VirtualBox`](https://www.virtualbox.org/wiki/Downloads) and [`Vagrant`](https://www.vagrantup.com/downloads.html) installed, you should get a working [Debian Jessie 64-bit](https://atlas.hashicorp.com/debian/boxes/jessie64) environment with runnable Dump1090-binaries in `/usr/local/bin` by typing `vagrant up` in the repository directory.

Credits
-------

[Dump1090](https://www.github.com/antirez/dump1090) was written by Salvatore Sanfilippo antirez@gmail.com and is released under the BSD three clause license. This repository uses the [Dump1090 adaption](https://github.com/MalcolmRobb/dump1090) done by Malcolm Robb.
