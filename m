Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm24-vm6.bullet.mail.ird.yahoo.com ([212.82.109.197]:46705 "HELO
	nm24-vm6.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1752616Ab2GXN4g convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Jul 2012 09:56:36 -0400
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <CAKjQTCex5oXLkPOZeoccT5a0CxMDpdpmSqcJy4SV7h1eaeo=pA@mail.gmail.com> <1343074978.66314.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343075460.1623.YahooMailNeo@web28905.mail.ir2.yahoo.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com>
Message-ID: <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com> (sfid-20120724_155640_887225_68300100)
Date: Tue, 24 Jul 2012 14:56:33 +0100 (BST)
From: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Reply-To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Subject: Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
To: "linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks Larry for your help.
I tried 3.4.6 and 3.5.0 Quantal kernels but they didn't boot with my i8042 keyboard chip.

So I have installed 3.2.23-030223 and it now starts OK.

FYI here is the new log (I ll have to investigate why the auth between the endpoint and the hotspot doesn't work)

MERCI
XabiX 

Configuration file: /etc/hostapd/hostapd.conf
nl80211: Register Action command failed: ret=-114 (Operation already in progress)
nl80211: Register Action match - hexdump(len=1): 06
nl80211: Failed to register Action frame processing - ignore for now
nl80211: Interface wlan0 is in bridge br0
nl80211: Add own interface ifindex 3
nl80211: Add own interface ifindex 4
nl80211: New interface mon.wlan0 created: ifindex=9
nl80211: Add own interface ifindex 9
BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
nl80211: Added 802.11b mode based on 802.11g information
Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=12 freq=2467 MHz max_tx_power=20 dBm
Allowed channel: mode=1 chan=13 freq=2472 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=12 freq=2467 MHz max_tx_power=20 dBm
Allowed channel: mode=0 chan=13 freq=2472 MHz max_tx_power=20 dBm
RATE[0] rate=10 flags=0x1
RATE[1] rate=20 flags=0x1
RATE[2] rate=55 flags=0x1
RATE[3] rate=110 flags=0x1
RATE[4] rate=60 flags=0x0
RATE[5] rate=90 flags=0x0
RATE[6] rate=120 flags=0x0
RATE[7] rate=180 flags=0x0
RATE[8] rate=240 flags=0x0
RATE[9] rate=360 flags=0x0
RATE[10] rate=480 flags=0x0
RATE[11] rate=540 flags=0x0
Completing interface initialization
Mode: IEEE 802.11g  Channel: 6  Frequency: 2437 MHz
Flushing old station entries
Deauthenticate all stations
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=(nil) key_idx=0 set_tx=1 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=(nil) key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=(nil) key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=(nil) key_idx=3 set_tx=0 seq_len=0 key_len=0
Using interface wlan0 with hwaddr e0:91:53:6f:55:e7 and ssid 'myWIFI'
Deriving WPA PSK based on passphrase
SSID - hexdump_ascii(len=12):
     53 77 65 65 74 20 48 6f 6d 65 20 32               myWIFI    
PSK (ASCII passphrase) - hexdump_ascii(len=24): [REMOVED]
PSK (from passphrase) - hexdump(len=32): [REMOVED]
WPA: group state machine entering state GTK_INIT (VLAN-ID 0)
GMK - hexdump(len=32): [REMOVED]
GTK - hexdump(len=16): [REMOVED]
WPA: group state machine entering state SETKEYSDONE (VLAN-ID 0)
wpa_driver_nl80211_set_key: ifindex=4 alg=3 addr=(nil) key_idx=1 set_tx=1 seq_len=0 key_len=16
nl80211: Set beacon (beacon_set=0)
wlan0: Setup of interface done.
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
nl80211: Add ifindex 3 for bridge br0
nl80211: Add own interface ifindex 3
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
nl80211: Add ifindex 3 for bridge br0
nl80211: Add own interface ifindex 3
RTM_NEWLINK: operstate=0 ifi_flags=0x1002 ()
RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlan0' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'mon.wlan0' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
nl80211: Add ifindex 3 for bridge br0
nl80211: Add own interface ifindex 3
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
nl80211: Add ifindex 3 for bridge br0
nl80211: Add own interface ifindex 3
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
nl80211: Add ifindex 3 for bridge br0
nl80211: Add own interface ifindex 3
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 88:30:8a:52:ed:cd sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 88:30:8a:52:ed:cd sent probe request for broadcast SSID
mgmt::proberesp cb
RTM_NEWLINK: operstate=0 ifi_flags=0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
Unknown event 5
nl80211: Add ifindex 3 for bridge br0
nl80211: Add own interface ifindex 3
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 88:30:8a:52:ed:cd sent probe request for our SSID
mgmt::proberesp cb
mgmt::auth
authentication: STA=88:30:8a:52:ed:cd auth_alg=0 auth_transaction=1 status_code=0 wep=0
  New STA
wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: authentication OK (open system)
wlan0: STA 88:30:8a:52:ed:cd MLME: MLME-AUTHENTICATE.indication(88:30:8a:52:ed:cd, OPEN_SYSTEM)
wlan0: STA 88:30:8a:52:ed:cd MLME: MLME-DELETEKEYS.request(88:30:8a:52:ed:cd)
authentication reply: STA=88:30:8a:52:ed:cd auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
mgmt::auth cb
wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: authenticated
mgmt::assoc_req
association request: STA=88:30:8a:52:ed:cd capab_info=0x431 listen_interval=10
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
  new AID 1
wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: association OK (aid 1)
mgmt::assoc_resp cb
wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: associated (aid 1)
wlan0: STA 88:30:8a:52:ed:cd MLME: MLME-ASSOCIATE.indication(88:30:8a:52:ed:cd)
wlan0: STA 88:30:8a:52:ed:cd MLME: MLME-DELETEKEYS.request(88:30:8a:52:ed:cd)
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x981cb48 key_idx=0 set_tx=1 seq_len=0 key_len=0
   addr=88:30:8a:52:ed:cd
wlan0: STA 88:30:8a:52:ed:cd WPA: event 1 notification
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x981cb48 key_idx=0 set_tx=1 seq_len=0 key_len=0
   addr=88:30:8a:52:ed:cd
wlan0: STA 88:30:8a:52:ed:cd WPA: start authentication
WPA: 88:30:8a:52:ed:cd WPA_PTK entering state INITIALIZE
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x981cb48 key_idx=0 set_tx=1 seq_len=0 key_len=0
   addr=88:30:8a:52:ed:cd
wlan0: STA 88:30:8a:52:ed:cd IEEE 802.1X: unauthorizing port
WPA: 88:30:8a:52:ed:cd WPA_PTK_GROUP entering state IDLE
WPA: 88:30:8a:52:ed:cd WPA_PTK entering state AUTHENTICATION
WPA: 88:30:8a:52:ed:cd WPA_PTK entering state AUTHENTICATION2
WPA: 88:30:8a:52:ed:cd WPA_PTK entering state INITPSK
WPA: 88:30:8a:52:ed:cd WPA_PTK entering state PTKSTART
wlan0: STA 88:30:8a:52:ed:cd WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
nl80211: Event message available
nl80211: Ignored unknown event (cmd=19)
IEEE 802.1X: 88:30:8a:52:ed:cd TX status - version=2 type=3 length=95 - ack=1
wlan0: STA 88:30:8a:52:ed:cd WPA: EAPOL-Key timeout
WPA: 88:30:8a:52:ed:cd WPA_PTK entering state PTKSTART
wlan0: STA 88:30:8a:52:ed:cd WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 88:30:8a:52:ed:cd TX status - version=2 type=3 length=95 - ack=1
wlan0: STA 88:30:8a:52:ed:cd WPA: EAPOL-Key timeout
WPA: 88:30:8a:52:ed:cd WPA_PTK entering state PTKSTART
wlan0: STA 88:30:8a:52:ed:cd WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 88:30:8a:52:ed:cd TX status - version=2 type=3 length=95 - ack=1
wlan0: STA 88:30:8a:52:ed:cd WPA: EAPOL-Key timeout
WPA: 88:30:8a:52:ed:cd WPA_PTK entering state PTKSTART
wlan0: STA 88:30:8a:52:ed:cd WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
IEEE 802.1X: 88:30:8a:52:ed:cd TX status - version=2 type=3 length=95 - ack=1
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 88:30:8a:52:ed:cd sent probe request for our SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 88:30:8a:52:ed:cd sent probe request for our SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 88:30:8a:52:ed:cd sent probe request for our SSID
mgmt::proberesp cb
wlan0: STA 88:30:8a:52:ed:cd WPA: EAPOL-Key timeout
WPA: 88:30:8a:52:ed:cd WPA_PTK entering state PTKSTART
WPA: 88:30:8a:52:ed:cd WPA_PTK entering state DISCONNECT
hostapd_wpa_auth_disconnect: WPA authenticator requests disconnect: STA 88:30:8a:52:ed:cd reason 2
WPA: 88:30:8a:52:ed:cd WPA_PTK entering state DISCONNECTED
WPA: 88:30:8a:52:ed:cd WPA_PTK entering state INITIALIZE
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x981cb48 key_idx=0 set_tx=1 seq_len=0 key_len=0
   addr=88:30:8a:52:ed:cd
wlan0: STA 88:30:8a:52:ed:cd IEEE 802.1X: unauthorizing port
wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: deauthenticated due to local deauth request
nl80211: Event message available
nl80211: Ignored unknown event (cmd=20)
Data/PS-poll frame from not associated STA 88:30:8a:52:ed:cd
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 88:30:8a:52:ed:cd sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 88:30:8a:52:ed:cd sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 88:30:8a:52:ed:cd sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 88:30:8a:52:ed:cd sent probe request for broadcast SSID
mgmt::proberesp cb
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
STA 88:30:8a:52:ed:cd sent probe request for our SSID
mgmt::proberesp cb
mgmt::auth
authentication: STA=88:30:8a:52:ed:cd auth_alg=0 auth_transaction=1 status_code=0 wep=0
  New STA
wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: authentication OK (open system)
wlan0: STA 88:30:8a:52:ed:cd MLME: MLME-AUTHENTICATE.indication(88:30:8a:52:ed:cd, OPEN_SYSTEM)
wlan0: STA 88:30:8a:52:ed:cd MLME: MLME-DELETEKEYS.request(88:30:8a:52:ed:cd)
authentication reply: STA=88:30:8a:52:ed:cd auth_alg=0 auth_transaction=2 resp=0 (IE len=0)
mgmt::auth cb
wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: authenticated
mgmt::assoc_req
association request: STA=88:30:8a:52:ed:cd capab_info=0x431 listen_interval=10
unknown vendor specific information element ignored (vendor OUI 00:10:18 len=9)
  new AID 1
wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: association OK (aid 1)
mgmt::assoc_resp cb
wlan0: STA 88:30:8a:52:ed:cd IEEE 802.11: associated (aid 1)
wlan0: STA 88:30:8a:52:ed:cd MLME: MLME-ASSOCIATE.indication(88:30:8a:52:ed:cd)
wlan0: STA 88:30:8a:52:ed:cd MLME: MLME-DELETEKEYS.request(88:30:8a:52:ed:cd)
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x981cb48 key_idx=0 set_tx=1 seq_len=0 key_len=0
   addr=88:30:8a:52:ed:cd
wlan0: STA 88:30:8a:52:ed:cd WPA: event 1 notification
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x981cb48 key_idx=0 set_tx=1 seq_len=0 key_len=0
   addr=88:30:8a:52:ed:cd
wlan0: STA 88:30:8a:52:ed:cd WPA: start authentication
WPA: 88:30:8a:52:ed:cd WPA_PTK entering state INITIALIZE
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x981cb48 key_idx=0 set_tx=1 seq_len=0 key_len=0
   addr=88:30:8a:52:ed:cd
wlan0: STA 88:30:8a:52:ed:cd IEEE 802.1X: unauthorizing port
WPA: 88:30:8a:52:ed:cd WPA_PTK_GROUP entering state IDLE
WPA: 88:30:8a:52:ed:cd WPA_PTK entering state AUTHENTICATION
WPA: 88:30:8a:52:ed:cd WPA_PTK entering state AUTHENTICATION2
WPA: 88:30:8a:52:ed:cd WPA_PTK entering state INITPSK
WPA: 88:30:8a:52:ed:cd WPA_PTK entering state PTKSTART
wlan0: STA 88:30:8a:52:ed:cd WPA: sending 1/4 msg of 4-Way Handshake
WPA: Send EAPOL(version=2 secure=0 mic=0 ack=1 install=0 pairwise=8 kde_len=0 keyidx=0 encr=0)
