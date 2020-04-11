# Docker-Zeek
Builds docker zeek IDS with pf-ring and jemalloc from master

# Build
`docker build . -t zamani/zeek`

# Run
`docker run --net=host -itd -name zeekctl -v /home/zamani/zeek/etc:/usr/local/zeek/etc -v /home/zamani/zeek/live/:/usr/local/zeek/spool/logger-1 -v /home/zamani/zeek/logs/:/usr/local/zeek/logs/  zamani/zeek`

We have 3 folder on host mashin:
- etc : 
In this folder config files of zeekctl are exist (node.cfg, network.cfg, zeekctl.cfg).
- live : current log save on this folder
- logs : archive logs save on this folder

# Test pf_ring
1- connect to bash of container
`docker exec -it zeekctl /bin/bash
2- run this command
``ldd /usr/local/zeek/bin/zeek | grep pcap`
3- You should see the following text:
` libpcap.so.1 => /opt/PF_RING/lib/libpcap.so.1 (0x00007f8e849b0000)`
