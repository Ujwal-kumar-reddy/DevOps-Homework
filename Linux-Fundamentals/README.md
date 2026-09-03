# Linux Fundamentals

## Task 1: Soft Link & Hard Link

### Soft Link

A soft link is a shortcut/reference to another file. It has a different inode from the original file.

**Create a soft link:**
```bash
ln -s original.txt softlink.txt
```

**Delete a soft link:**
```bash
rm softlink.txt
```

### Hard Link

A hard link is another directory entry pointing to the same inode and data as the original file.

**Create a hard link:**
```bash
ln original.txt hardlink.txt
```

**Delete a hard link:**
```bash
rm hardlink.txt
```

### Difference

| Soft Link | Hard Link |
|---|---|
| Has a different inode | Has the same inode as the original |
| Points to the file path | Points to the same file data |
| Can become broken if the original is deleted | Still works if the original filename is deleted |
| Can normally link to directories | Normally used for files |

---

## Task 2: adduser vs useradd

### adduser

`adduser` is a higher-level, interactive command that makes user creation easier on Ubuntu.

```bash
sudo adduser username
```

### useradd

`useradd` is a lower-level Linux command that provides more direct control over user creation.

```bash
sudo useradd username
```

### Preferred Command on Ubuntu

`adduser` is generally preferred for interactive user creation on Ubuntu because it handles common user-creation tasks interactively.

### Test User Creation

```bash
sudo adduser devopstest
```

**Verify the user:**
```bash
id devopstest
getent passwd devopstest
```

The test user was successfully created and verified.

---

## Task 3: journalctl

`journalctl` is used to view and query logs collected by systemd's journal.

### Check journalctl Version

```bash
journalctl --version
```

### View Recent System Logs

```bash
journalctl -n 20
```

### View Logs from the Current Boot

```bash
journalctl -b -n 20
```

### View Logs for a Specific Service

```bash
sudo journalctl -u systemd-journald.service -n 20
```

### View Logs from the Last Hour

```bash
journalctl --since "1 hour ago"
```

### View Error-Level Logs

```bash
journalctl -p err -n 20
```

---

## Task 4: Linux Command Cheat Sheet

### IP Addresses

```bash
ip addr
ip addr show
```

Displays IP address information.

### Network Interfaces

```bash
ip link
ip -s link
```

Displays network interfaces and interface statistics.

### Routing

```bash
ip route
ip route get 8.8.8.8
```

Displays the routing table and determines the route used to reach an address.

### Multicast

```bash
ip maddr
```

Displays multicast address information.

### Neighbor / ARP Table

```bash
ip neigh
```

Displays neighbor and ARP information.

### Help

```bash
ip help
ip addr help
ip link help
ip neigh help
```

Displays help for the `ip` command and its subcommands.

### Socket Statistics

```bash
ss -a
ss -n
ss -p
```

Displays socket information and network connections.

### Other Networking Commands

```bash
arping
ethtool
```

`arping` is used for sending ARP requests.

`ethtool` is used to query or control network interface settings.

### Common net-tools Equivalents

| Old Command | Modern Command |
|---|---|
| `ifconfig -a` | `ip addr` |
| `ifconfig eth0 up` | `ip link set eth0 up` |
| `ifconfig eth0 down` | `ip link set eth0 down` |
| `route` | `ip route` |
| `arp -a` | `ip neigh` |
| `netstat` | `ss` |
| `netstat -g` | `ip maddr` |

---

## Conclusion

This assignment covered:

- Soft links and hard links
- Linux user management using `adduser` and `useradd`
- System and service logs using `journalctl`
- Essential Linux networking commands