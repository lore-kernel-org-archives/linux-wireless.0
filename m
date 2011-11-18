Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from youngberry.canonical.com ([91.189.89.112]:36080 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755754Ab1KRWy3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 18 Nov 2011 17:54:29 -0500
Date: Fri, 18 Nov 2011 16:54:22 -0600
From: Seth Forshee <seth.forshee@canonical.com>
To: Larry Finger <Larry.Finger@lwfinger.net>,
	Chaoming Li <chaoming_li@realsil.com.cn>
Cc: linux-wireless@vger.kernel.org
Subject: Problems associating with RTL8188CE
Message-ID: <20111118225422.GD19138@thinkpad-t410> (sfid-20111118_235433_382686_E158A9FD)
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="6sX45UoQRIJXqkqR"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

I'm seeing a lot of problems associating with APs when using a Toshiba
NB505 with RTL8188CE wireless. The situation seems to have improved
quite a bit when I moved from 3.0 to 3.2-rc2, but I still see a good
number of failed associations. This card doesn't seem to like my Linksys
E2000 router in particular; I rarely see a successful association with
this router.

I'm attaching logs from the kernel and wpa_supplicant from some failed
associations with the E2000 along with the wpa_supplicant configuration
I used. I loaded rtl8192ce with debug=3, but if more verbosity or any
other information is needed, please let me know.

Thanks,
Seth

--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="wpa-supplicant.log"

Initializing interface 'wlan0' conf 'wpa_supplicant.conf' driver 'default' ctrl_interface 'N/A' bridge 'N/A'
Configuration file 'wpa_supplicant.conf' -> '/home/sforshee/wpa_supplicant.conf'
Reading configuration file '/home/sforshee/wpa_supplicant.conf'
Line: 1 - start of a new network block
ssid - hexdump_ascii(len=6):
     4b 61 69 6c 69 61                                 Kailia          
scan_ssid=1 (0x1)
key_mgmt: 0x2
PSK (ASCII passphrase) - hexdump_ascii(len=22): [REMOVED]
PSK (from passphrase) - hexdump(len=32): [REMOVED]
Priority group 0
   id=0 ssid='Kailia'
WEXT: cfg80211-based driver detected
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
  capabilities: key_mgmt 0xf enc 0xf flags 0x0
netlink: Operstate: linkmode=1, operstate=5
Own MAC address: 7c:4f:b5:c7:a5:53
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=4 set_tx=0 seq_len=0 key_len=0
Driver did not support SIOCSIWENCODEEXT
wpa_driver_wext_set_key: alg=0 key_idx=5 set_tx=0 seq_len=0 key_len=0
Driver did not support SIOCSIWENCODEEXT
wpa_driver_wext_set_countermeasures
RSN: flushing PMKID list in the driver
Setting scan request: 0 sec 100000 usec
WPS: UUID based on MAC address - hexdump(len=16): bb 15 a1 23 32 80 50 ef 91 fb cc 63 e2 40 66 22
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: Supplicant port status: Unauthorized
Added interface wlan0
RTM_NEWLINK: operstate=0 ifi_flags=0x1043 ([UP][RUNNING])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b1a len=16
State: DISCONNECTED -> SCANNING
Scan SSID - hexdump_ascii(len=6):
     4b 61 69 6c 69 61                                 Kailia          
Starting AP scan for specific SSID(s)
Scan requested (ret=0) - scan timeout 5 seconds
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b19 len=16
Received 3662 bytes of scan results (8 BSSes)
BSS: Start scan result update 1
BSS: Add new id 0 BSSID c0:c1:c0:01:e8:1c SSID 'Kailia'
BSS: Add new id 1 BSSID 00:25:3c:2d:1b:09 SSID '2WIRE639'
BSS: Add new id 2 BSSID 02:24:8c:65:b8:09 SSID 'Piria'
BSS: Add new id 3 BSSID 00:24:56:a0:d1:e9 SSID '2WIRE576'
BSS: Add new id 4 BSSID 00:24:8c:65:b8:08 SSID 'Nisyros'
BSS: Add new id 5 BSSID 00:1d:5a:7c:63:51 SSID '2WIRE788'
BSS: Add new id 6 BSSID 90:84:0d:de:96:01 SSID 'R-network'
BSS: Add new id 7 BSSID 00:14:d1:ca:8e:58 SSID ''
New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: c0:c1:c0:01:e8:1c ssid='Kailia' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   selected based on RSN IE
   selected WPA AP c0:c1:c0:01:e8:1c ssid='Kailia'
Trying to associate with c0:c1:c0:01:e8:1c (SSID='Kailia' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
Setting authentication timeout: 10 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b1a len=22
Authentication with c0:c1:c0:01:e8:1c timed out.
Added BSSID c0:c1:c0:01:e8:1c into blacklist
No keys have been configured - skip key clearing
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Received 6429 bytes of scan results (14 BSSes)
BSS: Start scan result update 2
BSS: Add new id 8 BSSID 98:fc:11:74:62:f2 SSID 'CSJHC'
BSS: Add new id 9 BSSID 00:1f:33:df:ce:2a SSID 'BandP'
BSS: Add new id 10 BSSID 00:02:6f:6b:ce:e6 SSID '09b239332'
BSS: Add new id 11 BSSID 00:1d:5a:70:8d:59 SSID '2WIRE868'
BSS: Add new id 12 BSSID 98:2c:be:20:f1:89 SSID '2WIRE065'
BSS: Add new id 13 BSSID 96:84:0d:de:96:01 SSID 'R-guest'
New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 00:25:3c:2d:1b:09 ssid='2WIRE639' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
1: 00:24:8c:65:b8:08 ssid='Nisyros' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
2: 02:24:8c:65:b8:09 ssid='Piria' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
3: 00:24:56:a0:d1:e9 ssid='2WIRE576' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
4: 98:fc:11:74:62:f2 ssid='CSJHC' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
5: 90:84:0d:de:96:01 ssid='R-network' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
6: 00:1f:33:df:ce:2a ssid='BandP' wpa_ie_len=24 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
7: 00:02:6f:6b:ce:e6 ssid='09b239332' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
8: c0:c1:c0:01:e8:1c ssid='Kailia' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   selected based on RSN IE
   selected WPA AP c0:c1:c0:01:e8:1c ssid='Kailia'
Trying to associate with c0:c1:c0:01:e8:1c (SSID='Kailia' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
Setting authentication timeout: 10 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b1a len=22
Authentication with c0:c1:c0:01:e8:1c timed out.
BSSID c0:c1:c0:01:e8:1c blacklist count incremented to 2
No keys have been configured - skip key clearing
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Scan SSID - hexdump_ascii(len=6):
     4b 61 69 6c 69 61                                 Kailia          
Starting AP scan for specific SSID(s)
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Received 5757 bytes of scan results (13 BSSes)
BSS: Start scan result update 3
BSS: Add new id 14 BSSID 00:1d:5a:e2:55:d9 SSID '2WIRE172'
BSS: Add new id 15 BSSID 00:21:7c:7a:27:91 SSID '2WIRE933'
New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1041 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=12
WPS: attr type=0x1023 len=13
WPS: attr type=0x1024 len=7
WPS: attr type=0x1042 len=2
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=13
WPS: attr type=0x1008 len=2
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1041 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=12
WPS: attr type=0x1023 len=13
WPS: attr type=0x1024 len=7
WPS: attr type=0x1042 len=2
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=13
WPS: attr type=0x1008 len=2
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 98:fc:11:74:62:f2 ssid='CSJHC' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:1f:33:df:ce:2a ssid='BandP' wpa_ie_len=24 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
2: 00:02:6f:6b:ce:e6 ssid='09b239332' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
3: 02:24:8c:65:b8:09 ssid='Piria' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
4: 00:24:56:a0:d1:e9 ssid='2WIRE576' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
5: 00:24:8c:65:b8:08 ssid='Nisyros' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
6: 00:1d:5a:70:8d:59 ssid='2WIRE868' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
7: 00:1d:5a:e2:55:d9 ssid='2WIRE172' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
8: 00:21:7c:7a:27:91 ssid='2WIRE933' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
9: 90:84:0d:de:96:01 ssid='R-network' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
10: 98:2c:be:20:f1:89 ssid='2WIRE065' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
11: 96:84:0d:de:96:01 ssid='R-guest' wpa_ie_len=0 rsn_ie_len=0 caps=0x1
   skip - no WPA/RSN IE
12: 00:14:d1:ca:8e:58 ssid='' wpa_ie_len=0 rsn_ie_len=0 caps=0x1
   skip - SSID not known
Try to find non-WPA AP
0: 98:fc:11:74:62:f2 ssid='CSJHC' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:1f:33:df:ce:2a ssid='BandP' wpa_ie_len=24 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
2: 00:02:6f:6b:ce:e6 ssid='09b239332' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
3: 02:24:8c:65:b8:09 ssid='Piria' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
4: 00:24:56:a0:d1:e9 ssid='2WIRE576' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
5: 00:24:8c:65:b8:08 ssid='Nisyros' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
6: 00:1d:5a:70:8d:59 ssid='2WIRE868' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
7: 00:1d:5a:e2:55:d9 ssid='2WIRE172' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
8: 00:21:7c:7a:27:91 ssid='2WIRE933' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
9: 90:84:0d:de:96:01 ssid='R-network' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
10: 98:2c:be:20:f1:89 ssid='2WIRE065' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
11: 96:84:0d:de:96:01 ssid='R-guest' wpa_ie_len=0 rsn_ie_len=0 caps=0x1
   skip - SSID mismatch
12: 00:14:d1:ca:8e:58 ssid='' wpa_ie_len=0 rsn_ie_len=0 caps=0x1
   skip - SSID not known
No APs found - clear blacklist and try again
Removed BSSID c0:c1:c0:01:e8:1c from blacklist (clear)
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 98:fc:11:74:62:f2 ssid='CSJHC' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:1f:33:df:ce:2a ssid='BandP' wpa_ie_len=24 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
2: 00:02:6f:6b:ce:e6 ssid='09b239332' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
3: 02:24:8c:65:b8:09 ssid='Piria' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
4: 00:24:56:a0:d1:e9 ssid='2WIRE576' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
5: 00:24:8c:65:b8:08 ssid='Nisyros' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
6: 00:1d:5a:70:8d:59 ssid='2WIRE868' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
7: 00:1d:5a:e2:55:d9 ssid='2WIRE172' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
8: 00:21:7c:7a:27:91 ssid='2WIRE933' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
9: 90:84:0d:de:96:01 ssid='R-network' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
10: 98:2c:be:20:f1:89 ssid='2WIRE065' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
11: 96:84:0d:de:96:01 ssid='R-guest' wpa_ie_len=0 rsn_ie_len=0 caps=0x1
   skip - no WPA/RSN IE
12: 00:14:d1:ca:8e:58 ssid='' wpa_ie_len=0 rsn_ie_len=0 caps=0x1
   skip - SSID not known
Try to find non-WPA AP
0: 98:fc:11:74:62:f2 ssid='CSJHC' wpa_ie_len=28 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:1f:33:df:ce:2a ssid='BandP' wpa_ie_len=24 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
2: 00:02:6f:6b:ce:e6 ssid='09b239332' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
3: 02:24:8c:65:b8:09 ssid='Piria' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
4: 00:24:56:a0:d1:e9 ssid='2WIRE576' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
5: 00:24:8c:65:b8:08 ssid='Nisyros' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
6: 00:1d:5a:70:8d:59 ssid='2WIRE868' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
7: 00:1d:5a:e2:55:d9 ssid='2WIRE172' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
8: 00:21:7c:7a:27:91 ssid='2WIRE933' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
9: 90:84:0d:de:96:01 ssid='R-network' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
10: 98:2c:be:20:f1:89 ssid='2WIRE065' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
11: 96:84:0d:de:96:01 ssid='R-guest' wpa_ie_len=0 rsn_ie_len=0 caps=0x1
   skip - SSID mismatch
12: 00:14:d1:ca:8e:58 ssid='' wpa_ie_len=0 rsn_ie_len=0 caps=0x1
   skip - SSID not known
No suitable network found
Setting scan request: 5 sec 0 usec
Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Received 5323 bytes of scan results (12 BSSes)
BSS: Start scan result update 4
BSS: Expire BSS 1 due to no match in scan
BSS: Remove id 1 BSSID 00:25:3c:2d:1b:09 SSID '2WIRE639'
BSS: Expire BSS 5 due to no match in scan
BSS: Remove id 5 BSSID 00:1d:5a:7c:63:51 SSID '2WIRE788'
New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 02:24:8c:65:b8:09 ssid='Piria' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:24:8c:65:b8:08 ssid='Nisyros' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
2: 00:1d:5a:e2:55:d9 ssid='2WIRE172' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
3: 00:24:56:a0:d1:e9 ssid='2WIRE576' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
4: 90:84:0d:de:96:01 ssid='R-network' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
5: 00:1d:5a:70:8d:59 ssid='2WIRE868' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
6: 00:02:6f:6b:ce:e6 ssid='09b239332' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
7: 00:21:7c:7a:27:91 ssid='2WIRE933' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
8: c0:c1:c0:01:e8:1c ssid='Kailia' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   selected based on RSN IE
   selected WPA AP c0:c1:c0:01:e8:1c ssid='Kailia'
Trying to associate with c0:c1:c0:01:e8:1c (SSID='Kailia' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
Setting authentication timeout: 10 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b1a len=22
Authentication with c0:c1:c0:01:e8:1c timed out.
Added BSSID c0:c1:c0:01:e8:1c into blacklist
No keys have been configured - skip key clearing
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Scan SSID - hexdump_ascii(len=6):
     4b 61 69 6c 69 61                                 Kailia          
Starting AP scan for specific SSID(s)
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Received 5185 bytes of scan results (12 BSSes)
BSS: Start scan result update 5
BSS: Add new id 16 BSSID 00:25:3c:2d:1b:09 SSID '2WIRE639'
BSS: Expire BSS 8 due to no match in scan
BSS: Remove id 8 BSSID 98:fc:11:74:62:f2 SSID 'CSJHC'
BSS: Expire BSS 9 due to no match in scan
BSS: Remove id 9 BSSID 00:1f:33:df:ce:2a SSID 'BandP'
New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 02:24:8c:65:b8:09 ssid='Piria' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:24:8c:65:b8:08 ssid='Nisyros' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
2: 90:84:0d:de:96:01 ssid='R-network' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
3: 00:1d:5a:70:8d:59 ssid='2WIRE868' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
4: 00:02:6f:6b:ce:e6 ssid='09b239332' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
5: 00:1d:5a:e2:55:d9 ssid='2WIRE172' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
6: 00:21:7c:7a:27:91 ssid='2WIRE933' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
7: c0:c1:c0:01:e8:1c ssid='Kailia' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   selected based on RSN IE
   selected WPA AP c0:c1:c0:01:e8:1c ssid='Kailia'
Trying to associate with c0:c1:c0:01:e8:1c (SSID='Kailia' freq=2412 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 0c 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_psk
Setting authentication timeout: 10 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b1a len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b1a len=22
Authentication with c0:c1:c0:01:e8:1c timed out.
BSSID c0:c1:c0:01:e8:1c blacklist count incremented to 2
No keys have been configured - skip key clearing
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan for wildcard SSID
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Wireless event: cmd=0x8b19 len=16
Scan results did not fit - trying larger buffer (8192 bytes)
Received 6028 bytes of scan results (14 BSSes)
BSS: Start scan result update 6
BSS: Add new id 17 BSSID 00:1d:5a:7c:63:51 SSID '2WIRE788'
New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 02:24:8c:65:b8:09 ssid='Piria' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:24:8c:65:b8:08 ssid='Nisyros' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
2: 90:84:0d:de:96:01 ssid='R-network' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
3: 00:1d:5a:70:8d:59 ssid='2WIRE868' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
4: 00:02:6f:6b:ce:e6 ssid='09b239332' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
5: 00:1d:5a:e2:55:d9 ssid='2WIRE172' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
6: 00:21:7c:7a:27:91 ssid='2WIRE933' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
7: 00:25:3c:2d:1b:09 ssid='2WIRE639' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
8: c0:c1:c0:01:e8:1c ssid='Kailia' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - blacklisted
9: 00:24:56:a0:d1:e9 ssid='2WIRE576' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
10: 00:1d:5a:7c:63:51 ssid='2WIRE788' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
11: 98:2c:be:20:f1:89 ssid='2WIRE065' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
12: 00:14:d1:ca:8e:58 ssid='' wpa_ie_len=0 rsn_ie_len=0 caps=0x1
   skip - SSID not known
13: 96:84:0d:de:96:01 ssid='R-guest' wpa_ie_len=0 rsn_ie_len=0 caps=0x1
   skip - no WPA/RSN IE
Try to find non-WPA AP
0: 02:24:8c:65:b8:09 ssid='Piria' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
1: 00:24:8c:65:b8:08 ssid='Nisyros' wpa_ie_len=0 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
2: 90:84:0d:de:96:01 ssid='R-network' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - SSID mismatch
3: 00:1d:5a:70:8d:59 ssid='2WIRE868' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
4: 00:02:6f:6b:ce:e6 ssid='09b239332' wpa_ie_len=26 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
5: 00:1d:5a:e2:55:d9 ssid='2WIRE172' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
6: 00:21:7c:7a:27:91 ssid='2WIRE933' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
7: 00:25:3c:2d:1b:09 ssid='2WIRE639' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
8: c0:c1:c0:01:e8:1c ssid='Kailia' wpa_ie_len=0 rsn_ie_len=20 caps=0x11
   skip - blacklisted
9: 00:24:56:a0:d1:e9 ssid='2WIRE576' wpa_ie_len=26 rsn_ie_len=24 caps=0x11
   skip - SSID mismatch
10: 00:1d:5a:7c:63:51 ssid='2WIRE788' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
11: 98:2c:be:20:f1:89 ssid='2WIRE065' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
12: 00:14:d1:ca:8e:58 ssid='' wpa_ie_len=0 rsn_ie_len=0 caps=0x1
   skip - SSID not known
13: 96:84:0d:de:96:01 ssid='R-guest' wpa_ie_len=0 rsn_ie_len=0 caps=0x1
   skip - SSID mismatch
No APs found - clear blacklist and try again
Removed BSSID c0:c1:c0:01:e8:1c from blacklist (clear)
Selecting BSS from priority group 0
Try to find WPA-enabled AP

--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="dmesg.log"

Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5360.904322] cfg80211: Calling CRDA to update world regulatory domain
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5360.932587] cfg80211: World regulatory domain updated:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5360.936510] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5360.940574] cfg80211:     (2402000 KHz - 2472000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5360.944608] cfg80211:     (2457000 KHz - 2482000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5360.948602] cfg80211:     (2474000 KHz - 2494000 KHz @ 20000 KHz), (300 mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5360.952533] cfg80211:     (5170000 KHz - 5250000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5360.956189] cfg80211:     (5735000 KHz - 5835000 KHz @ 40000 KHz), (300 mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5360.969504] rtl8192ce 0000:07:00.0: PCI INT A -> GSI 17 (level, low) -> IRQ 17
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5360.972820] rtl8192ce 0000:07:00.0: setting latency timer to 64
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5360.989838] rtlwifi:_rtl_init_hw_ht_capab():<0-0> 1T1R
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5360.993372] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5360.996464] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.000213] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.003857] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.007517] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.011409] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.016258] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.021505] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.026713] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.032082] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.037470] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.042979] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.048530] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.054266] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.059972] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.065798] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.071714] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.077903] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.084091] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.091445] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.098092] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.104631] cfg80211: 2402000 KHz - 2472000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.111276] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.118075] cfg80211: 2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.124764] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.131602] cfg80211: 2457000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.138441] cfg80211: Disabling freq 2484 MHz as custom regd has no rule that fits a 20 MHz wide channel
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.145891] cfg80211: Ignoring regulatory request Set by core since the driver uses its own custom regulatory domain
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.150945] ieee80211 phy0: Selected rate control algorithm 'rtl_rc'
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.157645] rtlwifi: wireless switch is on
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.165004] cfg80211: Calling CRDA for country: EC
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.194684] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.199637] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204386] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204398] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204406] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204415] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204422] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204430] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204437] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204445] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204452] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204460] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204467] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204475] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204482] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204491] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204497] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204506] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204512] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204521] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204528] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204536] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204543] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204551] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204558] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with regulatory rule:
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204566] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204572] cfg80211: Disabling freq 2484 MHz
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204583] cfg80211: Regulatory domain changed to country: EC
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204588] cfg80211:     (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204596] cfg80211:     (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204603] cfg80211:     (5170000 KHz - 5250000 KHz @ 20000 KHz), (300 mBi, 1700 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204611] cfg80211:     (5250000 KHz - 5330000 KHz @ 20000 KHz), (300 mBi, 2300 mBm)
Nov 18 16:23:38 ubuntu-NB505 kernel: [ 5361.204619] cfg80211:     (5735000 KHz - 5835000 KHz @ 20000 KHz), (300 mBi, 3000 mBm)
Nov 18 16:23:43 ubuntu-NB505 kernel: [ 5365.985224] rtl8192c_common: Loading firmware file rtlwifi/rtl8192cfw.bin
Nov 18 16:23:43 ubuntu-NB505 kernel: [ 5365.989357] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware Version(49), Signature(0x88c1),Size(32)
Nov 18 16:23:43 ubuntu-NB505 kernel: [ 5366.320052] rtlwifi:rtl_pci_start():<0-0> OK
Nov 18 16:23:43 ubuntu-NB505 kernel: [ 5366.335029] ADDRCONF(NETDEV_UP): wlan0: link is not ready
Nov 18 16:23:43 ubuntu-NB505 kernel: [ 5366.424070] rtl8192ce:_rtl92ce_phy_set_rf_power_state():<0-0> IPS Set eRf nic disable
Nov 18 16:23:43 ubuntu-NB505 kernel: [ 5366.481833] rtl8192ce:_rtl92ce_phy_set_rf_power_state():<0-0> IPS Set eRf nic enable
Nov 18 16:23:43 ubuntu-NB505 kernel: [ 5366.490556] rtl8192c_common: Loading firmware file rtlwifi/rtl8192cfw.bin
Nov 18 16:23:43 ubuntu-NB505 kernel: [ 5366.496684] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware Version(49), Signature(0x88c1),Size(32)
Nov 18 16:23:45 ubuntu-NB505 kernel: [ 5367.690674] wlan0: direct probe to c0:c1:c0:01:e8:1c (try 1/3)
Nov 18 16:23:45 ubuntu-NB505 kernel: [ 5367.706420] wlan0: direct probe responded
Nov 18 16:23:45 ubuntu-NB505 kernel: [ 5367.724064] wlan0: authenticate with c0:c1:c0:01:e8:1c (try 1)
Nov 18 16:23:45 ubuntu-NB505 kernel: [ 5367.724093] rtlwifi:rtl_pci_tx():<200-1> MAC80211_LINKING
Nov 18 16:23:45 ubuntu-NB505 kernel: [ 5367.788092] rtl8192ce:_rtl92ce_phy_set_rf_power_state():<0-0> IPS Set eRf nic disable
Nov 18 16:23:45 ubuntu-NB505 kernel: [ 5367.924090] wlan0: authenticate with c0:c1:c0:01:e8:1c (try 2)
Nov 18 16:23:45 ubuntu-NB505 kernel: [ 5368.124091] wlan0: authenticate with c0:c1:c0:01:e8:1c (try 3)
Nov 18 16:23:45 ubuntu-NB505 kernel: [ 5368.324086] wlan0: authentication with c0:c1:c0:01:e8:1c timed out
Nov 18 16:23:55 ubuntu-NB505 kernel: [ 5377.692058] rtl8192ce:_rtl92ce_phy_set_rf_power_state():<0-0> IPS Set eRf nic enable
Nov 18 16:23:55 ubuntu-NB505 kernel: [ 5377.698428] rtl8192c_common: Loading firmware file rtlwifi/rtl8192cfw.bin
Nov 18 16:23:55 ubuntu-NB505 kernel: [ 5377.702379] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware Version(49), Signature(0x88c1),Size(32)
Nov 18 16:23:56 ubuntu-NB505 kernel: [ 5378.894976] wlan0: authenticate with c0:c1:c0:01:e8:1c (try 1)
Nov 18 16:23:56 ubuntu-NB505 kernel: [ 5378.895011] rtlwifi:rtl_pci_tx():<200-1> MAC80211_LINKING
Nov 18 16:23:56 ubuntu-NB505 kernel: [ 5378.992092] rtl8192ce:_rtl92ce_phy_set_rf_power_state():<0-0> IPS Set eRf nic disable
Nov 18 16:23:56 ubuntu-NB505 kernel: [ 5379.092069] wlan0: authenticate with c0:c1:c0:01:e8:1c (try 2)
Nov 18 16:23:56 ubuntu-NB505 kernel: [ 5379.292089] wlan0: authenticate with c0:c1:c0:01:e8:1c (try 3)
Nov 18 16:23:56 ubuntu-NB505 kernel: [ 5379.496078] wlan0: authentication with c0:c1:c0:01:e8:1c timed out
Nov 18 16:24:06 ubuntu-NB505 kernel: [ 5388.897510] rtl8192ce:_rtl92ce_phy_set_rf_power_state():<0-0> IPS Set eRf nic enable
Nov 18 16:24:06 ubuntu-NB505 kernel: [ 5388.905087] rtl8192c_common: Loading firmware file rtlwifi/rtl8192cfw.bin
Nov 18 16:24:06 ubuntu-NB505 kernel: [ 5388.910213] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware Version(49), Signature(0x88c1),Size(32)
Nov 18 16:24:07 ubuntu-NB505 kernel: [ 5390.200085] rtl8192ce:_rtl92ce_phy_set_rf_power_state():<0-0> IPS Set eRf nic disable
Nov 18 16:24:12 ubuntu-NB505 kernel: [ 5395.108685] rtl8192ce:_rtl92ce_phy_set_rf_power_state():<0-0> IPS Set eRf nic enable
Nov 18 16:24:12 ubuntu-NB505 kernel: [ 5395.117237] rtl8192c_common: Loading firmware file rtlwifi/rtl8192cfw.bin
Nov 18 16:24:12 ubuntu-NB505 kernel: [ 5395.124784] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware Version(49), Signature(0x88c1),Size(32)
Nov 18 16:24:13 ubuntu-NB505 kernel: [ 5396.318437] wlan0: authenticate with c0:c1:c0:01:e8:1c (try 1)
Nov 18 16:24:13 ubuntu-NB505 kernel: [ 5396.322251] rtlwifi:rtl_pci_tx():<200-1> MAC80211_LINKING
Nov 18 16:24:13 ubuntu-NB505 kernel: [ 5396.416083] rtl8192ce:_rtl92ce_phy_set_rf_power_state():<0-0> IPS Set eRf nic disable
Nov 18 16:24:14 ubuntu-NB505 kernel: [ 5396.524076] wlan0: authenticate with c0:c1:c0:01:e8:1c (try 2)
Nov 18 16:24:14 ubuntu-NB505 kernel: [ 5396.724078] wlan0: authenticate with c0:c1:c0:01:e8:1c (try 3)
Nov 18 16:24:14 ubuntu-NB505 kernel: [ 5396.928077] wlan0: authentication with c0:c1:c0:01:e8:1c timed out
Nov 18 16:24:23 ubuntu-NB505 kernel: [ 5406.328680] rtl8192ce:_rtl92ce_phy_set_rf_power_state():<0-0> IPS Set eRf nic enable
Nov 18 16:24:23 ubuntu-NB505 kernel: [ 5406.331206] rtl8192c_common: Loading firmware file rtlwifi/rtl8192cfw.bin
Nov 18 16:24:23 ubuntu-NB505 kernel: [ 5406.331219] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware Version(49), Signature(0x88c1),Size(32)
Nov 18 16:24:25 ubuntu-NB505 kernel: [ 5407.519229] wlan0: direct probe to c0:c1:c0:01:e8:1c (try 1/3)
Nov 18 16:24:25 ubuntu-NB505 kernel: [ 5407.616070] rtl8192ce:_rtl92ce_phy_set_rf_power_state():<0-0> IPS Set eRf nic disable
Nov 18 16:24:25 ubuntu-NB505 kernel: [ 5407.720073] wlan0: direct probe to c0:c1:c0:01:e8:1c (try 2/3)
Nov 18 16:24:25 ubuntu-NB505 kernel: [ 5407.924075] wlan0: direct probe to c0:c1:c0:01:e8:1c (try 3/3)
Nov 18 16:24:25 ubuntu-NB505 kernel: [ 5408.124099] wlan0: direct probe to c0:c1:c0:01:e8:1c timed out
Nov 18 16:24:35 ubuntu-NB505 kernel: [ 5417.520334] rtl8192ce:_rtl92ce_phy_set_rf_power_state():<0-0> IPS Set eRf nic enable
Nov 18 16:24:35 ubuntu-NB505 kernel: [ 5417.522861] rtl8192c_common: Loading firmware file rtlwifi/rtl8192cfw.bin
Nov 18 16:24:35 ubuntu-NB505 kernel: [ 5417.522875] rtl8192c_common:rtl92c_download_fw():<0-0> Firmware Version(49), Signature(0x88c1),Size(32)
Nov 18 16:24:36 ubuntu-NB505 kernel: [ 5418.710601] wlan0: direct probe to c0:c1:c0:01:e8:1c (try 1/3)
Nov 18 16:24:36 ubuntu-NB505 kernel: [ 5418.808042] rtl8192ce:_rtl92ce_phy_set_rf_power_state():<0-0> IPS Set eRf nic disable
Nov 18 16:24:36 ubuntu-NB505 kernel: [ 5418.908061] wlan0: direct probe to c0:c1:c0:01:e8:1c (try 2/3)
Nov 18 16:24:36 ubuntu-NB505 kernel: [ 5419.108090] wlan0: direct probe to c0:c1:c0:01:e8:1c (try 3/3)
Nov 18 16:24:36 ubuntu-NB505 kernel: [ 5419.312085] wlan0: direct probe to c0:c1:c0:01:e8:1c timed out

--6sX45UoQRIJXqkqR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename="wpa_supplicant.conf"

network={
	ssid="Kailia"
	scan_ssid=1
	key_mgmt=WPA-PSK
	psk=[omitted]
}

--6sX45UoQRIJXqkqR--
