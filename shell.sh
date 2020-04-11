#!/bin/bash

echo “Hello-docker” > /usr/hello.txt
/usr/local/zeek/bin/zeekctl deploy
/usr/local/zeek/bin/zeekctl install
/usr/local/zeek/bin/zeekctl start
/bin/bash
