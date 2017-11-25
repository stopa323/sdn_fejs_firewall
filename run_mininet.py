from mininet.cli import CLI
from mininet.log import setLogLevel
from mininet.net import Mininet
from mininet.node import OVSSwitch, OVSController, RemoteController
from mininet.topo import Topo


class Topology(Topo):

    def build(self):
        h0 = self.addHost('h0', ip='10.0.0.10',
                          defaultRoute='dev h0-eth0 via 10.0.0.100')
        h1 = self.addHost('h1', ip='10.0.0.11',
                          defaultRoute='dev h1-eth0 via 10.0.0.100')
        h2 = self.addHost('h2', ip='10.0.0.12',
                          defaultRoute='dev h2-eth0 via 10.0.0.100')

        s1 = self.addSwitch('s1')

        self.addLink(s1, h0)
        self.addLink(s1, h1)
        self.addLink(s1, h2)


def run_topology():
    topo = Topology()
    net = Mininet(
        topo=topo,
        switch=OVSSwitch,
        controller=lambda name: RemoteController(name, ip='127.0.0.1'),
        autoSetMacs=True)
    net.start()

    CLI(net)

    net.stop()

if __name__ == '__main__':
    setLogLevel('info')
    run_topology()

topos = {
    'sdn-firewall': Topology, }
