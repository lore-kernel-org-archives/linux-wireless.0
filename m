Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from wr-out-0506.google.com ([64.233.184.239]:39058 "EHLO
	wr-out-0506.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752231AbYCEPtZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 5 Mar 2008 10:49:25 -0500
Received: by wr-out-0506.google.com with SMTP id 50so2226507wra.13
        for <linux-wireless@vger.kernel.org>; Wed, 05 Mar 2008 07:49:24 -0800 (PST)
Message-ID: <84ac67910803050749u9ba4918yed0b79c80b254415@mail.gmail.com> (sfid-20080305_154943_831024_6DAC15EC)
Date: Wed, 5 Mar 2008 15:49:22 +0000
From: "Ahmed Ammar" <b33fc0d3@gmail.com>
To: "Michael Buesch" <mb@bu3sch.de>
Subject: Re: B43 will not associate
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <200803051517.31919.mb@bu3sch.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
References: <84ac67910803041143y76e378c7m2fd88a26115f0ae2@mail.gmail.com>
	 <200803042047.35710.mb@bu3sch.de>
	 <84ac67910803041413s510c5513k25f77762b0e70d@mail.gmail.com>
	 <200803051517.31919.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Also the wpa_supplicant (v0.6.3) output:

wpa_supplicant -Dwext -iwlan1 -c /etc/wpa_supplicant/wpa_supplicant.conf -dd
Initializing interface 'wlan1' conf
'/etc/wpa_supplicant/wpa_supplicant.conf' driver 'wext' ctrl_interface
'N/A' bridge 'N/A'
Configuration file '/etc/wpa_supplicant/wpa_supplicant.conf' ->
'/etc/wpa_supplicant/wpa_supplicant.conf'
Reading configuration file '/etc/wpa_supplicant/wpa_supplicant.conf'
Line: 1 - start of a new network block
ssid - hexdump_ascii(len=16):
     4f 32 77 69 72 65 6c 65 73 73 46 34 31 32 41 32   O2wirelessF412A2
key_mgmt: 0x4
wep_key0 - hexdump(len=5): [REMOVED]
wep_tx_keyidx=0 (0x0)
priority=5 (0x5)
auth_alg: 0x2
Priority group 5
   id=0 ssid='O2wirelessF412A2'
Initializing interface (2) 'wlan1'
Interface wlan1 set UP - waiting a second for the driver to complete
initialization
SIOCGIWRANGE: WE(compiled)=22 WE(source)=21 enc_capa=0xf
  capabilities: key_mgmt 0xf enc 0xf
WEXT: Operstate: linkmode=1, operstate=5
Own MAC address: 00:40:05:a1:d9:09
wpa_driver_wext_set_wpa
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
ioctl[SIOCSIWENCODEEXT]: No such file or directory
Driver did not support SIOCSIWENCODEEXT
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
ioctl[SIOCSIWENCODEEXT]: No such file or directory
Driver did not support SIOCSIWENCODEEXT
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
ioctl[SIOCSIWENCODEEXT]: No such file or directory
Driver did not support SIOCSIWENCODEEXT
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
ioctl[SIOCSIWENCODEEXT]: No such file or directory
Driver did not support SIOCSIWENCODEEXT
wpa_driver_wext_set_countermeasures
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 4 value 0x0 - wpa_driver_wext_set_drop_unencrypted
RSN: flushing PMKID list in the driver
Setting scan request: 0 sec 100000 usec
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
Added interface wlan1
Ignore event for foreign ifindex 9
RTM_NEWLINK: operstate=0 ifi_flags=0x1803 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan1' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1803 ([UP])
Wireless event: cmd=0x8b06 len=12
State: DISCONNECTED -> SCANNING
Starting AP scan (broadcast SSID)
Trying to get current scan results first without requesting a new scan
to speed up initial association
Received 268 bytes of scan results (1 BSSes)
CTRL-EVENT-SCAN-RESULTS
Selecting BSS from priority group 5
Try to find WPA-enabled AP
0: 00:90:d0:f2:ad:7b ssid='O2wirelessF412A2' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
Try to find non-WPA AP
0: 00:90:d0:f2:ad:7b ssid='O2wirelessF412A2' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   selected non-WPA AP 00:90:d0:f2:ad:7b ssid='O2wirelessF412A2'
Trying to associate with 00:90:d0:f2:ad:7b (SSID='O2wirelessF412A2'
freq=2412 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
Overriding auth_alg selection: 0x2
WPA: clearing AP WPA IE
WPA: clearing AP RSN IE
WPA: clearing own WPA/RSN IE
No keys have been configured - skip key clearing
wpa_driver_wext_set_key: alg=1 key_idx=0 set_tx=1 seq_len=0 key_len=5
wpa_driver_wext_set_drop_unencrypted
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
Setting authentication timeout: 10 sec 0 usec
EAPOL: External notification - portControl=ForceAuthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1803 ([UP])
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1803 ([UP])
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1803 ([UP])
Wireless event: cmd=0x8b1a len=32
EAPOL: disable timer tick
RTM_NEWLINK: operstate=0 ifi_flags=0x1803 ([UP])
Wireless event: cmd=0x8b19 len=16
Received 268 bytes of scan results (1 BSSes)
CTRL-EVENT-SCAN-RESULTS
Selecting BSS from priority group 5
Try to find WPA-enabled AP
0: 00:90:d0:f2:ad:7b ssid='O2wirelessF412A2' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
Try to find non-WPA AP
0: 00:90:d0:f2:ad:7b ssid='O2wirelessF412A2' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   selected non-WPA AP 00:90:d0:f2:ad:7b ssid='O2wirelessF412A2'
Already associated with the selected AP.
RTM_NEWLINK: operstate=0 ifi_flags=0x1803 ([UP])
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1803 ([UP])
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1803 ([UP])
Wireless event: cmd=0x8b1a len=32
Authentication with 00:90:d0:f2:ad:7b timed out.
Added BSSID 00:90:d0:f2:ad:7b into blacklist
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
ioctl[SIOCSIWENCODEEXT]: No such file or directory
Driver did not support SIOCSIWENCODEEXT
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
ioctl[SIOCSIWENCODEEXT]: No such file or directory
Driver did not support SIOCSIWENCODEEXT
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
ioctl[SIOCSIWENCODEEXT]: No such file or directory
Driver did not support SIOCSIWENCODEEXT
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
Setting scan request: 0 sec 0 usec
State: DISCONNECTED -> SCANNING
Starting AP scan (broadcast SSID)
Scan requested (ret=0) - scan timeout 30 seconds
RTM_NEWLINK: operstate=0 ifi_flags=0x1803 ([UP])
Wireless event: cmd=0x8b19 len=16
Received 268 bytes of scan results (1 BSSes)
CTRL-EVENT-SCAN-RESULTS
Selecting BSS from priority group 5
Try to find WPA-enabled AP
0: 00:90:d0:f2:ad:7b ssid='O2wirelessF412A2' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
Try to find non-WPA AP
0: 00:90:d0:f2:ad:7b ssid='O2wirelessF412A2' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   selected non-WPA AP 00:90:d0:f2:ad:7b ssid='O2wirelessF412A2'
Trying to associate with 00:90:d0:f2:ad:7b (SSID='O2wirelessF412A2'
freq=2412 MHz)
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
Overriding auth_alg selection: 0x2
WPA: clearing AP WPA IE
WPA: clearing AP RSN IE
WPA: clearing own WPA/RSN IE
No keys have been configured - skip key clearing
wpa_driver_wext_set_key: alg=1 key_idx=0 set_tx=1 seq_len=0 key_len=5
wpa_driver_wext_set_drop_unencrypted
State: SCANNING -> ASSOCIATING
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_associate
Setting authentication timeout: 10 sec 0 usec
EAPOL: External notification - portControl=ForceAuthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1803 ([UP])
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1803 ([UP])
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1803 ([UP])
Wireless event: cmd=0x8b1a len=32
RTM_NEWLINK: operstate=0 ifi_flags=0x1803 ([UP])
Wireless event: cmd=0x8b19 len=16
Received 568 bytes of scan results (2 BSSes)
CTRL-EVENT-SCAN-RESULTS
Selecting BSS from priority group 5
Try to find WPA-enabled AP
0: 00:14:6c:ab:90:5a ssid='SKY25726' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
1: 00:90:d0:f2:ad:7b ssid='O2wirelessF412A2' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   skip - no WPA/RSN IE
Try to find non-WPA AP
0: 00:14:6c:ab:90:5a ssid='SKY25726' wpa_ie_len=22 rsn_ie_len=0 caps=0x11
   skip - SSID mismatch
1: 00:90:d0:f2:ad:7b ssid='O2wirelessF412A2' wpa_ie_len=0 rsn_ie_len=0 caps=0x11
   selected non-WPA AP 00:90:d0:f2:ad:7b ssid='O2wirelessF412A2'
Already associated with the selected AP.
RTM_NEWLINK: operstate=0 ifi_flags=0x1803 ([UP])
Wireless event: cmd=0x8b06 len=12
RTM_NEWLINK: operstate=0 ifi_flags=0x1803 ([UP])
Wireless event: cmd=0x8b04 len=16
RTM_NEWLINK: operstate=0 ifi_flags=0x1803 ([UP])
Wireless event: cmd=0x8b1a len=32
CTRL-EVENT-TERMINATING - signal 2 received
Removing interface wlan1
State: ASSOCIATING -> DISCONNECTED
wpa_driver_wext_set_operstate: operstate 0->0 (DORMANT)
WEXT: Operstate: linkmode=-1, operstate=5
wpa_driver_wext_set_key: alg=0 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_wext_set_key: alg=0 key_idx=1 set_tx=0 seq_len=0 key_len=0
ioctl[SIOCSIWENCODEEXT]: No such file or directory
Driver did not support SIOCSIWENCODEEXT
wpa_driver_wext_set_key: alg=0 key_idx=2 set_tx=0 seq_len=0 key_len=0
ioctl[SIOCSIWENCODEEXT]: No such file or directory
Driver did not support SIOCSIWENCODEEXT
wpa_driver_wext_set_key: alg=0 key_idx=3 set_tx=0 seq_len=0 key_len=0
ioctl[SIOCSIWENCODEEXT]: No such file or directory
Driver did not support SIOCSIWENCODEEXT
EAPOL: External notification - portEnabled=0
EAPOL: External notification - portValid=0
wpa_driver_wext_set_wpa
wpa_driver_wext_set_drop_unencrypted
wpa_driver_wext_set_countermeasures
ioctl[SIOCSIWAUTH]: Operation not supported
WEXT auth param 4 value 0x0 - No keys have been configured - skip key clearing
Removed BSSID 00:90:d0:f2:ad:7b from blacklist (clear)
Cancelling scan request
Cancelling authentication timeout
WEXT: Operstate: linkmode=0, operstate=6
