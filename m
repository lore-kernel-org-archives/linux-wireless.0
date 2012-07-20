Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.182]:11263 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751570Ab2GTTcO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 20 Jul 2012 15:32:14 -0400
Message-ID: <5cf4071422583bd246540992af9f7582.squirrel@www.infidigm.net> (sfid-20120720_213219_248753_C9007A27)
In-Reply-To: <5007D509.4050809@qca.qualcomm.com>
References: <43a66e0f20b45e9cc461272e83f2c4e4.squirrel@www.infidigm.net>
    <4FFC08C5.2050606@qca.qualcomm.com>
    <71781241c331fcbb5687068ddc6bbb06.squirrel@www.infidigm.net>
    <4FFD7621.5020207@qca.qualcomm.com>
    <19811dfd94388fb6406373822974cee7.squirrel@www.infidigm.net>
    <5005956F.3010300@qca.qualcomm.com>
    <5007D509.4050809@qca.qualcomm.com>
Date: Fri, 20 Jul 2012 16:09:44 -0400
Subject: Re: ath6kl: Add support for AR6004 hardware version 1.3
From: drwho@infidigm.net
To: "Kalle Valo" <kvalo@qca.qualcomm.com>
Cc: bkamatch@qca.qualcomm.com, linux-wireless@vger.kernel.org,
	"ath6kl-devel" <ath6kl-devel@qualcomm.com>
MIME-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20120720160942_53823"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

------=_20120720160942_53823
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Kalle,

Gave the firmware a try using your ath6kl-next branch (pulled yesterday). 
I can connect and move data to open networks only.  WPA connections appear
to keep trying to associate over and over at these states....

ASSOCIATED -> 4WAY_HANDSHAKE
4WAY_HANDSHAKE -> 4WAY_HANDSHAKE

wpa_supplicant log attached.  I tried a couple of routers / APs.

Jon

> Hi Jon,
>
> On 07/17/2012 07:40 PM, Kalle Valo wrote:
>> On 07/17/2012 05:53 PM, drwho@infidigm.net wrote:
>>> Would it be possible to get hw1.3 pushed up to linux-firmware git?
>>
>> We are working on it. Hopefully we can push it soon.
>
> Here's the firmware file and board data we are planning to send to
> linux-firmware.git soon. Please let me know if you have any problems
> with them.
>
> Kalle
>

------=_20120720160942_53823
Content-Type: text/plain; name="test_error.txt"
Content-Transfer-Encoding: 8bit
Content-Disposition: attachment; filename="test_error.txt"

Initializing interface 'wlan5' conf '/home/lab/wpa_test.conf' driver 'nl80211' ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/home/lab/wpa_test.conf' -> '/home/lab/wpa_test.conf'
Reading configuration file '/home/lab/wpa_test.conf'
Line: 1 - start of a new network block
ssid - hexdump_ascii(len=4):
     74 65 73 74                                       test            
scan_ssid=1 (0x1)
key_mgmt: 0x2
PSK (ASCII passphrase) - hexdump_ascii(len=9): [REMOVED]
PSK (from passphrase) - hexdump(len=32): [REMOVED]
Priority group 0
   id=0 ssid='test'
netlink: Operstate: linkmode=1, operstate=5
Own MAC address: 00:03:7f:20:48:79
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=0x80e4f28 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=0x80e4f28 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=0x80e4f28 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=0x80e4f28 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=0x80e4f28 key_idx=4 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=0x80e4f28 key_idx=5 set_tx=0 seq_len=0 key_len=0
RSN: flushing PMKID list in the driver
Setting scan request: 0 sec 100000 usec
WPS: UUID based on MAC address - hexdump(len=16): 15 92 41 47 5a 09 51 82 96 39 dd aa d4 b9 a8 70
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: Supplicant port status: Unauthorized
Added interface wlan5
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
State: DISCONNECTED -> SCANNING
Scan SSID - hexdump_ascii(len=4):
     74 65 73 74                                       test            
Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=4):
     74 65 73 74                                       test            
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 10 seconds
nl80211: Event message available
nl80211: Scan trigger
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized
nl80211: Event message available
nl80211: New scan results available
Received scan results (11 BSSes)
BSS: Start scan result update 1
BSS: Add new id 0 BSSID c0:3f:0e:87:f3:0e SSID 'test'
BSS: Add new id 1 BSSID 00:25:9c:a2:a2:f5 SSID 'aw-linksys'
BSS: Add new id 2 BSSID 04:4f:aa:5b:da:11 SSID 'labtest'
BSS: Add new id 3 BSSID 00:25:9c:a2:a2:f4 SSID 'aw-linksys-5'
BSS: Add new id 4 BSSID 90:94:e4:55:d6:f4 SSID 'AW-Blue'
BSS: Add new id 5 BSSID 00:16:c7:10:04:00 SSID ''
BSS: Add new id 6 BSSID 84:c9:b2:55:0f:b1 SSID 'dlink'
BSS: Add new id 7 BSSID 00:17:94:a6:8f:40 SSID ''
BSS: Add new id 8 BSSID 00:16:c7:db:5c:90 SSID ''
BSS: Add new id 9 BSSID 00:16:47:92:92:a0 SSID ''
BSS: Add new id 10 BSSID 00:16:c7:db:58:f0 SSID ''
New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=13
WPS: attr type=0x1023 len=9
WPS: attr type=0x1024 len=4
WPS: attr type=0x1042 len=4
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=27
WPS: attr type=0x1008 len=2
WPS: attr type=0x103c len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=13
WPS: attr type=0x1023 len=9
WPS: attr type=0x1024 len=4
WPS: attr type=0x1042 len=4
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=27
WPS: attr type=0x1008 len=2
WPS: attr type=0x103c len=1
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: c0:3f:0e:87:f3:0e ssid='test' wpa_ie_len=0 rsn_ie_len=20 caps=0x431
   selected based on RSN IE
   selected WPA AP c0:3f:0e:87:f3:0e ssid='test'
Trying to associate with c0:3f:0e:87:f3:0e (SSID='test' freq=2422 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
State: SCANNING -> ASSOCIATING
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
nl80211: Connect (ifindex=2)
  * bssid=c0:3f:0e:87:f3:0e
  * freq=2422
  * SSID - hexdump_ascii(len=4):
     74 65 73 74                                       test            
  * IEs - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
  * Auth Type 0
  * WPA Version 2
nl80211: Connect request send successfully
Setting authentication timeout: 10 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
nl80211: Event message available
Association info event
req_ies - hexdump(len=84): 00 04 74 65 73 74 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c 2d 1a ac 01 02 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 01 01 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 07 00 50 f2 02 00 01 00
resp_ies - hexdump(len=177): 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c dd 18 00 50 f2 02 01 01 82 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 09 00 03 7f 01 01 00 00 ff 7f dd 0a 00 03 7f 04 01 00 02 00 40 00 dd 1e 00 90 4c 33 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2d 1a 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
State: ASSOCIATING -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=c0:3f:0e:87:f3:0e
No keys have been configured - skip key clearing
Associated with c0:3f:0e:87:f3:0e
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
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
nl80211: Event message available
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
nl80211: Event message available
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 42 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 42
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 42 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: Renewed SNonce - hexdump(len=32): 20 37 a9 ef 01 b8 6b 54 7d 62 1e b0 68 fd 07 29 29 7d f5 49 90 7c 48 22 31 aa be cc 1c c3 e6 d0
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 01 20 37 a9 ef 01 b8 6b 54 7d 62 1e b0 68 fd 07 29 29 7d f5 49 90 7c 48 22 31 aa be cc 1c c3 e6 d0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 fe 6d 7c 4c ec 85 d6 a9 57 d0 52 17 f6 02 44 e3 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
EAPOL: startWhen --> 0
EAPOL: disable timer tick
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: txStart
WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 02 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 42 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 02
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 42
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 02 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 42 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 02 20 37 a9 ef 01 b8 6b 54 7d 62 1e b0 68 fd 07 29 29 7d f5 49 90 7c 48 22 31 aa be cc 1c c3 e6 d0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 5f 80 f4 9a c9 4a 53 1a 0c 4a 8c 7e 5e 3a 74 fb 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 03 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 42 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 03
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 42
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 03 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 42 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 03 20 37 a9 ef 01 b8 6b 54 7d 62 1e b0 68 fd 07 29 29 7d f5 49 90 7c 48 22 31 aa be cc 1c c3 e6 d0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 d4 c2 26 a1 7b 40 95 ca e9 3d 4a a4 e7 70 41 99 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 04 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 42 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 04
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 42
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 04 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 42 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 04 20 37 a9 ef 01 b8 6b 54 7d 62 1e b0 68 fd 07 29 29 7d f5 49 90 7c 48 22 31 aa be cc 1c c3 e6 d0 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 c1 81 99 ad 81 8d 39 ed d8 7a 07 75 cc 7e 67 a1 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
nl80211: Event message available
nl80211: Event message available
nl80211: Event message available
Association info event
req_ies - hexdump(len=84): 00 04 74 65 73 74 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c 2d 1a ac 01 02 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 01 01 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 07 00 50 f2 02 00 01 00
resp_ies - hexdump(len=177): 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c dd 18 00 50 f2 02 01 01 82 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 09 00 03 7f 01 01 00 00 ff 7f dd 0a 00 03 7f 04 01 00 02 00 40 00 dd 1e 00 90 4c 33 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2d 1a 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
State: 4WAY_HANDSHAKE -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
Associated with c0:3f:0e:87:f3:0e
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
nl80211: Event message available
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 43 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 43
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 43 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: Renewed SNonce - hexdump(len=32): 8a cd 42 16 a0 07 53 9d e9 8d f7 49 fe bd 62 e2 04 81 6b db f9 8d 0a a8 1a 35 b6 33 52 8f 33 fc
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 01 8a cd 42 16 a0 07 53 9d e9 8d f7 49 fe bd 62 e2 04 81 6b db f9 8d 0a a8 1a 35 b6 33 52 8f 33 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 17 0e 3a 8d 24 94 09 57 a8 20 27 2b 07 4b f9 b6 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
EAPOL: startWhen --> 0
EAPOL: disable timer tick
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: txStart
WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 02 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 43 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 02
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 43
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 02 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 43 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 02 8a cd 42 16 a0 07 53 9d e9 8d f7 49 fe bd 62 e2 04 81 6b db f9 8d 0a a8 1a 35 b6 33 52 8f 33 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3c b9 79 80 75 75 fb 0a e4 9e 16 d1 92 ad 85 25 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 03 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 43 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 03
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 43
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 03 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 43 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 03 8a cd 42 16 a0 07 53 9d e9 8d f7 49 fe bd 62 e2 04 81 6b db f9 8d 0a a8 1a 35 b6 33 52 8f 33 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 12 3e b2 b6 f1 91 4c 63 a0 84 c9 c0 81 23 17 3e 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 04 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 43 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 04
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 43
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 04 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 43 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 04 8a cd 42 16 a0 07 53 9d e9 8d f7 49 fe bd 62 e2 04 81 6b db f9 8d 0a a8 1a 35 b6 33 52 8f 33 fc 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 44 91 c2 c0 e3 c2 d6 1c 55 28 06 e3 11 9f d9 fa 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
nl80211: Event message available
nl80211: Event message available
nl80211: Event message available
Association info event
req_ies - hexdump(len=84): 00 04 74 65 73 74 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c 2d 1a ac 01 02 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 01 01 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 07 00 50 f2 02 00 01 00
resp_ies - hexdump(len=177): 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c dd 18 00 50 f2 02 01 01 82 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 09 00 03 7f 01 01 00 00 ff 7f dd 0a 00 03 7f 04 01 00 02 00 40 00 dd 1e 00 90 4c 33 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2d 1a 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
State: 4WAY_HANDSHAKE -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
Associated with c0:3f:0e:87:f3:0e
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
nl80211: Event message available
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 44 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 44
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 44 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: Renewed SNonce - hexdump(len=32): 08 e8 3f 63 9d 52 59 5b 81 c0 1d 72 24 5c e3 43 25 73 74 ad a1 70 ec 71 61 50 7b fd 7a 04 d5 c3
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 01 08 e8 3f 63 9d 52 59 5b 81 c0 1d 72 24 5c e3 43 25 73 74 ad a1 70 ec 71 61 50 7b fd 7a 04 d5 c3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 4d 99 d6 a7 c4 92 a1 58 c2 e3 08 b9 ac fe 98 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
EAPOL: startWhen --> 0
EAPOL: disable timer tick
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: txStart
WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 02 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 44 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 02
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 44
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 02 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 44 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 02 08 e8 3f 63 9d 52 59 5b 81 c0 1d 72 24 5c e3 43 25 73 74 ad a1 70 ec 71 61 50 7b fd 7a 04 d5 c3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 a5 4b f6 3f 86 eb 2c ae d2 f2 e9 8c 7e 46 80 b3 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 03 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 44 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 03
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 44
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 03 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 44 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 03 08 e8 3f 63 9d 52 59 5b 81 c0 1d 72 24 5c e3 43 25 73 74 ad a1 70 ec 71 61 50 7b fd 7a 04 d5 c3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2f 94 04 51 41 fe c1 f8 f0 ff 83 f9 ed 01 f4 e2 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 04 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 44 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 04
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 44
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 04 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 44 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 04 08 e8 3f 63 9d 52 59 5b 81 c0 1d 72 24 5c e3 43 25 73 74 ad a1 70 ec 71 61 50 7b fd 7a 04 d5 c3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4a 3d 5c f7 a3 c6 eb e6 41 e6 0c 23 60 d6 4d 94 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
nl80211: Event message available
nl80211: Event message available
Association info event
req_ies - hexdump(len=84): 00 04 74 65 73 74 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c 2d 1a ac 01 02 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 01 01 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 07 00 50 f2 02 00 01 00
resp_ies - hexdump(len=177): 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c dd 18 00 50 f2 02 01 01 82 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 09 00 03 7f 01 01 00 00 ff 7f dd 0a 00 03 7f 04 01 00 02 00 40 00 dd 1e 00 90 4c 33 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2d 1a 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
State: 4WAY_HANDSHAKE -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
Associated with c0:3f:0e:87:f3:0e
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
nl80211: Event message available
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
nl80211: Event message available
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 45 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 45
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 45 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: Renewed SNonce - hexdump(len=32): 15 88 d0 9b 05 02 87 18 b9 88 13 eb 3d 30 9e 18 36 5a a4 56 d3 af 2e 0c a9 2d 6e 40 5e 99 37 01
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 01 15 88 d0 9b 05 02 87 18 b9 88 13 eb 3d 30 9e 18 36 5a a4 56 d3 af 2e 0c a9 2d 6e 40 5e 99 37 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7b 28 ec 13 d2 b5 45 73 6a 5d 68 f1 d1 a7 87 3c 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
nl80211: Event message available
Disassociation notification
WPA: 4-Way Handshake failed - pre-shared key may be incorrect
Setting scan request: 0 sec 100000 usec
Added BSSID c0:3f:0e:87:f3:0e into blacklist
CTRL-EVENT-DISCONNECTED bssid=c0:3f:0e:87:f3:0e reason=3
Disconnect event - remove keys
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=0x80e4f28 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=0x80e4f28 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=0x80e4f28 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=0x80e4f28 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=0x80e4f28 key_idx=4 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=0x80e4f28 key_idx=5 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=0xa009574 key_idx=0 set_tx=0 seq_len=0 key_len=0
   addr=c0:3f:0e:87:f3:0e
State: 4WAY_HANDSHAKE -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
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
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
EAPOL: startWhen --> 0
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized
State: DISCONNECTED -> SCANNING
Scan SSID - hexdump_ascii(len=4):
     74 65 73 74                                       test            
Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=4):
     74 65 73 74                                       test            
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: Scan trigger
nl80211: Event message available
nl80211: New scan results available
Received scan results (9 BSSes)
BSS: Start scan result update 2
New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=13
WPS: attr type=0x1023 len=9
WPS: attr type=0x1024 len=4
WPS: attr type=0x1042 len=4
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=27
WPS: attr type=0x1008 len=2
WPS: attr type=0x103c len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=13
WPS: attr type=0x1023 len=9
WPS: attr type=0x1024 len=4
WPS: attr type=0x1042 len=4
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=27
WPS: attr type=0x1008 len=2
WPS: attr type=0x103c len=1
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: c0:3f:0e:87:f3:0e ssid='test' wpa_ie_len=0 rsn_ie_len=20 caps=0x431
   selected based on RSN IE
   selected WPA AP c0:3f:0e:87:f3:0e ssid='test'
Trying to associate with c0:3f:0e:87:f3:0e (SSID='test' freq=2422 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
State: SCANNING -> ASSOCIATING
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
nl80211: Connect (ifindex=2)
  * bssid=c0:3f:0e:87:f3:0e
  * freq=2422
  * SSID - hexdump_ascii(len=4):
     74 65 73 74                                       test            
  * IEs - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
  * Auth Type 0
  * WPA Version 2
nl80211: Connect request send successfully
Setting authentication timeout: 10 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
nl80211: Event message available
Association info event
req_ies - hexdump(len=84): 00 04 74 65 73 74 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c 2d 1a ac 01 02 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 01 01 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 07 00 50 f2 02 00 01 00
resp_ies - hexdump(len=177): 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c dd 18 00 50 f2 02 01 01 82 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 09 00 03 7f 01 01 00 00 ff 7f dd 0a 00 03 7f 04 01 00 02 00 40 00 dd 1e 00 90 4c 33 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2d 1a 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
State: ASSOCIATING -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=c0:3f:0e:87:f3:0e
No keys have been configured - skip key clearing
Associated with c0:3f:0e:87:f3:0e
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
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
nl80211: Event message available
nl80211: Event message available
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 46 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 46
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 46 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: Renewed SNonce - hexdump(len=32): 7b bf cb 56 58 a8 77 3f bf 0b a2 db 0c 45 1f 85 c5 5f 77 e2 76 a9 a2 b8 51 97 8a f4 43 e2 bb e3
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 01 7b bf cb 56 58 a8 77 3f bf 0b a2 db 0c 45 1f 85 c5 5f 77 e2 76 a9 a2 b8 51 97 8a f4 43 e2 bb e3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 b0 04 96 c1 56 8d da d5 89 24 30 5c 29 af 10 40 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 02 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 46 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 02
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 46
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 02 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 46 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 02 7b bf cb 56 58 a8 77 3f bf 0b a2 db 0c 45 1f 85 c5 5f 77 e2 76 a9 a2 b8 51 97 8a f4 43 e2 bb e3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 cc 87 fa d1 bc 27 c1 58 dd c1 12 5c 11 1e e2 04 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
EAPOL: startWhen --> 0
EAPOL: disable timer tick
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: txStart
WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 03 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 46 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 03
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 46
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 03 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 46 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 03 7b bf cb 56 58 a8 77 3f bf 0b a2 db 0c 45 1f 85 c5 5f 77 e2 76 a9 a2 b8 51 97 8a f4 43 e2 bb e3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 c8 a3 5e 75 f4 13 23 ab 1b 4b 95 f8 72 12 6d 42 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 04 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 46 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 04
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 46
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 04 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 46 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 04 7b bf cb 56 58 a8 77 3f bf 0b a2 db 0c 45 1f 85 c5 5f 77 e2 76 a9 a2 b8 51 97 8a f4 43 e2 bb e3 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 df f1 ff 4d e9 9f 2c 3a 3f fc bb 00 89 48 6f 46 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
nl80211: Event message available
nl80211: Event message available
nl80211: Event message available
Association info event
req_ies - hexdump(len=84): 00 04 74 65 73 74 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c 2d 1a ac 01 02 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 01 01 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 07 00 50 f2 02 00 01 00
resp_ies - hexdump(len=177): 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c dd 18 00 50 f2 02 01 01 82 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 09 00 03 7f 01 01 00 00 ff 7f dd 0a 00 03 7f 04 01 00 02 00 40 00 dd 1e 00 90 4c 33 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2d 1a 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
State: 4WAY_HANDSHAKE -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
Associated with c0:3f:0e:87:f3:0e
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
nl80211: Event message available
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 47 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 47
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 47 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: Renewed SNonce - hexdump(len=32): b3 66 ef ea 3b 6c 30 38 7a f3 57 34 61 97 bb 49 66 f6 8b a0 06 7d 29 45 53 75 8b 3f 69 71 1b 9d
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 01 b3 66 ef ea 3b 6c 30 38 7a f3 57 34 61 97 bb 49 66 f6 8b a0 06 7d 29 45 53 75 8b 3f 69 71 1b 9d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 48 b0 fb d2 3d b2 24 46 23 2b 24 d2 03 2f 9a d7 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
EAPOL: startWhen --> 0
EAPOL: disable timer tick
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: txStart
WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 02 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 47 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 02
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 47
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 02 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 47 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 02 b3 66 ef ea 3b 6c 30 38 7a f3 57 34 61 97 bb 49 66 f6 8b a0 06 7d 29 45 53 75 8b 3f 69 71 1b 9d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 b3 15 3b d8 8f c8 c9 34 a4 8d 81 09 53 2e 47 ad 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 03 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 47 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 03
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 47
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 03 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 47 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 03 b3 66 ef ea 3b 6c 30 38 7a f3 57 34 61 97 bb 49 66 f6 8b a0 06 7d 29 45 53 75 8b 3f 69 71 1b 9d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 d0 87 2c 42 4e cb 8b d3 04 40 ae a9 32 49 c0 c2 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 04 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 47 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 04
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 47
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 04 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 47 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 04 b3 66 ef ea 3b 6c 30 38 7a f3 57 34 61 97 bb 49 66 f6 8b a0 06 7d 29 45 53 75 8b 3f 69 71 1b 9d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 a6 8c 9d c2 e3 2f 99 06 91 ba 28 ab 24 fe 5a 42 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
nl80211: Event message available
nl80211: Event message available
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
nl80211: Event message available
Association info event
req_ies - hexdump(len=84): 00 04 74 65 73 74 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c 2d 1a ac 01 02 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 01 01 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 07 00 50 f2 02 00 01 00
resp_ies - hexdump(len=177): 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c dd 18 00 50 f2 02 01 01 82 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 09 00 03 7f 01 01 00 00 ff 7f dd 0a 00 03 7f 04 01 00 02 00 40 00 dd 1e 00 90 4c 33 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2d 1a 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
State: 4WAY_HANDSHAKE -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
Associated with c0:3f:0e:87:f3:0e
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
nl80211: Event message available
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 48 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 48
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 48 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: Renewed SNonce - hexdump(len=32): 6b a3 20 cb 42 f1 39 8c 7f 8f 1d 9b 73 43 1b 8c 43 dd b4 df 88 d8 8c 59 48 1f ee 4b a9 b9 c8 36
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 01 6b a3 20 cb 42 f1 39 8c 7f 8f 1d 9b 73 43 1b 8c 43 dd b4 df 88 d8 8c 59 48 1f ee 4b a9 b9 c8 36 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 c3 30 d8 09 c5 8d 5a ec 12 6d 2b 7a 74 a3 64 6d 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
EAPOL: startWhen --> 0
EAPOL: disable timer tick
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: txStart
WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 02 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 48 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 02
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 48
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 02 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 48 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 02 6b a3 20 cb 42 f1 39 8c 7f 8f 1d 9b 73 43 1b 8c 43 dd b4 df 88 d8 8c 59 48 1f ee 4b a9 b9 c8 36 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4a a4 cc 4f 43 a5 eb e3 e4 be 53 33 08 6b 87 c4 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 03 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 48 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 03
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 48
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 03 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 48 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 03 6b a3 20 cb 42 f1 39 8c 7f 8f 1d 9b 73 43 1b 8c 43 dd b4 df 88 d8 8c 59 48 1f ee 4b a9 b9 c8 36 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 a8 05 61 4c dd 78 cb d6 e2 b9 84 78 92 e6 1a 67 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 04 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 48 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 04
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 48
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 04 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 48 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 04 6b a3 20 cb 42 f1 39 8c 7f 8f 1d 9b 73 43 1b 8c 43 dd b4 df 88 d8 8c 59 48 1f ee 4b a9 b9 c8 36 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 79 dc f0 cd ba 6b ec 35 c3 60 ba 2f a8 93 bc 57 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
nl80211: Event message available
nl80211: Event message available
nl80211: Event message available
Association info event
req_ies - hexdump(len=84): 00 04 74 65 73 74 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c 2d 1a ac 01 02 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 01 01 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 07 00 50 f2 02 00 01 00
resp_ies - hexdump(len=177): 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c dd 18 00 50 f2 02 01 01 82 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 09 00 03 7f 01 01 00 00 ff 7f dd 0a 00 03 7f 04 01 00 02 00 40 00 dd 1e 00 90 4c 33 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2d 1a 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
State: 4WAY_HANDSHAKE -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
Associated with c0:3f:0e:87:f3:0e
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
nl80211: Event message available
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 49 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 49
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 49 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: Renewed SNonce - hexdump(len=32): 56 42 63 23 c7 51 68 24 48 fb 48 ad be 46 af 33 e9 01 84 c9 0d 92 a5 2f a2 c3 a0 76 74 93 c1 01
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 01 56 42 63 23 c7 51 68 24 48 fb 48 ad be 46 af 33 e9 01 84 c9 0d 92 a5 2f a2 c3 a0 76 74 93 c1 01 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0b 94 50 94 5e bd e2 56 7e e0 aa ad 39 68 1f 68 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
nl80211: Event message available
Disassociation notification
WPA: 4-Way Handshake failed - pre-shared key may be incorrect
Setting scan request: 0 sec 100000 usec
BSSID c0:3f:0e:87:f3:0e blacklist count incremented to 2
CTRL-EVENT-DISCONNECTED bssid=c0:3f:0e:87:f3:0e reason=3
Disconnect event - remove keys
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=0x80e4f28 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=0x80e4f28 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=0x80e4f28 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=0x80e4f28 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=0x80e4f28 key_idx=4 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=0x80e4f28 key_idx=5 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=2 alg=0 addr=0xa009574 key_idx=0 set_tx=0 seq_len=0 key_len=0
   addr=c0:3f:0e:87:f3:0e
State: 4WAY_HANDSHAKE -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
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
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
EAPOL: startWhen --> 0
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized
State: DISCONNECTED -> SCANNING
Scan SSID - hexdump_ascii(len=4):
     74 65 73 74                                       test            
Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=4):
     74 65 73 74                                       test            
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: Scan trigger
nl80211: Event message available
nl80211: New scan results available
Received scan results (9 BSSes)
BSS: Start scan result update 3
BSS: Expire BSS 4 due to no match in scan
BSS: Remove id 4 BSSID 90:94:e4:55:d6:f4 SSID 'AW-Blue'
BSS: Expire BSS 10 due to no match in scan
BSS: Remove id 10 BSSID 00:16:c7:db:58:f0 SSID ''
New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=13
WPS: attr type=0x1023 len=9
WPS: attr type=0x1024 len=4
WPS: attr type=0x1042 len=4
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=27
WPS: attr type=0x1008 len=2
WPS: attr type=0x103c len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=13
WPS: attr type=0x1023 len=9
WPS: attr type=0x1024 len=4
WPS: attr type=0x1042 len=4
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=27
WPS: attr type=0x1008 len=2
WPS: attr type=0x103c len=1
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: c0:3f:0e:87:f3:0e ssid='test' wpa_ie_len=0 rsn_ie_len=20 caps=0x431
   skip - blacklisted
1: 00:25:9c:a2:a2:f5 ssid='aw-linksys' wpa_ie_len=22 rsn_ie_len=0 caps=0x431
   skip - SSID mismatch
2: 04:4f:aa:5b:da:11 ssid='labtest' wpa_ie_len=22 rsn_ie_len=0 caps=0x431
   skip - SSID mismatch
3: 00:25:9c:a2:a2:f4 ssid='aw-linksys-5' wpa_ie_len=22 rsn_ie_len=0 caps=0x411
   skip - SSID mismatch
4: 00:16:c7:10:04:00 ssid='' wpa_ie_len=24 rsn_ie_len=0 caps=0x1
   skip - SSID mismatch
5: 84:c9:b2:55:0f:b1 ssid='dlink' wpa_ie_len=0 rsn_ie_len=0 caps=0x421
   skip - no WPA/RSN IE
6: 00:17:94:a6:8f:40 ssid='' wpa_ie_len=0 rsn_ie_len=0 caps=0x421
   skip - no WPA/RSN IE
7: 00:16:c7:db:5c:90 ssid='' wpa_ie_len=0 rsn_ie_len=0 caps=0x421
   skip - no WPA/RSN IE
8: 00:16:47:92:92:a0 ssid='' wpa_ie_len=0 rsn_ie_len=0 caps=0x1
   skip - no WPA/RSN IE
Try to find non-WPA AP
0: c0:3f:0e:87:f3:0e ssid='test' wpa_ie_len=0 rsn_ie_len=20 caps=0x431
   skip - blacklisted
1: 00:25:9c:a2:a2:f5 ssid='aw-linksys' wpa_ie_len=22 rsn_ie_len=0 caps=0x431
   skip - SSID mismatch
2: 04:4f:aa:5b:da:11 ssid='labtest' wpa_ie_len=22 rsn_ie_len=0 caps=0x431
   skip - SSID mismatch
3: 00:25:9c:a2:a2:f4 ssid='aw-linksys-5' wpa_ie_len=22 rsn_ie_len=0 caps=0x411
   skip - SSID mismatch
4: 00:16:c7:10:04:00 ssid='' wpa_ie_len=24 rsn_ie_len=0 caps=0x1
   skip - SSID mismatch
5: 84:c9:b2:55:0f:b1 ssid='dlink' wpa_ie_len=0 rsn_ie_len=0 caps=0x421
   skip - SSID mismatch
6: 00:17:94:a6:8f:40 ssid='' wpa_ie_len=0 rsn_ie_len=0 caps=0x421
   skip - SSID mismatch
7: 00:16:c7:db:5c:90 ssid='' wpa_ie_len=0 rsn_ie_len=0 caps=0x421
   skip - SSID mismatch
8: 00:16:47:92:92:a0 ssid='' wpa_ie_len=0 rsn_ie_len=0 caps=0x1
   skip - SSID mismatch
No APs found - clear blacklist and try again
Removed BSSID c0:3f:0e:87:f3:0e from blacklist (clear)
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: c0:3f:0e:87:f3:0e ssid='test' wpa_ie_len=0 rsn_ie_len=20 caps=0x431
   selected based on RSN IE
   selected WPA AP c0:3f:0e:87:f3:0e ssid='test'
Trying to associate with c0:3f:0e:87:f3:0e (SSID='test' freq=2422 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
RSN: using IEEE 802.11i/D9.0
WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2 proto 2
WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: using GTK CCMP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
No keys have been configured - skip key clearing
State: SCANNING -> ASSOCIATING
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
nl80211: Connect (ifindex=2)
  * bssid=c0:3f:0e:87:f3:0e
  * freq=2422
  * SSID - hexdump_ascii(len=4):
     74 65 73 74                                       test            
  * IEs - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
  * Auth Type 0
  * WPA Version 2
nl80211: Connect request send successfully
Setting authentication timeout: 10 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
nl80211: Event message available
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
nl80211: Event message available
Association info event
req_ies - hexdump(len=84): 00 04 74 65 73 74 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c 2d 1a ac 01 02 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 01 01 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 07 00 50 f2 02 00 01 00
resp_ies - hexdump(len=177): 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c dd 18 00 50 f2 02 01 01 82 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 09 00 03 7f 01 01 00 00 ff 7f dd 0a 00 03 7f 04 01 00 02 00 40 00 dd 1e 00 90 4c 33 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2d 1a 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
State: ASSOCIATING -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=c0:3f:0e:87:f3:0e
No keys have been configured - skip key clearing
Associated with c0:3f:0e:87:f3:0e
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
nl80211: Event message available
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4a
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: Renewed SNonce - hexdump(len=32): 22 c6 6d e1 15 06 1a 49 c2 f6 15 38 58 5e 03 c6 77 8a e7 1c f6 12 2b d0 2c 1f ae f8 8c 9a 80 9f
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 01 22 c6 6d e1 15 06 1a 49 c2 f6 15 38 58 5e 03 c6 77 8a e7 1c f6 12 2b d0 2c 1f ae f8 8c 9a 80 9f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 16 68 0f 25 c5 02 75 a5 f9 0f 31 e9 7d 4f 18 07 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 02 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 02
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4a
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 02 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 02 22 c6 6d e1 15 06 1a 49 c2 f6 15 38 58 5e 03 c6 77 8a e7 1c f6 12 2b d0 2c 1f ae f8 8c 9a 80 9f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4b 8d 02 86 56 f6 16 21 4c eb 0d a1 92 29 d9 51 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
EAPOL: startWhen --> 0
EAPOL: disable timer tick
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: txStart
WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 03 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 03
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4a
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 03 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 03 22 c6 6d e1 15 06 1a 49 c2 f6 15 38 58 5e 03 c6 77 8a e7 1c f6 12 2b d0 2c 1f ae f8 8c 9a 80 9f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e4 ce 91 de 34 5a 8d 0f c7 f9 1f 3d c7 ce 4a 7e 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 04 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 04
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4a
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 04 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 04 22 c6 6d e1 15 06 1a 49 c2 f6 15 38 58 5e 03 c6 77 8a e7 1c f6 12 2b d0 2c 1f ae f8 8c 9a 80 9f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 20 d7 bf 52 4c 21 2c ee 53 9f 26 b4 18 74 24 36 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
nl80211: Event message available
nl80211: Event message available
nl80211: Event message available
Association info event
req_ies - hexdump(len=84): 00 04 74 65 73 74 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c 2d 1a ac 01 02 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 01 01 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 07 00 50 f2 02 00 01 00
resp_ies - hexdump(len=177): 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c dd 18 00 50 f2 02 01 01 82 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 09 00 03 7f 01 01 00 00 ff 7f dd 0a 00 03 7f 04 01 00 02 00 40 00 dd 1e 00 90 4c 33 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2d 1a 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
State: 4WAY_HANDSHAKE -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
Associated with c0:3f:0e:87:f3:0e
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
nl80211: Event message available
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4b
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: Renewed SNonce - hexdump(len=32): 8d e6 cd 14 1d 12 92 62 18 50 b6 a9 f8 41 5e b3 17 a5 2d f5 39 35 65 eb 6d 8b 3e ab f9 61 bd 40
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 01 8d e6 cd 14 1d 12 92 62 18 50 b6 a9 f8 41 5e b3 17 a5 2d f5 39 35 65 eb 6d 8b 3e ab f9 61 bd 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e9 1b e7 d2 f1 0b 00 58 ad b6 bf be f3 1c 02 39 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
EAPOL: startWhen --> 0
EAPOL: disable timer tick
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: txStart
WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 02 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 02
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4b
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 02 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 02 8d e6 cd 14 1d 12 92 62 18 50 b6 a9 f8 41 5e b3 17 a5 2d f5 39 35 65 eb 6d 8b 3e ab f9 61 bd 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 d1 53 14 e8 ef a9 7d 2e 67 33 39 a4 a2 5e 83 b5 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 03 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 03
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4b
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 03 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 03 8d e6 cd 14 1d 12 92 62 18 50 b6 a9 f8 41 5e b3 17 a5 2d f5 39 35 65 eb 6d 8b 3e ab f9 61 bd 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 23 6b 05 93 be 1d 78 01 fd 4e 9c 61 5b b0 a5 5e 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 04 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 04
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4b
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 04 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4b 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 04 8d e6 cd 14 1d 12 92 62 18 50 b6 a9 f8 41 5e b3 17 a5 2d f5 39 35 65 eb 6d 8b 3e ab f9 61 bd 40 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 68 76 67 d5 ba 05 92 98 3a c5 f5 7a a8 93 c3 d7 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
nl80211: Event message available
nl80211: Event message available
Association info event
req_ies - hexdump(len=84): 00 04 74 65 73 74 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c 2d 1a ac 01 02 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 01 01 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00 dd 07 00 50 f2 02 00 01 00
resp_ies - hexdump(len=177): 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c dd 18 00 50 f2 02 01 01 82 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00 dd 09 00 03 7f 01 01 00 00 ff 7f dd 0a 00 03 7f 04 01 00 02 00 40 00 dd 1e 00 90 4c 33 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 2d 1a 4e 11 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 1a 00 90 4c 34 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 03 0d 0a 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: set own WPA/RSN IE - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
State: 4WAY_HANDSHAKE -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
Associated with c0:3f:0e:87:f3:0e
WPA: Association event - clear replay counter
WPA: Clear old PTK
EAPOL: External notification - portEnabled=0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portValid=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portEnabled=1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: SUPP_BE entering state IDLE
Setting authentication timeout: 10 sec 0 usec
Cancelling scan request
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
nl80211: Event message available
nl80211: Event message available
RX EAPOL from c0:3f:0e:87:f3:0e
RX EAPOL - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=2 type=3 length=95
  EAPOL-Key type=2
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4c
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 00 00 01 be 75 c7 45 9a 2f 44 fc 3a bc 51 fc 82 10 60 d9 41 74 f3 e6 cb 86 0e 9f b0 56 c6 ab 8f b3 48 4c 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c0:3f:0e:87:f3:0e (ver=2)
RSN: msg 1/4 key data - hexdump(len=0):
WPA: Renewed SNonce - hexdump(len=32): 05 de dc db a7 fb 0d dc 87 94 82 5b 66 47 08 3e 63 d6 97 59 2e 05 9d a6 43 6d db eb 37 24 e5 25
WPA: PTK derivation - A1=00:03:7f:20:48:79 A2=c0:3f:0e:87:f3:0e
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=22): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=121): 01 03 00 75 02 01 0a 00 00 00 00 00 00 00 00 00 01 05 de dc db a7 fb 0d dc 87 94 82 5b 66 47 08 3e 63 d6 97 59 2e 05 9d a6 43 6d db eb 37 24 e5 25 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e4 08 65 46 9f c4 3f 28 f0 56 38 d2 bd 39 2f 59 00 16 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
CTRL-EVENT-TERMINATING - signal 2 received
Removing interface wlan5
wpa_driver_nl80211_disconnect
No keys have been configured - skip key clearing
State: 4WAY_HANDSHAKE -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
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
BSS: Remove id 0 BSSID c0:3f:0e:87:f3:0e SSID 'test'
BSS: Remove id 1 BSSID 00:25:9c:a2:a2:f5 SSID 'aw-linksys'
BSS: Remove id 2 BSSID 04:4f:aa:5b:da:11 SSID 'labtest'
BSS: Remove id 3 BSSID 00:25:9c:a2:a2:f4 SSID 'aw-linksys-5'
BSS: Remove id 5 BSSID 00:16:c7:10:04:00 SSID ''
BSS: Remove id 6 BSSID 84:c9:b2:55:0f:b1 SSID 'dlink'
BSS: Remove id 7 BSSID 00:17:94:a6:8f:40 SSID ''
BSS: Remove id 8 BSSID 00:16:c7:db:5c:90 SSID ''
BSS: Remove id 9 BSSID 00:16:47:92:92:a0 SSID ''
Cancelling scan request
Cancelling authentication timeout
netlink: Operstate: linkmode=0, operstate=6
------=_20120720160942_53823--


