## Environment setup
### Install required packages:
`apt-get install build-essential ant maven python-dev`

### Download and build floodlight:
link: https://github.com/floodlight/floodlight/archive/v1.2.tar.gz
```
tar -xf floodlight-1.2.tar.gz
rm floodlight-1.2.tar.gz
cd floodlight*
ant
```

### Run controller:
`java -jar target/floodlight.jar`

### Run mininet:
`python run_mininet.py`

### Configure NAT on external bridge
`tools/setup.sh`

## Mininet topology
```
                   10.0.0.11
                   +-------+
                   |       |
                   |   h1  |
                   |       |
                   +---+---+
                       |
                       |
                       |
10.0.0.10              |                10.0.0.12
+-------+           +--+---+            +-------+
|       |           |      |            |       |
|  h0   +-----------+  s1  +------------+   h2  |
|       |           |      |            |       |
+-------+           +--+---+            +-------+
                       |
                       |
                       |
                       |
 +-----------+     +---+-----+
 |           |     |         |
 | internety | <---+ lbr-ex  |
 |           |     |         |
 +-----------+     +---------+
                  10.0.0.100/8

```
