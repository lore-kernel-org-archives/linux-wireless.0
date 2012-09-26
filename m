Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-wg0-f44.google.com ([74.125.82.44]:37897 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753831Ab2IZMfy (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Sep 2012 08:35:54 -0400
Received: by wgbdr13 with SMTP id dr13so476374wgb.1
        for <linux-wireless@vger.kernel.org>; Wed, 26 Sep 2012 05:35:52 -0700 (PDT)
Message-ID: <5062F6A6.8000207@gmail.com> (sfid-20120926_143558_789962_B0C44220)
Date: Wed, 26 Sep 2012 13:35:50 +0100
From: Ben Gray <ben.r.gray@gmail.com>
MIME-Version: 1.0
To: Mohammed Shafi <shafi.wireless@gmail.com>
CC: Jonathan Bagg <jbagg@lenbrook.com>, linux-wireless@vger.kernel.org,
	jouni@qca.qualcomm.com
Subject: Re: ath6kl ar6004/ar9374 (hw 1.3) WPA/WPA2 supported ?
References: <5062E0CB.6040308@gmail.com> <5062EBCE.70700@lenbrook.com> <CAD2nsn3Tkkk92WRhBhBtj8oU5edWZf4tgS2ex8doSAnGDGpcnA@mail.gmail.com>
In-Reply-To: <CAD2nsn3Tkkk92WRhBhBtj8oU5edWZf4tgS2ex8doSAnGDGpcnA@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------030708090705080508030408"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------030708090705080508030408
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit

Wow that was quick, thanks very much.  Any idea when it will make it 
upstream ?

I've attached the wpa_supplicant (v0.7.3) log in case anyone is still 
interested.

Thanks everyone for your replies,

Ben.


On 26/09/2012 13:19, Mohammed Shafi wrote:
> On Wed, Sep 26, 2012 at 5:19 PM, Jonathan Bagg <jbagg@lenbrook.com> wrote:
>> I've had the same experience, I can connect with iw, but not with
>> wpa_supplicant with wpa.  I also couldn't get higher than 65Mbps, MCS7
>> (other devices on the same router will go faster).  I'm probably the other
>> post you mentioned.
>
> We have a fix, I shall validate it and send it upstream.
>>
>> Jon
>>
>>
>> On 12-09-26 07:02 AM, Ben Gray wrote:
>>>
>>> Hi,
>>>
>>>      I have a bunch of UB134 USB dongles which have a ath6kl chip with H/W
>>> version 0x31c8088a, I'm trying to get them to work with the ath6kl driver
>>> from the compat-wireless-3.6-rc5-1 package. I've applied this
>>> (https://patchwork.kernel.org/patch/1203191/) patch to the source and pulled
>>> the hw1.3 firmware from the linux-firmware git.
>>>
>>>      The driver works as far as it can scan AP's and connect to unencrypted
>>> networks, however WPA/WPA2 doesn't work when I run wpa_supplicant. I realise
>>> "WPA doesn't work" is a bit vague, and I can post the wpa_supplicant and
>>> driver logs if that helps, but I've seen another post which says they
>>> couldn't get WPA to work either, so I'd like to know if this is a known
>>> issue with the driver and/or firmware? Has anyone had any luck getting
>>> WPA/WPA2 working with ath6kl hw1.3 ?
>>>
>>>      If this is a known issue does anyone know when it might be fixed ?
>>>
>>>
>>> Thanks in advance,
>>> Ben.
>>>
>>> --
>>> To unsubscribe from this list: send the line "unsubscribe linux-wireless"
>>> in
>>> the body of a message to majordomo@vger.kernel.org
>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
>
>


--------------030708090705080508030408
Content-Type: text/plain; charset=UTF-8; x-mac-type="0"; x-mac-creator="0";
 name="wpa_supp.log"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="wpa_supp.log"

Initializing interface 'wlan0' conf '/tmp/wpa_supp.conf' driver 'nl80211' ctrl_interface 'N/A' bridge 'N/A'
Configuration file '/tmp/wpa_supp.conf' -> '/tmp/wpa_supp.conf'
Reading configuration file '/tmp/wpa_supp.conf'
ctrl_interface='/var/run/wpa_supplicant'
ap_scan=1
Line: 4 - start of a new network block
ssid - hexdump_ascii(len=8):
     53 4b 59 34 36 31 36 45                           SKY4616E        
proto: 0x1
key_mgmt: 0x2
pairwise: 0x18
group: 0x18
PSK - hexdump(len=32): [REMOVED]
Priority group 0
   id=0 ssid='SKY4616E'
netlink: Operstate: linkmode=1, operstate=5
Own MAC address: 00:03:7f:20:49:12
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e4f28 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e4f28 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e4f28 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e4f28 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e4f28 key_idx=4 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e4f28 key_idx=5 set_tx=0 seq_len=0 key_len=0
RSN: flushing PMKID list in the driver
Setting scan request: 0 sec 100000 usec
WPS: UUID based on MAC address - hexdump(len=16): 89 22 27 6c 5f ea 52 33 93 f7 92 9a 11 5e b7 1c
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
EAPOL: Supplicant port status: Unauthorized
Added interface wlan0
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
State: DISCONNECTED -> SCANNING
Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 10 seconds
nl80211: Event message available
nl80211: Scan trigger
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized
nl80211: Event message available
nl80211: New scan results available
Received scan results (29 BSSes)
BSS: Start scan result update 1
BSS: Add new id 0 BSSID c8:cd:72:c4:61:6f SSID '<<removed>>'
BSS: Add new id 1 BSSID 00:19:fb:5b:92:75 SSID '<<removed>>'
BSS: Add new id 2 BSSID a8:b1:d4:6c:ed:7e SSID '<<removed>>'
New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1041 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=13
WPS: attr type=0x1023 len=8
WPS: attr type=0x1024 len=8
WPS: attr type=0x1042 len=2
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=8
WPS: attr type=0x1008 len=2
WPS: attr type=0x103c len=1
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x1041 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=13
WPS: attr type=0x1023 len=8
WPS: attr type=0x1024 len=8
WPS: attr type=0x1042 len=2
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=8
WPS: attr type=0x1008 len=2
WPS: attr type=0x103c len=1
Selecting BSS from priority group 0
Try to find WPA-enabled AP
0: c8:cd:72:c4:61:6f ssid='SKY4616E' wpa_ie_len=28 rsn_ie_len=0 caps=0x411
   selected based on WPA IE
   selected WPA AP c8:cd:72:c4:61:6f ssid='SKY4616E'
Trying to associate with c8:cd:72:c4:61:6f (SSID='SKY4616E' freq=2437 MHz)
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
Cancelling scan request
WPA: clearing own WPA/RSN IE
Automatic auth_alg selection: 0x1
WPA: using IEEE 802.11i/D3.0
WPA: Selected cipher suites: group 8 pairwise 24 key_mgmt 2 proto 1
WPA: set AP WPA IE - hexdump(len=30): dd 1c 00 50 f2 01 01 00 00 50 f2 02 02 00 00 50 f2 04 00 50 f2 02 01 00 00 50 f2 02 0c 00
WPA: clearing AP RSN IE
WPA: using GTK TKIP
WPA: using PTK CCMP
WPA: using KEY_MGMT WPA-PSK
WPA: not using MGMT group cipher
WPA: Set own WPA IE default - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
No keys have been configured - skip key clearing
State: SCANNING -> ASSOCIATING
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
nl80211: Connect (ifindex=4)
  * bssid=c8:cd:72:c4:61:6f
  * freq=2437
  * SSID - hexdump_ascii(len=8):
     53 4b 59 34 36 31 36 45                           SKY4616E        
  * IEs - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
  * Auth Type 0
  * WPA Version 1
nl80211: Connect request send successfully
Setting authentication timeout: 10 sec 0 usec
EAPOL: External notification - EAP success=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - EAP fail=0
EAPOL: Supplicant port status: Unauthorized
EAPOL: External notification - portControl=Auto
EAPOL: Supplicant port status: Unauthorized
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
nl80211: Event message available
Association info event
req_ies - hexdump(len=90): 00 08 53 4b 59 34 36 31 36 45 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c 2d 1a ac 01 02 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 01 01 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02 dd 07 00 50 f2 02 00 01 00
resp_ies - hexdump(len=105): 01 08 82 84 8b 96 24 30 48 6c 32 04 0c 12 18 60 2d 1a 6c 18 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 06 00 15 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 01 f0 04 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
WPA: set own WPA/RSN IE - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
State: ASSOCIATING -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
Associated to a new BSS: BSSID=c8:cd:72:c4:61:6f
No keys have been configured - skip key clearing
Associated with c8:cd:72:c4:61:6f
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
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RX EAPOL from c8:cd:72:c4:61:6f
RX EAPOL - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 00 00 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=1 type=3 length=95
  EAPOL-Key type=254
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_nonce - hexdump(len=32): 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 00 00 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c8:cd:72:c4:61:6f (ver=2)
WPA: Renewed SNonce - hexdump(len=32): 1c 6c bd 77 3d c7 c4 ee 38 ca 7d 4e e5 a6 01 4f 79 69 7b e6 b7 7b 35 55 68 a0 2e 6f 5c 89 64 6d
WPA: PTK derivation - A1=00:03:7f:20:49:12 A2=c8:cd:72:c4:61:6f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=123): 01 03 00 77 fe 01 0a 00 10 00 00 00 00 00 00 00 00 1c 6c bd 77 3d c7 c4 ee 38 ca 7d 4e e5 a6 01 4f 79 69 7b e6 b7 7b 35 55 68 a0 2e 6f 5c 89 64 6d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 4e ea db 34 73 85 f4 21 c1 38 4d 2f 5e b9 bc 11 00 18 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
EAPOL: startWhen --> 0
EAPOL: disable timer tick
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: txStart
WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
RX EAPOL from c8:cd:72:c4:61:6f
RX EAPOL - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 00 01 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=1 type=3 length=95
  EAPOL-Key type=254
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 00 01 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c8:cd:72:c4:61:6f (ver=2)
WPA: PTK derivation - A1=00:03:7f:20:49:12 A2=c8:cd:72:c4:61:6f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=123): 01 03 00 77 fe 01 0a 00 10 00 00 00 00 00 00 00 01 1c 6c bd 77 3d c7 c4 ee 38 ca 7d 4e e5 a6 01 4f 79 69 7b e6 b7 7b 35 55 68 a0 2e 6f 5c 89 64 6d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 b8 35 5d 40 74 0e 60 dc b6 fb d7 ca 33 c1 b8 27 00 18 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
RX EAPOL from c8:cd:72:c4:61:6f
RX EAPOL - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 00 02 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=1 type=3 length=95
  EAPOL-Key type=254
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 02
  key_nonce - hexdump(len=32): 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 00 02 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c8:cd:72:c4:61:6f (ver=2)
WPA: PTK derivation - A1=00:03:7f:20:49:12 A2=c8:cd:72:c4:61:6f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=123): 01 03 00 77 fe 01 0a 00 10 00 00 00 00 00 00 00 02 1c 6c bd 77 3d c7 c4 ee 38 ca 7d 4e e5 a6 01 4f 79 69 7b e6 b7 7b 35 55 68 a0 2e 6f 5c 89 64 6d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 33 ab cb bc de 39 fd 0c 7c 55 3e 77 72 84 78 b0 00 18 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
RX EAPOL from c8:cd:72:c4:61:6f
RX EAPOL - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 00 03 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=1 type=3 length=95
  EAPOL-Key type=254
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 03
  key_nonce - hexdump(len=32): 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 00 03 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c8:cd:72:c4:61:6f (ver=2)
WPA: PTK derivation - A1=00:03:7f:20:49:12 A2=c8:cd:72:c4:61:6f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=123): 01 03 00 77 fe 01 0a 00 10 00 00 00 00 00 00 00 03 1c 6c bd 77 3d c7 c4 ee 38 ca 7d 4e e5 a6 01 4f 79 69 7b e6 b7 7b 35 55 68 a0 2e 6f 5c 89 64 6d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 21 c2 55 c3 eb a0 13 dd 4a 9d 6e 6f 18 c5 b2 69 00 18 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
RX EAPOL from c8:cd:72:c4:61:6f
RX EAPOL - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 00 04 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=1 type=3 length=95
  EAPOL-Key type=254
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 04
  key_nonce - hexdump(len=32): 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 00 04 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c8:cd:72:c4:61:6f (ver=2)
WPA: PTK derivation - A1=00:03:7f:20:49:12 A2=c8:cd:72:c4:61:6f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=123): 01 03 00 77 fe 01 0a 00 10 00 00 00 00 00 00 00 04 1c 6c bd 77 3d c7 c4 ee 38 ca 7d 4e e5 a6 01 4f 79 69 7b e6 b7 7b 35 55 68 a0 2e 6f 5c 89 64 6d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 aa 26 6f 2e da af 00 ca 9a cf c7 70 53 f3 3e 57 00 18 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
RX EAPOL from c8:cd:72:c4:61:6f
RX EAPOL - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 00 05 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=1 type=3 length=95
  EAPOL-Key type=254
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 05
  key_nonce - hexdump(len=32): 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 00 05 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c8:cd:72:c4:61:6f (ver=2)
WPA: PTK derivation - A1=00:03:7f:20:49:12 A2=c8:cd:72:c4:61:6f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=123): 01 03 00 77 fe 01 0a 00 10 00 00 00 00 00 00 00 05 1c 6c bd 77 3d c7 c4 ee 38 ca 7d 4e e5 a6 01 4f 79 69 7b e6 b7 7b 35 55 68 a0 2e 6f 5c 89 64 6d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 b4 1a 54 8f a6 f8 a7 48 63 57 1a db 48 4b 7c b1 00 18 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
RX EAPOL from c8:cd:72:c4:61:6f
RX EAPOL - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 00 06 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=1 type=3 length=95
  EAPOL-Key type=254
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 06
  key_nonce - hexdump(len=32): 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 00 06 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c8:cd:72:c4:61:6f (ver=2)
WPA: PTK derivation - A1=00:03:7f:20:49:12 A2=c8:cd:72:c4:61:6f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=123): 01 03 00 77 fe 01 0a 00 10 00 00 00 00 00 00 00 06 1c 6c bd 77 3d c7 c4 ee 38 ca 7d 4e e5 a6 01 4f 79 69 7b e6 b7 7b 35 55 68 a0 2e 6f 5c 89 64 6d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 51 74 0e c4 f5 58 a6 22 e0 73 1b 63 0a 56 12 59 00 18 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
RX EAPOL from c8:cd:72:c4:61:6f
RX EAPOL - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 00 07 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=1 type=3 length=95
  EAPOL-Key type=254
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 07
  key_nonce - hexdump(len=32): 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 00 07 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 1f 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c8:cd:72:c4:61:6f (ver=2)
WPA: PTK derivation - A1=00:03:7f:20:49:12 A2=c8:cd:72:c4:61:6f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=123): 01 03 00 77 fe 01 0a 00 10 00 00 00 00 00 00 00 07 1c 6c bd 77 3d c7 c4 ee 38 ca 7d 4e e5 a6 01 4f 79 69 7b e6 b7 7b 35 55 68 a0 2e 6f 5c 89 64 6d 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1f 99 09 4f 0d c2 1e b2 1e d9 67 24 47 6f f5 c6 00 18 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
nl80211: Event message available
Association info event
req_ies - hexdump(len=90): 00 08 53 4b 59 34 36 31 36 45 01 08 82 84 8b 0c 12 96 18 24 32 04 30 48 60 6c 2d 1a ac 01 02 ff ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 7f 01 01 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02 dd 07 00 50 f2 02 00 01 00
resp_ies - hexdump(len=105): 01 08 82 84 8b 96 24 30 48 6c 32 04 0c 12 18 60 2d 1a 6c 18 1b ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3d 16 06 00 15 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd 09 00 10 18 02 02 f0 04 00 00 dd 18 00 50 f2 02 01 01 80 00 03 a4 00 00 27 a4 00 00 42 43 5e 00 62 32 2f 00
WPA: set own WPA/RSN IE - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
FT: Stored MDIE and FTIE from (Re)Association Response - hexdump(len=0):
State: 4WAY_HANDSHAKE -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=-1, operstate=5
Associated with c8:cd:72:c4:61:6f
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
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RX EAPOL from c8:cd:72:c4:61:6f
RX EAPOL - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 00 00 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
Setting authentication timeout: 10 sec 0 usec
IEEE 802.1X RX: version=1 type=3 length=95
  EAPOL-Key type=254
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_nonce - hexdump(len=32): 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 20
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 00 00 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: ASSOCIATED -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c8:cd:72:c4:61:6f (ver=2)
WPA: Renewed SNonce - hexdump(len=32): fc 69 21 9a ee 02 ce cf 51 ac b3 8f 14 32 4c 3b cd 5f 8c 5e bb 0b 99 0a 4e 8a 3a bd bc 90 16 79
WPA: PTK derivation - A1=00:03:7f:20:49:12 A2=c8:cd:72:c4:61:6f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=123): 01 03 00 77 fe 01 0a 00 10 00 00 00 00 00 00 00 00 fc 69 21 9a ee 02 ce cf 51 ac b3 8f 14 32 4c 3b cd 5f 8c 5e bb 0b 99 0a 4e 8a 3a bd bc 90 16 79 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 1b 03 f8 d6 fd 8c c6 a2 5a f7 eb 00 09 7a 81 78 00 18 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
EAPOL: startWhen --> 0
EAPOL: disable timer tick
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: txStart
WPA: drop TX EAPOL in non-IEEE 802.1X mode (type=1 len=0)
RX EAPOL from c8:cd:72:c4:61:6f
RX EAPOL - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 00 01 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
IEEE 802.1X RX: version=1 type=3 length=95
  EAPOL-Key type=254
  key_info 0x8a (ver=2 keyidx=0 rsvd=0 Pairwise Ack)
  key_length=16 key_data_length=0
  replay_counter - hexdump(len=8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=32): 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 20
  key_iv - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
  key_rsc - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
WPA: RX EAPOL-Key - hexdump(len=99): 01 03 00 5f fe 00 8a 00 10 00 00 00 00 00 00 00 01 49 4a 25 ab 9b 70 c8 d3 d3 1c 6c 57 31 ad 8e 4f 1b e0 5b 9e 0f b7 de 91 44 a6 16 14 ee 57 e1 20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
WPA: RX message 1 of 4-Way Handshake from c8:cd:72:c4:61:6f (ver=2)
WPA: PTK derivation - A1=00:03:7f:20:49:12 A2=c8:cd:72:c4:61:6f
WPA: PMK - hexdump(len=32): [REMOVED]
WPA: PTK - hexdump(len=48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=24): dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
WPA: Sending EAPOL-Key 2/4
WPA: TX EAPOL-Key - hexdump(len=123): 01 03 00 77 fe 01 0a 00 10 00 00 00 00 00 00 00 01 fc 69 21 9a ee 02 ce cf 51 ac b3 8f 14 32 4c 3b cd 5f 8c 5e bb 0b 99 0a 4e 8a 3a bd bc 90 16 79 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 f8 42 ca 36 14 23 44 5b f9 64 69 28 ea 5c 30 43 00 18 dd 16 00 50 f2 01 01 00 00 50 f2 02 01 00 00 50 f2 04 01 00 00 50 f2 02
nl80211: Event message available
Disassociation notification
WPA: 4-Way Handshake failed - pre-shared key may be incorrect
Setting scan request: 0 sec 100000 usec
Added BSSID c8:cd:72:c4:61:6f into blacklist
CTRL-EVENT-DISCONNECTED bssid=c8:cd:72:c4:61:6f reason=3
Disconnect event - remove keys
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e4f28 key_idx=0 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e4f28 key_idx=1 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e4f28 key_idx=2 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e4f28 key_idx=3 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e4f28 key_idx=4 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x80e4f28 key_idx=5 set_tx=0 seq_len=0 key_len=0
wpa_driver_nl80211_set_key: ifindex=4 alg=0 addr=0x8e01574 key_idx=0 set_tx=0 seq_len=0 key_len=0
   addr=c8:cd:72:c4:61:6f
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
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
RTM_NEWLINK: operstate=0 ifi_flags=0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan0' added
EAPOL: Supplicant port status: Unauthorized
State: DISCONNECTED -> SCANNING
Starting AP scan for wildcard SSID
nl80211: Scan SSID - hexdump_ascii(len=0): [NULL]
Scan requested (ret=0) - scan timeout 30 seconds
nl80211: Event message available
nl80211: Scan trigger
EAPOL: Supplicant port status: Unauthorized
nl80211: Event message available
nl80211: New scan results available
Received scan results (29 BSSes)
BSS: Start scan result update 2
BSS: Add new id 29 BSSID 74:44:01:8d:7e:1b SSID '<<removed>>'
BSS: Add new id 30 BSSID a8:b1:d4:6c:ed:7c SSID '<<removed>>'
BSS: Add new id 31 BSSID a8:b1:d4:6c:ed:72 SSID '<<removed>>'
BSS: Add new id 32 BSSID a8:b1:d4:21:43:8d SSID '<<removed>>'
New scan results available
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=8
WPS: attr type=0x1023 len=8
WPS: attr type=0x1024 len=6
WPS: attr type=0x1042 len=4
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=10
WPS: attr type=0x1008 len=2
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: Unsupported attribute type 0x1049 len=6
WPS: attr type=0x104a len=1
WPS: attr type=0x1044 len=1
WPS: attr type=0x103b len=1
WPS: attr type=0x1047 len=16
WPS: attr type=0x1021 len=8
WPS: attr type=0x1023 len=8
WPS: attr type=0x1024 len=6
WPS: attr type=0x1042 len=4
WPS: attr type=0x1054 len=8
WPS: attr type=0x1011 len=10
WPS: attr type=0x1008 len=2
WPS: attr type=0x103c len=1
WPS: attr type=0x1049 len=6
WPS: Unsupported attribute type 0x1049 len=6


--------------030708090705080508030408--
