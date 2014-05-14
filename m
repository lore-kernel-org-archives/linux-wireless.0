Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from pegasos-out.vodafone.de ([80.84.1.38]:36978 "EHLO
	pegasos-out.vodafone.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752742AbaENUWy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 14 May 2014 16:22:54 -0400
In-Reply-To: <5373C466.2070203@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: Kernel binary for RTL8192EE
From: stefan.krueger@vodafone.de
Date: Wed, 14 May 2014 22:22:18 +0200
To: Larry Finger <Larry.Finger@lwfinger.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Message-ID: <f4470598-38ae-4bac-baab-5da9b369c795@email.android.com> (sfid-20140514_222310_139665_C0AB828F)
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA512

here is the log.. i hope it is not too long..





wpa_supplicant v1.0
random: Trying to read entropy from /dev/random
Initializing interface 'wlan0' conf '/tmp/test.conf' driver 'default' ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/tmp/test.conf' -> '/tmp/test.conf'
Reading configuration file '/tmp/test.conf'
Line: 1 - start of a new network block
ssid - hexdump_ascii(len=23):
46 52 49 54 5a 21 42 6f 78 20 46 6f 6e 20 57 4c FRITZ!Box Fon WL
41 4e 20 37 31 31 32 AN 7112
PSK - hexdump(len=32): [REMOVED]
Priority group 0
id=0 ssid='FRITZ!Box Fon WLAN 7112'
WEXT: cfg80211-based driver detected
wext: interface wlan0 phy: phy0
rfkill: initial event: idx=0 type=2 op=0 soft=0 hard=0
rfkill: initial event: idx=1 type=1 op=0 soft=0 hard=0
rfkill: initial event: idx=2 type=2 op=0 soft=0 hard=0
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
capabilities: key_mgmt 0xf enc 0xf flags 0x0
netlink: Operstate: linkmode=1, operstate=5
wlan0: Own MAC address: 54:35:30:0e:6c:8b
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=4 set_tx=0 seq_len=0 key_len=0
Driver did not support SIOCSIWENCODEEXT
wpa_driver_wext_set_key: alg=0 key_idx=5 set_tx=0 seq_len=0 key_len=0
Driver did not support SIOCSIWENCODEEXT
wpa_driver_wext_set_countermeasures
wlan0: RSN: flushing PMKID list in the driver
wlan0: Setting scan request: 0 sec 100000 usec
WPS: Set UUID for interface wlan0
WPS: UUID based on MAC address - hexdump(len=16): 9d 84 25 e1 02 40 50 14 a8 86 d4 89 6f 25 99 9e
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: Supplicant port status: Unauthorized
wlan0: Added interface wlan0
Daemonize..
random: Got 20/20 bytes from /dev/random
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 10 seconds
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 1091 bytes of scan results (2 BSSes)
Sorted scan results
f4:ec:38:bd:63:d2 freq=2452 qual=46 noise=0 level=-64 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=46 noise=0 level=-64 flags=0xa
wlan0: BSS: Start scan result update 1
wlan0: BSS: Add new id 0 BSSID f4:ec:38:bd:63:d2 SSID 'Honeypot'
wlan0: BSS: Add new id 1 BSSID 00:23:54:ac:69:61 SSID 'c46bec'
Add randomness: count=1 entropy=0
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=2 entropy=1
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 1: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: No suitable network found
wlan0: Setting scan request: 5 sec 0 usec
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 2058 bytes of scan results (4 BSSes)
Sorted scan results
bc:05:43:79:f9:47 freq=2412 qual=54 noise=0 level=-56 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=46 noise=0 level=-64 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=46 noise=0 level=-64 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=42 noise=0 level=-68 flags=0xa
wlan0: BSS: Start scan result update 2
wlan0: BSS: Add new id 2 BSSID bc:05:43:79:f9:47 SSID 'FRITZ!Box Fon WLAN 7112'
wlan0: BSS: Add new id 3 BSSID cc:5d:4e:ed:5e:a0 SSID 'WLAN0511-24'
Add randomness: count=3 entropy=2
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=4 entropy=3
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=5 entropy=4
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=6 entropy=5
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-56
wlan0: selected based on RSN IE
wlan0: selected BSS bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112'
wlan0: Request association: reassociate: 0 selected: bc:05:43:79:f9:47 bssid: 00:00:00:00:00:00 pending: 00:00:00:00:00:00 wpa_state: SCANNING
wlan0: Trying to associate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
wlan0: WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=39
wlan0: Authentication with bc:05:43:79:f9:47 timed out.
Added BSSID bc:05:43:79:f9:47 into blacklist
wlan0: No keys have been configured - skip key clearing
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: Setting scan request: 1 sec 0 usec
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 2522 bytes of scan results (5 BSSes)
Sorted scan results
bc:05:43:79:f9:47 freq=2412 qual=58 noise=0 level=-52 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=46 noise=0 level=-64 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=46 noise=0 level=-64 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=42 noise=0 level=-68 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=38 noise=0 level=-72 flags=0xa
wlan0: BSS: Start scan result update 3
wlan0: BSS: Add new id 4 BSSID 00:1c:4a:46:75:28 SSID 'WLAN-001C4A467528'
Add randomness: count=7 entropy=6
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=8 entropy=7
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=9 entropy=8
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=10 entropy=9
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=11 entropy=10
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-52
wlan0: skip - blacklisted (count=1 limit=0)
wlan0: 1: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 2: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 3: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-68
wlan0: skip - SSID mismatch
wlan0: 4: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: No APs found - clear blacklist and try again
Removed BSSID bc:05:43:79:f9:47 from blacklist (clear)
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-52
wlan0: selected based on RSN IE
wlan0: selected BSS bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112'
wlan0: Request association: reassociate: 1 selected: bc:05:43:79:f9:47 bssid: 00:00:00:00:00:00 pending: 00:00:00:00:00:00 wpa_state: SCANNING
wlan0: Trying to associate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
wlan0: WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=39
wlan0: Authentication with bc:05:43:79:f9:47 timed out.
Added BSSID bc:05:43:79:f9:47 into blacklist
wlan0: No keys have been configured - skip key clearing
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: Setting scan request: 1 sec 0 usec
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 2047 bytes of scan results (4 BSSes)
Sorted scan results
cc:5d:4e:ed:5e:a0 freq=2472 qual=50 noise=0 level=-60 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=46 noise=0 level=-64 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=46 noise=0 level=-64 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=38 noise=0 level=-72 flags=0xa
wlan0: BSS: Start scan result update 4
Add randomness: count=12 entropy=11
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=13 entropy=12
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=14 entropy=13
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=15 entropy=14
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60
wlan0: skip - SSID mismatch
wlan0: 1: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 2: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 3: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: No APs found - clear blacklist and try again
Removed BSSID bc:05:43:79:f9:47 from blacklist (clear)
wlan0: Selecting BSS from priority group 0
wlan0: 0: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60
wlan0: skip - SSID mismatch
wlan0: 1: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 2: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 3: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: No suitable network found
wlan0: Setting scan request: 5 sec 0 usec
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 3235 bytes of scan results (6 BSSes)
Sorted scan results
cc:5d:4e:ed:5e:a0 freq=2472 qual=50 noise=0 level=-60 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=46 noise=0 level=-64 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=46 noise=0 level=-64 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=38 noise=0 level=-72 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=38 noise=0 level=-72 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
wlan0: BSS: Start scan result update 5
wlan0: BSS: Add new id 5 BSSID 74:31:70:a9:6d:f9 SSID 'Mohr'
wlan0: BSS: Add new id 6 BSSID 08:96:d7:4f:7d:97 SSID 'FRITZ!Box 7312'
wlan0: BSS: Expire BSS 2 due to no match in scan
wlan0: BSS: Remove id 2 BSSID bc:05:43:79:f9:47 SSID 'FRITZ!Box Fon WLAN 7112'
Add randomness: count=16 entropy=15
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=17 entropy=16
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=18 entropy=17
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=19 entropy=18
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=20 entropy=19
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=21 entropy=20
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60
wlan0: skip - SSID mismatch
wlan0: 1: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 2: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 3: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: 4: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 5: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: No suitable network found
wlan0: Setting scan request: 5 sec 0 usec
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 4029 bytes of scan results (8 BSSes)
Sorted scan results
bc:05:43:79:f9:47 freq=2412 qual=62 noise=0 level=-48 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=50 noise=0 level=-60 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=46 noise=0 level=-64 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=42 noise=0 level=-68 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=38 noise=0 level=-72 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=38 noise=0 level=-72 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=36 noise=0 level=-74 flags=0xa
wlan0: BSS: Start scan result update 6
wlan0: BSS: Add new id 7 BSSID bc:05:43:79:f9:47 SSID 'FRITZ!Box Fon WLAN 7112'
wlan0: BSS: Add new id 8 BSSID bc:05:43:17:3d:8d SSID 'Engelchens FRITZ!Box'
Add randomness: count=22 entropy=21
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=23 entropy=22
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=24 entropy=23
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=25 entropy=24
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=26 entropy=25
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=27 entropy=26
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=28 entropy=27
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=29 entropy=28
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-48
wlan0: selected based on RSN IE
wlan0: selected BSS bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112'
wlan0: Request association: reassociate: 1 selected: bc:05:43:79:f9:47 bssid: 00:00:00:00:00:00 pending: 00:00:00:00:00:00 wpa_state: SCANNING
wlan0: Trying to associate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
wlan0: WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=39
wlan0: Authentication with bc:05:43:79:f9:47 timed out.
Added BSSID bc:05:43:79:f9:47 into blacklist
wlan0: No keys have been configured - skip key clearing
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: Setting scan request: 1 sec 0 usec
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 4062 bytes of scan results (8 BSSes)
Sorted scan results
cc:5d:4e:ed:5e:a0 freq=2472 qual=50 noise=0 level=-60 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=46 noise=0 level=-64 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=42 noise=0 level=-68 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=38 noise=0 level=-72 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=38 noise=0 level=-72 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=36 noise=0 level=-74 flags=0xa
bc:05:43:79:f9:47 freq=2412 qual=58 noise=0 level=-52 flags=0xa
wlan0: BSS: Start scan result update 7
Add randomness: count=30 entropy=29
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=31 entropy=30
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=32 entropy=31
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=33 entropy=32
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=34 entropy=33
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=35 entropy=34
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=36 entropy=35
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=37 entropy=36
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60
wlan0: skip - SSID mismatch
wlan0: 1: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 2: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-68 wps
wlan0: skip - SSID mismatch
wlan0: 3: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: 4: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 5: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 6: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 7: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=0 rsn_ie_len=0 caps=0x11 level=-52
wlan0: skip - blacklisted (count=1 limit=0)
wlan0: No APs found - clear blacklist and try again
Removed BSSID bc:05:43:79:f9:47 from blacklist (clear)
wlan0: Selecting BSS from priority group 0
wlan0: 0: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60
wlan0: skip - SSID mismatch
wlan0: 1: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 2: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-68 wps
wlan0: skip - SSID mismatch
wlan0: 3: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: 4: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 5: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 6: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 7: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=0 rsn_ie_len=0 caps=0x11 level=-52
wlan0: skip - no WPA/RSN proto match
wlan0: No suitable network found
wlan0: Setting scan request: 5 sec 0 usec
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 3749 bytes of scan results (7 BSSes)
Sorted scan results
bc:05:43:79:f9:47 freq=2412 qual=58 noise=0 level=-52 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=50 noise=0 level=-60 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=50 noise=0 level=-60 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=46 noise=0 level=-64 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=38 noise=0 level=-72 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=36 noise=0 level=-74 flags=0xa
wlan0: BSS: Start scan result update 8
Add randomness: count=38 entropy=37
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=39 entropy=38
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=40 entropy=39
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=41 entropy=40
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=42 entropy=41
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=43 entropy=42
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=44 entropy=43
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-52
wlan0: selected based on RSN IE
wlan0: selected BSS bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112'
wlan0: Request association: reassociate: 1 selected: bc:05:43:79:f9:47 bssid: 00:00:00:00:00:00 pending: 00:00:00:00:00:00 wpa_state: SCANNING
wlan0: Trying to associate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
wlan0: WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=39
wlan0: Authentication with bc:05:43:79:f9:47 timed out.
Added BSSID bc:05:43:79:f9:47 into blacklist
wlan0: No keys have been configured - skip key clearing
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: Setting scan request: 1 sec 0 usec
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 3792 bytes of scan results (7 BSSes)
Sorted scan results
bc:05:43:79:f9:47 freq=2412 qual=58 noise=0 level=-52 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=46 noise=0 level=-64 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=46 noise=0 level=-64 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=38 noise=0 level=-72 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=36 noise=0 level=-74 flags=0xa
00:24:fe:72:e7:43 freq=2462 qual=36 noise=0 level=-74 flags=0xa
wlan0: BSS: Start scan result update 9
wlan0: BSS: Add new id 9 BSSID 00:24:fe:72:e7:43 SSID 'Der Alte Fritz'
wlan0: BSS: Expire BSS 4 due to no match in scan
wlan0: BSS: Remove id 4 BSSID 00:1c:4a:46:75:28 SSID 'WLAN-001C4A467528'
Add randomness: count=45 entropy=44
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=46 entropy=45
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=47 entropy=46
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=48 entropy=47
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=49 entropy=48
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=50 entropy=49
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=51 entropy=50
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-52
wlan0: skip - blacklisted (count=1 limit=0)
wlan0: 1: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 2: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 3: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 4: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 5: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 6: 00:24:fe:72:e7:43 ssid='Der Alte Fritz' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: No APs found - clear blacklist and try again
Removed BSSID bc:05:43:79:f9:47 from blacklist (clear)
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-52
wlan0: selected based on RSN IE
wlan0: selected BSS bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112'
wlan0: Request association: reassociate: 1 selected: bc:05:43:79:f9:47 bssid: 00:00:00:00:00:00 pending: 00:00:00:00:00:00 wpa_state: SCANNING
wlan0: Trying to associate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
wlan0: WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=39
wlan0: Authentication with bc:05:43:79:f9:47 timed out.
Added BSSID bc:05:43:79:f9:47 into blacklist
wlan0: No keys have been configured - skip key clearing
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: Setting scan request: 1 sec 0 usec
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 2605 bytes of scan results (5 BSSes)
Sorted scan results
bc:05:43:79:f9:47 freq=2412 qual=58 noise=0 level=-52 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=50 noise=0 level=-60 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=46 noise=0 level=-64 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=36 noise=0 level=-74 flags=0xa
00:24:fe:72:e7:43 freq=2462 qual=36 noise=0 level=-74 flags=0xa
wlan0: BSS: Start scan result update 10
wlan0: BSS: Expire BSS 3 due to no match in scan
wlan0: BSS: Remove id 3 BSSID cc:5d:4e:ed:5e:a0 SSID 'WLAN0511-24'
Add randomness: count=52 entropy=51
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=53 entropy=52
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=54 entropy=53
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=55 entropy=54
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=56 entropy=55
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-52
wlan0: skip - blacklisted (count=1 limit=0)
wlan0: 1: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-60 wps
wlan0: skip - SSID mismatch
wlan0: 2: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 3: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 4: 00:24:fe:72:e7:43 ssid='Der Alte Fritz' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: No APs found - clear blacklist and try again
Removed BSSID bc:05:43:79:f9:47 from blacklist (clear)
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-52
wlan0: selected based on RSN IE
wlan0: selected BSS bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112'
wlan0: Request association: reassociate: 1 selected: bc:05:43:79:f9:47 bssid: 00:00:00:00:00:00 pending: 00:00:00:00:00:00 wpa_state: SCANNING
wlan0: Trying to associate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
wlan0: WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=39
wlan0: Authentication with bc:05:43:79:f9:47 timed out.
Added BSSID bc:05:43:79:f9:47 into blacklist
wlan0: No keys have been configured - skip key clearing
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: Setting scan request: 1 sec 0 usec
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 2105 bytes of scan results (4 BSSes)
Sorted scan results
bc:05:43:79:f9:47 freq=2412 qual=54 noise=0 level=-56 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=50 noise=0 level=-60 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=46 noise=0 level=-64 flags=0xa
00:24:fe:72:e7:43 freq=2462 qual=36 noise=0 level=-74 flags=0xa
wlan0: BSS: Start scan result update 11
wlan0: BSS: Expire BSS 5 due to no match in scan
wlan0: BSS: Remove id 5 BSSID 74:31:70:a9:6d:f9 SSID 'Mohr'
wlan0: BSS: Expire BSS 6 due to no match in scan
wlan0: BSS: Remove id 6 BSSID 08:96:d7:4f:7d:97 SSID 'FRITZ!Box 7312'
Add randomness: count=57 entropy=56
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=58 entropy=57
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=59 entropy=58
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=60 entropy=59
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-56
wlan0: skip - blacklisted (count=1 limit=0)
wlan0: 1: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-60 wps
wlan0: skip - SSID mismatch
wlan0: 2: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 3: 00:24:fe:72:e7:43 ssid='Der Alte Fritz' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: No APs found - clear blacklist and try again
Removed BSSID bc:05:43:79:f9:47 from blacklist (clear)
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-56
wlan0: selected based on RSN IE
wlan0: selected BSS bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112'
wlan0: Request association: reassociate: 1 selected: bc:05:43:79:f9:47 bssid: 00:00:00:00:00:00 pending: 00:00:00:00:00:00 wpa_state: SCANNING
wlan0: Trying to associate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
wlan0: WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=39
wlan0: Authentication with bc:05:43:79:f9:47 timed out.
Added BSSID bc:05:43:79:f9:47 into blacklist
wlan0: No keys have been configured - skip key clearing
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: Setting scan request: 1 sec 0 usec
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 3181 bytes of scan results (6 BSSes)
Sorted scan results
bc:05:43:79:f9:47 freq=2412 qual=62 noise=0 level=-48 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=50 noise=0 level=-60 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=46 noise=0 level=-64 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=46 noise=0 level=-64 flags=0xa
00:24:fe:72:e7:43 freq=2462 qual=36 noise=0 level=-74 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
wlan0: BSS: Start scan result update 12
wlan0: BSS: Add new id 10 BSSID cc:5d:4e:ed:5e:a0 SSID 'WLAN0511-24'
wlan0: BSS: Add new id 11 BSSID 08:96:d7:4f:7d:97 SSID 'FRITZ!Box 7312'
wlan0: BSS: Expire BSS 8 due to no match in scan
wlan0: BSS: Remove id 8 BSSID bc:05:43:17:3d:8d SSID 'Engelchens FRITZ!Box'
Add randomness: count=61 entropy=60
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=62 entropy=61
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=63 entropy=62
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=64 entropy=63
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=65 entropy=64
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=66 entropy=65
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-48
wlan0: skip - blacklisted (count=1 limit=0)
wlan0: 1: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-60 wps
wlan0: skip - SSID mismatch
wlan0: 2: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 3: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 4: 00:24:fe:72:e7:43 ssid='Der Alte Fritz' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 5: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: No APs found - clear blacklist and try again
Removed BSSID bc:05:43:79:f9:47 from blacklist (clear)
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-48
wlan0: selected based on RSN IE
wlan0: selected BSS bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112'
wlan0: Request association: reassociate: 1 selected: bc:05:43:79:f9:47 bssid: 00:00:00:00:00:00 pending: 00:00:00:00:00:00 wpa_state: SCANNING
wlan0: Trying to associate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
wlan0: WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=39
wlan0: Authentication with bc:05:43:79:f9:47 timed out.
Added BSSID bc:05:43:79:f9:47 into blacklist
wlan0: No keys have been configured - skip key clearing
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: Setting scan request: 1 sec 0 usec
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 2644 bytes of scan results (5 BSSes)
Sorted scan results
bc:05:43:79:f9:47 freq=2412 qual=58 noise=0 level=-52 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=50 noise=0 level=-60 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=50 noise=0 level=-60 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=46 noise=0 level=-64 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
wlan0: BSS: Start scan result update 13
Add randomness: count=67 entropy=66
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=68 entropy=67
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=69 entropy=68
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=70 entropy=69
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=71 entropy=70
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-52
wlan0: skip - blacklisted (count=1 limit=0)
wlan0: 1: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60 wps
wlan0: skip - SSID mismatch
wlan0: 2: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-60 wps
wlan0: skip - SSID mismatch
wlan0: 3: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 4: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: No APs found - clear blacklist and try again
Removed BSSID bc:05:43:79:f9:47 from blacklist (clear)
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-52
wlan0: selected based on RSN IE
wlan0: selected BSS bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112'
wlan0: Request association: reassociate: 1 selected: bc:05:43:79:f9:47 bssid: 00:00:00:00:00:00 pending: 00:00:00:00:00:00 wpa_state: SCANNING
wlan0: Trying to associate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
wlan0: WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=39
wlan0: Authentication with bc:05:43:79:f9:47 timed out.
Added BSSID bc:05:43:79:f9:47 into blacklist
wlan0: No keys have been configured - skip key clearing
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: Setting scan request: 1 sec 0 usec
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 2714 bytes of scan results (5 BSSes)
Sorted scan results
bc:05:43:79:f9:47 freq=2412 qual=58 noise=0 level=-52 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=46 noise=0 level=-64 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=46 noise=0 level=-64 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=36 noise=0 level=-74 flags=0xa
wlan0: BSS: Start scan result update 14
wlan0: BSS: Add new id 12 BSSID 74:31:70:a9:6d:f9 SSID 'Mohr'
wlan0: BSS: Expire BSS 9 due to no match in scan
wlan0: BSS: Remove id 9 BSSID 00:24:fe:72:e7:43 SSID 'Der Alte Fritz'
Add randomness: count=72 entropy=71
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=73 entropy=72
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=74 entropy=73
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=75 entropy=74
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=76 entropy=75
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-52
wlan0: skip - blacklisted (count=1 limit=0)
wlan0: 1: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 2: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 3: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 4: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: No APs found - clear blacklist and try again
Removed BSSID bc:05:43:79:f9:47 from blacklist (clear)
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-52
wlan0: selected based on RSN IE
wlan0: selected BSS bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112'
wlan0: Request association: reassociate: 1 selected: bc:05:43:79:f9:47 bssid: 00:00:00:00:00:00 pending: 00:00:00:00:00:00 wpa_state: SCANNING
wlan0: Trying to associate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
wlan0: WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=39
wlan0: Authentication with bc:05:43:79:f9:47 timed out.
Added BSSID bc:05:43:79:f9:47 into blacklist
wlan0: No keys have been configured - skip key clearing
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: Setting scan request: 1 sec 0 usec
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 4067 bytes of scan results (8 BSSes)
Sorted scan results
f4:ec:38:bd:63:d2 freq=2452 qual=50 noise=0 level=-60 flags=0xa
bc:05:43:79:f9:47 freq=2412 qual=50 noise=0 level=-60 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=46 noise=0 level=-64 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=36 noise=0 level=-74 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=36 noise=0 level=-74 flags=0xa
0e:96:d7:11:d8:bd freq=2422 qual=36 noise=0 level=-74 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=38 noise=0 level=-72 flags=0xa
wlan0: BSS: Start scan result update 15
wlan0: BSS: Add new id 13 BSSID 0e:96:d7:11:d8:bd SSID 'Mohr'
wlan0: BSS: Add new id 14 BSSID 00:1c:4a:46:75:28 SSID 'WLAN-001C4A467528'
Add randomness: count=77 entropy=76
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=78 entropy=77
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=79 entropy=78
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=80 entropy=79
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=81 entropy=80
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=82 entropy=81
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=83 entropy=82
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=84 entropy=83
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60 wps
wlan0: skip - SSID mismatch
wlan0: 1: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-60
wlan0: skip - blacklisted (count=1 limit=0)
wlan0: 2: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 3: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 4: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 5: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 6: 0e:96:d7:11:d8:bd ssid='Mohr' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74
wlan0: skip - SSID mismatch
wlan0: 7: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=0 rsn_ie_len=0 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: No APs found - clear blacklist and try again
Removed BSSID bc:05:43:79:f9:47 from blacklist (clear)
wlan0: Selecting BSS from priority group 0
wlan0: 0: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60 wps
wlan0: skip - SSID mismatch
wlan0: 1: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-60
wlan0: selected based on RSN IE
wlan0: selected BSS bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112'
wlan0: Request association: reassociate: 1 selected: bc:05:43:79:f9:47 bssid: 00:00:00:00:00:00 pending: 00:00:00:00:00:00 wpa_state: SCANNING
wlan0: Trying to associate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
wlan0: WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=39
wlan0: Authentication with bc:05:43:79:f9:47 timed out.
Added BSSID bc:05:43:79:f9:47 into blacklist
wlan0: No keys have been configured - skip key clearing
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: Setting scan request: 1 sec 0 usec
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 4063 bytes of scan results (8 BSSes)
Sorted scan results
cc:5d:4e:ed:5e:a0 freq=2472 qual=46 noise=0 level=-64 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=46 noise=0 level=-64 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=42 noise=0 level=-68 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=38 noise=0 level=-72 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=38 noise=0 level=-72 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
0e:96:d7:11:d8:bd freq=2422 qual=36 noise=0 level=-74 flags=0xa
bc:05:43:79:f9:47 freq=2412 qual=54 noise=0 level=-56 flags=0xa
wlan0: BSS: Start scan result update 16
Add randomness: count=85 entropy=84
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=86 entropy=85
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=87 entropy=86
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=88 entropy=87
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=89 entropy=88
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=90 entropy=89
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=91 entropy=90
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=92 entropy=91
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 1: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 2: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-68 wps
wlan0: skip - SSID mismatch
wlan0: 3: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 4: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: 5: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 6: 0e:96:d7:11:d8:bd ssid='Mohr' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74
wlan0: skip - SSID mismatch
wlan0: 7: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=0 rsn_ie_len=0 caps=0x11 level=-56
wlan0: skip - blacklisted (count=1 limit=0)
wlan0: No APs found - clear blacklist and try again
Removed BSSID bc:05:43:79:f9:47 from blacklist (clear)
wlan0: Selecting BSS from priority group 0
wlan0: 0: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 1: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 2: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-68 wps
wlan0: skip - SSID mismatch
wlan0: 3: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 4: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: 5: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 6: 0e:96:d7:11:d8:bd ssid='Mohr' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74
wlan0: skip - SSID mismatch
wlan0: 7: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=0 rsn_ie_len=0 caps=0x11 level=-56
wlan0: skip - no WPA/RSN proto match
wlan0: No suitable network found
wlan0: Setting scan request: 5 sec 0 usec
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 4061 bytes of scan results (8 BSSes)
Sorted scan results
f4:ec:38:bd:63:d2 freq=2452 qual=50 noise=0 level=-60 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=46 noise=0 level=-64 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=38 noise=0 level=-72 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=38 noise=0 level=-72 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=36 noise=0 level=-74 flags=0xa
0e:96:d7:11:d8:bd freq=2422 qual=36 noise=0 level=-74 flags=0xa
bc:05:43:79:f9:47 freq=2412 qual=58 noise=0 level=-52 flags=0xa
wlan0: BSS: Start scan result update 17
Add randomness: count=93 entropy=92
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=94 entropy=93
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=95 entropy=94
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=96 entropy=95
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=97 entropy=96
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=98 entropy=97
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=99 entropy=98
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=100 entropy=99
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60 wps
wlan0: skip - SSID mismatch
wlan0: 1: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 2: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 3: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: 4: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 5: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 6: 0e:96:d7:11:d8:bd ssid='Mohr' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74
wlan0: skip - SSID mismatch
wlan0: 7: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=0 rsn_ie_len=0 caps=0x11 level=-52
wlan0: skip - no WPA/RSN proto match
wlan0: No suitable network found
wlan0: Setting scan request: 5 sec 0 usec
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Scan results did not fit - trying larger buffer (8192 bytes)
Received 4713 bytes of scan results (9 BSSes)
Sorted scan results
bc:05:43:79:f9:47 freq=2412 qual=54 noise=0 level=-56 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=46 noise=0 level=-64 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=38 noise=0 level=-72 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=38 noise=0 level=-72 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=38 noise=0 level=-72 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=38 noise=0 level=-72 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=36 noise=0 level=-74 flags=0xa
0e:96:d7:11:d8:bd freq=2422 qual=36 noise=0 level=-74 flags=0xa
wlan0: BSS: Start scan result update 18
wlan0: BSS: Add new id 15 BSSID bc:05:43:17:3d:8d SSID 'Engelchens FRITZ!Box'
Add randomness: count=101 entropy=100
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=102 entropy=101
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=103 entropy=102
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=104 entropy=103
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=105 entropy=104
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=106 entropy=105
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=107 entropy=106
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=108 entropy=107
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=109 entropy=108
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-56
wlan0: selected based on RSN IE
wlan0: selected BSS bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112'
wlan0: Request association: reassociate: 1 selected: bc:05:43:79:f9:47 bssid: 00:00:00:00:00:00 pending: 00:00:00:00:00:00 wpa_state: SCANNING
wlan0: Trying to associate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
wlan0: WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=39
wlan0: Authentication with bc:05:43:79:f9:47 timed out.
Added BSSID bc:05:43:79:f9:47 into blacklist
wlan0: No keys have been configured - skip key clearing
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: Setting scan request: 1 sec 0 usec
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 4062 bytes of scan results (8 BSSes)
Sorted scan results
f4:ec:38:bd:63:d2 freq=2452 qual=50 noise=0 level=-60 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=46 noise=0 level=-64 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=42 noise=0 level=-68 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=38 noise=0 level=-72 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=38 noise=0 level=-72 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
0e:96:d7:11:d8:bd freq=2422 qual=36 noise=0 level=-74 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=38 noise=0 level=-72 flags=0xa
wlan0: BSS: Start scan result update 19
Add randomness: count=110 entropy=109
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=111 entropy=110
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=112 entropy=111
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=113 entropy=112
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=114 entropy=113
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=115 entropy=114
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=116 entropy=115
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=117 entropy=116
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60 wps
wlan0: skip - SSID mismatch
wlan0: 1: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 2: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-68
wlan0: skip - SSID mismatch
wlan0: 3: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 4: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: 5: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 6: 0e:96:d7:11:d8:bd ssid='Mohr' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74
wlan0: skip - SSID mismatch
wlan0: 7: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=0 rsn_ie_len=0 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: No APs found - clear blacklist and try again
Removed BSSID bc:05:43:79:f9:47 from blacklist (clear)
wlan0: Selecting BSS from priority group 0
wlan0: 0: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60 wps
wlan0: skip - SSID mismatch
wlan0: 1: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 2: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-68
wlan0: skip - SSID mismatch
wlan0: 3: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 4: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: 5: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 6: 0e:96:d7:11:d8:bd ssid='Mohr' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74
wlan0: skip - SSID mismatch
wlan0: 7: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=0 rsn_ie_len=0 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: No suitable network found
wlan0: Setting scan request: 5 sec 0 usec
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 4056 bytes of scan results (8 BSSes)
Sorted scan results
f4:ec:38:bd:63:d2 freq=2452 qual=50 noise=0 level=-60 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=46 noise=0 level=-64 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=42 noise=0 level=-68 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=38 noise=0 level=-72 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=38 noise=0 level=-72 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=38 noise=0 level=-72 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
bc:05:43:79:f9:47 freq=2412 qual=58 noise=0 level=-52 flags=0xa
wlan0: BSS: Start scan result update 20
Add randomness: count=118 entropy=117
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=119 entropy=118
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=120 entropy=119
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=121 entropy=120
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=122 entropy=121
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=123 entropy=122
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=124 entropy=123
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=125 entropy=124
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60 wps
wlan0: skip - SSID mismatch
wlan0: 1: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 2: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-68 wps
wlan0: skip - SSID mismatch
wlan0: 3: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 4: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: 5: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 6: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 7: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=0 rsn_ie_len=0 caps=0x11 level=-52
wlan0: skip - no WPA/RSN proto match
wlan0: No suitable network found
wlan0: Setting scan request: 5 sec 0 usec
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 4053 bytes of scan results (8 BSSes)
Sorted scan results
cc:5d:4e:ed:5e:a0 freq=2472 qual=50 noise=0 level=-60 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=46 noise=0 level=-64 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=42 noise=0 level=-68 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=38 noise=0 level=-72 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=38 noise=0 level=-72 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=36 noise=0 level=-74 flags=0xa
bc:05:43:79:f9:47 freq=2412 qual=54 noise=0 level=-56 flags=0xa
wlan0: BSS: Start scan result update 21
wlan0: BSS: Expire BSS 13 due to no match in scan
wlan0: BSS: Remove id 13 BSSID 0e:96:d7:11:d8:bd SSID 'Mohr'
Add randomness: count=126 entropy=125
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=127 entropy=126
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=128 entropy=127
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=129 entropy=128
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=130 entropy=129
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=131 entropy=130
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=132 entropy=131
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=133 entropy=132
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60
wlan0: skip - SSID mismatch
wlan0: 1: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 2: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-68 wps
wlan0: skip - SSID mismatch
wlan0: 3: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 4: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 5: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 6: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-74
wlan0: skip - SSID mismatch
wlan0: 7: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=0 rsn_ie_len=0 caps=0x11 level=-56
wlan0: skip - no WPA/RSN proto match
wlan0: No suitable network found
wlan0: Setting scan request: 5 sec 0 usec
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Scan results did not fit - trying larger buffer (8192 bytes)
Received 4686 bytes of scan results (9 BSSes)
Sorted scan results
bc:05:43:79:f9:47 freq=2412 qual=54 noise=0 level=-56 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=46 noise=0 level=-64 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=46 noise=0 level=-64 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=42 noise=0 level=-68 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=38 noise=0 level=-72 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=38 noise=0 level=-72 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=36 noise=0 level=-74 flags=0xa
00:1a:2b:3b:a1:6a freq=2437 qual=36 noise=0 level=-74 flags=0xa
wlan0: BSS: Start scan result update 22
wlan0: BSS: Add new id 16 BSSID 00:1a:2b:3b:a1:6a SSID 'CABLELINK4200-001C7B238AF3'
Add randomness: count=134 entropy=133
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=135 entropy=134
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=136 entropy=135
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=137 entropy=136
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=138 entropy=137
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=139 entropy=138
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=140 entropy=139
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=141 entropy=140
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=142 entropy=141
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-56
wlan0: selected based on RSN IE
wlan0: selected BSS bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112'
wlan0: Request association: reassociate: 1 selected: bc:05:43:79:f9:47 bssid: 00:00:00:00:00:00 pending: 00:00:00:00:00:00 wpa_state: SCANNING
wlan0: Trying to associate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
wlan0: WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=39
wlan0: Authentication with bc:05:43:79:f9:47 timed out.
Added BSSID bc:05:43:79:f9:47 into blacklist
wlan0: No keys have been configured - skip key clearing
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: Setting scan request: 1 sec 0 usec
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Scan results did not fit - trying larger buffer (8192 bytes)
Received 4685 bytes of scan results (9 BSSes)
Sorted scan results
bc:05:43:79:f9:47 freq=2412 qual=62 noise=0 level=-48 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=50 noise=0 level=-60 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=46 noise=0 level=-64 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=46 noise=0 level=-64 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=42 noise=0 level=-68 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=42 noise=0 level=-68 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=38 noise=0 level=-72 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
00:1a:2b:3b:a1:6a freq=2437 qual=36 noise=0 level=-74 flags=0xa
wlan0: BSS: Start scan result update 23
Add randomness: count=143 entropy=142
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=144 entropy=143
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=145 entropy=144
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=146 entropy=145
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=147 entropy=146
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=148 entropy=147
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=149 entropy=148
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=150 entropy=149
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=151 entropy=150
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-48
wlan0: skip - blacklisted (count=1 limit=0)
wlan0: 1: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60
wlan0: skip - SSID mismatch
wlan0: 2: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 3: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 4: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-68
wlan0: skip - SSID mismatch
wlan0: 5: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-68 wps
wlan0: skip - SSID mismatch
wlan0: 6: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 7: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 8: 00:1a:2b:3b:a1:6a ssid='CABLELINK4200-001C7B238AF3' wpa_ie_len=28 rsn_ie_len=0 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: No APs found - clear blacklist and try again
Removed BSSID bc:05:43:79:f9:47 from blacklist (clear)
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-48
wlan0: selected based on RSN IE
wlan0: selected BSS bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112'
wlan0: Request association: reassociate: 1 selected: bc:05:43:79:f9:47 bssid: 00:00:00:00:00:00 pending: 00:00:00:00:00:00 wpa_state: SCANNING
wlan0: Trying to associate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
wlan0: WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=39
wlan0: Authentication with bc:05:43:79:f9:47 timed out.
Added BSSID bc:05:43:79:f9:47 into blacklist
wlan0: No keys have been configured - skip key clearing
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: Setting scan request: 1 sec 0 usec
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Scan results did not fit - trying larger buffer (8192 bytes)
Received 4690 bytes of scan results (9 BSSes)
Sorted scan results
bc:05:43:79:f9:47 freq=2412 qual=54 noise=0 level=-56 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=50 noise=0 level=-60 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=46 noise=0 level=-64 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=42 noise=0 level=-68 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=42 noise=0 level=-68 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=38 noise=0 level=-72 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=38 noise=0 level=-72 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
00:1a:2b:3b:a1:6a freq=2437 qual=36 noise=0 level=-74 flags=0xa
wlan0: BSS: Start scan result update 24
Add randomness: count=152 entropy=151
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=153 entropy=152
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=154 entropy=153
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=155 entropy=154
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=156 entropy=155
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=157 entropy=156
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=158 entropy=157
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=159 entropy=158
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=160 entropy=159
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-56
wlan0: skip - blacklisted (count=1 limit=0)
wlan0: 1: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60 wps
wlan0: skip - SSID mismatch
wlan0: 2: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 3: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-68
wlan0: skip - SSID mismatch
wlan0: 4: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-68 wps
wlan0: skip - SSID mismatch
wlan0: 5: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: 6: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 7: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 8: 00:1a:2b:3b:a1:6a ssid='CABLELINK4200-001C7B238AF3' wpa_ie_len=28 rsn_ie_len=0 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: No APs found - clear blacklist and try again
Removed BSSID bc:05:43:79:f9:47 from blacklist (clear)
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-56
wlan0: selected based on RSN IE
wlan0: selected BSS bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112'
wlan0: Request association: reassociate: 1 selected: bc:05:43:79:f9:47 bssid: 00:00:00:00:00:00 pending: 00:00:00:00:00:00 wpa_state: SCANNING
wlan0: Trying to associate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
wlan0: WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=39
wlan0: Authentication with bc:05:43:79:f9:47 timed out.
Added BSSID bc:05:43:79:f9:47 into blacklist
wlan0: No keys have been configured - skip key clearing
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: Setting scan request: 1 sec 0 usec
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Scan results did not fit - trying larger buffer (8192 bytes)
Received 4690 bytes of scan results (9 BSSes)
Sorted scan results
bc:05:43:79:f9:47 freq=2412 qual=62 noise=0 level=-48 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=50 noise=0 level=-60 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=46 noise=0 level=-64 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=46 noise=0 level=-64 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=42 noise=0 level=-68 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=38 noise=0 level=-72 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=38 noise=0 level=-72 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=38 noise=0 level=-72 flags=0xa
00:1a:2b:3b:a1:6a freq=2437 qual=36 noise=0 level=-74 flags=0xa
wlan0: BSS: Start scan result update 25
Add randomness: count=161 entropy=160
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=162 entropy=161
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=163 entropy=162
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=164 entropy=163
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=165 entropy=164
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=166 entropy=165
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=167 entropy=166
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=168 entropy=167
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=169 entropy=168
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-48
wlan0: skip - blacklisted (count=1 limit=0)
wlan0: 1: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60 wps
wlan0: skip - SSID mismatch
wlan0: 2: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 3: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 4: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-68 wps
wlan0: skip - SSID mismatch
wlan0: 5: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 6: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 7: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: 8: 00:1a:2b:3b:a1:6a ssid='CABLELINK4200-001C7B238AF3' wpa_ie_len=28 rsn_ie_len=0 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: No APs found - clear blacklist and try again
Removed BSSID bc:05:43:79:f9:47 from blacklist (clear)
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-48
wlan0: selected based on RSN IE
wlan0: selected BSS bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112'
wlan0: Request association: reassociate: 1 selected: bc:05:43:79:f9:47 bssid: 00:00:00:00:00:00 pending: 00:00:00:00:00:00 wpa_state: SCANNING
wlan0: Trying to associate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
wlan0: WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=39
wlan0: Authentication with bc:05:43:79:f9:47 timed out.
Added BSSID bc:05:43:79:f9:47 into blacklist
wlan0: No keys have been configured - skip key clearing
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: Setting scan request: 1 sec 0 usec
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 4052 bytes of scan results (8 BSSes)
Sorted scan results
f4:ec:38:bd:63:d2 freq=2452 qual=46 noise=0 level=-64 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=46 noise=0 level=-64 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=46 noise=0 level=-64 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=42 noise=0 level=-68 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=38 noise=0 level=-72 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=38 noise=0 level=-72 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=36 noise=0 level=-74 flags=0xa
bc:05:43:79:f9:47 freq=2412 qual=54 noise=0 level=-56 flags=0xa
wlan0: BSS: Start scan result update 26
Add randomness: count=170 entropy=169
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=171 entropy=170
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=172 entropy=171
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=173 entropy=172
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=174 entropy=173
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=175 entropy=174
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=176 entropy=175
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=177 entropy=176
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 1: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 2: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 3: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-68 wps
wlan0: skip - SSID mismatch
wlan0: 4: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 5: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 6: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 7: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=0 rsn_ie_len=0 caps=0x11 level=-56
wlan0: skip - blacklisted (count=1 limit=0)
wlan0: No APs found - clear blacklist and try again
Removed BSSID bc:05:43:79:f9:47 from blacklist (clear)
wlan0: Selecting BSS from priority group 0
wlan0: 0: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 1: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 2: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 3: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-68 wps
wlan0: skip - SSID mismatch
wlan0: 4: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 5: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 6: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 7: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=0 rsn_ie_len=0 caps=0x11 level=-56
wlan0: skip - no WPA/RSN proto match
wlan0: No suitable network found
wlan0: Setting scan request: 5 sec 0 usec
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 4058 bytes of scan results (8 BSSes)
Sorted scan results
f4:ec:38:bd:63:d2 freq=2452 qual=50 noise=0 level=-60 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=46 noise=0 level=-64 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=46 noise=0 level=-64 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=46 noise=0 level=-64 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=42 noise=0 level=-68 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=38 noise=0 level=-72 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=36 noise=0 level=-74 flags=0xa
bc:05:43:79:f9:47 freq=2412 qual=54 noise=0 level=-56 flags=0xa
wlan0: BSS: Start scan result update 27
wlan0: BSS: Expire BSS 16 due to no match in scan
wlan0: BSS: Remove id 16 BSSID 00:1a:2b:3b:a1:6a SSID 'CABLELINK4200-001C7B238AF3'
Add randomness: count=178 entropy=177
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=179 entropy=178
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=180 entropy=179
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=181 entropy=180
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=182 entropy=181
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=183 entropy=182
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=184 entropy=183
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=185 entropy=184
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60 wps
wlan0: skip - SSID mismatch
wlan0: 1: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 2: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 3: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 4: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-68 wps
wlan0: skip - SSID mismatch
wlan0: 5: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 6: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 7: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=0 rsn_ie_len=0 caps=0x11 level=-56
wlan0: skip - no WPA/RSN proto match
wlan0: No suitable network found
wlan0: Setting scan request: 5 sec 0 usec
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 3708 bytes of scan results (7 BSSes)
Sorted scan results
bc:05:43:79:f9:47 freq=2412 qual=62 noise=0 level=-48 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=50 noise=0 level=-60 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=46 noise=0 level=-64 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=46 noise=0 level=-64 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=46 noise=0 level=-64 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=38 noise=0 level=-72 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=36 noise=0 level=-74 flags=0xa
wlan0: BSS: Start scan result update 28
Add randomness: count=186 entropy=185
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=187 entropy=186
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=188 entropy=187
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=189 entropy=188
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=190 entropy=189
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=191 entropy=190
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=192 entropy=191
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-48
wlan0: selected based on RSN IE
wlan0: selected BSS bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112'
wlan0: Request association: reassociate: 1 selected: bc:05:43:79:f9:47 bssid: 00:00:00:00:00:00 pending: 00:00:00:00:00:00 wpa_state: SCANNING
wlan0: Trying to associate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
wlan0: WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=39
wlan0: Authentication with bc:05:43:79:f9:47 timed out.
Added BSSID bc:05:43:79:f9:47 into blacklist
wlan0: No keys have been configured - skip key clearing
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: Setting scan request: 1 sec 0 usec
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 3734 bytes of scan results (7 BSSes)
Sorted scan results
cc:5d:4e:ed:5e:a0 freq=2472 qual=54 noise=0 level=-56 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=50 noise=0 level=-60 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=46 noise=0 level=-64 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=46 noise=0 level=-64 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=38 noise=0 level=-72 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=38 noise=0 level=-72 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=36 noise=0 level=-74 flags=0xa
wlan0: BSS: Start scan result update 29
Add randomness: count=193 entropy=192
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=194 entropy=193
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=195 entropy=194
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=196 entropy=195
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=197 entropy=196
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=198 entropy=197
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=199 entropy=198
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-56
wlan0: skip - SSID mismatch
wlan0: 1: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60 wps
wlan0: skip - SSID mismatch
wlan0: 2: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 3: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 4: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 5: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 6: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: No APs found - clear blacklist and try again
Removed BSSID bc:05:43:79:f9:47 from blacklist (clear)
wlan0: Selecting BSS from priority group 0
wlan0: 0: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-56
wlan0: skip - SSID mismatch
wlan0: 1: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60 wps
wlan0: skip - SSID mismatch
wlan0: 2: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 3: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 4: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 5: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 6: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: No suitable network found
wlan0: Setting scan request: 5 sec 0 usec
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 3621 bytes of scan results (7 BSSes)
Sorted scan results
bc:05:43:79:f9:47 freq=2412 qual=62 noise=0 level=-48 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=46 noise=0 level=-64 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=46 noise=0 level=-64 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=46 noise=0 level=-64 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=38 noise=0 level=-72 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=38 noise=0 level=-72 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=36 noise=0 level=-74 flags=0xa
wlan0: BSS: Start scan result update 30
Add randomness: count=200 entropy=199
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=201 entropy=200
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=202 entropy=201
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=203 entropy=202
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=204 entropy=203
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=205 entropy=204
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=206 entropy=205
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-48
wlan0: selected based on RSN IE
wlan0: selected BSS bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112'
wlan0: Request association: reassociate: 1 selected: bc:05:43:79:f9:47 bssid: 00:00:00:00:00:00 pending: 00:00:00:00:00:00 wpa_state: SCANNING
wlan0: Trying to associate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
wlan0: WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=39
wlan0: Authentication with bc:05:43:79:f9:47 timed out.
Added BSSID bc:05:43:79:f9:47 into blacklist
wlan0: No keys have been configured - skip key clearing
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: Setting scan request: 1 sec 0 usec
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 2546 bytes of scan results (5 BSSes)
Sorted scan results
f4:ec:38:bd:63:d2 freq=2452 qual=46 noise=0 level=-64 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=46 noise=0 level=-64 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=38 noise=0 level=-72 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=38 noise=0 level=-72 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=38 noise=0 level=-72 flags=0xa
wlan0: BSS: Start scan result update 31
wlan0: BSS: Expire BSS 11 due to no match in scan
wlan0: BSS: Remove id 11 BSSID 08:96:d7:4f:7d:97 SSID 'FRITZ!Box 7312'
Add randomness: count=207 entropy=206
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=208 entropy=207
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=209 entropy=208
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=210 entropy=209
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=211 entropy=210
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 1: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 2: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 3: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: 4: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: No APs found - clear blacklist and try again
Removed BSSID bc:05:43:79:f9:47 from blacklist (clear)
wlan0: Selecting BSS from priority group 0
wlan0: 0: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 1: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 2: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 3: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: 4: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: No suitable network found
wlan0: Setting scan request: 5 sec 0 usec
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 3019 bytes of scan results (6 BSSes)
Sorted scan results
bc:05:43:79:f9:47 freq=2412 qual=54 noise=0 level=-56 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=50 noise=0 level=-60 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=46 noise=0 level=-64 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=42 noise=0 level=-68 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=38 noise=0 level=-72 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=38 noise=0 level=-72 flags=0xa
wlan0: BSS: Start scan result update 32
wlan0: BSS: Expire BSS 12 due to no match in scan
wlan0: BSS: Remove id 12 BSSID 74:31:70:a9:6d:f9 SSID 'Mohr'
Add randomness: count=212 entropy=211
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=213 entropy=212
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=214 entropy=213
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=215 entropy=214
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=216 entropy=215
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=217 entropy=216
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-56
wlan0: selected based on RSN IE
wlan0: selected BSS bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112'
wlan0: Request association: reassociate: 1 selected: bc:05:43:79:f9:47 bssid: 00:00:00:00:00:00 pending: 00:00:00:00:00:00 wpa_state: SCANNING
wlan0: Trying to associate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
wlan0: WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=39
wlan0: Authentication with bc:05:43:79:f9:47 timed out.
Added BSSID bc:05:43:79:f9:47 into blacklist
wlan0: No keys have been configured - skip key clearing
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: Setting scan request: 1 sec 0 usec
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 3732 bytes of scan results (7 BSSes)
Sorted scan results
f4:ec:38:bd:63:d2 freq=2452 qual=50 noise=0 level=-60 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=50 noise=0 level=-60 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=46 noise=0 level=-64 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=38 noise=0 level=-72 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=38 noise=0 level=-72 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=38 noise=0 level=-72 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
wlan0: BSS: Start scan result update 33
wlan0: BSS: Add new id 17 BSSID 74:31:70:a9:6d:f9 SSID 'Mohr'
wlan0: BSS: Add new id 18 BSSID 08:96:d7:4f:7d:97 SSID 'FRITZ!Box 7312'
Add randomness: count=218 entropy=217
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=219 entropy=218
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=220 entropy=219
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=221 entropy=220
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=222 entropy=221
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=223 entropy=222
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=224 entropy=223
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60 wps
wlan0: skip - SSID mismatch
wlan0: 1: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60
wlan0: skip - SSID mismatch
wlan0: 2: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 3: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: 4: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 5: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 6: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: No APs found - clear blacklist and try again
Removed BSSID bc:05:43:79:f9:47 from blacklist (clear)
wlan0: Selecting BSS from priority group 0
wlan0: 0: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60 wps
wlan0: skip - SSID mismatch
wlan0: 1: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60
wlan0: skip - SSID mismatch
wlan0: 2: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 3: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: 4: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 5: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 6: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: No suitable network found
wlan0: Setting scan request: 5 sec 0 usec
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 4053 bytes of scan results (8 BSSes)
Sorted scan results
f4:ec:38:bd:63:d2 freq=2452 qual=50 noise=0 level=-60 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=46 noise=0 level=-64 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=46 noise=0 level=-64 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=38 noise=0 level=-72 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=38 noise=0 level=-72 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=38 noise=0 level=-72 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
bc:05:43:79:f9:47 freq=2412 qual=62 noise=0 level=-48 flags=0xa
wlan0: BSS: Start scan result update 34
Add randomness: count=225 entropy=224
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=226 entropy=225
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=227 entropy=226
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=228 entropy=227
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=229 entropy=228
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=230 entropy=229
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=231 entropy=230
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=232 entropy=231
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60 wps
wlan0: skip - SSID mismatch
wlan0: 1: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 2: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 3: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: 4: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 5: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 6: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 7: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=0 rsn_ie_len=0 caps=0x11 level=-48
wlan0: skip - no WPA/RSN proto match
wlan0: No suitable network found
wlan0: Setting scan request: 5 sec 0 usec
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 4059 bytes of scan results (8 BSSes)
Sorted scan results
f4:ec:38:bd:63:d2 freq=2452 qual=50 noise=0 level=-60 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=46 noise=0 level=-64 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=46 noise=0 level=-64 flags=0xa
00:1c:4a:46:75:28 freq=2462 qual=38 noise=0 level=-72 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=38 noise=0 level=-72 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=38 noise=0 level=-72 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
bc:05:43:79:f9:47 freq=2412 qual=62 noise=0 level=-48 flags=0xa
wlan0: BSS: Start scan result update 35
Add randomness: count=233 entropy=232
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=234 entropy=233
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=235 entropy=234
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=236 entropy=235
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=237 entropy=236
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=238 entropy=237
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=239 entropy=238
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=240 entropy=239
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: f4:ec:38:bd:63:d2 ssid='Honeypot' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-60 wps
wlan0: skip - SSID mismatch
wlan0: 1: cc:5d:4e:ed:5e:a0 ssid='WLAN0511-24' wpa_ie_len=0 rsn_ie_len=20 caps=0x11 level=-64
wlan0: skip - SSID mismatch
wlan0: 2: 00:23:54:ac:69:61 ssid='c46bec' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-64 wps
wlan0: skip - SSID mismatch
wlan0: 3: 00:1c:4a:46:75:28 ssid='WLAN-001C4A467528' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-72
wlan0: skip - SSID mismatch
wlan0: 4: bc:05:43:17:3d:8d ssid='Engelchens FRITZ!Box' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 5: 74:31:70:a9:6d:f9 ssid='Mohr' wpa_ie_len=28 rsn_ie_len=24 caps=0x11 level=-72 wps
wlan0: skip - SSID mismatch
wlan0: 6: 08:96:d7:4f:7d:97 ssid='FRITZ!Box 7312' wpa_ie_len=22 rsn_ie_len=20 caps=0x11 level=-74 wps
wlan0: skip - SSID mismatch
wlan0: 7: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=0 rsn_ie_len=0 caps=0x11 level=-48
wlan0: skip - no WPA/RSN proto match
wlan0: No suitable network found
wlan0: Setting scan request: 5 sec 0 usec
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b19 len=16
wlan0: Event SCAN_RESULTS (3) received
Received 3748 bytes of scan results (7 BSSes)
Sorted scan results
bc:05:43:79:f9:47 freq=2412 qual=58 noise=0 level=-52 flags=0xa
f4:ec:38:bd:63:d2 freq=2452 qual=50 noise=0 level=-60 flags=0xa
cc:5d:4e:ed:5e:a0 freq=2472 qual=46 noise=0 level=-64 flags=0xa
00:23:54:ac:69:61 freq=2412 qual=42 noise=0 level=-68 flags=0xa
bc:05:43:17:3d:8d freq=2447 qual=38 noise=0 level=-72 flags=0xa
74:31:70:a9:6d:f9 freq=2422 qual=38 noise=0 level=-72 flags=0xa
08:96:d7:4f:7d:97 freq=2412 qual=36 noise=0 level=-74 flags=0xa
wlan0: BSS: Start scan result update 36
Add randomness: count=241 entropy=240
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=242 entropy=241
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=243 entropy=242
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=244 entropy=243
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=245 entropy=244
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=246 entropy=245
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
Add randomness: count=247 entropy=246
random pool - hexdump(len=128): [REMOVED]
random_mix_pool - hexdump(len=16): [REMOVED]
random_mix_pool - hexdump(len=5): [REMOVED]
random pool - hexdump(len=128): [REMOVED]
wlan0: New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: WFA subelement id=0 len=1
wlan0: Selecting BSS from priority group 0
wlan0: 0: bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112' wpa_ie_len=24 rsn_ie_len=20 caps=0x11 level=-52
wlan0: selected based on RSN IE
wlan0: selected BSS bc:05:43:79:f9:47 ssid='FRITZ!Box Fon WLAN 7112'
wlan0: Request association: reassociate: 1 selected: bc:05:43:79:f9:47 bssid: 00:00:00:00:00:00 pending: 00:00:00:00:00:00 wpa_state: SCANNING
wlan0: Trying to associate with bc:05:43:79:f9:47 (SSID='FRITZ!Box Fon WLAN 7112' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
wlan0: Cancelling scan request
wlan0: WPA: clearing own WPA/RSN IE
wlan0: Automatic auth_alg selection: 0x1
wlan0: RSN: using IEEE 802.11i/D9.0
wlan0: WPA: Selected cipher suites: group 8 pairwise 16 key_mgmt 2 proto 2
WPA: set AP WPA IE - hexdump(len=26): dd 18 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 02 01 00 00 50 f2 02 00 00
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: WPA: using GTK TKIP
wlan0: WPA: using PTK CCMP
wlan0: WPA: using KEY_MGMT WPA-PSK
wlan0: WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 02 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
wlan0: No keys have been configured - skip key clearing
wlan0: State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
wlan0: Association request to the driver failed
wlan0: Setting authentication timeout: 5 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RSN: Ignored PMKID candidate without preauth flag
wlan0: Checking for other virtual interfaces sharing same radio (phy0) in event_scan_results
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
WEXT: if_removed already cleared - ignore event
Wireless event: cmd=0x8b1a len=39
wlan0: Authentication with bc:05:43:79:f9:47 timed out.
Added BSSID bc:05:43:79:f9:47 into blacklist
wlan0: No keys have been configured - skip key clearing
wlan0: State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
wlan0: Setting scan request: 1 sec 0 usec
wlan0: State: DISCONNECTED -> SCANNING
wlan0: Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
- --
Diese Nachricht wurde von meinem Android-Mobiltelefon mit K-9 Mail gesendet.
-----BEGIN PGP SIGNATURE-----
Version: APG v1.1.1

iQJIBAEBCgAyBQJTc9B6KxxTdGVmYW4gS3L8Z2VyIDxzdGVmYW4ua3J1ZWdlckB2
b2RhZm9uZS5kZT4ACgkQKfL7XZZDcf1R8A/+Kz2Jy/f1vMZhJBmDpaZfduFxW1hx
7+1BwYJ9u9J9kaK/RJQ4+Dj2iDLqa/NnU9pth0r9GC7OfNobFbx7BXGPDWhM3UwK
pB1opmFbR/m/0H+p9GI6Kpo2mjmFrKESY1fbE3Dd5bDJOZI5oy6jw4dMKLdVdGbe
XFSh0gAy1Aj7vN8XQo1TbveiwF7KFraGEDmmc7zU4FVI2yNOCT0IyzHxEajbD9ck
fR3xsEmBlm8c1d9+ho4hZURXkTKqGOtvN1VdS702CZX3wWDvxjoc61bRH+hI1lp7
I33OiA7BWKvjcrJDVihUyqAJIlS3WEN0gd7xlRAcrtoA9aob2NlvWWXMTf1JyU+N
QIZQa5bPt3gWnOEYNnFOgcb305657uIVOzkpDZw5YEV8rwSgzs6HexTFI2TA5rTy
cfeO3e+RiExMZaznkaEAp6UzdvtLud7X3XouWZyaM7KmZGK7AQMSyBqLvTxOgm2i
to7w/NuTWXU5O/p0vPMnN9slMZxynVR70lnZyoWo3uDC5pxAcmHcS+brSCVCeeMM
To/Ey9Nsypl5uHsYw/NP+N9l2MlG94GEdranYahN/okb2IGeZ6AqHtsU9RP5zh66
4kvEVUwZ9JiWy7ADigRZ0PUePnosgOFioTDG2QuK7s8MU/qdq6VB/TVFAC+WUjw/
5R1/wyjjb8zIC+8=
=+WlS
-----END PGP SIGNATURE-----

