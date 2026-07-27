from scapy.all import *

dst = "10.10.10.10"

for i in range(11, 200):
    send(IP(src=f"10.10.{i}.1", dst=dst)/ICMP())
