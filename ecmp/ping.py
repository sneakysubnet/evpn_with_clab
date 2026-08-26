from scapy.all import IP, TCP, send
src_ip = "10.10.10.10"
dst_ip = "10.20.20.20"
src_port = 1234

for dport in range(400, 411):
      pkt = IP(src=src_ip, dst=dst_ip) / \
            TCP(sport=src_port, dport=dport, flags="S")

      send(pkt, count=1, verbose=False)
