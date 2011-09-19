Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f45.google.com ([209.85.215.45]:47912 "EHLO
	mail-ew0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755050Ab1ISUFu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 19 Sep 2011 16:05:50 -0400
Received: by ewy28 with SMTP id 28so1035048ewy.4
        for <linux-wireless@vger.kernel.org>; Mon, 19 Sep 2011 13:05:49 -0700 (PDT)
Message-ID: <4E77A065.4070300@gmail.com> (sfid-20110919_220555_708960_B48CB694)
Date: Mon, 19 Sep 2011 22:04:53 +0200
From: Stefan Zwanenburg <stefanhetzwaantje@gmail.com>
MIME-Version: 1.0
To: =?UTF-8?B?5p2O5pyd5piO?= <chaoming_li@realsil.com.cn>
CC: 'Larry Finger' <Larry.Finger@lwfinger.net>,
	linux-wireless@vger.kernel.org
Subject: Re: =?UTF-8?B?562U5aSNOiDnrZTlpI06IOetlOWkjTogUlRMODE5MlNFIGFuZCA=?=
 =?UTF-8?B?ODAyLjExbiBwcm9ibGVt?=
References: <4E67CE3F.8090405@gmail.com> <4E67CEA3.7020709@gmail.com> <4E682732.1040700@lwfinger.net> <4E682D68.1070408@lwfinger.net> <4E68353D.3010505@gmail.com> <4E6839A4.9010403@lwfinger.net> <8117B559D4E64A83837479A8C342A5CA@realsil.com.cn> <4E6E537D.5060404@gmail.com> <24C6797004D84406B7564679CAE21531@realsil.com.cn> <4E74946A.3080206@gmail.com> <1903155944F64F00AC0C401593C20923@realsil.com.cn>
In-Reply-To: <1903155944F64F00AC0C401593C20923@realsil.com.cn>
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 09/19/2011 06:41 AM, 李朝明 wrote:
> Dear Sir:
>
> 	Yes, sniffer can help, Could you help to catch the authentication
> and association packet and send it to me。
>
> Best Regards，
> lizhaoming
>
Find below the output of wpa_supplicant with the -ddd switch. If that is
not the information you required (ie: you need even rawer logging or
somesuch), please tell me what I need to do, or where I might find the
information to do what I need to do.

Initializing interface 'wlan0' conf '/home/psychotic/wpa.conf' driver
'nl80211' ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/home/psychotic/wpa.conf' -> '/home/psychotic/wpa.conf'
Reading configuration file '/home/psychotic/wpa.conf'
ap_scan=1
ctrl_interface='DIR=/var/run/wpa_supplicant GROUP=wheel'
Line: 3 - start of a new network block
ssid - hexdump_ascii(len=10):
     50 65 72 66 6f 72 61 74 6f 72                     Perforator     
scan_ssid=1 (0x1)
proto: 0x3
key_mgmt: 0x2
pairwise: 0x18
group: 0x18
PSK - hexdump(len=32): [REMOVED]
Priority group 0
   id=0 ssid='Perforator'
netlink: Operstate: linkmode=1, operstate=5
Own MAC address: 1c:4b:d6:69:6a:dc
wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x450c7b key_idx=0
set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x450c7b key_idx=1
set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x450c7b key_idx=2
set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x450c7b key_idx=3
set_tx=0 seq_len=0 key_len=0
RSN: flushing PMKID list in the driver
Setting scan request: 0 sec 100000 usec
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: Supplicant port status: Unauthorized
ctrl_interface_group=10 (from group name 'wheel')
Added interface wlan0
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
State: DISCONNECTED -> SCANNING
Scan SSID - hexdump_ascii(len=10):
     50 65 72 66 6f 72 61 74 6f 72                     Perforator     
Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=10):
     50 65 72 66 6f 72 61 74 6f 72                     Perforator     
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 10 seconds
nl80211: Event message available
nl80211: Scan trigger
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized
nl80211: Event message available
nl80211: New scan results available
Received scan results (8 BSSes)
BSS: Start scan result update 1
BSS: Add new id 0 BSSID 80:c6:ab:1e:48:d3 SSID 'UPC0038938'
BSS: Add new id 1 BSSID 00:14:7f:c6:a0:bc SSID 'SpeedTouch5E1151'
BSS: Add new id 2 BSSID 00:18:f6:e9:22:07 SSID 'Thomson104ABB'
BSS: Add new id 3 BSSID 00:23:cd:11:e9:c2 SSID 'Sloot'
BSS: Add new id 4 BSSID 00:1e:c1:a2:01:5a SSID 'Perforator'
BSS: Add new id 5 BSSID 00:1e:2a:06:c7:f8 SSID 'NETGEAR'
BSS: Add new id 6 BSSID c0:c1:c0:20:c6:3f SSID 'Cisco36513'
BSS: Add new id 7 BSSID 00:25:9c:df:0a:6d SSID 'Linksys-120n'
New scan results available
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: 80:c6:ab:1e:48:d3 ssid='UPC0038938' wpa_ie_len=28 rsn_ie_len=24
caps=0x411
   skip - SSID mismatch
1: 00:14:7f:c6:a0:bc ssid='SpeedTouch5E1151' wpa_ie_len=24 rsn_ie_len=0
caps=0x411
   skip - SSID mismatch
2: 00:18:f6:e9:22:07 ssid='Thomson104ABB' wpa_ie_len=28 rsn_ie_len=24
caps=0x411
   skip - SSID mismatch
3: 00:23:cd:11:e9:c2 ssid='Sloot' wpa_ie_len=0 rsn_ie_len=24 caps=0x431
   skip - SSID mismatch
4: 00:1e:c1:a2:01:5a ssid='Perforator' wpa_ie_len=0 rsn_ie_len=20 caps=0x411
   selected based on RSN IE
   selected WPA AP 00:1e:c1:a2:01:5a ssid='Perforator'
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00
0f ac 04 01 00 00 0f ac 02 01 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04
01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
Cancelling scan request
Trying to authenticate with 00:1e:c1:a2:01:5a (SSID='Perforator'
freq=2442 MHz)
No keys have been configured - skip key clearing
State: SCANNING -> AUTHENTICATING
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
nl80211: Authenticate (ifindex=6)
  * bssid=00:1e:c1:a2:01:5a
  * freq=2442
  * SSID - hexdump_ascii(len=10):
     50 65 72 66 6f 72 61 74 6f 72                     Perforator     
  * IEs - hexdump(len=0): [NULL]
  * Auth Type 0
nl80211: Authentication request send successfully
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
nl80211: Event message available
nl80211: MLME event 37
nl80211: MLME event frame - hexdump(len=30): b0 00 32 00 1c 4b d6 69 6a
dc 00 1e c1 a2 01 5a 00 1e c1 a2 01 5a d0 3c 00 00 02 00 00 00
SME: Authentication response: peer=00:1e:c1:a2:01:5a auth_type=0
status_code=0
SME: Authentication response IEs - hexdump(len=0): [NULL]
Trying to associate with 00:1e:c1:a2:01:5a (SSID='Perforator' freq=2442 MHz)
State: AUTHENTICATING -> ASSOCIATING
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00
00 0f ac 04 01 00 00 0f ac 02 00 00
nl80211: Associate (ifindex=6)
  * bssid=00:1e:c1:a2:01:5a
  * freq=2442
  * SSID - hexdump_ascii(len=10):
     50 65 72 66 6f 72 61 74 6f 72                     Perforator     
  * IEs - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01
00 00 0f ac 02 00 00
nl80211: Association request send successfully
nl80211: Event message available
nl80211: Ignored unknown event (cmd=19)
nl80211: Event message available
nl80211: MLME event 38
nl80211: MLME event frame - hexdump(len=55): 10 00 32 00 1c 4b d6 69 6a
dc 00 1e c1 a2 01 5a 00 1e c1 a2 01 5a e0 3c 11 04 00 00 02 c0 01 08 82
84 8b 96 12 24 48 6c 32 04 0c 18 30 60 dd 07 00 0c 43 04 00 00 00
Association info event
resp_ies - hexdump(len=25): 01 08 82 84 8b 96 12 24 48 6c 32 04 0c 18 30
60 dd 07 00 0c 43 04 00 00 00
freq=2442 MHz
State: ASSOCIATING -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=00:1e:c1:a2:01:5a
No keys have been configured - skip key clearing
Associated with 00:1e:c1:a2:01:5a
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
nl80211: Event message available
nl80211: Ignore connect event (cmd=46) when using userspace SME
RX EAPOL from 00:1e:c1:a2:01:5a
RX EAPOL - hexdump(len=121): 01 03 00 75 02 00 8a 00 10 00 00 00 00 00
00 0a 48 bf 66 e9 22 34 9a 54 97 4a d1 f4 0f 68 ea 96 50 bb 75 fd 8f 8d
ae 98 95 06 c8 d6 60 fd b7 89 1b 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 3a d1 08 d5 c1
2d d5 21 fd b4 64 fb 3b 2e 1f 46
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=1 type=3 length=117
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=22
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 0a 48
  key_nonce - hexdump(len=32): bf 66 e9 22 34 9a 54 97 4a d1 f4 0f 68 ea
96 50 bb 75 fd 8f 8d ae 98 95 06 c8 d6 60 fd b7 89 1b
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 00 8a 00 10 00 00
00 00 00 00 0a 48 bf 66 e9 22 34 9a 54 97 4a d1 f4 0f 68 ea 96 50 bb 75
fd 8f 8d ae 98 95 06 c8 d6 60 fd b7 89 1b 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 dd 14 00 0f ac 04 3a d1
08 d5 c1 2d d5 21 fd b4 64 fb 3b 2e 1f 46
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from 00:1e:c1:a2:01:5a (ver=2)
RSN: msg 1/4 key data - hexdump(len=22): dd 14 00 0f ac 04 3a d1 08 d5
c1 2d d5 21 fd b4 64 fb 3b 2e 1f 46
WPA: PMKID in EAPOL-Key - hexdump(len=22): dd 14 00 0f ac 04 3a d1 08 d5
c1 2d d5 21 fd b4 64 fb 3b 2e 1f 46
RSN: PMKID from Authenticator - hexdump(len=16): 3a d1 08 d5 c1 2d d5 21
fd b4 64 fb 3b 2e 1f 46
RSN: no matching PMKID found
WPA: Renewed SNonce - hexdump(len=32): d3 ce 10 ea a3 0b 3e b0 bc 40 91
fb f2 ee 00 a2 9e f6 a2 08 50 49 8b fe 94 93 d1 66 9c 62 92 7f
WPA: PTK derivation - A1=1c:4b:d6:69:6a:dc A2=00:1e:c1:a2:01:5a
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00
00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00
00 00 00 00 0a 48 d3 ce 10 ea a3 0b 3e b0 bc 40 91 fb f2 ee 00 a2 9e f6
a2 08 50 49 8b fe 94 93 d1 66 9c 62 92 7f 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7e 86
e7 f4 dd 37 0a c6 88 2a 45 79 ea 07 9c 2d 00 16 30 14 01 00 00 0f ac 04
01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from 00:1e:c1:a2:01:5a
RX EAPOL - hexdump(len=155): 01 03 00 97 02 13 ca 00 10 00 00 00 00 00
00 0a 49 bf 66 e9 22 34 9a 54 97 4a d1 f4 0f 68 ea 96 50 bb 75 fd 8f 8d
ae 98 95 06 c8 d6 60 fd b7 89 1b 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 3f e3 04 00 00 00 00 00 00 00 00 00 00 00 00 00 72 62 5e ad 3f
fa de fa a8 df 9c 8b 28 54 ac 52 00 38 af f7 5a c8 75 be 95 65 97 ce 28
db d4 84 fd 79 db 70 50 31 4e 48 5e 1b dc 04 fa c8 8f 88 ba 1f e8 55 04
60 a0 f2 a5 84 ca 78 bb de db 39 d3 18 f4 f9 26 1e 79 a0 e4 bf
IEEE 802.1X RX: version=1 type=3 length=151
  EAPOL-Key type=2
  key_info 0x13ca (ver=2 keyidx=0 rsvd=0 Pairwise Install Ack MIC Secure
Encr)
  key_length=16 key_data_length=56
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 0a 49
  key_nonce - hexdump(len=32): bf 66 e9 22 34 9a 54 97 4a d1 f4 0f 68 ea
96 50 bb 75 fd 8f 8d ae 98 95 06 c8 d6 60 fd b7 89 1b
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 3f e3 04 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 72 62 5e ad 3f fa de fa a8 df 9c 8b 28 54 ac 52
WPA: RX EAPOL-Key - hexdump(len=155): 01 03 00 97 02 13 ca 00 10 00 00
00 00 00 00 0a 49 bf 66 e9 22 34 9a 54 97 4a d1 f4 0f 68 ea 96 50 bb 75
fd 8f 8d ae 98 95 06 c8 d6 60 fd b7 89 1b 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 3f e3 04 00 00 00 00 00 00 00 00 00 00 00 00 00 72 62
5e ad 3f fa de fa a8 df 9c 8b 28 54 ac 52 00 38 af f7 5a c8 75 be 95 65
97 ce 28 db d4 84 fd 79 db 70 50 31 4e 48 5e 1b dc 04 fa c8 8f 88 ba 1f
e8 55 04 60 a0 f2 a5 84 ca 78 bb de db 39 d3 18 f4 f9 26 1e 79 a0 e4 bf
RSN: encrypted key data - hexdump(len=56): af f7 5a c8 75 be 95 65 97 ce
28 db d4 84 fd 79 db 70 50 31 4e 48 5e 1b dc 04 fa c8 8f 88 ba 1f e8 55
04 60 a0 f2 a5 84 ca 78 bb de db 39 d3 18 f4 f9 26 1e 79 a0 e4 bf
WPA: decrypted EAPOL-Key key data - hexdump(len=48): [REMOVED]
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 3 of 4-Way Handshake from 00:1e:c1:a2:01:5a (ver=2)
WPA: IE KeyData - hexdump(len=48): 30 14 01 00 00 0f ac 04 01 00 00 0f
ac 04 01 00 00 0f ac 02 01 00 dd 16 00 0f ac 01 03 00 9f a8 6b 04 f7 5c
23 20 14 e0 8a bd 0e de 92 10 dd 00
WPA: RSN IE in EAPOL-Key - hexdump(len=22): 30 14 01 00 00 0f ac 04 01
00 00 0f ac 04 01 00 00 0f ac 02 01 00
WPA: GTK in EAPOL-Key - hexdump(len=24): [REMOVED]
WPA: Sending EAPOL-Key 4/4
WPA: TX EAPOL-Key - hexdump(len=99): 01 03 00 5f 02 03 0a 00 00 00 00 00
00 00 00 0a 49 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 ca 0c ff
3c 6b 08 dd b6 71 12 6f 83 97 7f 33 4c 00 00
WPA: Installing PTK to the driver.
wpa_driver_nl80211_set_key: ifindex=6 alg=3 addr=0xdc85b0 key_idx=0
set_tx=1 seq_len=6 key_len=16
   addr=00:1e:c1:a2:01:5a
EAPOL: External notification - portValid=1
State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
RSN: received GTK in pairwise handshake - hexdump(len=18): [REMOVED]
WPA: Group Key - hexdump(len=16): [REMOVED]
WPA: Installing GTK to the driver (keyidx=3 tx=0 len=16).
WPA: RSC - hexdump(len=6): 3f e3 04 00 00 00
wpa_driver_nl80211_set_key: ifindex=6 alg=3 addr=0x450c7b key_idx=3
set_tx=0 seq_len=6 key_len=16
WPA: Key negotiation completed with 00:1e:c1:a2:01:5a [PTK=CCMP GTK=CCMP]
Cancelling authentication timeout
State: GROUP_HANDSHAKE -> COMPLETED
CTRL-EVENT-CONNECTED - Connection to 00:1e:c1:a2:01:5a completed (auth)
[id=0 id_str=]
wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)
netlink: Operstate: linkmode=-1, operstate=6
EAPOL: External notification - portValid=1
EAPOL: External notification - EAP success=1
EAPOL: SUPP_PAE entering state AUTHENTICATING
EAPOL: SUPP_BE entering state SUCCESS
EAP: EAP entering state DISABLED
EAPOL: SUPP_PAE entering state AUTHENTICATED
EAPOL: Supplicant port status: Authorized
EAPOL: SUPP_BE entering state IDLE
EAPOL authentication completed successfully
RTM_NEWLINK: operstate=1 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
EAPOL: startWhen --> 0
EAPOL: disable timer tick
CTRL-EVENT-TERMINATING - signal 2 received
Removing interface wlan0
wpa_driver_nl80211_deauthenticate
wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x450c7b key_idx=0
set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x450c7b key_idx=1
set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x450c7b key_idx=2
set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0x450c7b key_idx=3
set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=6 alg=0 addr=0xdc7a80 key_idx=0
set_tx=0 seq_len=0 key_len=0
   addr=00:1e:c1:a2:01:5a
State: COMPLETED -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 1->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
No keys have been configured - skip key clearing
BSS: Remove id 0 BSSID 80:c6:ab:1e:48:d3 SSID 'UPC0038938'
BSS: Remove id 1 BSSID 00:14:7f:c6:a0:bc SSID 'SpeedTouch5E1151'
BSS: Remove id 2 BSSID 00:18:f6:e9:22:07 SSID 'Thomson104ABB'
BSS: Remove id 3 BSSID 00:23:cd:11:e9:c2 SSID 'Sloot'
BSS: Remove id 4 BSSID 00:1e:c1:a2:01:5a SSID 'Perforator'
BSS: Remove id 5 BSSID 00:1e:2a:06:c7:f8 SSID 'NETGEAR'
BSS: Remove id 6 BSSID c0:c1:c0:20:c6:3f SSID 'Cisco36513'
BSS: Remove id 7 BSSID 00:25:9c:df:0a:6d SSID 'Linksys-120n'
Cancelling scan request
Cancelling authentication timeout
netlink: Operstate: linkmode=0, operstate=6


Thanks again!
Stefan Zwanenburg
