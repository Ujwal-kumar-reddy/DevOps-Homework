# Networking Homework

## Task 1 — Networking Commands Practice

I practiced the networking commands provided in the networking resources and understood their basic usage.

---

# Task 2 — Networking Commands

## 1. ping google.com

### Command
```bash
ping google.com
```

### Output
```text
PING google.com (192.178.173.139) 56(84) bytes of data.
64 bytes from lcbome-in-f139.1e100.net (192.178.173.139): icmp_seq=1 ttl=114 time=23.4 ms
64 bytes from lcbome-in-f139.1e100.net (192.178.173.139): icmp_seq=2 ttl=114 time=19.8 ms
64 bytes from lcbome-in-f139.1e100.net (192.178.173.139): icmp_seq=3 ttl=114 time=15.6 ms
64 bytes from lcbome-in-f139.1e100.net (192.178.173.139): icmp_seq=4 ttl=114 time=22.2 ms
64 bytes from lcbome-in-f139.1e100.net (192.178.173.139): icmp_seq=5 ttl=114 time=19.4 ms
64 bytes from lcbome-in-f139.1e100.net (192.178.173.139): icmp_seq=6 ttl=114 time=21.1 ms
64 bytes from lcbome-in-f139.1e100.net (192.178.173.139): icmp_seq=7 ttl=114 time=17.4 ms
64 bytes from lcbome-in-f139.1e100.net (192.178.173.139): icmp_seq=8 ttl=114 time=18.3 ms
64 bytes from lcbome-in-f139.1e100.net (192.178.173.139): icmp_seq=9 ttl=114 time=101 ms

--- google.com ping statistics ---
9 packets transmitted, 9 received, 0% packet loss, time 8013ms
rtt min/avg/max/mdev = 15.617/28.734/101.401/25.790 ms
```

### Explanation
The `ping` command checks connectivity to a host by sending ICMP packets and measuring the response time.

---

## 2. traceroute google.com

### Command
```bash
traceroute google.com
```

### Output
```text
traceroute to google.com (192.178.173.101), 30 hops max, 60 byte packets
 1  UJWAL.mshome.net (172.25.160.1)  8.823 ms  8.803 ms  8.796 ms
 2  wifi.height8tech.com (100.128.160.1)  91.136 ms  91.010 ms  91.074 ms
 3  114.79.130.29.dvois.com (114.79.130.29)  90.997 ms  90.980 ms  90.964 ms
 4  72.14.208.165 (72.14.208.165)  90.916 ms  90.849 ms  90.827 ms
 5  192.178.110.221 (192.178.110.221)  90.696 ms  90.453 ms  192.178.84.175 (192.178.84.175)  92.365 ms
 6  142.250.238.244 (142.250.238.244)  92.474 ms  142.251.250.0 (142.251.250.0)  88.456 ms  142.251.249.254 (142.251.249.254)  88.331 ms
 7  * * *
 8  * * *
 9  * * *
10  * * *
11  * * *
12  * * *
13  * lcbome-in-f101.1e100.net (192.178.173.101)  33.854 ms *
```

### Explanation
The `traceroute` command shows the path and network hops taken by packets from the computer to the destination.

---

## 3. netstat -tuln

### Command
```bash
netstat -tuln
```

### Output
```text
Active Internet connections (only servers)
Proto Recv-Q Send-Q Local Address           Foreign Address         State
tcp        0      0 10.255.255.254:53       0.0.0.0:*               LISTEN
tcp        0      0 127.0.0.54:53           0.0.0.0:*               LISTEN
tcp        0      0 127.0.0.53:53           0.0.0.0:*               LISTEN
udp        0      0 127.0.0.54:53           0.0.0.0:*
udp        0      0 127.0.0.53:53           0.0.0.0:*
udp        0      0 10.255.255.254:53       0.0.0.0:*
udp        0      0 127.0.0.1:323           0.0.0.0:*
udp        0      0 127.0.0.1:323           0.0.0.0:*
udp6       0      0 ::1:323                 :::*
udp6       0      0 ::1:323                 :::*
```

### Explanation
The `netstat -tuln` command displays listening TCP and UDP ports and their network addresses.

---

## 4. telnet google.com 80

### Command
```bash
telnet google.com 80
```

### Output
```text
Trying 192.178.173.139...
Connected to google.com.
Escape character is '^]'.
^]
telnet> quit
Connection closed.
```

### Explanation
The `telnet` command tests whether a TCP connection can be established to a specific host and port.

---

## 5. sudo tcpdump -i eth0 host google.com

### Command
```bash
sudo tcpdump -i eth0 host google.com
```

### Output
```text
tcpdump: verbose output suppressed, use -v[v]... for full protocol decode
listening on eth0, link-type EN10MB (Ethernet), snapshot length 262144 bytes
^C
0 packets captured
0 packets received by filter
0 packets dropped by kernel
```

### Explanation
The `tcpdump` command captures and displays network packets matching the specified filter. In this run, no matching packets were captured.

---

## 6. nslookup google.com

### Command
```bash
nslookup google.com
```

### Output
```text
Server:         10.255.255.254
Address:        10.255.255.254#53

Non-authoritative answer:
Name:   google.com
Address: 192.178.211.102
Name:   google.com
Address: 192.178.211.139
Name:   google.com
Address: 192.178.211.113
Name:   google.com
Address: 192.178.211.138
Name:   google.com
Address: 192.178.211.100
Name:   google.com
Address: 192.178.211.101
Name:   google.com
Address: 2404:6800:4000:101d::8a
Name:   google.com
Address: 2404:6800:4000:101d::8b
Name:   google.com
Address: 2404:6800:4000:101d::66
Name:   google.com
Address: 2404:6800:4000:101d::65
```

### Explanation
The `nslookup` command queries DNS to find the IP addresses associated with a domain name.

---

## 7. dig google.com

### Command
```bash
dig google.com
```

### Output
```text
; <<>> DiG 9.20.24-1ubuntu0.3-Ubuntu <<>> google.com
;; global options: +cmd
;; Got answer:
;; ->>HEADER<<- opcode: QUERY, status: NOERROR, id: 4968
;; flags: qr rd ra; QUERY: 1, ANSWER: 6, AUTHORITY: 4, ADDITIONAL: 4

;; QUESTION SECTION:
;google.com.                    IN      A

;; ANSWER SECTION:
google.com.             23      IN      A       192.178.211.139
google.com.             23      IN      A       192.178.211.113
google.com.             23      IN      A       192.178.211.138
google.com.             23      IN      A       192.178.211.100
google.com.             23      IN      A       192.178.211.101
google.com.             23      IN      A       192.178.211.102

;; AUTHORITY SECTION:
google.com.             17445   IN      NS      ns3.google.com.
google.com.             17445   IN      NS      ns4.google.com.
google.com.             17445   IN      NS      ns1.google.com.
google.com.             17445   IN      NS      ns2.google.com.

;; ADDITIONAL SECTION:
ns3.google.com.         32430   IN      A       216.239.36.10
ns4.google.com.         320155  IN      A       216.239.38.10
ns1.google.com.         39717   IN      A       216.239.32.10
ns2.google.com.         29378  IN      A       216.239.34.10

;; Query time: 19 msec
;; SERVER: 10.255.255.254#53(10.255.255.254) (UDP)
;; MSG SIZE  rcvd: 260
```

### Explanation
The `dig` command performs DNS queries and provides detailed information about the DNS response.

---

## 8. curl -I https://www.google.com

### Command
```bash
curl -I https://www.google.com
```

### Output
```text
HTTP/2 200
content-type: text/html; charset=ISO-8859-1
content-security-policy-report-only: object-src 'none';base-uri 'self';script-src 'nonce-REDACTED'
accept-ch: Sec-CH-Prefers-Color-Scheme
p3p: CP="This is not a P3P policy! See g.co/p3phelp for more info."
date: Fri, 04 Sep 2026 02:10:07 GMT
server: gws
x-xss-protection: 0
x-frame-options: SAMEORIGIN
expires: Fri, 04 Sep 2026 02:10:07 GMT
cache-control: private
set-cookie: [REDACTED]
set-cookie: [REDACTED]
set-cookie: [REDACTED]
alt-svc: h3=":443"; ma=2592000,h3-29=":443"; ma=2592000
```

### Explanation
The `curl -I` command requests only the HTTP headers from a web server. `HTTP/2 200` indicates that the request was successful.

---

## 9. arp -a

### Command
```bash
arp -a
```

### Output
```text
UJWAL.mshome.net (172.25.160.1) at 00:15:5d:d3:80:58 [ether] on eth0
```

### Explanation
The `arp -a` command displays the ARP table, showing IP addresses and their associated MAC addresses.

---

## 10. systemctl status NetworkManager

### Command
```bash
systemctl status NetworkManager
```

### Output
```text
Unit NetworkManager.service could not be found.
```

### Explanation
The command checks the status of the NetworkManager service. In this WSL environment, the NetworkManager service was not found.

---

# Conclusion

I practiced the networking commands and observed their outputs. I understood how these commands can be used to check network connectivity, trace network paths, inspect ports, test connections, capture packets, perform DNS lookups, inspect HTTP headers, view ARP information, and check network services.
