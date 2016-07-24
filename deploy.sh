#!/bin/sh
#
# deploy.sh: Idempotent script for building and deploying Malcom Robb's
#            adaption of Antirez's 'dump1090' application and Elias Oenal's
#            'multimonNG' within a Vagrant VM.
#

set -e

PREFIX="/usr/local"

build_dump1090 () {
     printf 'dump1090 + view1090 ' >&2

     [ -d "/vagrant/dump1090" ] || return 1

     cd "/vagrant/dump1090" || return 1
     make clean || return 1
     make || return 1

     return 0
}

build_multimon_ng () {
    printf 'multimon-ng ' >&2

    [ -d "/vagrant/multimon-ng" ] || return 1

    if [ ! -d "/vagrant/multimon-ng/build" ]; then
        mkdir "/vagrant/multimon-ng/build" || return 1
    fi

    cd "/vagrant/multimon-ng/build" || return 1

    qmake ../"multimon-ng.pro" PREFIX="$PREFIX" || return 1
    make || return 1
    make install | return 1

    return 0
}

build_applications () {
    printf 'Building applications... ' >&2

    if ! build_dump1090; then
        printf 'Failed!' >&2

        return 1
    fi

    if ! build_multimon_ng; then
        printf 'Failed!' >&2

        return 1
    fi

    printf 'Success!\n' >&2

    return 0
}

clone_dump1090 () {
    printf 'dump1090 ' >&2

    if [ ! -d "/vagrant/dump1090" ]; then
        git clone http://github.com/MalcolmRobb/dump1090.git \
           "/vagrant/dump1090" || return 1
    fi

    return 0
}

clone_multimon_ng () {
    printf 'multimon-ng ' >&2

    if [ ! -d "/vagrant/multimon-ng" ]; then
        git clone http://github.com/EliasOenal/multimon-ng.git \
           "/vagrant/multimon-ng" || return 1
    fi

    return 0
}

clone_applications () {
    printf 'Cloning applications... ' >&2

    if ! clone_dump1090; then
        printf 'Failed!\n' >&2

        return 1
    fi

    if ! clone_multimon_ng; then
        printf 'Failed!\n' >&2

        return 1
    fi

    printf 'Success!\n'

    return 0
}

link_dump1090 () {
    printf 'dump1090 + view1090 ' >&2

    for binary in dump1090 view1090; do
        if [ ! -L "$PREFIX/bin/$binary" ]; then
            ln -s "/vagrant/dump1090/$binary" "$PREFIX/bin/$binary" \
                || return 1
        fi
    done

    if [ ! -L "/home/vagrant/public_html" ]; then
        ln -s "/vagrant/dump1090/public_html" "/home/vagrant/public_html" \
            || return 1
    fi
}

link_applications () {
    printf 'Linking applications... ' >&2

    if ! link_dump1090; then
        printf 'Failed!\n' >&2

        return 1
    fi

    printf 'Success!\n' >&2

    return 0
}

install_packages () {
    printf 'Installing packages... ' >&2

    while [ $# -ne 0 ] ; do
        if [ -e /usr/share/doc/"$1" ] ; then
            printf 'skipping "%s" ' "$1" >&2
            shift
        else
            printf '"$@" ' >&2

            apt-get install -y "$@" || ( printf 'Failed!\n' >&2 && return 1 )
            break
        fi
    done

    printf 'Success!\n' >&2

    return 0
}

install_script () {
    SCRIPT="$PREFIX/bin/$1"

    printf 'Installing "%s"...\n' "$SCRIPT" >&2

    cat > "$SCRIPT"
    chmod 755 "$SCRIPT"
}

update_distribution () {
    printf 'Updating distribution files... ' >&2

    if ! apt-get -y update; then
        printf 'Failed!\n' >&2
    fi

    printf 'Success!\n'

    return 0
}

main () {
    install_script redeploy <<'EOF'
#!/bin/sh
sudo sh /vagrant/deploy.sh
EOF

    install_script start-dump1090.sh <<'EOF'
#!/bin/sh
"/usr/local/bin/dump1090" --net --interactive
EOF

    install_script start-multimon-ng-POCSAG-NL.sh <<'EOF'
#!/bin/sh
"/usr/bin/rtl_fm" -f 172.45e6 -s 22050 -g 100 - | \
    "/usr/local/bin/multimon-ng" -c \
        -a POCSAG512 \
        -a POCSAG1200 \
        -a POCSAG2400 \
        -t raw \
        -
EOF

    update_distribution

    install_packages \
        airspy \
        alsa-utils \
        build-essential \
        git \
        libpulse-dev \
        librtlsdr-dev \
        libusb-1.0-0 \
        libusb-1.0-0-dev \
        ntp \
        pkg-config \
        qt5-default \
        rtl-sdr \
        screen \
        sudo

    clone_applications

    build_applications

    link_applications
}

main
