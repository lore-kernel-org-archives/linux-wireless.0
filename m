Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from slow1-d.mail.gandi.net ([217.70.178.86]:50030 "EHLO
	slow1-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755289Ab3GDHAU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Jul 2013 03:00:20 -0400
Received: from relay5-d.mail.gandi.net (relay5-d.mail.gandi.net [217.70.183.197])
	by slow1-d.mail.gandi.net (Postfix) with ESMTP id 4890C535BCF
	for <linux-wireless@vger.kernel.org>; Thu,  4 Jul 2013 09:00:18 +0200 (CEST)
Message-ID: <51D51D5A.6070700@kaiwen.me> (sfid-20130704_090028_680726_44F0A164)
Date: Thu, 04 Jul 2013 08:59:38 +0200
From: =?ISO-8859-1?Q?K=E9vin_THIERRY?= <kevin.thierry@kaiwen.me>
MIME-Version: 1.0
To: Gagan Goyal <gagsbond@gmail.com>
CC: linux-wireless@vger.kernel.org, ronan lanoe <ronan.lanoe@gmail.com>
Subject: Re: Use of 5GHz frequencies with Wi-Fi Direct
References: <51D3E2C7.7020605@kaiwen.me> <CAChKcEmU9MMrC4gP4Vi3WWENTAC4+rtDK6mxA=5phdsEDxipxQ@mail.gmail.com> <51D41899.1010608@kaiwen.me> <CAChKcEnx12SE+qjYcp0yDpxB=w0gLKw9LM7z1=Dyz0=V91_TLw@mail.gmail.com>
In-Reply-To: <CAChKcEnx12SE+qjYcp0yDpxB=w0gLKw9LM7z1=Dyz0=V91_TLw@mail.gmail.com>
Content-Type: multipart/mixed;
 boundary="------------000609010609010501060509"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

This is a multi-part message in MIME format.
--------------000609010609010501060509
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: quoted-printable

Hi Gagan,

Please find, attached to this mail, the full connection logs.

The peer device is a Samsung Galaxy Note 10.1 with support for 5GHz=20
channels.

Thanks,

Kevin

Le 04/07/2013 04:59, Gagan Goyal a =E9crit :
> It seems that peer device is configured to use 2.4 Ghz channel.
> Plz share the complete connection logs to confirm.
>
> //Gagan
>
> On 7/3/13, K=E9vin THIERRY <kevin.thierry@kaiwen.me> wrote:
>> I'm using an Atheros WB222 Wi-Fi card.
>>
>> $ iw list
>>
>> [...]
>> /Frequencies://
>> //* 5180 MHz [36] (15.0 dBm) (passive scanning, no IBSS)//
>> //* 5200 MHz [40] (15.0 dBm) (passive scanning, no IBSS)//
>> //* 5220 MHz [44] (15.0 dBm) (passive scanning, no IBSS)//
>> //* 5240 MHz [48] (15.0 dBm) (passive scanning, no IBSS)//
>> //* 5260 MHz [52] (17.0 dBm) (passive scanning, no IBSS, radar detecti=
on)//
>> //* 5280 MHz [56] (15.0 dBm) (passive scanning, no IBSS, radar detecti=
on)//
>> //* 5300 MHz [60] (15.0 dBm) (passive scanning, no IBSS, radar detecti=
on)//
>> //* 5320 MHz [64] (15.0 dBm) (passive scanning, no IBSS, radar detecti=
on)//
>> //* 5500 MHz [100] (disabled)//
>> //* 5520 MHz [104] (disabled)//
>> //* 5540 MHz [108] (disabled)//
>> //* 5560 MHz [112] (disabled)//
>> //* 5580 MHz [116] (disabled)//
>> //* 5600 MHz [120] (disabled)//
>> //* 5620 MHz [124] (disabled)//
>> //* 5640 MHz [128] (disabled)//
>> //* 5660 MHz [132] (disabled)//
>> //* 5680 MHz [136] (disabled)//
>> //* 5700 MHz [140] (disabled)//
>> //* 5745 MHz [149] (17.0 dBm) (passive scanning, no IBSS)//
>> //* 5765 MHz [153] (17.0 dBm) (passive scanning, no IBSS)//
>> //* 5785 MHz [157] (17.0 dBm) (passive scanning, no IBSS)//
>> //* 5805 MHz [161] (17.0 dBm) (passive scanning, no IBSS)//
>> //* 5825 MHz [165] (17.0 dBm) (passive scanning, no IBSS)/
>> [...]
>>
>>
>> wpa_supplicant config file :
>>
>> /ctrl_interface=3D/var/run/wpa_supplicant//
>> //ap_scan=3D1//
>> //device_name=3Dkevin_PC//
>> //device_type=3D1-0050F204-1//
>> //p2p_oper_reg_class=3D115//
>> //p2p_oper_channel=3D36//
>> //country=3DUS/
>>
>>
>> wpa_supplicant debug at start :
>>
>> /ctrl_interface=3D'/var/run/wpa_supplicant'//
>> //ap_scan=3D1//
>> //device_name=3D'kevin_PC'//
>> //p2p_oper_reg_class=3D115//
>> //p2p_oper_channel=3D36//
>> //country=3D'US'//
>> //nl80211: interface wlan5 in phy phy0//
>> //rfkill: initial event: idx=3D0 type=3D1 op=3D0 soft=3D0 hard=3D0//
>> //rfkill: initial event: idx=3D1 type=3D2 op=3D0 soft=3D1 hard=3D0//
>> //nl80211: Set mode ifindex 4 iftype 2 (STATION)//
>> //nl80211: Subscribe to mgmt frames with non-AP handle 0x1e332f0//
>> //nl80211: Register frame type=3D0xd0 nl_handle=3D0x1e332f0//
>> //nl80211: Register frame match - hexdump(len=3D2): 04 0a//
>> //nl80211: Register frame type=3D0xd0 nl_handle=3D0x1e332f0//
>> //nl80211: Register frame match - hexdump(len=3D2): 04 0b//
>> //nl80211: Register frame type=3D0xd0 nl_handle=3D0x1e332f0//
>> //nl80211: Register frame match - hexdump(len=3D2): 04 0c//
>> //nl80211: Register frame type=3D0xd0 nl_handle=3D0x1e332f0//
>> //nl80211: Register frame match - hexdump(len=3D2): 04 0d//
>> //nl80211: Register frame type=3D0xd0 nl_handle=3D0x1e332f0//
>> //nl80211: Register frame match - hexdump(len=3D6): 04 09 50 6f 9a 09/=
/
>> //nl80211: Register frame type=3D0xd0 nl_handle=3D0x1e332f0//
>> //nl80211: Register frame match - hexdump(len=3D5): 7f 50 6f 9a 09//
>> //nl80211: Register frame type=3D0xd0 nl_handle=3D0x1e332f0//
>> //nl80211: Register frame match - hexdump(len=3D1): 06//
>> //nl80211: Register frame type=3D0xd0 nl_handle=3D0x1e332f0//
>> //nl80211: Register frame match - hexdump(len=3D2): 0a 07//
>> //nl80211: Register frame type=3D0xd0 nl_handle=3D0x1e332f0//
>> //nl80211: Register frame match - hexdump(len=3D2): 0a 11//
>> //netlink: Operstate: linkmode=3D1, operstate=3D5//
>> //nl80211: Using driver-based off-channel TX//
>> //nl80211: TDLS supported//
>> //nl80211: TDLS external setup//
>> //nl80211: Use separate P2P group interface (driver advertised support=
)//
>> //nl80211: driver param=3D'(null)'//
>> //nl80211: Regulatory information - country=3DUS//
>> //nl80211: 2402-2472 @ 40 MHz//
>> //nl80211: 5170-5250 @ 40 MHz//
>> //nl80211: 5250-5330 @ 40 MHz//
>> //nl80211: 5490-5600 @ 40 MHz//
>> //nl80211: 5650-5710 @ 40 MHz//
>> //nl80211: 5735-5835 @ 40 MHz//
>> //nl80211: Added 802.11b mode based on 802.11g information//
>> //wlan5: Own MAC address: 00:0b:6b:7f:92:56//
>> //wpa_driver_nl80211_set_key: ifindex=3D4 alg=3D0 addr=3D(nil) key_idx=
=3D0
>> set_tx=3D0 seq_len=3D0 key_len=3D0//
>> //wpa_driver_nl80211_set_key: ifindex=3D4 alg=3D0 addr=3D(nil) key_idx=
=3D1
>> set_tx=3D0 seq_len=3D0 key_len=3D0//
>> //wpa_driver_nl80211_set_key: ifindex=3D4 alg=3D0 addr=3D(nil) key_idx=
=3D2
>> set_tx=3D0 seq_len=3D0 key_len=3D0//
>> //wpa_driver_nl80211_set_key: ifindex=3D4 alg=3D0 addr=3D(nil) key_idx=
=3D3
>> set_tx=3D0 seq_len=3D0 key_len=3D0//
>> //wlan5: RSN: flushing PMKID list in the driver//
>> //nl80211: Flush PMKIDs//
>> //wlan5: State: DISCONNECTED -> INACTIVE//
>> //WPS: Set UUID for interface wlan5//
>> //WPS: UUID based on MAC address - hexdump(len=3D16): 97 71 b0 a8 da c=
a 57
>> bf 99 80 01 b3 3f 50 26 de//
>> //EAPOL: SUPP_PAE entering state DISCONNECTED//
>> //EAPOL: Supplicant port status: Unauthorized//
>> //nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00//
>> //EAPOL: KEY_RX entering state NO_KEY_RECEIVE//
>> //EAPOL: SUPP_BE entering state INITIALIZE//
>> //EAP: EAP entering state DISABLED//
>> //EAPOL: Supplicant port status: Unauthorized//
>> //nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00//
>> //EAPOL: Supplicant port status: Unauthorized//
>> //nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00//
>> //P2P: Own listen channel: 1//
>> //P2P: Configured operating channel: 115:36//
>> //P2P: Add operating class 81//
>> //P2P: Channels - hexdump(len=3D12): 01 02 03 04 05 06 07 08 09 0a 0b =
0d//
>> //wlan5: Added interface wlan5//
>> //wlan5: State: INACTIVE -> DISCONNECTED//
>> //wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)//
>> //netlink: Operstate: linkmode=3D-1, operstate=3D5//
>> //random: Got 18/20 bytes from /dev/random//
>> //RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])//
>> //RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added//
>> //nl80211: if_removed already cleared - ignore event//
>> //EAPOL: disable timer tick//
>> //EAPOL: Supplicant port status: Unauthorized//
>> //nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00//
>> //random: Got 2/2 bytes from /dev/random//
>> //nl80211: Ignore event for foreign ifindex 2/
>>
>>
>> It seems that the 5 GHz channels are added but the 2.4 GHz channels ar=
e
>> still there and used instead of the frequency 5180.
>>
>> K=E9vin
>>
>> Le 03/07/2013 11:59, Gagan Goyal a =E9crit :
>>> Hi Kevin,
>>>
>>> plz make sure that driver advertise the support for both the bands an=
d
>>> provide all the supported frequencies.
>>>
>>> During Supplicant init, supplicant read the driver capabilities and
>>> along with other things the supported band and frequencies are stored=
.
>>>
>>> P2p global data is then initialized with same data.
>>>
>>> Cheers
>>>
>>> Gagan
>>>
>>> On 7/3/13, K=E9vin THIERRY <kevin.thierry@kaiwen.me> wrote:
>>>> Hi,
>>>>
>>>> Is there a way to force the use of 5GHz frequencies with Wi-Fi Direc=
t ?
>>>> (Or define the 5GHz frequencies as preferred ?)
>>>>
>>>> I tried to add the freq_list option in wpa_supplicant config file
>>>> without success. (I think this option should be set in a network blo=
ck
>>>> but there is no network block for Wi-Fi Direct...)
>>>> "freq_list=3D5180 5200 5220 5240 5260 5280 5300 5320 5500 5520 5540 =
5560
>>>> 5580 5600 5620 5640 5660 5680 5700 5745 5765 5785 5805 5825"
>>>>
>>>> Thanks,
>>>>
>>>> Kevin
>>>> --
>>>> To unsubscribe from this list: send the line "unsubscribe
>>>> linux-wireless"
>>>> in
>>>> the body of a message to majordomo@vger.kernel.org
>>>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>>>>
>>


--------------000609010609010501060509
Content-Type: text/plain; charset=UTF-8;
 name="wpa_supplicant_debug"
Content-Transfer-Encoding: quoted-printable
Content-Disposition: attachment;
 filename="wpa_supplicant_debug"

wpa_supplicant v2.1-devel
random: Trying to read entropy from /dev/random
Successfully initialized wpa_supplicant
Initializing interface 'wlan5' conf 'wpa.conf' driver 'nl80211' ctrl_inte=
rface 'N/A' bridge 'N/A'
Configuration file 'wpa.conf' -> '/home/eurogiciel/widi-new/wpa.conf'
Reading configuration file '/home/eurogiciel/widi-new/wpa.conf'
ctrl_interface=3D'/var/run/wpa_supplicant'
ap_scan=3D1
device_name=3D'kevin_PC'
p2p_oper_reg_class=3D115
p2p_oper_channel=3D36
country=3D'US'
nl80211: interface wlan5 in phy phy0
rfkill: initial event: idx=3D0 type=3D1 op=3D0 soft=3D0 hard=3D0
rfkill: initial event: idx=3D1 type=3D2 op=3D0 soft=3D1 hard=3D0
nl80211: Set mode ifindex 4 iftype 2 (STATION)
nl80211: Subscribe to mgmt frames with non-AP handle 0x1fa52f0
nl80211: Register frame type=3D0xd0 nl_handle=3D0x1fa52f0
nl80211: Register frame match - hexdump(len=3D2): 04 0a
nl80211: Register frame type=3D0xd0 nl_handle=3D0x1fa52f0
nl80211: Register frame match - hexdump(len=3D2): 04 0b
nl80211: Register frame type=3D0xd0 nl_handle=3D0x1fa52f0
nl80211: Register frame match - hexdump(len=3D2): 04 0c
nl80211: Register frame type=3D0xd0 nl_handle=3D0x1fa52f0
nl80211: Register frame match - hexdump(len=3D2): 04 0d
nl80211: Register frame type=3D0xd0 nl_handle=3D0x1fa52f0
nl80211: Register frame match - hexdump(len=3D6): 04 09 50 6f 9a 09
nl80211: Register frame type=3D0xd0 nl_handle=3D0x1fa52f0
nl80211: Register frame match - hexdump(len=3D5): 7f 50 6f 9a 09
nl80211: Register frame type=3D0xd0 nl_handle=3D0x1fa52f0
nl80211: Register frame match - hexdump(len=3D1): 06
nl80211: Register frame type=3D0xd0 nl_handle=3D0x1fa52f0
nl80211: Register frame match - hexdump(len=3D2): 0a 07
nl80211: Register frame type=3D0xd0 nl_handle=3D0x1fa52f0
nl80211: Register frame match - hexdump(len=3D2): 0a 11
netlink: Operstate: linkmode=3D1, operstate=3D5
nl80211: Using driver-based off-channel TX
nl80211: TDLS supported
nl80211: TDLS external setup
nl80211: Use separate P2P group interface (driver advertised support)
nl80211: driver param=3D'(null)'
nl80211: Regulatory information - country=3DUS
nl80211: 2402-2472 @ 40 MHz
nl80211: 5170-5250 @ 40 MHz
nl80211: 5250-5330 @ 40 MHz
nl80211: 5490-5600 @ 40 MHz
nl80211: 5650-5710 @ 40 MHz
nl80211: 5735-5835 @ 40 MHz
nl80211: Added 802.11b mode based on 802.11g information
wlan5: Own MAC address: 00:0b:6b:7f:92:56
wpa_driver_nl80211_set_key: ifindex=3D4 alg=3D0 addr=3D(nil) key_idx=3D0 =
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D4 alg=3D0 addr=3D(nil) key_idx=3D1 =
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D4 alg=3D0 addr=3D(nil) key_idx=3D2 =
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D4 alg=3D0 addr=3D(nil) key_idx=3D3 =
set_tx=3D0 seq_len=3D0 key_len=3D0
wlan5: RSN: flushing PMKID list in the driver
nl80211: Flush PMKIDs
wlan5: State: DISCONNECTED -> INACTIVE
WPS: Set UUID for interface wlan5
WPS: UUID based on MAC address - hexdump(len=3D16): 97 71 b0 a8 da ca 57 =
bf 99 80 01 b3 3f 50 26 de
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
P2P: Own listen channel: 1
P2P: Configured operating channel: 115:36
P2P: Add operating class 81
P2P: Channels - hexdump(len=3D12): 01 02 03 04 05 06 07 08 09 0a 0b 0d
wlan5: Added interface wlan5
wlan5: State: INACTIVE -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=3D-1, operstate=3D5
random: Got 20/20 bytes from /dev/random
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'wlan5' added
nl80211: if_removed already cleared - ignore event
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
RX ctrl_iface - hexdump_ascii(len=3D18):
     53 45 54 20 77 69 66 69 5f 64 69 73 70 6c 61 79   SET wifi_display
     20 30                                              0             =20
wlan5: Control interface command 'SET wifi_display 0'
CTRL_IFACE SET 'wifi_display'=3D'0'
WFD: Wi-Fi Display disabled
WFD: Update WFD IE
WFD: Wi-Fi Display disabled - do not include WFD IE
RX ctrl_iface - hexdump_ascii(len=3D35):
     57 46 44 5f 53 55 42 45 4c 45 4d 5f 53 45 54 20   WFD_SUBELEM_SET=20
     30 30 20 30 30 30 36 30 30 30 31 30 30 30 30 30   00 0006000100000
     30 30 30                                          000            =20
wlan5: Control interface command 'WFD_SUBELEM_SET 00 0006000100000000'
WFD: Set subelement 0
WFD: Update WFD IE
WFD: Wi-Fi Display disabled - do not include WFD IE
RX ctrl_iface - hexdump_ascii(len=3D24):
     53 45 54 20 64 65 76 69 63 65 5f 6e 61 6d 65 20   SET device_name=20
     6b 65 76 69 6e 2d 70 63                           kevin-pc       =20
wlan5: Control interface command 'SET device_name kevin-pc'
CTRL_IFACE SET 'device_name'=3D'kevin-pc'
device_name=3D'kevin-pc'
RX ctrl_iface - hexdump_ascii(len=3D17):
     53 45 54 20 6d 6f 64 65 6c 5f 6e 61 6d 65 20 70   SET model_name p
     63                                                c              =20
wlan5: Control interface command 'SET model_name pc'
CTRL_IFACE SET 'model_name'=3D'pc'
model_name=3D'pc'
RX ctrl_iface - hexdump_ascii(len=3D30):
     53 45 54 20 6d 61 6e 75 66 61 63 74 75 72 65 72   SET manufacturer
     20 5b 70 6c 61 63 65 68 6f 6c 64 65 72 5d          [placeholder] =20
wlan5: Control interface command 'SET manufacturer [placeholder]'
CTRL_IFACE SET 'manufacturer'=3D'[placeholder]'
manufacturer=3D'[placeholder]'
RX ctrl_iface - hexdump_ascii(len=3D24):
     53 45 54 20 6d 6f 64 65 6c 5f 6e 75 6d 62 65 72   SET model_number
     20 34 2e 30 2e 30 2e 30                            4.0.0.0       =20
wlan5: Control interface command 'SET model_number 4.0.0.0'
CTRL_IFACE SET 'model_number'=3D'4.0.0.0'
model_number=3D'4.0.0.0'
RX ctrl_iface - hexdump_ascii(len=3D31):
     53 45 54 20 73 65 72 69 61 6c 5f 6e 75 6d 62 65   SET serial_numbe
     72 20 5b 70 6c 61 63 65 68 6f 6c 64 65 72 5d      r [placeholder]=20
wlan5: Control interface command 'SET serial_number [placeholder]'
CTRL_IFACE SET 'serial_number'=3D'[placeholder]'
serial_number=3D'[placeholder]'
RX ctrl_iface - hexdump_ascii(len=3D18):
     53 45 54 20 77 69 66 69 5f 64 69 73 70 6c 61 79   SET wifi_display
     20 31                                              1             =20
wlan5: Control interface command 'SET wifi_display 1'
CTRL_IFACE SET 'wifi_display'=3D'1'
WFD: Wi-Fi Display enabled
WFD: Update WFD IE
WFD: WFD IE for Beacon - hexdump(len=3D15): dd 0d 50 6f 9a 0a 00 00 06 00=
 01 00 00 00 00
WFD: WFD IE for (Re)Association Request - hexdump(len=3D15): dd 0d 50 6f =
9a 0a 00 00 06 00 01 00 00 00 00
WFD: WFD IE for GO Negotiation - hexdump(len=3D15): dd 0d 50 6f 9a 0a 00 =
00 06 00 01 00 00 00 00
WFD: WFD IE for Provision Discovery Request - hexdump(len=3D15): dd 0d 50=
 6f 9a 0a 00 00 06 00 01 00 00 00 00
WFD: WFD IE for Probe Request - hexdump(len=3D15): dd 0d 50 6f 9a 0a 00 0=
0 06 00 01 00 00 00 00
WFD: WFD IE for Probe Response - hexdump(len=3D15): dd 0d 50 6f 9a 0a 00 =
00 06 00 01 00 00 00 00
WFD: WFD IE for P2P Invitation - hexdump(len=3D15): dd 0d 50 6f 9a 0a 00 =
00 06 00 01 00 00 00 00
WFD: WFD IE for Provision Discovery Response - hexdump(len=3D15): dd 0d 5=
0 6f 9a 0a 00 00 06 00 01 00 00 00 00
RX ctrl_iface - hexdump_ascii(len=3D10):
     50 32 50 5f 43 41 4e 43 45 4c                     P2P_CANCEL     =20
wlan5: Control interface command 'P2P_CANCEL'
P2P: Request to cancel group formation
P2P: Stopping find
P2P: Clear timeout (state=3DIDLE)
P2P: State IDLE -> IDLE
P2P: No ongoing group formation found
RX ctrl_iface - hexdump_ascii(len=3D22):
     50 32 50 5f 47 52 4f 55 50 5f 52 45 4d 4f 56 45   P2P_GROUP_REMOVE
     20 77 6c 61 6e 35                                  wlan5         =20
wlan5: Control interface command 'P2P_GROUP_REMOVE wlan5'
P2P: P2P group interface not found
RX ctrl_iface - hexdump_ascii(len=3D10):
     50 32 50 5f 4c 49 53 54 45 4e                     P2P_LISTEN     =20
wlan5: Control interface command 'P2P_LISTEN'
P2P: Stopping find
P2P: Clear timeout (state=3DIDLE)
P2P: State IDLE -> IDLE
P2P: Going to listen(only) state
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: Enable Probe Request reporting nl_preq=3D0x1fa68c0
nl80211: Register frame type=3D0x40 nl_handle=3D0x1fa68c0
nl80211: Register frame match - hexdump(len=3D0): [NULL]
nl80211: Remain-on-channel cookie 0xffff8804042eb280 for freq=3D2412 MHz =
duration=3D5000
P2P: State IDLE -> LISTEN_ONLY
RX ctrl_iface - hexdump_ascii(len=3D19):
     53 45 54 20 70 32 70 5f 67 6f 5f 69 6e 74 65 6e   SET p2p_go_inten
     74 20 30                                          t 0            =20
wlan5: Control interface command 'SET p2p_go_intent 0'
CTRL_IFACE SET 'p2p_go_intent'=3D'0'
p2p_go_intent=3D0
RX ctrl_iface - hexdump_ascii(len=3D26):
     53 45 54 20 70 65 72 73 69 73 74 65 6e 74 5f 72   SET persistent_r
     65 63 6f 6e 6e 65 63 74 20 31                     econnect 1     =20
wlan5: Control interface command 'SET persistent_reconnect 1'
CTRL_IFACE SET 'persistent_reconnect'=3D'1'
persistent_reconnect=3D1
RX ctrl_iface - hexdump_ascii(len=3D24):
     53 45 54 20 64 65 76 69 63 65 5f 6e 61 6d 65 20   SET device_name=20
     6b 65 76 69 6e 2d 70 63                           kevin-pc       =20
wlan5: Control interface command 'SET device_name kevin-pc'
CTRL_IFACE SET 'device_name'=3D'kevin-pc'
device_name=3D'kevin-pc'
RX ctrl_iface - hexdump_ascii(len=3D17):
     53 45 54 20 6d 6f 64 65 6c 5f 6e 61 6d 65 20 70   SET model_name p
     63                                                c              =20
wlan5: Control interface command 'SET model_name pc'
CTRL_IFACE SET 'model_name'=3D'pc'
model_name=3D'pc'
RX ctrl_iface - hexdump_ascii(len=3D30):
     53 45 54 20 6d 61 6e 75 66 61 63 74 75 72 65 72   SET manufacturer
     20 5b 70 6c 61 63 65 68 6f 6c 64 65 72 5d          [placeholder] =20
wlan5: Control interface command 'SET manufacturer [placeholder]'
CTRL_IFACE SET 'manufacturer'=3D'[placeholder]'
manufacturer=3D'[placeholder]'
RX ctrl_iface - hexdump_ascii(len=3D24):
     53 45 54 20 6d 6f 64 65 6c 5f 6e 75 6d 62 65 72   SET model_number
     20 34 2e 30 2e 30 2e 30                            4.0.0.0       =20
wlan5: Control interface command 'SET model_number 4.0.0.0'
CTRL_IFACE SET 'model_number'=3D'4.0.0.0'
model_number=3D'4.0.0.0'
RX ctrl_iface - hexdump_ascii(len=3D31):
     53 45 54 20 73 65 72 69 61 6c 5f 6e 75 6d 62 65   SET serial_numbe
     72 20 5b 70 6c 61 63 65 68 6f 6c 64 65 72 5d      r [placeholder]=20
wlan5: Control interface command 'SET serial_number [placeholder]'
CTRL_IFACE SET 'serial_number'=3D'[placeholder]'
serial_number=3D'[placeholder]'
RX ctrl_iface - hexdump_ascii(len=3D35):
     57 46 44 5f 53 55 42 45 4c 45 4d 5f 53 45 54 20   WFD_SUBELEM_SET=20
     30 30 20 30 30 30 36 30 30 31 31 30 30 30 30 30   00 0006001100000
     30 30 30                                          000            =20
wlan5: Control interface command 'WFD_SUBELEM_SET 00 0006001100000000'
WFD: Set subelement 0
WFD: Update WFD IE
WFD: WFD IE for Beacon - hexdump(len=3D15): dd 0d 50 6f 9a 0a 00 00 06 00=
 11 00 00 00 00
WFD: WFD IE for (Re)Association Request - hexdump(len=3D15): dd 0d 50 6f =
9a 0a 00 00 06 00 11 00 00 00 00
WFD: WFD IE for GO Negotiation - hexdump(len=3D15): dd 0d 50 6f 9a 0a 00 =
00 06 00 11 00 00 00 00
WFD: WFD IE for Provision Discovery Request - hexdump(len=3D15): dd 0d 50=
 6f 9a 0a 00 00 06 00 11 00 00 00 00
WFD: WFD IE for Probe Request - hexdump(len=3D15): dd 0d 50 6f 9a 0a 00 0=
0 06 00 11 00 00 00 00
WFD: WFD IE for Probe Response - hexdump(len=3D15): dd 0d 50 6f 9a 0a 00 =
00 06 00 11 00 00 00 00
WFD: WFD IE for P2P Invitation - hexdump(len=3D15): dd 0d 50 6f 9a 0a 00 =
00 06 00 11 00 00 00 00
WFD: WFD IE for Provision Discovery Response - hexdump(len=3D15): dd 0d 5=
0 6f 9a 0a 00 00 06 00 11 00 00 00 00
CTRL_IFACE monitor attached - hexdump(len=3D46): 2f 74 6d 70 2f 73 61 6d =
70 6c 65 5f 77 69 64 69 5f 77 70 61 5f 73 75 70 70 6c 69 63 61 6e 74 2e 5=
4 6b 4d 4e 5a 54 2f 73 6f 63 6b 65 74 00
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2412 channel_type=3D0=
 duration=3D5000 cookie=3D0xffff8804042eb280 (match))
wlan5: Event REMAIN_ON_CHANNEL (22) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(n=
il))
P2P: Starting Listen timeout(5,0) on freq=3D2412 based on callback
P2P: Set timeout (state=3DLISTEN_ONLY): 5.020000 sec
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3De0:2a:82:46:13:6e
nl80211: MLME event frame - hexdump(len=3D116): 40 00 00 00 ff ff ff ff f=
f ff e0 2a 82 46 13 6e ff ff ff ff ff ff 30 00 00 00 01 04 02 04 0b 16 32=
 08 0c 12 18 24 30 48 60 6c 2d 1a 3c 18 1f ff 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 01 dd 09 00 10 18 02 00 11 0=
1 00 00 dd 1e 00 90 4c 33 3c 18 1f ff 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3De0:2a:82:46:13:6e
nl80211: MLME event frame - hexdump(len=3D116): 40 00 00 00 ff ff ff ff f=
f ff e0 2a 82 46 13 6e ff ff ff ff ff ff 40 00 00 00 01 04 02 04 0b 16 32=
 08 0c 12 18 24 30 48 60 6c 2d 1a 3c 18 1f ff 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 01 dd 09 00 10 18 02 00 11 0=
1 00 00 dd 1e 00 90 4c 33 3c 18 1f ff 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D62:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D306): 40 00 00 00 ff ff ff ff f=
f ff 62 21 c0 99 88 b1 ff ff ff ff ff ff 20 1c 00 07 44 49 52 45 43 54 2d=
 01 08 8c 12 98 24 b0 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 01 dd 99 00 50 f2 04 10 4=
a 00 01 10 10 3a 00 01 01 10 08 00 02 21 08 10 47 00 10 34 e6 cb 58 77 e0=
 5f db 94 f5 e0 e3 4d 80 d0 f9 10 54 00 08 00 0a 00 50 f2 04 00 05 10 3c =
00 01 03 10 02 00 02 00 00 10 09 00 02 00 00 10 12 00 02 00 00 10 21 00 1=
3 53 41 4d 53 55 4e 47 5f 45 4c 45 43 54 52 4f 4e 49 43 53 10 23 00 0e 53=
 41 4d 53 55 4e 47 5f 4d 4f 42 49 4c 45 10 24 00 04 32 30 31 32 10 11 00 =
0c 41 6e 64 72 6f 69 64 5f 61 37 63 61 10 49 00 09 00 37 2a 00 01 20 03 0=
1 01 dd 11 50 6f 9a 09 02 02 00 27 00 06 05 00 58 58 04 51 01 dd 0d 50 6f=
 9a 0a 00 00 06 01 10 c0 00 00 28 dd 09 00 10 18 02 00 00 00 00 00 dd 1e =
00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x2108
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country XX(0x04) Regulatory Class 81 Channel Numbe=
r 1
P2P: Created device entry based on Probe Req: 62:21:c0:99:88:b1 dev_capab=
=3D0x25 group_capab=3D0x0 name=3D'Android_a7ca' listen_freq=3D2412
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x2108
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country XX(0x04) Regulatory Class 81 Channel Numbe=
r 1
P2P: Reply to P2P Probe Request in Listen state
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: CMD_FRAME freq=3D2412 wait=3D0 no_cck=3D1 no_ack=3D1 offchanok=3D=
1
nl80211: Frame TX command accepted (no ACK); cookie 0x0
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3De0:2a:82:46:13:6e
nl80211: MLME event frame - hexdump(len=3D116): 40 00 00 00 ff ff ff ff f=
f ff e0 2a 82 46 13 6e ff ff ff ff ff ff 50 00 00 00 01 04 02 04 0b 16 32=
 08 0c 12 18 24 30 48 60 6c 2d 1a 3c 18 1f ff 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 02 dd 09 00 10 18 02 00 11 0=
1 00 00 dd 1e 00 90 4c 33 3c 18 1f ff 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D62:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D306): 40 00 00 00 ff ff ff ff f=
f ff 62 21 c0 99 88 b1 ff ff ff ff ff ff 50 1c 00 07 44 49 52 45 43 54 2d=
 01 08 8c 12 98 24 b0 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 01 dd 99 00 50 f2 04 10 4=
a 00 01 10 10 3a 00 01 01 10 08 00 02 21 08 10 47 00 10 34 e6 cb 58 77 e0=
 5f db 94 f5 e0 e3 4d 80 d0 f9 10 54 00 08 00 0a 00 50 f2 04 00 05 10 3c =
00 01 03 10 02 00 02 00 00 10 09 00 02 00 00 10 12 00 02 00 00 10 21 00 1=
3 53 41 4d 53 55 4e 47 5f 45 4c 45 43 54 52 4f 4e 49 43 53 10 23 00 0e 53=
 41 4d 53 55 4e 47 5f 4d 4f 42 49 4c 45 10 24 00 04 32 30 31 32 10 11 00 =
0c 41 6e 64 72 6f 69 64 5f 61 37 63 61 10 49 00 09 00 37 2a 00 01 20 03 0=
1 01 dd 11 50 6f 9a 09 02 02 00 27 00 06 05 00 58 58 04 51 01 dd 0d 50 6f=
 9a 0a 00 00 06 01 10 c0 00 00 28 dd 09 00 10 18 02 00 00 00 00 00 dd 1e =
00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x2108
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country XX(0x04) Regulatory Class 81 Channel Numbe=
r 1
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x2108
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country XX(0x04) Regulatory Class 81 Channel Numbe=
r 1
P2P: Reply to P2P Probe Request in Listen state
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: CMD_FRAME freq=3D2412 wait=3D0 no_cck=3D1 no_ack=3D1 offchanok=3D=
1
nl80211: Frame TX command accepted (no ACK); cookie 0x0
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D18:f4:6a:88:56:a2
nl80211: MLME event frame - hexdump(len=3D45): 40 00 00 00 ff ff ff ff ff=
 ff 18 f4 6a 88 56 a2 ff ff ff ff ff ff b0 16 00 00 01 08 82 84 8b 96 0c =
12 18 24 32 04 30 48 60 6c 7f 01 01
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D18:f4:6a:88:56:a2
nl80211: MLME event frame - hexdump(len=3D45): 40 00 00 00 ff ff ff ff ff=
 ff 18 f4 6a 88 56 a2 ff ff ff ff ff ff c0 16 00 00 01 08 82 84 8b 96 0c =
12 18 24 32 04 30 48 60 6c 7f 01 01
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D62:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D306): 40 00 00 00 ff ff ff ff f=
f ff 62 21 c0 99 88 b1 ff ff ff ff ff ff 80 1c 00 07 44 49 52 45 43 54 2d=
 01 08 8c 12 98 24 b0 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 01 dd 99 00 50 f2 04 10 4=
a 00 01 10 10 3a 00 01 01 10 08 00 02 21 08 10 47 00 10 34 e6 cb 58 77 e0=
 5f db 94 f5 e0 e3 4d 80 d0 f9 10 54 00 08 00 0a 00 50 f2 04 00 05 10 3c =
00 01 03 10 02 00 02 00 00 10 09 00 02 00 00 10 12 00 02 00 00 10 21 00 1=
3 53 41 4d 53 55 4e 47 5f 45 4c 45 43 54 52 4f 4e 49 43 53 10 23 00 0e 53=
 41 4d 53 55 4e 47 5f 4d 4f 42 49 4c 45 10 24 00 04 32 30 31 32 10 11 00 =
0c 41 6e 64 72 6f 69 64 5f 61 37 63 61 10 49 00 09 00 37 2a 00 01 20 03 0=
1 01 dd 11 50 6f 9a 09 02 02 00 27 00 06 05 00 58 58 04 51 01 dd 0d 50 6f=
 9a 0a 00 00 06 01 10 c0 00 00 28 dd 09 00 10 18 02 00 00 00 00 00 dd 1e =
00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x2108
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country XX(0x04) Regulatory Class 81 Channel Numbe=
r 1
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x2108
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country XX(0x04) Regulatory Class 81 Channel Numbe=
r 1
P2P: Reply to P2P Probe Request in Listen state
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: CMD_FRAME freq=3D2412 wait=3D0 no_cck=3D1 no_ack=3D1 offchanok=3D=
1
nl80211: Frame TX command accepted (no ACK); cookie 0x0
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D18:f4:6a:88:56:a2
nl80211: MLME event frame - hexdump(len=3D45): 40 00 00 00 ff ff ff ff ff=
 ff 18 f4 6a 88 56 a2 ff ff ff ff ff ff 50 17 00 00 01 08 82 84 8b 96 0c =
12 18 24 32 04 30 48 60 6c 7f 01 01
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D62:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D306): 40 00 00 00 ff ff ff ff f=
f ff 62 21 c0 99 88 b1 ff ff ff ff ff ff b0 1c 00 07 44 49 52 45 43 54 2d=
 01 08 8c 12 98 24 b0 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 01 dd 99 00 50 f2 04 10 4=
a 00 01 10 10 3a 00 01 01 10 08 00 02 21 08 10 47 00 10 34 e6 cb 58 77 e0=
 5f db 94 f5 e0 e3 4d 80 d0 f9 10 54 00 08 00 0a 00 50 f2 04 00 05 10 3c =
00 01 03 10 02 00 02 00 00 10 09 00 02 00 00 10 12 00 02 00 00 10 21 00 1=
3 53 41 4d 53 55 4e 47 5f 45 4c 45 43 54 52 4f 4e 49 43 53 10 23 00 0e 53=
 41 4d 53 55 4e 47 5f 4d 4f 42 49 4c 45 10 24 00 04 32 30 31 32 10 11 00 =
0c 41 6e 64 72 6f 69 64 5f 61 37 63 61 10 49 00 09 00 37 2a 00 01 20 03 0=
1 01 dd 11 50 6f 9a 09 02 02 00 27 00 06 05 00 58 58 04 51 01 dd 0d 50 6f=
 9a 0a 00 00 06 01 10 c0 00 00 28 dd 09 00 10 18 02 00 00 00 00 00 dd 1e =
00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x2108
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country XX(0x04) Regulatory Class 81 Channel Numbe=
r 1
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x2108
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country XX(0x04) Regulatory Class 81 Channel Numbe=
r 1
P2P: Reply to P2P Probe Request in Listen state
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: CMD_FRAME freq=3D2412 wait=3D0 no_cck=3D1 no_ack=3D1 offchanok=3D=
1
nl80211: Frame TX command accepted (no ACK); cookie 0x0
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D62:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D306): 40 00 00 00 ff ff ff ff f=
f ff 62 21 c0 99 88 b1 ff ff ff ff ff ff e0 1c 00 07 44 49 52 45 43 54 2d=
 01 08 8c 12 98 24 b0 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 01 dd 99 00 50 f2 04 10 4=
a 00 01 10 10 3a 00 01 01 10 08 00 02 21 08 10 47 00 10 34 e6 cb 58 77 e0=
 5f db 94 f5 e0 e3 4d 80 d0 f9 10 54 00 08 00 0a 00 50 f2 04 00 05 10 3c =
00 01 03 10 02 00 02 00 00 10 09 00 02 00 00 10 12 00 02 00 00 10 21 00 1=
3 53 41 4d 53 55 4e 47 5f 45 4c 45 43 54 52 4f 4e 49 43 53 10 23 00 0e 53=
 41 4d 53 55 4e 47 5f 4d 4f 42 49 4c 45 10 24 00 04 32 30 31 32 10 11 00 =
0c 41 6e 64 72 6f 69 64 5f 61 37 63 61 10 49 00 09 00 37 2a 00 01 20 03 0=
1 01 dd 11 50 6f 9a 09 02 02 00 27 00 06 05 00 58 58 04 51 01 dd 0d 50 6f=
 9a 0a 00 00 06 01 10 c0 00 00 28 dd 09 00 10 18 02 00 00 00 00 00 dd 1e =
00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x2108
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country XX(0x04) Regulatory Class 81 Channel Numbe=
r 1
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x2108
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country XX(0x04) Regulatory Class 81 Channel Numbe=
r 1
P2P: Reply to P2P Probe Request in Listen state
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: CMD_FRAME freq=3D2412 wait=3D0 no_cck=3D1 no_ack=3D1 offchanok=3D=
1
nl80211: Frame TX command accepted (no ACK); cookie 0x0
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D62:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D306): 40 00 00 00 ff ff ff ff f=
f ff 62 21 c0 99 88 b1 ff ff ff ff ff ff 10 1d 00 07 44 49 52 45 43 54 2d=
 01 08 8c 12 98 24 b0 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 01 dd 99 00 50 f2 04 10 4=
a 00 01 10 10 3a 00 01 01 10 08 00 02 21 08 10 47 00 10 34 e6 cb 58 77 e0=
 5f db 94 f5 e0 e3 4d 80 d0 f9 10 54 00 08 00 0a 00 50 f2 04 00 05 10 3c =
00 01 03 10 02 00 02 00 00 10 09 00 02 00 00 10 12 00 02 00 00 10 21 00 1=
3 53 41 4d 53 55 4e 47 5f 45 4c 45 43 54 52 4f 4e 49 43 53 10 23 00 0e 53=
 41 4d 53 55 4e 47 5f 4d 4f 42 49 4c 45 10 24 00 04 32 30 31 32 10 11 00 =
0c 41 6e 64 72 6f 69 64 5f 61 37 63 61 10 49 00 09 00 37 2a 00 01 20 03 0=
1 01 dd 11 50 6f 9a 09 02 02 00 27 00 06 05 00 58 58 04 51 01 dd 0d 50 6f=
 9a 0a 00 00 06 01 10 c0 00 00 28 dd 09 00 10 18 02 00 00 00 00 00 dd 1e =
00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x2108
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country XX(0x04) Regulatory Class 81 Channel Numbe=
r 1
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x2108
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country XX(0x04) Regulatory Class 81 Channel Numbe=
r 1
P2P: Reply to P2P Probe Request in Listen state
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: CMD_FRAME freq=3D2412 wait=3D0 no_cck=3D1 no_ack=3D1 offchanok=3D=
1
nl80211: Frame TX command accepted (no ACK); cookie 0x0
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D60:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D116): 40 00 00 00 ff ff ff ff f=
f ff 60 21 c0 99 88 b1 ff ff ff ff ff ff 40 1d 00 00 01 04 02 04 0b 16 32=
 08 0c 12 18 24 30 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 01 dd 09 00 10 18 02 00 00 0=
0 00 00 dd 1e 00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D60:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D116): 40 00 00 00 ff ff ff ff f=
f ff 60 21 c0 99 88 b1 ff ff ff ff ff ff 50 1d 00 00 01 04 02 04 0b 16 32=
 08 0c 12 18 24 30 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 01 dd 09 00 10 18 02 00 00 0=
0 00 00 dd 1e 00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D60:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D116): 40 00 00 00 ff ff ff ff f=
f ff 60 21 c0 99 88 b1 ff ff ff ff ff ff 60 1d 00 00 01 04 02 04 0b 16 32=
 08 0c 12 18 24 30 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 02 dd 09 00 10 18 02 00 00 0=
0 00 00 dd 1e 00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D60:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D116): 40 00 00 00 ff ff ff ff f=
f ff 60 21 c0 99 88 b1 ff ff ff ff ff ff 70 1d 00 00 01 04 02 04 0b 16 32=
 08 0c 12 18 24 30 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 02 dd 09 00 10 18 02 00 00 0=
0 00 00 dd 1e 00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D60:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D116): 40 00 00 00 ff ff ff ff f=
f ff 60 21 c0 99 88 b1 ff ff ff ff ff ff c0 1d 00 00 01 04 02 04 0b 16 32=
 08 0c 12 18 24 30 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 05 dd 09 00 10 18 02 00 00 0=
0 00 00 dd 1e 00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D60:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D116): 40 00 00 00 ff ff ff ff f=
f ff 60 21 c0 99 88 b1 ff ff ff ff ff ff e0 1e 00 00 01 04 02 04 0b 16 32=
 08 0c 12 18 24 30 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 01 dd 09 00 10 18 02 00 00 0=
0 00 00 dd 1e 00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D60:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D116): 40 00 00 00 ff ff ff ff f=
f ff 60 21 c0 99 88 b1 ff ff ff ff ff ff f0 1e 00 00 01 04 02 04 0b 16 32=
 08 0c 12 18 24 30 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 01 dd 09 00 10 18 02 00 00 0=
0 00 00 dd 1e 00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D60:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D116): 40 00 00 00 ff ff ff ff f=
f ff 60 21 c0 99 88 b1 ff ff ff ff ff ff 00 1f 00 00 01 04 02 04 0b 16 32=
 08 0c 12 18 24 30 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 02 dd 09 00 10 18 02 00 00 0=
0 00 00 dd 1e 00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D60:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D116): 40 00 00 00 ff ff ff ff f=
f ff 60 21 c0 99 88 b1 ff ff ff ff ff ff 10 1f 00 00 01 04 02 04 0b 16 32=
 08 0c 12 18 24 30 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 02 dd 09 00 10 18 02 00 00 0=
0 00 00 dd 1e 00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D60:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D116): 40 00 00 00 ff ff ff ff f=
f ff 60 21 c0 99 88 b1 ff ff ff ff ff ff 60 1f 00 00 01 04 02 04 0b 16 32=
 08 0c 12 18 24 30 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 05 dd 09 00 10 18 02 00 00 0=
0 00 00 dd 1e 00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D2c:d0:5a:06:a5:92
nl80211: MLME event frame - hexdump(len=3D73): 40 00 00 00 ff ff ff ff ff=
 ff 2c d0 5a 06 a5 92 ff ff ff ff ff ff c0 ae 00 00 01 08 02 04 0b 16 0c =
12 18 24 32 04 30 48 60 6c 03 01 01 2d 1a 6e 11 1b ff 00 00 00 00 00 00 0=
0 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D2c:d0:5a:06:a5:92
nl80211: MLME event frame - hexdump(len=3D73): 40 00 00 00 ff ff ff ff ff=
 ff 2c d0 5a 06 a5 92 ff ff ff ff ff ff d0 ae 00 00 01 08 02 04 0b 16 0c =
12 18 24 32 04 30 48 60 6c 03 01 02 2d 1a 6e 11 1b ff 00 00 00 00 00 00 0=
0 00 00 00 00 01 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D62:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D306): 40 00 00 00 ff ff ff ff f=
f ff 62 21 c0 99 88 b1 ff ff ff ff ff ff 60 20 00 07 44 49 52 45 43 54 2d=
 01 08 8c 12 98 24 b0 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 01 dd 99 00 50 f2 04 10 4=
a 00 01 10 10 3a 00 01 01 10 08 00 02 21 08 10 47 00 10 34 e6 cb 58 77 e0=
 5f db 94 f5 e0 e3 4d 80 d0 f9 10 54 00 08 00 0a 00 50 f2 04 00 05 10 3c =
00 01 03 10 02 00 02 00 00 10 09 00 02 00 00 10 12 00 02 00 00 10 21 00 1=
3 53 41 4d 53 55 4e 47 5f 45 4c 45 43 54 52 4f 4e 49 43 53 10 23 00 0e 53=
 41 4d 53 55 4e 47 5f 4d 4f 42 49 4c 45 10 24 00 04 32 30 31 32 10 11 00 =
0c 41 6e 64 72 6f 69 64 5f 61 37 63 61 10 49 00 09 00 37 2a 00 01 20 03 0=
1 01 dd 11 50 6f 9a 09 02 02 00 27 00 06 05 00 58 58 04 51 01 dd 0d 50 6f=
 9a 0a 00 00 06 01 10 c0 00 00 28 dd 09 00 10 18 02 00 00 00 00 00 dd 1e =
00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x2108
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country XX(0x04) Regulatory Class 81 Channel Numbe=
r 1
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x2108
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country XX(0x04) Regulatory Class 81 Channel Numbe=
r 1
P2P: Reply to P2P Probe Request in Listen state
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: CMD_FRAME freq=3D2412 wait=3D0 no_cck=3D1 no_ack=3D1 offchanok=3D=
1
nl80211: Frame TX command accepted (no ACK); cookie 0x0
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3D00:0b:6b:7f:92:56=
 A2=3D62:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D119): d0 00 3c 00 00 0b 6b 7f 9=
2 56 62 21 c0 99 88 b1 00 0b 6b 7f 92 56 70 20 04 09 50 6f 9a 09 07 01 dd=
 2d 50 6f 9a 09 02 02 00 27 00 0d 21 00 62 21 c0 99 88 b1 01 88 00 0a 00 =
50 f2 04 00 05 00 10 11 00 0c 41 6e 64 72 6f 69 64 5f 61 37 63 61 dd 0a 0=
0 50 f2 04 10 08 00 02 00 08 dd 0b 00 00 f0 0a 00 00 04 0a 31 a8 c0 dd 0d=
 50 6f 9a 0a 00 00 06 01 10 c0 00 00 28
nl80211: Frame event
wlan5: Event RX_ACTION (21) received
wlan5: Received Action frame: SA=3D62:21:c0:99:88:b1 Category=3D4 DataLen=
=3D94 freq=3D2412 MHz
P2P: RX P2P Public Action from 62:21:c0:99:88:b1
P2P: P2P Public Action contents - hexdump(len=3D89): 07 01 dd 2d 50 6f 9a=
 09 02 02 00 27 00 0d 21 00 62 21 c0 99 88 b1 01 88 00 0a 00 50 f2 04 00 =
05 00 10 11 00 0c 41 6e 64 72 6f 69 64 5f 61 37 63 61 dd 0a 00 50 f2 04 1=
0 08 00 02 00 08 dd 0b 00 00 f0 0a 00 00 04 0a 31 a8 c0 dd 0d 50 6f 9a 0a=
 00 00 06 01 10 c0 00 00 28
P2P: Parsing the received message
P2P: * Dialog Token: 1
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x8
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 00
P2P: Attribute 13 length 33
P2P: * Device Info: addr 62:21:c0:99:88:b1 primary device type 10-0050F20=
4-5 device name 'Android_a7ca' config methods 0x188
P2P: Received Provision Discovery Request from 62:21:c0:99:88:b1 with con=
fig methods 0x8 (freq=3D2412)
P2P: Provision Discovery Request from unknown peer 62:21:c0:99:88:b1
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x8
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 00
P2P: Attribute 13 length 33
P2P: * Device Info: addr 62:21:c0:99:88:b1 primary device type 10-0050F20=
4-5 device name 'Android_a7ca' config methods 0x188
P2P: Update peer 62:21:c0:99:88:b1 config_methods 0x0 -> 0x188
P2P: Peer found with Listen frequency 2412 MHz (rx_time=3D1372920467.9849=
41)
P2P-DEVICE-FOUND 62:21:c0:99:88:b1 p2p_dev_addr=3D62:21:c0:99:88:b1 pri_d=
ev_type=3D10-0050F204-5 name=3D'Android_a7ca' config_methods=3D0x188 dev_=
capab=3D0x25 group_capab=3D0x0
CTRL_IFACE monitor send - hexdump(len=3D46): 2f 74 6d 70 2f 73 61 6d 70 6=
c 65 5f 77 69 64 69 5f 77 70 61 5f 73 75 70 70 6c 69 63 61 6e 74 2e 54 6b=
 4d 4e 5a 54 2f 73 6f 63 6b 65 74 00
P2P: Peer 62:21:c0:99:88:b1 requested us to show a PIN on display
P2P: * Dialog Token: 1
P2P: Sending Provision Discovery Response
Off-channel: Send action frame: freq=3D2412 dst=3D62:21:c0:99:88:b1 src=3D=
00:0b:6b:7f:92:56 bssid=3D00:0b:6b:7f:92:56 len=3D35
nl80211: Send Action frame (ifindex=3D4, freq=3D2412 MHz wait=3D200 ms no=
_cck=3D1)
nl80211: CMD_FRAME freq=3D2412 wait=3D200 no_cck=3D1 no_ack=3D0 offchanok=
=3D1
nl80211: Frame TX command accepted; cookie 0xffff8804077e0800
Get randomness: len=3D4 entropy=3D0
P2P-PROV-DISC-SHOW-PIN 62:21:c0:99:88:b1 13073176 p2p_dev_addr=3D62:21:c0=
:99:88:b1 pri_dev_type=3D10-0050F204-5 name=3D'Android_a7ca' config_metho=
ds=3D0x188 dev_capab=3D0x27 group_capab=3D0x0
CTRL_IFACE monitor send - hexdump(len=3D46): 2f 74 6d 70 2f 73 61 6d 70 6=
c 65 5f 77 69 64 69 5f 77 70 61 5f 73 75 70 70 6c 69 63 61 6e 74 2e 54 6b=
 4d 4e 5a 54 2f 73 6f 63 6b 65 74 00
nl80211: Event message available
nl80211: MLME event 60 on wlan5(00:0b:6b:7f:92:56) A1=3D62:21:c0:99:88:b1=
 A2=3D00:0b:6b:7f:92:56
nl80211: MLME event frame - hexdump(len=3D59): d0 00 ac 00 62 21 c0 99 88=
 b1 00 0b 6b 7f 92 56 00 0b 6b 7f 92 56 e0 1b 04 09 50 6f 9a 09 08 01 dd =
0a 00 50 f2 04 10 08 00 02 00 08 dd 0d 50 6f 9a 0a 00 00 06 00 11 00 00 0=
0 00
nl80211: Frame TX status event
nl80211: Action TX status: cookie=3D0ffff8804077e0800 (match) (ack=3D1)
wlan5: Event TX_STATUS (18) received
wlan5: EVENT_TX_STATUS dst=3D62:21:c0:99:88:b1 type=3D0 stype=3D13
Off-channel: TX status result=3D0 cb=3D0x423fe0
P2P: Action frame TX callback (state=3D0 freq=3D2412 dst=3D62:21:c0:99:88=
:b1 src=3D00:0b:6b:7f:92:56 bssid=3D00:0b:6b:7f:92:56 result=3D0
RX ctrl_iface - hexdump_ascii(len=3D46):
     50 32 50 5f 43 4f 4e 4e 45 43 54 20 36 32 3a 32   P2P_CONNECT 62:2
     31 3a 63 30 3a 39 39 3a 38 38 3a 62 31 20 31 33   1:c0:99:88:b1 13
     30 37 33 31 37 36 20 64 69 73 70 6c 61 79         073176 display =20
wlan5: Control interface command 'P2P_CONNECT 62:21:c0:99:88:b1 13073176 =
display'
nl80211: Get shared freq for PHY phy0
nl80211: No shared interface for PHY (phy0) in associated state
P2P: Own frequency preference: 0 MHz
P2P: Create a new interface p2p-wlan5-0 for the group
nl80211: Create interface iftype 8 (P2P_CLIENT)
nl80211: New interface p2p-wlan5-0 created: ifindex=3D6
nl80211: Set TX rates failed: ret=3D-100 (Network is down)
nl80211: Allocate new address for P2P group interface
nl80211: Assigned new P2P Interface Address 02:0b:6b:7f:92:56
P2P: Created pending virtual interface p2p-wlan5-0 addr 02:0b:6b:7f:92:56=

P2P: Request to start group negotiation - peer=3D62:21:c0:99:88:b1  GO In=
tent=3D0  Intended Interface Address=3D02:0b:6b:7f:92:56 wps_method=3D1 p=
ersistent_group=3D0 pd_before_go_neg=3D0
P2P: Own preference for operation channel: Operating Class 115 Channel 36=

P2P: Stopping find
P2P: Clear timeout (state=3DLISTEN_ONLY)
P2P: State LISTEN_ONLY -> IDLE
P2P: Clear timeout (state=3DIDLE)
P2P: Clear drv_in_listen (2412)
nl80211: Cancel remain-on-channel with cookie 0xffff8804042eb280
nl80211: Disable Probe Request reporting nl_preq=3D0x1fa68c0
P2P: * Dialog Token: 1
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D08
P2P: * GO Intent: Intent 0 Tie breaker 1
P2P: * Configuration Timeout: GO 100 (*10ms)  client 20 (*10ms)
P2P: * Listen Channel: Regulatory Class 81 Channel 1
P2P: * Intended P2P Interface Address 02:0b:6b:7f:92:56
P2P: * Channel List - hexdump(len=3D17): 55 53 04 51 0c 01 02 03 04 05 06=
 07 08 09 0a 0b 0d
P2P: * Device Info
P2P: * Operating Channel: Regulatory Class 115 Channel 36
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 5
WPS:  * Version2 (0x20)
P2P: Sending GO Negotiation Request
P2P: State IDLE -> CONNECT
Off-channel: Send action frame: freq=3D2412 dst=3D62:21:c0:99:88:b1 src=3D=
00:0b:6b:7f:92:56 bssid=3D62:21:c0:99:88:b1 len=3D147
nl80211: Send Action frame (ifindex=3D4, freq=3D2412 MHz wait=3D500 ms no=
_cck=3D1)
nl80211: CMD_FRAME freq=3D2412 wait=3D500 no_cck=3D1 no_ack=3D0 offchanok=
=3D1
nl80211: Frame TX command accepted; cookie 0xffff8803d954ad00
nl80211: Ignore event for foreign ifindex 6
nl80211: Ignore event for foreign ifindex 6
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2412 channel_type=3D0=
 duration=3D0 cookie=3D0xffff8804042eb280 (match))
wlan5: Event CANCEL_REMAIN_ON_CHANNEL (23) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms pending_ac=
tion_tx=3D0x1fa8bb0)
P2P: Driver ended Listen state (freq=3D2412)
nl80211: Event message available
nl80211: MLME event 60 on wlan5(00:0b:6b:7f:92:56) A1=3D62:21:c0:99:88:b1=
 A2=3D00:0b:6b:7f:92:56
nl80211: MLME event frame - hexdump(len=3D171): d0 00 ac 00 62 21 c0 99 8=
8 b1 00 0b 6b 7f 92 56 62 21 c0 99 88 b1 f0 1b 04 09 50 6f 9a 09 00 01 dd=
 5f 50 6f 9a 09 02 02 00 25 08 04 01 00 01 05 02 00 64 14 06 05 00 55 53 =
04 51 01 09 06 00 02 0b 6b 7f 92 56 0b 11 00 55 53 04 51 0c 01 02 03 04 0=
5 06 07 08 09 0a 0b 0d 0d 1d 00 00 0b 6b 7f 92 56 01 08 00 01 00 50 f2 04=
 00 01 00 10 11 00 08 6b 65 76 69 6e 2d 70 63 11 05 00 55 53 04 73 24 dd =
19 00 50 f2 04 10 4a 00 01 10 10 12 00 02 00 05 10 49 00 06 00 37 2a 00 0=
1 20 dd 0d 50 6f 9a 0a 00 00 06 00 11 00 00 00 00
nl80211: Frame TX status event
nl80211: Action TX status: cookie=3D0ffff8803d954ad00 (match) (ack=3D1)
wlan5: Event TX_STATUS (18) received
wlan5: EVENT_TX_STATUS dst=3D62:21:c0:99:88:b1 type=3D0 stype=3D13
Off-channel: TX status result=3D0 cb=3D0x423fe0
P2P: Action frame TX callback (state=3D1 freq=3D2412 dst=3D62:21:c0:99:88=
:b1 src=3D00:0b:6b:7f:92:56 bssid=3D62:21:c0:99:88:b1 result=3D0
P2P: GO Negotiation Request TX callback: success=3D1
P2P: State CONNECT -> CONNECT
P2P: Set timeout (state=3DCONNECT): 0.500000 sec
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3D00:0b:6b:7f:92:56=
 A2=3D62:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D178): d0 00 3c 00 00 0b 6b 7f 9=
2 56 62 21 c0 99 88 b1 62 21 c0 99 88 b1 80 20 04 09 50 6f 9a 09 01 01 dd=
 66 50 6f 9a 09 00 01 00 01 02 02 00 27 00 04 01 00 0e 05 02 00 64 14 11 =
05 00 58 58 04 73 30 09 06 00 62 21 c0 99 08 b1 0b 18 00 58 58 04 51 0d 0=
1 02 03 04 05 06 07 08 09 0a 0b 0c 0d 73 04 24 28 2c 30 0d 21 00 62 21 c0=
 99 88 b1 01 88 00 0a 00 50 f2 04 00 05 00 10 11 00 0c 41 6e 64 72 6f 69 =
64 5f 61 37 63 61 dd 19 00 50 f2 04 10 4a 00 01 10 10 12 00 02 00 00 10 4=
9 00 06 00 37 2a 00 01 20 dd 0d 50 6f 9a 0a 00 00 06 01 10 c0 00 00 28
nl80211: Frame event
wlan5: Event RX_ACTION (21) received
wlan5: Received Action frame: SA=3D62:21:c0:99:88:b1 Category=3D4 DataLen=
=3D153 freq=3D2412 MHz
P2P: RX P2P Public Action from 62:21:c0:99:88:b1
P2P: P2P Public Action contents - hexdump(len=3D148): 01 01 dd 66 50 6f 9=
a 09 00 01 00 01 02 02 00 27 00 04 01 00 0e 05 02 00 64 14 11 05 00 58 58=
 04 73 30 09 06 00 62 21 c0 99 08 b1 0b 18 00 58 58 04 51 0d 01 02 03 04 =
05 06 07 08 09 0a 0b 0c 0d 73 04 24 28 2c 30 0d 21 00 62 21 c0 99 88 b1 0=
1 88 00 0a 00 50 f2 04 00 05 00 10 11 00 0c 41 6e 64 72 6f 69 64 5f 61 37=
 63 61 dd 19 00 50 f2 04 10 4a 00 01 10 10 12 00 02 00 00 10 49 00 06 00 =
37 2a 00 01 20 dd 0d 50 6f 9a 0a 00 00 06 01 10 c0 00 00 28
P2P: Received GO Negotiation Response from 62:21:c0:99:88:b1 (freq=3D2412=
)
P2P: Parsing the received message
P2P: * Dialog Token: 1
P2P: Parsing WPS IE
P2P: Device Password ID: 0
P2P: Parsing P2P IE
P2P: Attribute 0 length 1
P2P: * Status: 1
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 00
P2P: Attribute 4 length 1
P2P: * GO Intent: Intent 7 Tie breaker 0
P2P: Attribute 5 length 2
P2P: * Configuration Timeout
P2P: Attribute 17 length 5
P2P: * Operating Channel: Country XX(0x04) Regulatory Class 115 Channel N=
umber 48
P2P: Attribute 9 length 6
P2P: * Intended P2P Interface Address: 62:21:c0:99:08:b1
P2P: Attribute 11 length 24
P2P: * Channel List: Country String 'XX(0x04)'
P2P: Channel List - hexdump(len=3D24): 58 58 04 51 0d 01 02 03 04 05 06 0=
7 08 09 0a 0b 0c 0d 73 04 24 28 2c 30
P2P: Attribute 13 length 33
P2P: * Device Info: addr 62:21:c0:99:88:b1 primary device type 10-0050F20=
4-5 device name 'Android_a7ca' config methods 0x188
P2P: GO Negotiation rejected: status 1
P2P: Wait for the peer to become ready for GO Negotiation
P2P: State CONNECT -> WAIT_PEER_IDLE
P2P: Set timeout (state=3DWAIT_PEER_IDLE): 0.000000 sec
Off-channel: Action frame sequence done notification
nl80211: Cancel TX frame wait: cookie=3D0xffff8803d954ad00
P2P: Timeout (state=3DWAIT_PEER_IDLE)
P2P: Go to Listen state while waiting for the peer to become ready for GO=
 Negotiation
P2P: State WAIT_PEER_IDLE -> WAIT_PEER_CONNECT
P2P: Starting short listen state (state=3DWAIT_PEER_CONNECT)
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 5
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: Enable Probe Request reporting nl_preq=3D0x1fa68c0
nl80211: Register frame type=3D0x40 nl_handle=3D0x1fa68c0
nl80211: Register frame match - hexdump(len=3D0): [NULL]
nl80211: Remain-on-channel cookie 0xffff880405e77f80 for freq=3D2412 MHz =
duration=3D307
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2412 channel_type=3D0=
 duration=3D307 cookie=3D0xffff880405e77f80 (match))
wlan5: Event REMAIN_ON_CHANNEL (22) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(n=
il))
P2P: Starting Listen timeout(0,307200) on freq=3D2412 based on callback
P2P: Set timeout (state=3DWAIT_PEER_CONNECT): 0.327200 sec
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2412 channel_type=3D0=
 duration=3D0 cookie=3D0xffff880405e77f80 (match))
wlan5: Event CANCEL_REMAIN_ON_CHANNEL (23) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms pending_ac=
tion_tx=3D(nil))
P2P: Driver ended Listen state (freq=3D2412)
P2P: Timeout (state=3DWAIT_PEER_CONNECT)
P2P: State WAIT_PEER_CONNECT -> WAIT_PEER_IDLE
P2P: Set timeout (state=3DWAIT_PEER_IDLE): 0.500000 sec
P2P: Timeout (state=3DWAIT_PEER_IDLE)
P2P: Go to Listen state while waiting for the peer to become ready for GO=
 Negotiation
P2P: State WAIT_PEER_IDLE -> WAIT_PEER_CONNECT
P2P: Starting short listen state (state=3DWAIT_PEER_CONNECT)
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 5
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: Probe Request reporting already on! nl_preq=3D0x1fa68c0
nl80211: Remain-on-channel cookie 0xffff880405e77e80 for freq=3D2412 MHz =
duration=3D307
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2412 channel_type=3D0=
 duration=3D307 cookie=3D0xffff880405e77e80 (match))
wlan5: Event REMAIN_ON_CHANNEL (22) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(n=
il))
P2P: Starting Listen timeout(0,307200) on freq=3D2412 based on callback
P2P: Set timeout (state=3DWAIT_PEER_CONNECT): 0.327200 sec
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2412 channel_type=3D0=
 duration=3D0 cookie=3D0xffff880405e77e80 (match))
wlan5: Event CANCEL_REMAIN_ON_CHANNEL (23) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms pending_ac=
tion_tx=3D(nil))
P2P: Driver ended Listen state (freq=3D2412)
P2P: Timeout (state=3DWAIT_PEER_CONNECT)
P2P: State WAIT_PEER_CONNECT -> WAIT_PEER_IDLE
P2P: Set timeout (state=3DWAIT_PEER_IDLE): 0.500000 sec
P2P: Timeout (state=3DWAIT_PEER_IDLE)
P2P: Go to Listen state while waiting for the peer to become ready for GO=
 Negotiation
P2P: State WAIT_PEER_IDLE -> WAIT_PEER_CONNECT
P2P: Starting short listen state (state=3DWAIT_PEER_CONNECT)
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 5
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: Probe Request reporting already on! nl_preq=3D0x1fa68c0
nl80211: Remain-on-channel cookie 0xffff88034c994780 for freq=3D2412 MHz =
duration=3D307
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2412 channel_type=3D0=
 duration=3D307 cookie=3D0xffff88034c994780 (match))
wlan5: Event REMAIN_ON_CHANNEL (22) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(n=
il))
P2P: Starting Listen timeout(0,307200) on freq=3D2412 based on callback
P2P: Set timeout (state=3DWAIT_PEER_CONNECT): 0.327200 sec
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2412 channel_type=3D0=
 duration=3D0 cookie=3D0xffff88034c994780 (match))
wlan5: Event CANCEL_REMAIN_ON_CHANNEL (23) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms pending_ac=
tion_tx=3D(nil))
P2P: Driver ended Listen state (freq=3D2412)
P2P: Timeout (state=3DWAIT_PEER_CONNECT)
P2P: State WAIT_PEER_CONNECT -> WAIT_PEER_IDLE
P2P: Set timeout (state=3DWAIT_PEER_IDLE): 0.500000 sec
P2P: Timeout (state=3DWAIT_PEER_IDLE)
P2P: Go to Listen state while waiting for the peer to become ready for GO=
 Negotiation
P2P: State WAIT_PEER_IDLE -> WAIT_PEER_CONNECT
P2P: Starting short listen state (state=3DWAIT_PEER_CONNECT)
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 5
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: Probe Request reporting already on! nl_preq=3D0x1fa68c0
nl80211: Remain-on-channel cookie 0xffff88040831b500 for freq=3D2412 MHz =
duration=3D204
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2412 channel_type=3D0=
 duration=3D204 cookie=3D0xffff88040831b500 (match))
wlan5: Event REMAIN_ON_CHANNEL (22) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(n=
il))
P2P: Starting Listen timeout(0,204800) on freq=3D2412 based on callback
P2P: Set timeout (state=3DWAIT_PEER_CONNECT): 0.224800 sec
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2412 channel_type=3D0=
 duration=3D0 cookie=3D0xffff88040831b500 (match))
wlan5: Event CANCEL_REMAIN_ON_CHANNEL (23) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms pending_ac=
tion_tx=3D(nil))
P2P: Driver ended Listen state (freq=3D2412)
P2P: Timeout (state=3DWAIT_PEER_CONNECT)
P2P: State WAIT_PEER_CONNECT -> WAIT_PEER_IDLE
P2P: Set timeout (state=3DWAIT_PEER_IDLE): 0.500000 sec
P2P: Timeout (state=3DWAIT_PEER_IDLE)
P2P: Go to Listen state while waiting for the peer to become ready for GO=
 Negotiation
P2P: State WAIT_PEER_IDLE -> WAIT_PEER_CONNECT
P2P: Starting short listen state (state=3DWAIT_PEER_CONNECT)
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 5
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: Probe Request reporting already on! nl_preq=3D0x1fa68c0
nl80211: Remain-on-channel cookie 0xffff88034c8f2f00 for freq=3D2412 MHz =
duration=3D204
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2412 channel_type=3D0=
 duration=3D204 cookie=3D0xffff88034c8f2f00 (match))
wlan5: Event REMAIN_ON_CHANNEL (22) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(n=
il))
P2P: Starting Listen timeout(0,204800) on freq=3D2412 based on callback
P2P: Set timeout (state=3DWAIT_PEER_CONNECT): 0.224800 sec
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2412 channel_type=3D0=
 duration=3D0 cookie=3D0xffff88034c8f2f00 (match))
wlan5: Event CANCEL_REMAIN_ON_CHANNEL (23) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms pending_ac=
tion_tx=3D(nil))
P2P: Driver ended Listen state (freq=3D2412)
P2P: Timeout (state=3DWAIT_PEER_CONNECT)
P2P: State WAIT_PEER_CONNECT -> WAIT_PEER_IDLE
P2P: Set timeout (state=3DWAIT_PEER_IDLE): 0.500000 sec
P2P: Timeout (state=3DWAIT_PEER_IDLE)
P2P: Go to Listen state while waiting for the peer to become ready for GO=
 Negotiation
P2P: State WAIT_PEER_IDLE -> WAIT_PEER_CONNECT
P2P: Starting short listen state (state=3DWAIT_PEER_CONNECT)
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 5
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: Probe Request reporting already on! nl_preq=3D0x1fa68c0
nl80211: Remain-on-channel cookie 0xffff88034c994c00 for freq=3D2412 MHz =
duration=3D307
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2412 channel_type=3D0=
 duration=3D307 cookie=3D0xffff88034c994c00 (match))
wlan5: Event REMAIN_ON_CHANNEL (22) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(n=
il))
P2P: Starting Listen timeout(0,307200) on freq=3D2412 based on callback
P2P: Set timeout (state=3DWAIT_PEER_CONNECT): 0.327200 sec
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2412 channel_type=3D0=
 duration=3D0 cookie=3D0xffff88034c994c00 (match))
wlan5: Event CANCEL_REMAIN_ON_CHANNEL (23) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms pending_ac=
tion_tx=3D(nil))
P2P: Driver ended Listen state (freq=3D2412)
P2P: Timeout (state=3DWAIT_PEER_CONNECT)
P2P: State WAIT_PEER_CONNECT -> WAIT_PEER_IDLE
P2P: Set timeout (state=3DWAIT_PEER_IDLE): 0.500000 sec
P2P: Timeout (state=3DWAIT_PEER_IDLE)
P2P: Go to Listen state while waiting for the peer to become ready for GO=
 Negotiation
P2P: State WAIT_PEER_IDLE -> WAIT_PEER_CONNECT
P2P: Starting short listen state (state=3DWAIT_PEER_CONNECT)
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 5
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: Probe Request reporting already on! nl_preq=3D0x1fa68c0
nl80211: Remain-on-channel cookie 0xffff88034c8f2a80 for freq=3D2412 MHz =
duration=3D204
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2412 channel_type=3D0=
 duration=3D204 cookie=3D0xffff88034c8f2a80 (match))
wlan5: Event REMAIN_ON_CHANNEL (22) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(n=
il))
P2P: Starting Listen timeout(0,204800) on freq=3D2412 based on callback
P2P: Set timeout (state=3DWAIT_PEER_CONNECT): 0.224800 sec
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2412 channel_type=3D0=
 duration=3D0 cookie=3D0xffff88034c8f2a80 (match))
wlan5: Event CANCEL_REMAIN_ON_CHANNEL (23) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms pending_ac=
tion_tx=3D(nil))
P2P: Driver ended Listen state (freq=3D2412)
P2P: Timeout (state=3DWAIT_PEER_CONNECT)
P2P: State WAIT_PEER_CONNECT -> WAIT_PEER_IDLE
P2P: Set timeout (state=3DWAIT_PEER_IDLE): 0.500000 sec
P2P: Timeout (state=3DWAIT_PEER_IDLE)
P2P: Go to Listen state while waiting for the peer to become ready for GO=
 Negotiation
P2P: State WAIT_PEER_IDLE -> WAIT_PEER_CONNECT
P2P: Starting short listen state (state=3DWAIT_PEER_CONNECT)
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 5
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: Probe Request reporting already on! nl_preq=3D0x1fa68c0
nl80211: Remain-on-channel cookie 0xffff88034c994c00 for freq=3D2412 MHz =
duration=3D102
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2412 channel_type=3D0=
 duration=3D102 cookie=3D0xffff88034c994c00 (match))
wlan5: Event REMAIN_ON_CHANNEL (22) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(n=
il))
P2P: Starting Listen timeout(0,102400) on freq=3D2412 based on callback
P2P: Set timeout (state=3DWAIT_PEER_CONNECT): 0.122400 sec
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2412 channel_type=3D0=
 duration=3D0 cookie=3D0xffff88034c994c00 (match))
wlan5: Event CANCEL_REMAIN_ON_CHANNEL (23) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms pending_ac=
tion_tx=3D(nil))
P2P: Driver ended Listen state (freq=3D2412)
P2P: Timeout (state=3DWAIT_PEER_CONNECT)
P2P: State WAIT_PEER_CONNECT -> WAIT_PEER_IDLE
P2P: Set timeout (state=3DWAIT_PEER_IDLE): 0.500000 sec
P2P: Timeout (state=3DWAIT_PEER_IDLE)
P2P: Go to Listen state while waiting for the peer to become ready for GO=
 Negotiation
P2P: State WAIT_PEER_IDLE -> WAIT_PEER_CONNECT
P2P: Starting short listen state (state=3DWAIT_PEER_CONNECT)
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 5
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: Probe Request reporting already on! nl_preq=3D0x1fa68c0
nl80211: Remain-on-channel cookie 0xffff88034c8f2900 for freq=3D2412 MHz =
duration=3D204
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2412 channel_type=3D0=
 duration=3D204 cookie=3D0xffff88034c8f2900 (match))
wlan5: Event REMAIN_ON_CHANNEL (22) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(n=
il))
P2P: Starting Listen timeout(0,204800) on freq=3D2412 based on callback
P2P: Set timeout (state=3DWAIT_PEER_CONNECT): 0.224800 sec
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2412 channel_type=3D0=
 duration=3D0 cookie=3D0xffff88034c8f2900 (match))
wlan5: Event CANCEL_REMAIN_ON_CHANNEL (23) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms pending_ac=
tion_tx=3D(nil))
P2P: Driver ended Listen state (freq=3D2412)
P2P: Timeout (state=3DWAIT_PEER_CONNECT)
P2P: State WAIT_PEER_CONNECT -> WAIT_PEER_IDLE
P2P: Set timeout (state=3DWAIT_PEER_IDLE): 0.500000 sec
P2P: Timeout (state=3DWAIT_PEER_IDLE)
P2P: Go to Listen state while waiting for the peer to become ready for GO=
 Negotiation
P2P: State WAIT_PEER_IDLE -> WAIT_PEER_CONNECT
P2P: Starting short listen state (state=3DWAIT_PEER_CONNECT)
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 5
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: Probe Request reporting already on! nl_preq=3D0x1fa68c0
nl80211: Remain-on-channel cookie 0xffff88034c994d80 for freq=3D2412 MHz =
duration=3D307
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2412 channel_type=3D0=
 duration=3D307 cookie=3D0xffff88034c994d80 (match))
wlan5: Event REMAIN_ON_CHANNEL (22) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(n=
il))
P2P: Starting Listen timeout(0,307200) on freq=3D2412 based on callback
P2P: Set timeout (state=3DWAIT_PEER_CONNECT): 0.327200 sec
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2412 channel_type=3D0=
 duration=3D0 cookie=3D0xffff88034c994d80 (match))
wlan5: Event CANCEL_REMAIN_ON_CHANNEL (23) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms pending_ac=
tion_tx=3D(nil))
P2P: Driver ended Listen state (freq=3D2412)
P2P: Timeout (state=3DWAIT_PEER_CONNECT)
P2P: State WAIT_PEER_CONNECT -> WAIT_PEER_IDLE
P2P: Set timeout (state=3DWAIT_PEER_IDLE): 0.500000 sec
P2P: Timeout (state=3DWAIT_PEER_IDLE)
P2P: Go to Listen state while waiting for the peer to become ready for GO=
 Negotiation
P2P: State WAIT_PEER_IDLE -> WAIT_PEER_CONNECT
P2P: Starting short listen state (state=3DWAIT_PEER_CONNECT)
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 5
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: Probe Request reporting already on! nl_preq=3D0x1fa68c0
nl80211: Remain-on-channel cookie 0xffff88034c994400 for freq=3D2412 MHz =
duration=3D102
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2412 channel_type=3D0=
 duration=3D102 cookie=3D0xffff88034c994400 (match))
wlan5: Event REMAIN_ON_CHANNEL (22) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(n=
il))
P2P: Starting Listen timeout(0,102400) on freq=3D2412 based on callback
P2P: Set timeout (state=3DWAIT_PEER_CONNECT): 0.122400 sec
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D62:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D306): 40 00 00 00 ff ff ff ff f=
f ff 62 21 c0 99 88 b1 ff ff ff ff ff ff 40 00 00 07 44 49 52 45 43 54 2d=
 01 08 8c 12 98 24 b0 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 01 dd 99 00 50 f2 04 10 4=
a 00 01 10 10 3a 00 01 01 10 08 00 02 21 08 10 47 00 10 34 e6 cb 58 77 e0=
 5f db 94 f5 e0 e3 4d 80 d0 f9 10 54 00 08 00 0a 00 50 f2 04 00 05 10 3c =
00 01 03 10 02 00 02 00 00 10 09 00 02 00 00 10 12 00 02 00 00 10 21 00 1=
3 53 41 4d 53 55 4e 47 5f 45 4c 45 43 54 52 4f 4e 49 43 53 10 23 00 0e 53=
 41 4d 53 55 4e 47 5f 4d 4f 42 49 4c 45 10 24 00 04 32 30 31 32 10 11 00 =
0c 41 6e 64 72 6f 69 64 5f 61 37 63 61 10 49 00 09 00 37 2a 00 01 20 03 0=
1 01 dd 11 50 6f 9a 09 02 02 00 27 00 06 05 00 58 58 04 51 01 dd 0d 50 6f=
 9a 0a 00 00 06 01 10 c0 00 00 28 dd 09 00 10 18 02 00 00 00 00 00 dd 1e =
00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x2108
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country XX(0x04) Regulatory Class 81 Channel Numbe=
r 1
P2P: Parsing WPS IE
P2P: Config Methods (WPS): 0x2108
P2P: Device Password ID: 0
P2P: Primary Device Type (WPS): 10-0050F204-5
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 00
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country XX(0x04) Regulatory Class 81 Channel Numbe=
r 1
P2P: Reply to P2P Probe Request in Listen state
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 5
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: CMD_FRAME freq=3D2412 wait=3D0 no_cck=3D1 no_ack=3D1 offchanok=3D=
1
nl80211: Frame TX command accepted (no ACK); cookie 0x0
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3D00:0b:6b:7f:92:56=
 A2=3D62:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D182): d0 00 3c 00 00 0b 6b 7f 9=
2 56 62 21 c0 99 88 b1 00 0b 6b 7f 92 56 50 00 04 09 50 6f 9a 09 00 02 dd=
 6a 50 6f 9a 09 02 02 00 27 08 04 01 00 0f 05 02 00 64 14 06 05 00 58 58 =
04 51 01 09 06 00 62 21 c0 99 08 b1 0b 18 00 58 58 04 51 0d 01 02 03 04 0=
5 06 07 08 09 0a 0b 0c 0d 73 04 24 28 2c 30 0d 21 00 62 21 c0 99 88 b1 01=
 08 00 0a 00 50 f2 04 00 05 00 10 11 00 0c 41 6e 64 72 6f 69 64 5f 61 37 =
63 61 11 05 00 58 58 04 73 30 dd 19 00 50 f2 04 10 4a 00 01 10 10 12 00 0=
2 00 01 10 49 00 06 00 37 2a 00 01 20 dd 0d 50 6f 9a 0a 00 00 06 01 10 c0=
 00 00 28
nl80211: Frame event
wlan5: Event RX_ACTION (21) received
wlan5: Received Action frame: SA=3D62:21:c0:99:88:b1 Category=3D4 DataLen=
=3D157 freq=3D2412 MHz
P2P: RX P2P Public Action from 62:21:c0:99:88:b1
P2P: P2P Public Action contents - hexdump(len=3D152): 00 02 dd 6a 50 6f 9=
a 09 02 02 00 27 08 04 01 00 0f 05 02 00 64 14 06 05 00 58 58 04 51 01 09=
 06 00 62 21 c0 99 08 b1 0b 18 00 58 58 04 51 0d 01 02 03 04 05 06 07 08 =
09 0a 0b 0c 0d 73 04 24 28 2c 30 0d 21 00 62 21 c0 99 88 b1 01 08 00 0a 0=
0 50 f2 04 00 05 00 10 11 00 0c 41 6e 64 72 6f 69 64 5f 61 37 63 61 11 05=
 00 58 58 04 73 30 dd 19 00 50 f2 04 10 4a 00 01 10 10 12 00 02 00 01 10 =
49 00 06 00 37 2a 00 01 20 dd 0d 50 6f 9a 0a 00 00 06 01 10 c0 00 00 28
P2P: Received GO Negotiation Request from 62:21:c0:99:88:b1(freq=3D2412)
P2P: Parsing the received message
P2P: * Dialog Token: 2
P2P: Parsing WPS IE
P2P: Device Password ID: 1
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 08
P2P: Attribute 4 length 1
P2P: * GO Intent: Intent 7 Tie breaker 1
P2P: Attribute 5 length 2
P2P: * Configuration Timeout
P2P: Attribute 6 length 5
P2P: * Listen Channel: Country XX(0x04) Regulatory Class 81 Channel Numbe=
r 1
P2P: Attribute 9 length 6
P2P: * Intended P2P Interface Address: 62:21:c0:99:08:b1
P2P: Attribute 11 length 24
P2P: * Channel List: Country String 'XX(0x04)'
P2P: Channel List - hexdump(len=3D24): 58 58 04 51 0d 01 02 03 04 05 06 0=
7 08 09 0a 0b 0c 0d 73 04 24 28 2c 30
P2P: Attribute 13 length 33
P2P: * Device Info: addr 62:21:c0:99:88:b1 primary device type 10-0050F20=
4-5 device name 'Android_a7ca' config methods 0x108
P2P: Attribute 17 length 5
P2P: * Operating Channel: Country XX(0x04) Regulatory Class 115 Channel N=
umber 48
P2P: Peer country - hexdump_ascii(len=3D3):
     58 58 04                                          XX_            =20
P2P: Own reg_classes 1 peer reg_classes 2 intersection reg_classes 1
P2P: Peer entered PIN on Keypad
P2P: Peer operating channel preference: 5240 MHz
P2P: GO Negotiation with 62:21:c0:99:88:b1
P2P: Stopping find
P2P: Clear timeout (state=3DWAIT_PEER_CONNECT)
P2P: State WAIT_PEER_CONNECT -> IDLE
P2P: Skip stop_listen since we are on correct channel for response
P2P: State IDLE -> GO_NEG
P2P: Clear timeout (state=3DGO_NEG)
P2P: Building GO Negotiation Response
P2P: * Dialog Token: 2
P2P: * P2P IE header
P2P: * Status: 0
P2P: * Capability dev=3D25 group=3D00
P2P: * GO Intent: Intent 0 Tie breaker 0
P2P: * Configuration Timeout: GO 100 (*10ms)  client 20 (*10ms)
P2P: Omit Operating Channel attribute
P2P: * Intended P2P Interface Address 02:0b:6b:7f:92:56
P2P: * Channel List - hexdump(len=3D17): 55 53 04 51 0c 01 02 03 04 05 06=
 07 08 09 0a 0b 0d
P2P: * Device Info
WPS:  * Version (hardcoded 0x10)
P2P: WPS IE Device Password ID: 5
WPS:  * Version2 (0x20)
P2P: Sending GO Negotiation Response
Off-channel: Send action frame: freq=3D2412 dst=3D62:21:c0:99:88:b1 src=3D=
00:0b:6b:7f:92:56 bssid=3D00:0b:6b:7f:92:56 len=3D135
nl80211: Send Action frame (ifindex=3D4, freq=3D2412 MHz wait=3D500 ms no=
_cck=3D1)
nl80211: CMD_FRAME freq=3D2412 wait=3D500 no_cck=3D1 no_ack=3D0 offchanok=
=3D1
nl80211: Frame TX command accepted; cookie 0xffff880399356e00
nl80211: Event message available
nl80211: MLME event 60 on wlan5(00:0b:6b:7f:92:56) A1=3D62:21:c0:99:88:b1=
 A2=3D00:0b:6b:7f:92:56
nl80211: MLME event frame - hexdump(len=3D159): d0 00 ac 00 62 21 c0 99 8=
8 b1 00 0b 6b 7f 92 56 00 0b 6b 7f 92 56 10 1c 04 09 50 6f 9a 09 01 02 dd=
 53 50 6f 9a 09 00 01 00 00 02 02 00 25 00 04 01 00 00 05 02 00 64 14 09 =
06 00 02 0b 6b 7f 92 56 0b 11 00 55 53 04 51 0c 01 02 03 04 05 06 07 08 0=
9 0a 0b 0d 0d 1d 00 00 0b 6b 7f 92 56 01 08 00 01 00 50 f2 04 00 01 00 10=
 11 00 08 6b 65 76 69 6e 2d 70 63 dd 19 00 50 f2 04 10 4a 00 01 10 10 12 =
00 02 00 05 10 49 00 06 00 37 2a 00 01 20 dd 0d 50 6f 9a 0a 00 00 06 00 1=
1 00 00 00 00
nl80211: Frame TX status event
nl80211: Action TX status: cookie=3D0ffff880399356e00 (match) (ack=3D1)
wlan5: Event TX_STATUS (18) received
wlan5: EVENT_TX_STATUS dst=3D62:21:c0:99:88:b1 type=3D0 stype=3D13
Off-channel: TX status result=3D0 cb=3D0x423fe0
P2P: Action frame TX callback (state=3D2 freq=3D2412 dst=3D62:21:c0:99:88=
:b1 src=3D00:0b:6b:7f:92:56 bssid=3D00:0b:6b:7f:92:56 result=3D0
P2P: GO Negotiation Response TX callback: success=3D1
P2P: State GO_NEG -> CONNECT
P2P: Set timeout (state=3DCONNECT): 0.500000 sec
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3D00:0b:6b:7f:92:56=
 A2=3D62:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D121): d0 00 3c 00 00 0b 6b 7f 9=
2 56 62 21 c0 99 88 b1 00 0b 6b 7f 92 56 60 00 04 09 50 6f 9a 09 02 02 dd=
 48 50 6f 9a 09 00 01 00 00 02 02 00 27 00 11 05 00 58 58 04 51 01 0b 11 =
00 58 58 04 51 0c 01 02 03 04 05 06 07 08 09 0a 0b 0d 0f 1c 00 62 21 c0 9=
9 88 b1 44 49 52 45 43 54 2d 66 43 2d 41 6e 64 72 6f 69 64 5f 61 37 63 61=
 dd 0d 50 6f 9a 0a 00 00 06 01 10 c0 00 00 28
nl80211: Frame event
wlan5: Event RX_ACTION (21) received
wlan5: Received Action frame: SA=3D62:21:c0:99:88:b1 Category=3D4 DataLen=
=3D96 freq=3D2412 MHz
P2P: RX P2P Public Action from 62:21:c0:99:88:b1
P2P: P2P Public Action contents - hexdump(len=3D91): 02 02 dd 48 50 6f 9a=
 09 00 01 00 00 02 02 00 27 00 11 05 00 58 58 04 51 01 0b 11 00 58 58 04 =
51 0c 01 02 03 04 05 06 07 08 09 0a 0b 0d 0f 1c 00 62 21 c0 99 88 b1 44 4=
9 52 45 43 54 2d 66 43 2d 41 6e 64 72 6f 69 64 5f 61 37 63 61 dd 0d 50 6f=
 9a 0a 00 00 06 01 10 c0 00 00 28
P2P: Received GO Negotiation Confirm from 62:21:c0:99:88:b1
P2P: Parsing the received message
P2P: * Dialog Token: 2
P2P: Parsing P2P IE
P2P: Attribute 0 length 1
P2P: * Status: 0
P2P: Attribute 2 length 2
P2P: * Device Capability 27 Group Capability 00
P2P: Attribute 17 length 5
P2P: * Operating Channel: Country XX(0x04) Regulatory Class 81 Channel Nu=
mber 1
P2P: Attribute 11 length 17
P2P: * Channel List: Country String 'XX(0x04)'
P2P: Channel List - hexdump(len=3D17): 58 58 04 51 0c 01 02 03 04 05 06 0=
7 08 09 0a 0b 0d
P2P: Attribute 15 length 28
P2P: * P2P Group ID: Device Address 62:21:c0:99:88:b1
P2P: * P2P Group ID: SSID - hexdump_ascii(len=3D22):
     44 49 52 45 43 54 2d 66 43 2d 41 6e 64 72 6f 69   DIRECT-fC-Androi
     64 5f 61 37 63 61                                 d_a7ca         =20
P2P: 20 ms wait on current channel before starting group
P2P: GO Negotiation with 62:21:c0:99:88:b1 completed (peer will be GO)
P2P: Clear timeout (state=3DCONNECT)
P2P: State CONNECT -> PROVISIONING
nl80211: Cancel remain-on-channel with cookie 0xffff88034c994400
P2P-GO-NEG-SUCCESS=20
CTRL_IFACE monitor send - hexdump(len=3D46): 2f 74 6d 70 2f 73 61 6d 70 6=
c 65 5f 77 69 64 69 5f 77 70 61 5f 73 75 70 70 6c 69 63 61 6e 74 2e 54 6b=
 4d 4e 5a 54 2f 73 6f 63 6b 65 74 00
Initializing interface 'p2p-wlan5-0' conf 'N/A' driver 'nl80211' ctrl_int=
erface '/var/run/wpa_supplicant' bridge 'N/A'
nl80211: interface p2p-wlan5-0 in phy phy0
rfkill: initial event: idx=3D0 type=3D1 op=3D0 soft=3D0 hard=3D0
rfkill: initial event: idx=3D1 type=3D2 op=3D0 soft=3D1 hard=3D0
netlink: Operstate: linkmode=3D1, operstate=3D5
nl80211: Using driver-based off-channel TX
nl80211: TDLS supported
nl80211: TDLS external setup
nl80211: Use separate P2P group interface (driver advertised support)
nl80211: driver param=3D'(null)'
nl80211: Regulatory information - country=3DUS
nl80211: 2402-2472 @ 40 MHz
nl80211: 5170-5250 @ 40 MHz
nl80211: 5250-5330 @ 40 MHz
nl80211: 5490-5600 @ 40 MHz
nl80211: 5650-5710 @ 40 MHz
nl80211: 5735-5835 @ 40 MHz
nl80211: Added 802.11b mode based on 802.11g information
p2p-wlan5-0: Own MAC address: 02:0b:6b:7f:92:56
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D0 addr=3D(nil) key_idx=3D0 =
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D0 addr=3D(nil) key_idx=3D1 =
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D0 addr=3D(nil) key_idx=3D2 =
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D0 addr=3D(nil) key_idx=3D3 =
set_tx=3D0 seq_len=3D0 key_len=3D0
p2p-wlan5-0: RSN: flushing PMKID list in the driver
nl80211: Flush PMKIDs
p2p-wlan5-0: State: DISCONNECTED -> INACTIVE
WPS: Set UUID for interface p2p-wlan5-0
WPS: UUID from the first interface - hexdump(len=3D16): 97 71 b0 a8 da ca=
 57 bf 99 80 01 b3 3f 50 26 de
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
EAPOL: KEY_RX entering state NO_KEY_RECEIVE
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
Using existing control interface directory.
p2p-wlan5-0: Added interface p2p-wlan5-0
p2p-wlan5-0: State: INACTIVE -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=3D-1, operstate=3D5
P2P: Start WPS Enrollee for peer 62:21:c0:99:08:b1
P2P: Start WPS Enrollee for SSID - hexdump_ascii(len=3D22):
     44 49 52 45 43 54 2d 66 43 2d 41 6e 64 72 6f 69   DIRECT-fC-Androi
     64 5f 61 37 63 61                                 d_a7ca         =20
key_mgmt: 0x200
eap methods - hexdump(len=3D16): 2a 37 00 00 01 00 00 00 00 00 00 00 00 0=
0 00 00
identity - hexdump_ascii(len=3D29):
     57 46 41 2d 53 69 6d 70 6c 65 43 6f 6e 66 69 67   WFA-SimpleConfig
     2d 45 6e 72 6f 6c 6c 65 65 2d 31 2d 30            -Enrollee-1-0  =20
WPS: Use specific AP SSID - hexdump_ascii(len=3D22):
     44 49 52 45 43 54 2d 66 43 2d 41 6e 64 72 6f 69   DIRECT-fC-Androi
     64 5f 61 37 63 61                                 d_a7ca         =20
phase1 - hexdump_ascii(len=3D24):
     70 69 6e 3d 31 33 30 37 33 31 37 36 20 64 65 76   pin=3D13073176 dev=

     5f 70 77 5f 69 64 3d 30                           _pw_id=3D0        =

p2p-wlan5-0: Setting scan request: 0 sec 0 usec
p2p-wlan5-0: State: DISCONNECTED -> SCANNING
P2P: Use specific SSID for scan during P2P group formation
p2p-wlan5-0: P2P: Scan only GO preferred frequency 5240 MHz
WPS: Building WPS IE for Probe Request
WPS:  * Version (hardcoded 0x10)
WPS:  * Request Type
WPS:  * Config Methods (2108)
WPS:  * UUID-E
WPS:  * Primary Device Type
WPS:  * RF Bands (3)
WPS:  * Association State
WPS:  * Configuration Error (0)
WPS:  * Device Password ID (0)
WPS:  * Manufacturer
WPS:  * Model Name
WPS:  * Model Number
WPS:  * Device Name
WPS:  * Version2 (0x20)
WPS:  * Request to Enroll (1)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Listen Channel: Regulatory Class 81 Channel 1
p2p-wlan5-0: nl80211: scan request
nl80211: Scan SSID - hexdump_ascii(len=3D22):
     44 49 52 45 43 54 2d 66 43 2d 41 6e 64 72 6f 69   DIRECT-fC-Androi
     64 5f 61 37 63 61                                 d_a7ca         =20
nl80211: Scan extra IEs - hexdump(len=3D144): dd 6c 00 50 f2 04 10 4a 00 =
01 10 10 3a 00 01 01 10 08 00 02 21 08 10 47 00 10 97 71 b0 a8 da ca 57 b=
f 99 80 01 b3 3f 50 26 de 10 54 00 08 00 00 00 00 00 00 00 00 10 3c 00 01=
 03 10 02 00 02 00 00 10 09 00 02 00 00 10 12 00 02 00 00 10 21 00 01 20 =
10 23 00 01 20 10 24 00 01 20 10 11 00 01 20 10 49 00 09 00 37 2a 00 01 2=
0 03 01 01 dd 0d 50 6f 9a 0a 00 00 06 00 11 00 00 00 00 dd 11 50 6f 9a 09=
 02 02 00 25 00 06 05 00 55 53 04 51 01
nl80211: Scan frequency 5240 MHz
nl80211: P2P probe - mask SuppRates
Scan requested (ret=3D0) - scan timeout 10 seconds
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1043 ([UP][RUNNING])
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan5-0' added
nl80211: if_removed already cleared - ignore event
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan5-0' added
nl80211: if_removed already cleared - ignore event
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan5-0' added
nl80211: if_removed already cleared - ignore event
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2412 channel_type=3D0=
 duration=3D0 cookie=3D0xffff88034c994400 (match))
wlan5: Event CANCEL_REMAIN_ON_CHANNEL (23) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D0 ms pending_ac=
tion_tx=3D(nil))
P2P: Driver ended Listen state (freq=3D2412)
nl80211: Event message available
p2p-wlan5-0: nl80211: Scan trigger
EAPOL: disable timer tick
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan5-0' added
nl80211: if_removed already cleared - ignore event
nl80211: Event message available
p2p-wlan5-0: nl80211: New scan results available
p2p-wlan5-0: Event SCAN_RESULTS (3) received
nl80211: Received scan results (0 BSSes)
p2p-wlan5-0: WPS: Order scan results with WPS provisioning rules
p2p-wlan5-0: BSS: Start scan result update 1
BSS: last_scan_res_used=3D0/0 last_scan_full=3D0
p2p-wlan5-0: New scan results available
p2p-wlan5-0: No suitable network found
p2p-wlan5-0: Setting scan request: 0 sec 250000 usec
p2p-wlan5-0: Checking for other virtual interfaces sharing same radio (ph=
y0) in event_scan_results
wlan5: Updating scan results from sibling
nl80211: Received scan results (0 BSSes)
wlan5: BSS: Start scan result update 1
BSS: last_scan_res_used=3D0/0 last_scan_full=3D0
wlan5: New scan results available
CTRL_IFACE monitor send - hexdump(len=3D46): 2f 74 6d 70 2f 73 61 6d 70 6=
c 65 5f 77 69 64 69 5f 77 70 61 5f 73 75 70 70 6c 69 63 61 6e 74 2e 54 6b=
 4d 4e 5a 54 2f 73 6f 63 6b 65 74 00
wlan5: No suitable network found
wlan5: Short-circuit new scan request since there are no enabled networks=

wlan5: State: DISCONNECTED -> INACTIVE
p2p-wlan5-0: P2P: Station mode scan operation not pending anymore (sta_sc=
an_pending=3D0 p2p_cb_on_scan_complete=3D0)
P2P: Use specific SSID for scan during P2P group formation
p2p-wlan5-0: P2P: Scan only GO preferred frequency 5240 MHz
WPS: Building WPS IE for Probe Request
WPS:  * Version (hardcoded 0x10)
WPS:  * Request Type
WPS:  * Config Methods (2108)
WPS:  * UUID-E
WPS:  * Primary Device Type
WPS:  * RF Bands (3)
WPS:  * Association State
WPS:  * Configuration Error (0)
WPS:  * Device Password ID (0)
WPS:  * Manufacturer
WPS:  * Model Name
WPS:  * Model Number
WPS:  * Device Name
WPS:  * Version2 (0x20)
WPS:  * Request to Enroll (1)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Listen Channel: Regulatory Class 81 Channel 1
p2p-wlan5-0: nl80211: scan request
nl80211: Scan SSID - hexdump_ascii(len=3D22):
     44 49 52 45 43 54 2d 66 43 2d 41 6e 64 72 6f 69   DIRECT-fC-Androi
     64 5f 61 37 63 61                                 d_a7ca         =20
nl80211: Scan extra IEs - hexdump(len=3D144): dd 6c 00 50 f2 04 10 4a 00 =
01 10 10 3a 00 01 01 10 08 00 02 21 08 10 47 00 10 97 71 b0 a8 da ca 57 b=
f 99 80 01 b3 3f 50 26 de 10 54 00 08 00 00 00 00 00 00 00 00 10 3c 00 01=
 03 10 02 00 02 00 00 10 09 00 02 00 00 10 12 00 02 00 00 10 21 00 01 20 =
10 23 00 01 20 10 24 00 01 20 10 11 00 01 20 10 49 00 09 00 37 2a 00 01 2=
0 03 01 01 dd 0d 50 6f 9a 0a 00 00 06 00 11 00 00 00 00 dd 11 50 6f 9a 09=
 02 02 00 25 00 06 05 00 55 53 04 51 01
nl80211: Scan frequency 5240 MHz
nl80211: P2P probe - mask SuppRates
Scan requested (ret=3D0) - scan timeout 30 seconds
nl80211: Event message available
p2p-wlan5-0: nl80211: Scan trigger
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan5-0' added
nl80211: if_removed already cleared - ignore event
nl80211: Event message available
p2p-wlan5-0: nl80211: New scan results available
p2p-wlan5-0: Event SCAN_RESULTS (3) received
nl80211: Received scan results (0 BSSes)
p2p-wlan5-0: WPS: Order scan results with WPS provisioning rules
p2p-wlan5-0: BSS: Start scan result update 2
BSS: last_scan_res_used=3D0/0 last_scan_full=3D0
p2p-wlan5-0: New scan results available
p2p-wlan5-0: No suitable network found
p2p-wlan5-0: Setting scan request: 0 sec 250000 usec
p2p-wlan5-0: Checking for other virtual interfaces sharing same radio (ph=
y0) in event_scan_results
wlan5: Updating scan results from sibling
nl80211: Received scan results (0 BSSes)
wlan5: BSS: Start scan result update 2
BSS: last_scan_res_used=3D0/0 last_scan_full=3D0
wlan5: New scan results available
CTRL_IFACE monitor send - hexdump(len=3D46): 2f 74 6d 70 2f 73 61 6d 70 6=
c 65 5f 77 69 64 69 5f 77 70 61 5f 73 75 70 70 6c 69 63 61 6e 74 2e 54 6b=
 4d 4e 5a 54 2f 73 6f 63 6b 65 74 00
wlan5: No suitable network found
wlan5: Short-circuit new scan request since there are no enabled networks=

wlan5: State: INACTIVE -> INACTIVE
p2p-wlan5-0: P2P: Station mode scan operation not pending anymore (sta_sc=
an_pending=3D0 p2p_cb_on_scan_complete=3D0)
P2P: Use specific SSID for scan during P2P group formation
p2p-wlan5-0: P2P: Scan only GO preferred frequency 5240 MHz
WPS: Building WPS IE for Probe Request
WPS:  * Version (hardcoded 0x10)
WPS:  * Request Type
WPS:  * Config Methods (2108)
WPS:  * UUID-E
WPS:  * Primary Device Type
WPS:  * RF Bands (3)
WPS:  * Association State
WPS:  * Configuration Error (0)
WPS:  * Device Password ID (0)
WPS:  * Manufacturer
WPS:  * Model Name
WPS:  * Model Number
WPS:  * Device Name
WPS:  * Version2 (0x20)
WPS:  * Request to Enroll (1)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Listen Channel: Regulatory Class 81 Channel 1
p2p-wlan5-0: nl80211: scan request
nl80211: Scan SSID - hexdump_ascii(len=3D22):
     44 49 52 45 43 54 2d 66 43 2d 41 6e 64 72 6f 69   DIRECT-fC-Androi
     64 5f 61 37 63 61                                 d_a7ca         =20
nl80211: Scan extra IEs - hexdump(len=3D144): dd 6c 00 50 f2 04 10 4a 00 =
01 10 10 3a 00 01 01 10 08 00 02 21 08 10 47 00 10 97 71 b0 a8 da ca 57 b=
f 99 80 01 b3 3f 50 26 de 10 54 00 08 00 00 00 00 00 00 00 00 10 3c 00 01=
 03 10 02 00 02 00 00 10 09 00 02 00 00 10 12 00 02 00 00 10 21 00 01 20 =
10 23 00 01 20 10 24 00 01 20 10 11 00 01 20 10 49 00 09 00 37 2a 00 01 2=
0 03 01 01 dd 0d 50 6f 9a 0a 00 00 06 00 11 00 00 00 00 dd 11 50 6f 9a 09=
 02 02 00 25 00 06 05 00 55 53 04 51 01
nl80211: Scan frequency 5240 MHz
nl80211: P2P probe - mask SuppRates
Scan requested (ret=3D0) - scan timeout 30 seconds
nl80211: Event message available
p2p-wlan5-0: nl80211: Scan trigger
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan5-0' added
nl80211: if_removed already cleared - ignore event
nl80211: Event message available
p2p-wlan5-0: nl80211: New scan results available
p2p-wlan5-0: Event SCAN_RESULTS (3) received
nl80211: Received scan results (0 BSSes)
p2p-wlan5-0: WPS: Order scan results with WPS provisioning rules
p2p-wlan5-0: BSS: Start scan result update 3
BSS: last_scan_res_used=3D0/0 last_scan_full=3D0
p2p-wlan5-0: New scan results available
p2p-wlan5-0: No suitable network found
p2p-wlan5-0: Setting scan request: 0 sec 250000 usec
p2p-wlan5-0: Checking for other virtual interfaces sharing same radio (ph=
y0) in event_scan_results
wlan5: Updating scan results from sibling
nl80211: Received scan results (0 BSSes)
wlan5: BSS: Start scan result update 3
BSS: last_scan_res_used=3D0/0 last_scan_full=3D0
wlan5: New scan results available
CTRL_IFACE monitor send - hexdump(len=3D46): 2f 74 6d 70 2f 73 61 6d 70 6=
c 65 5f 77 69 64 69 5f 77 70 61 5f 73 75 70 70 6c 69 63 61 6e 74 2e 54 6b=
 4d 4e 5a 54 2f 73 6f 63 6b 65 74 00
wlan5: No suitable network found
wlan5: Short-circuit new scan request since there are no enabled networks=

wlan5: State: INACTIVE -> INACTIVE
p2p-wlan5-0: P2P: Station mode scan operation not pending anymore (sta_sc=
an_pending=3D0 p2p_cb_on_scan_complete=3D0)
P2P: Use specific SSID for scan during P2P group formation
p2p-wlan5-0: P2P: Scan only GO preferred frequency 5240 MHz
WPS: Building WPS IE for Probe Request
WPS:  * Version (hardcoded 0x10)
WPS:  * Request Type
WPS:  * Config Methods (2108)
WPS:  * UUID-E
WPS:  * Primary Device Type
WPS:  * RF Bands (3)
WPS:  * Association State
WPS:  * Configuration Error (0)
WPS:  * Device Password ID (0)
WPS:  * Manufacturer
WPS:  * Model Name
WPS:  * Model Number
WPS:  * Device Name
WPS:  * Version2 (0x20)
WPS:  * Request to Enroll (1)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Listen Channel: Regulatory Class 81 Channel 1
p2p-wlan5-0: nl80211: scan request
nl80211: Scan SSID - hexdump_ascii(len=3D22):
     44 49 52 45 43 54 2d 66 43 2d 41 6e 64 72 6f 69   DIRECT-fC-Androi
     64 5f 61 37 63 61                                 d_a7ca         =20
nl80211: Scan extra IEs - hexdump(len=3D144): dd 6c 00 50 f2 04 10 4a 00 =
01 10 10 3a 00 01 01 10 08 00 02 21 08 10 47 00 10 97 71 b0 a8 da ca 57 b=
f 99 80 01 b3 3f 50 26 de 10 54 00 08 00 00 00 00 00 00 00 00 10 3c 00 01=
 03 10 02 00 02 00 00 10 09 00 02 00 00 10 12 00 02 00 00 10 21 00 01 20 =
10 23 00 01 20 10 24 00 01 20 10 11 00 01 20 10 49 00 09 00 37 2a 00 01 2=
0 03 01 01 dd 0d 50 6f 9a 0a 00 00 06 00 11 00 00 00 00 dd 11 50 6f 9a 09=
 02 02 00 25 00 06 05 00 55 53 04 51 01
nl80211: Scan frequency 5240 MHz
nl80211: P2P probe - mask SuppRates
Scan requested (ret=3D0) - scan timeout 30 seconds
nl80211: Event message available
p2p-wlan5-0: nl80211: Scan trigger
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan5-0' added
nl80211: if_removed already cleared - ignore event
nl80211: Event message available
p2p-wlan5-0: nl80211: New scan results available
p2p-wlan5-0: Event SCAN_RESULTS (3) received
nl80211: Received scan results (0 BSSes)
p2p-wlan5-0: WPS: Order scan results with WPS provisioning rules
p2p-wlan5-0: BSS: Start scan result update 4
BSS: last_scan_res_used=3D0/0 last_scan_full=3D0
p2p-wlan5-0: New scan results available
p2p-wlan5-0: No suitable network found
p2p-wlan5-0: Setting scan request: 0 sec 250000 usec
p2p-wlan5-0: Checking for other virtual interfaces sharing same radio (ph=
y0) in event_scan_results
wlan5: Updating scan results from sibling
nl80211: Received scan results (0 BSSes)
wlan5: BSS: Start scan result update 4
BSS: last_scan_res_used=3D0/0 last_scan_full=3D0
wlan5: New scan results available
CTRL_IFACE monitor send - hexdump(len=3D46): 2f 74 6d 70 2f 73 61 6d 70 6=
c 65 5f 77 69 64 69 5f 77 70 61 5f 73 75 70 70 6c 69 63 61 6e 74 2e 54 6b=
 4d 4e 5a 54 2f 73 6f 63 6b 65 74 00
wlan5: No suitable network found
wlan5: Short-circuit new scan request since there are no enabled networks=

wlan5: State: INACTIVE -> INACTIVE
p2p-wlan5-0: P2P: Station mode scan operation not pending anymore (sta_sc=
an_pending=3D0 p2p_cb_on_scan_complete=3D0)
P2P: Use specific SSID for scan during P2P group formation
p2p-wlan5-0: P2P: Scan only common channels
WPS: Building WPS IE for Probe Request
WPS:  * Version (hardcoded 0x10)
WPS:  * Request Type
WPS:  * Config Methods (2108)
WPS:  * UUID-E
WPS:  * Primary Device Type
WPS:  * RF Bands (3)
WPS:  * Association State
WPS:  * Configuration Error (0)
WPS:  * Device Password ID (0)
WPS:  * Manufacturer
WPS:  * Model Name
WPS:  * Model Number
WPS:  * Device Name
WPS:  * Version2 (0x20)
WPS:  * Request to Enroll (1)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Listen Channel: Regulatory Class 81 Channel 1
p2p-wlan5-0: nl80211: scan request
nl80211: Scan SSID - hexdump_ascii(len=3D22):
     44 49 52 45 43 54 2d 66 43 2d 41 6e 64 72 6f 69   DIRECT-fC-Androi
     64 5f 61 37 63 61                                 d_a7ca         =20
nl80211: Scan extra IEs - hexdump(len=3D144): dd 6c 00 50 f2 04 10 4a 00 =
01 10 10 3a 00 01 01 10 08 00 02 21 08 10 47 00 10 97 71 b0 a8 da ca 57 b=
f 99 80 01 b3 3f 50 26 de 10 54 00 08 00 00 00 00 00 00 00 00 10 3c 00 01=
 03 10 02 00 02 00 00 10 09 00 02 00 00 10 12 00 02 00 00 10 21 00 01 20 =
10 23 00 01 20 10 24 00 01 20 10 11 00 01 20 10 49 00 09 00 37 2a 00 01 2=
0 03 01 01 dd 0d 50 6f 9a 0a 00 00 06 00 11 00 00 00 00 dd 11 50 6f 9a 09=
 02 02 00 25 00 06 05 00 55 53 04 51 01
nl80211: Scan frequency 2412 MHz
nl80211: Scan frequency 2417 MHz
nl80211: Scan frequency 2422 MHz
nl80211: Scan frequency 2427 MHz
nl80211: Scan frequency 2432 MHz
nl80211: Scan frequency 2437 MHz
nl80211: Scan frequency 2442 MHz
nl80211: Scan frequency 2447 MHz
nl80211: Scan frequency 2452 MHz
nl80211: Scan frequency 2457 MHz
nl80211: Scan frequency 2462 MHz
nl80211: Scan frequency 2472 MHz
nl80211: P2P probe - mask SuppRates
Scan requested (ret=3D0) - scan timeout 30 seconds
nl80211: Event message available
p2p-wlan5-0: nl80211: Scan trigger
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan5-0' added
nl80211: if_removed already cleared - ignore event
nl80211: Event message available
p2p-wlan5-0: nl80211: New scan results available
p2p-wlan5-0: Event SCAN_RESULTS (3) received
nl80211: Received scan results (1 BSSes)
p2p-wlan5-0: WPS: Order scan results with WPS provisioning rules
p2p-wlan5-0: BSS: Start scan result update 5
p2p-wlan5-0: BSS: Add new id 0 BSSID 62:21:c0:99:08:b1 SSID 'DIRECT-fC-An=
droid_a7ca'
BSS: last_scan_res_used=3D1/32 last_scan_full=3D0
p2p-wlan5-0: New scan results available
WPS: AP 62:21:c0:99:08:b1 type 2 added
WPS: AP[0] 62:21:c0:99:08:b1 type=3D2 tries=3D0 last_attempt=3D-1 sec ago=
 blacklist=3D0
p2p-wlan5-0: Selecting BSS from priority group 0
p2p-wlan5-0: 0: 62:21:c0:99:08:b1 ssid=3D'DIRECT-fC-Android_a7ca' wpa_ie_=
len=3D0 rsn_ie_len=3D20 caps=3D0x511 level=3D-15 wps
   selected based on WPS IE (Authorized MAC or Active PIN)
p2p-wlan5-0:    selected BSS 62:21:c0:99:08:b1 ssid=3D'DIRECT-fC-Android_=
a7ca'
p2p-wlan5-0: Considering connect request: reassociate: 1  selected: 62:21=
:c0:99:08:b1  bssid: 00:00:00:00:00:00  pending: 00:00:00:00:00:00  wpa_s=
tate: SCANNING  ssid=3D0x1faae00  current_ssid=3D(nil)
p2p-wlan5-0: Request association with 62:21:c0:99:08:b1
p2p-wlan5-0: Automatic auth_alg selection: 0x1
WPS: Building WPS IE for (Re)Association Request
WPS:  * Version (hardcoded 0x10)
WPS:  * Request Type
WPS:  * Version2 (0x20)
p2p-wlan5-0: WPA: clearing AP WPA IE
p2p-wlan5-0: WPA: clearing AP RSN IE
p2p-wlan5-0: WPA: clearing own WPA/RSN IE
P2P: * P2P IE header
P2P: * Capability dev=3D27 group=3D00
P2P: * Device Info
p2p-wlan5-0: Cancelling scan request
p2p-wlan5-0: P2P: Station mode scan operation not pending anymore (sta_sc=
an_pending=3D0 p2p_cb_on_scan_complete=3D0)
p2p-wlan5-0: SME: Trying to authenticate with 62:21:c0:99:08:b1 (SSID=3D'=
DIRECT-fC-Android_a7ca' freq=3D2412 MHz)
p2p-wlan5-0: No keys have been configured - skip key clearing
p2p-wlan5-0: State: SCANNING -> AUTHENTICATING
EAPOL: External notification - EAP success=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
EAPOL: External notification - EAP fail=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
EAPOL: External notification - portControl=3DAuto
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
nl80211: Set mode ifindex 6 iftype 8 (P2P_CLIENT)
nl80211: Subscribe to mgmt frames with non-AP handle 0x1fa8b10
nl80211: Register frame type=3D0xd0 nl_handle=3D0x1fa8b10
nl80211: Register frame match - hexdump(len=3D2): 04 0a
nl80211: Register frame type=3D0xd0 nl_handle=3D0x1fa8b10
nl80211: Register frame match - hexdump(len=3D2): 04 0b
nl80211: Register frame type=3D0xd0 nl_handle=3D0x1fa8b10
nl80211: Register frame match - hexdump(len=3D2): 04 0c
nl80211: Register frame type=3D0xd0 nl_handle=3D0x1fa8b10
nl80211: Register frame match - hexdump(len=3D2): 04 0d
nl80211: Register frame type=3D0xd0 nl_handle=3D0x1fa8b10
nl80211: Register frame match - hexdump(len=3D6): 04 09 50 6f 9a 09
nl80211: Register frame type=3D0xd0 nl_handle=3D0x1fa8b10
nl80211: Register frame match - hexdump(len=3D5): 7f 50 6f 9a 09
nl80211: Register frame type=3D0xd0 nl_handle=3D0x1fa8b10
nl80211: Register frame match - hexdump(len=3D1): 06
nl80211: Register frame type=3D0xd0 nl_handle=3D0x1fa8b10
nl80211: Register frame match - hexdump(len=3D2): 0a 07
nl80211: Register frame type=3D0xd0 nl_handle=3D0x1fa8b10
nl80211: Register frame match - hexdump(len=3D2): 0a 11
nl80211: Authenticate (ifindex=3D6)
  * bssid=3D62:21:c0:99:08:b1
  * freq=3D2412
  * SSID - hexdump_ascii(len=3D22):
     44 49 52 45 43 54 2d 66 43 2d 41 6e 64 72 6f 69   DIRECT-fC-Androi
     64 5f 61 37 63 61                                 d_a7ca         =20
  * IEs - hexdump(len=3D0): [NULL]
  * Auth Type 0
nl80211: Authentication request send successfully
RSN: Ignored PMKID candidate without preauth flag
nl80211: Event message available
nl80211: New station 62:21:c0:99:08:b1
nl80211: Event message available
nl80211: MLME event 37 on p2p-wlan5-0(02:0b:6b:7f:92:56) A1=3D02:0b:6b:7f=
:92:56 A2=3D62:21:c0:99:08:b1
nl80211: MLME event frame - hexdump(len=3D41): b0 00 3c 00 02 0b 6b 7f 92=
 56 62 21 c0 99 08 b1 62 21 c0 99 08 b1 20 02 00 00 02 00 00 00 dd 09 00 =
10 18 02 00 00 0c 00 00
nl80211: Authenticate event
p2p-wlan5-0: Event AUTH (11) received
p2p-wlan5-0: SME: Authentication response: peer=3D62:21:c0:99:08:b1 auth_=
type=3D0 auth_transaction=3D2 status_code=3D0
SME: Authentication response IEs - hexdump(len=3D11): dd 09 00 10 18 02 0=
0 00 0c 00 00
p2p-wlan5-0: Trying to associate with 62:21:c0:99:08:b1 (SSID=3D'DIRECT-f=
C-Android_a7ca' freq=3D2412 MHz)
p2p-wlan5-0: State: AUTHENTICATING -> ASSOCIATING
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=3D-1, operstate=3D5
p2p-wlan5-0: WPA: clearing own WPA/RSN IE
nl80211: Associate (ifindex=3D6)
  * bssid=3D62:21:c0:99:08:b1
  * freq=3D2412
  * SSID - hexdump_ascii(len=3D22):
     44 49 52 45 43 54 2d 66 43 2d 41 6e 64 72 6f 69   DIRECT-fC-Androi
     64 5f 61 37 63 61                                 d_a7ca         =20
  * IEs - hexdump(len=3D84): dd 18 00 50 f2 04 10 4a 00 01 10 10 3a 00 01=
 01 10 49 00 06 00 37 2a 00 01 20 dd 0d 50 6f 9a 0a 00 00 06 00 11 00 00 =
00 00 dd 29 50 6f 9a 09 02 02 00 27 00 0d 1d 00 00 0b 6b 7f 92 56 01 08 0=
0 01 00 50 f2 04 00 01 00 10 11 00 08 6b 65 76 69 6e 2d 70 63
  * P2P group
nl80211: Association request send successfully
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan5-0' added
nl80211: if_removed already cleared - ignore event
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan5-0' added
nl80211: if_removed already cleared - ignore event
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan5-0' added
nl80211: if_removed already cleared - ignore event
nl80211: Event message available
nl80211: MLME event 38 on p2p-wlan5-0(02:0b:6b:7f:92:56) A1=3D02:0b:6b:7f=
:92:56 A2=3D62:21:c0:99:08:b1
nl80211: MLME event frame - hexdump(len=3D176): 10 00 3c 00 02 0b 6b 7f 9=
2 56 62 21 c0 99 08 b1 62 21 c0 99 08 b1 30 02 31 04 00 00 01 c0 01 08 8c=
 12 98 24 b0 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 3d 16 01 08 04 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00 00 00 00 00 00 dd 0d 50 6f 9a 0a 00 00 06 01 10 c0 00 00=
 28 dd 18 00 50 f2 04 10 4a 00 01 10 10 3b 00 01 03 10 49 00 06 00 37 2a =
00 01 20 dd 09 00 10 18 02 00 00 0c 00 00 dd 18 00 50 f2 02 01 01 84 00 0=
3 64 00 00 27 a4 00 00 41 43 5e 00 61 32 2f 00 dd 04 50 6f 9a 09
nl80211: Associate event
p2p-wlan5-0: Event ASSOC (0) received
p2p-wlan5-0: Association info event
resp_ies - hexdump(len=3D146): 01 08 8c 12 98 24 b0 48 60 6c 2d 1a 20 10 =
1a ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3=
d 16 01 08 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd=
 0d 50 6f 9a 0a 00 00 06 01 10 c0 00 00 28 dd 18 00 50 f2 04 10 4a 00 01 =
10 10 3b 00 01 03 10 49 00 06 00 37 2a 00 01 20 dd 09 00 10 18 02 00 00 0=
c 00 00 dd 18 00 50 f2 02 01 01 84 00 03 64 00 00 27 a4 00 00 41 43 5e 00=
 61 32 2f 00 dd 04 50 6f 9a 09
p2p-wlan5-0: freq=3D2412 MHz
p2p-wlan5-0: State: ASSOCIATING -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=3D-1, operstate=3D5
p2p-wlan5-0: Associated to a new BSS: BSSID=3D62:21:c0:99:08:b1
p2p-wlan5-0: No keys have been configured - skip key clearing
p2p-wlan5-0: Associated with 62:21:c0:99:08:b1
p2p-wlan5-0: WPA: Association event - clear replay counter
p2p-wlan5-0: WPA: Clear old PTK
EAPOL: External notification - portEnabled=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 62:21:c0:99:08:b1
EAPOL: External notification - portValid=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 62:21:c0:99:08:b1
EAPOL: External notification - portEnabled=3D1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: enable timer tick
EAPOL: SUPP_BE entering state IDLE
EAP: EAP entering state INITIALIZE
EAP: EAP entering state IDLE
p2p-wlan5-0: Setting authentication timeout: 10 sec 0 usec
p2p-wlan5-0: Cancelling scan request
p2p-wlan5-0: P2P: Station mode scan operation not pending anymore (sta_sc=
an_pending=3D0 p2p_cb_on_scan_complete=3D0)
nl80211: Event message available
nl80211: Ignore connect event (cmd=3D46) when using userspace SME
nl80211: Event message available
nl80211: Regulatory domain change
p2p-wlan5-0: Event CHANNEL_LIST_CHANGED (31) received
nl80211: Regulatory information - country=3DGB
nl80211: 2402-2482 @ 40 MHz
nl80211: 5170-5250 @ 40 MHz
nl80211: 5250-5330 @ 40 MHz
nl80211: 5490-5710 @ 40 MHz
nl80211: Added 802.11b mode based on 802.11g information
P2P: Add operating class 81
P2P: Channels - hexdump(len=3D11): 01 02 03 04 05 06 07 08 09 0a 0b
P2P: Update channel list
p2p-wlan5-0: RX EAPOL from 62:21:c0:99:08:b1
RX EAPOL - hexdump(len=3D9): 02 00 00 05 01 92 00 05 01
p2p-wlan5-0: Setting authentication timeout: 70 sec 0 usec
EAPOL: Received EAP-Packet frame
EAPOL: SUPP_PAE entering state RESTART
EAP: EAP entering state INITIALIZE
EAP: EAP entering state IDLE
EAPOL: SUPP_PAE entering state AUTHENTICATING
EAPOL: SUPP_BE entering state REQUEST
EAPOL: getSuppRsp
EAP: EAP entering state RECEIVED
EAP: Received EAP-Request id=3D146 method=3D1 vendor=3D0 vendorMethod=3D0=

EAP: EAP entering state IDENTITY
p2p-wlan5-0: CTRL-EVENT-EAP-STARTED EAP authentication started
EAP: Status notification: started (param=3D)
EAP: EAP-Request Identity data - hexdump_ascii(len=3D0):
EAP: using real identity - hexdump_ascii(len=3D29):
     57 46 41 2d 53 69 6d 70 6c 65 43 6f 6e 66 69 67   WFA-SimpleConfig
     2d 45 6e 72 6f 6c 6c 65 65 2d 31 2d 30            -Enrollee-1-0  =20
EAP: EAP entering state SEND_RESPONSE
EAP: EAP entering state IDLE
EAPOL: SUPP_BE entering state RESPONSE
EAPOL: txSuppRsp
TX EAPOL: dst=3D62:21:c0:99:08:b1
TX EAPOL - hexdump(len=3D38): 01 00 00 22 02 92 00 22 01 57 46 41 2d 53 6=
9 6d 70 6c 65 43 6f 6e 66 69 67 2d 45 6e 72 6f 6c 6c 65 65 2d 31 2d 30
EAPOL: SUPP_BE entering state RECEIVE
p2p-wlan5-0: RX EAPOL from 62:21:c0:99:08:b1
RX EAPOL - hexdump(len=3D18): 02 00 00 0e 01 93 00 0e fe 00 37 2a 00 00 0=
0 01 01 00
EAPOL: Received EAP-Packet frame
EAPOL: SUPP_BE entering state REQUEST
EAPOL: getSuppRsp
EAP: EAP entering state RECEIVED
EAP: Received EAP-Request id=3D147 method=3D254 vendor=3D14122 vendorMeth=
od=3D1
EAP: EAP entering state GET_METHOD
p2p-wlan5-0: CTRL-EVENT-EAP-PROPOSED-METHOD vendor=3D14122 method=3D1
EAP: Status notification: accept proposed method (param=3DWSC)
EAP: Initialize selected EAP method: vendor 14122 method 1 (WSC)
WPS: AP PIN dev_password - hexdump(len=3D8): [REMOVED]
EAP-WSC: Fragment size limit 1398
p2p-wlan5-0: CTRL-EVENT-EAP-METHOD EAP vendor 14122 method 1 (WSC) select=
ed
EAP: EAP entering state METHOD
EAP-WSC: Received packet: Op-Code 1 Flags 0x0 Message Length 0
EAP-WSC: Received start
EAP-WSC: WAIT_START -> MESG
Get randomness: len=3D16 entropy=3D2
WPS: Enrollee Nonce - hexdump(len=3D16): 6b 64 05 a1 88 05 17 2b 67 cc 78=
 5a af fe 74 35
WPS: Building Message M1
WPS:  * Version (hardcoded 0x10)
WPS:  * Message Type (4)
WPS:  * UUID-E
WPS:  * MAC Address (02:0b:6b:7f:92:56)
WPS:  * Enrollee Nonce
WPS:  * Public Key
WPS: Generate new DH keys
WPS: DH Private Key - hexdump(len=3D192): [REMOVED]
WPS: DH own Public Key - hexdump(len=3D192): 8f c7 40 08 e9 70 3d cf 8e 1=
b 02 f9 38 1b 30 bf a7 b8 20 9e 45 09 62 b0 87 9b e0 10 5d 3f 92 e0 f1 c8=
 e5 7d b1 1d f6 5c 93 14 32 f7 72 59 54 af ba e7 39 4a 67 cd 95 df 46 e0 =
42 f1 cf d5 b5 76 c4 d9 63 f0 8e 1a 61 fa 63 0d 98 1f 29 91 7c 38 1a 36 8=
7 8d 79 b3 9d 80 ee 45 5b e0 25 be 79 3f 29 9a 7d e3 69 52 bf cf 32 52 4f=
 58 22 ba 5c e0 69 eb 5a 3a f6 50 c1 1e 16 32 68 5c a6 a3 6b 31 14 87 d3 =
02 36 dc 81 d7 7b b1 a0 e5 60 82 86 ff 6f 5c e0 0c bf 71 9c 6f d5 b7 2f 8=
5 0b 11 78 39 ba b1 65 9c 81 78 bc f6 5e 47 f7 5f 7f 26 bd db d9 7d fa 13=
 7f e0 9f 03 d1 e8 b3 56 b6 7f 76 51
WPS:  * Authentication Type Flags
WPS:  * Encryption Type Flags
WPS:  * Connection Type Flags
WPS:  * Config Methods (2108)
WPS:  * Wi-Fi Protected Setup State (1)
WPS:  * Manufacturer
WPS:  * Model Name
WPS:  * Model Number
WPS:  * Serial Number
WPS:  * Primary Device Type
WPS:  * Device Name
WPS:  * RF Bands (3)
WPS:  * Association State
WPS:  * Device Password ID (0)
WPS:  * Configuration Error (0)
WPS:  * OS Version
WPS:  * Version2 (0x20)
EAP-WSC: MESG -> MESG
EAP-WSC: Generating Response
EAP-WSC: Sending out 362 bytes (message sent completely)
EAP-WSC: MESG -> MESG
EAP: method process -> ignore=3DFALSE methodState=3DMAY_CONT decision=3DF=
AIL
EAP: EAP entering state SEND_RESPONSE
EAP: EAP entering state IDLE
EAPOL: SUPP_BE entering state RESPONSE
EAPOL: txSuppRsp
TX EAPOL: dst=3D62:21:c0:99:08:b1
TX EAPOL - hexdump(len=3D380): 01 00 01 78 02 93 01 78 fe 00 37 2a 00 00 =
00 01 04 00 10 4a 00 01 10 10 22 00 01 04 10 47 00 10 97 71 b0 a8 da ca 5=
7 bf 99 80 01 b3 3f 50 26 de 10 20 00 06 02 0b 6b 7f 92 56 10 1a 00 10 6b=
 64 05 a1 88 05 17 2b 67 cc 78 5a af fe 74 35 10 32 00 c0 8f c7 40 08 e9 =
70 3d cf 8e 1b 02 f9 38 1b 30 bf a7 b8 20 9e 45 09 62 b0 87 9b e0 10 5d 3=
f 92 e0 f1 c8 e5 7d b1 1d f6 5c 93 14 32 f7 72 59 54 af ba e7 39 4a 67 cd=
 95 df 46 e0 42 f1 cf d5 b5 76 c4 d9 63 f0 8e 1a 61 fa 63 0d 98 1f 29 91 =
7c 38 1a 36 87 8d 79 b3 9d 80 ee 45 5b e0 25 be 79 3f 29 9a 7d e3 69 52 b=
f cf 32 52 4f 58 22 ba 5c e0 69 eb 5a 3a f6 50 c1 1e 16 32 68 5c a6 a3 6b=
 31 14 87 d3 02 36 dc 81 d7 7b b1 a0 e5 60 82 86 ff 6f 5c e0 0c bf 71 9c =
6f d5 b7 2f 85 0b 11 78 39 ba b1 65 9c 81 78 bc f6 5e 47 f7 5f 7f 26 bd d=
b d9 7d fa 13 7f e0 9f 03 d1 e8 b3 56 b6 7f 76 51 10 04 00 02 00 3b 10 10=
 00 02 00 0d 10 0d 00 01 01 10 08 00 02 21 08 10 44 00 01 01 10 21 00 01 =
20 10 23 00 01 20 10 24 00 01 20 10 42 00 01 20 10 54 00 08 00 00 00 00 0=
0 00 00 00 10 11 00 01 20 10 3c 00 01 03 10 02 00 02 00 00 10 12 00 02 00=
 00 10 09 00 02 00 00 10 2d 00 04 80 00 00 00 10 49 00 06 00 37 2a 00 01 =
20
EAPOL: SUPP_BE entering state RECEIVE
p2p-wlan5-0: RX EAPOL from 62:21:c0:99:08:b1
RX EAPOL - hexdump(len=3D449): 02 00 01 bd 01 94 01 bd fe 00 37 2a 00 00 =
00 01 04 00 10 4a 00 01 10 10 22 00 01 05 10 1a 00 10 6b 64 05 a1 88 05 1=
7 2b 67 cc 78 5a af fe 74 35 10 39 00 10 e9 f3 fd c8 b8 99 de 1c 76 ea ea=
 e8 27 15 bb 53 10 48 00 10 34 e6 cb 58 77 e0 5f db 94 f5 e0 e3 4d 80 d0 =
f9 10 32 00 c0 30 6c e3 31 25 66 a5 30 a4 45 c0 2f d9 36 c0 9a f9 55 c6 e=
d ad a9 c7 a2 e8 28 f6 06 a3 1d 13 e0 1e 3c 8d 3c 65 05 35 f7 0f 0f 1d 24=
 b9 9f 1b 6e d5 a3 56 85 1e 5d ad c0 16 cc cb 39 39 54 d9 3e 40 21 e8 e2 =
c2 a5 46 24 c2 db 3a b2 66 8b ef 7d 97 fb 31 2b 05 e3 15 0f 2a b8 cc b5 0=
2 af 35 06 74 f0 a5 ac 23 3a 05 8b b6 33 51 9d 84 da 1f db 53 e0 bf 0a 84=
 d8 ef 0a 46 0c 79 49 6c 12 c8 99 ed 94 cc 75 15 f5 af ab 80 1c e8 b9 38 =
ec 11 03 47 84 4e 18 f1 6a d2 93 a5 ea 6d 31 18 d1 71 79 51 2e 86 41 5e 9=
f fe 7e a0 0e f7 8d dc 86 47 52 f8 ca a9 ce 42 ec f3 b7 97 ac 00 87 ed 41=
 e5 1a 10 04 00 02 00 3b 10 10 00 02 00 0d 10 0d 00 01 01 10 08 00 02 43 =
88 10 21 00 13 53 41 4d 53 55 4e 47 5f 45 4c 45 43 54 52 4f 4e 49 43 53 1=
0 23 00 0e 53 41 4d 53 55 4e 47 5f 4d 4f 42 49 4c 45 10 24 00 04 32 30 31=
 32 10 42 00 08 31 39 36 39 31 31 30 31 10 54 00 08 00 0a 00 50 f2 04 00 =
05 10 11 00 0c 41 6e 64 72 6f 69 64 5f 61 37 63 61 10 3c 00 01 01 10 02 0=
0 02 00 00 10 09 00 02 00 00 10 12 00 02 00 00 10 2d 00 04 80 00 00 00 10=
 49 00 06 00 37 2a 00 01 20 10 05 00 08 96 f9 19 ca 99 f3 a6 20
EAPOL: Received EAP-Packet frame
EAPOL: SUPP_BE entering state REQUEST
EAPOL: getSuppRsp
EAP: EAP entering state RECEIVED
EAP: Received EAP-Request id=3D148 method=3D254 vendor=3D14122 vendorMeth=
od=3D1
EAP: EAP entering state METHOD
EAP-WSC: Received packet: Op-Code 4 Flags 0x0 Message Length 0
WPS: Processing received message (len=3D431 op_code=3D4)
WPS: Received WSC_MSG
WPS: Received M2
WPS: Registrar Nonce - hexdump(len=3D16): e9 f3 fd c8 b8 99 de 1c 76 ea e=
a e8 27 15 bb 53
WPS: UUID-R - hexdump(len=3D16): 34 e6 cb 58 77 e0 5f db 94 f5 e0 e3 4d 8=
0 d0 f9
WPS: Device Password ID 0
WPS: DH Private Key - hexdump(len=3D192): [REMOVED]
WPS: DH peer Public Key - hexdump(len=3D192): 30 6c e3 31 25 66 a5 30 a4 =
45 c0 2f d9 36 c0 9a f9 55 c6 ed ad a9 c7 a2 e8 28 f6 06 a3 1d 13 e0 1e 3=
c 8d 3c 65 05 35 f7 0f 0f 1d 24 b9 9f 1b 6e d5 a3 56 85 1e 5d ad c0 16 cc=
 cb 39 39 54 d9 3e 40 21 e8 e2 c2 a5 46 24 c2 db 3a b2 66 8b ef 7d 97 fb =
31 2b 05 e3 15 0f 2a b8 cc b5 02 af 35 06 74 f0 a5 ac 23 3a 05 8b b6 33 5=
1 9d 84 da 1f db 53 e0 bf 0a 84 d8 ef 0a 46 0c 79 49 6c 12 c8 99 ed 94 cc=
 75 15 f5 af ab 80 1c e8 b9 38 ec 11 03 47 84 4e 18 f1 6a d2 93 a5 ea 6d =
31 18 d1 71 79 51 2e 86 41 5e 9f fe 7e a0 0e f7 8d dc 86 47 52 f8 ca a9 c=
e 42 ec f3 b7 97 ac 00 87 ed 41 e5 1a
WPS: DH shared key - hexdump(len=3D192): [REMOVED]
WPS: DHKey - hexdump(len=3D32): [REMOVED]
WPS: KDK - hexdump(len=3D32): [REMOVED]
WPS: AuthKey - hexdump(len=3D32): [REMOVED]
WPS: KeyWrapKey - hexdump(len=3D16): [REMOVED]
WPS: EMSK - hexdump(len=3D32): [REMOVED]
WPS: Manufacturer - hexdump_ascii(len=3D19):
     53 41 4d 53 55 4e 47 5f 45 4c 45 43 54 52 4f 4e   SAMSUNG_ELECTRON
     49 43 53                                          ICS            =20
WPS: Model Name - hexdump_ascii(len=3D14):
     53 41 4d 53 55 4e 47 5f 4d 4f 42 49 4c 45         SAMSUNG_MOBILE =20
WPS: Model Number - hexdump_ascii(len=3D4):
     32 30 31 32                                       2012           =20
WPS: Serial Number - hexdump_ascii(len=3D8):
     31 39 36 39 31 31 30 31                           19691101       =20
WPS: Primary Device Type: 10-0050F204-5
WPS: Device Name - hexdump_ascii(len=3D12):
     41 6e 64 72 6f 69 64 5f 61 37 63 61               Android_a7ca   =20
EAP-WSC: MESG -> MESG
WPS: Building Message M3
WPS: Device Password - hexdump_ascii(len=3D8): [REMOVED]
WPS: PSK1 - hexdump(len=3D16): [REMOVED]
WPS: PSK2 - hexdump(len=3D16): [REMOVED]
WPS:  * Version (hardcoded 0x10)
WPS:  * Message Type (7)
WPS:  * Registrar Nonce
Get randomness: len=3D32 entropy=3D0
WPS: E-S1 - hexdump(len=3D16): bd 18 5c c7 2d 64 47 6d 90 8f bd e9 b4 bf =
28 4e
WPS: E-S2 - hexdump(len=3D16): c6 27 07 a1 37 36 e5 9f f2 cc 7b 0a df 57 =
26 fe
WPS:  * E-Hash1
WPS: E-Hash1 - hexdump(len=3D32): 18 88 99 1d 8b 22 74 ec 27 6a c0 05 2c =
bc 7e 1d 11 89 69 35 fc 52 8e 2b af 56 79 4f e0 8b 23 0e
WPS:  * E-Hash2
WPS: E-Hash2 - hexdump(len=3D32): 70 1b d8 e9 bb 0e 43 f4 bd 00 c3 62 ee =
e7 d2 41 ff 1a e7 55 09 29 04 61 8f 2c 82 16 a1 15 e1 ed
WPS:  * Version2 (0x20)
WPS:  * Authenticator
EAP-WSC: MESG -> MESG
EAP-WSC: Generating Response
EAP-WSC: Sending out 124 bytes (message sent completely)
EAP-WSC: MESG -> MESG
EAP: method process -> ignore=3DFALSE methodState=3DMAY_CONT decision=3DF=
AIL
EAP: EAP entering state SEND_RESPONSE
EAP: EAP entering state IDLE
EAPOL: SUPP_BE entering state RESPONSE
EAPOL: txSuppRsp
TX EAPOL: dst=3D62:21:c0:99:08:b1
TX EAPOL - hexdump(len=3D142): 01 00 00 8a 02 94 00 8a fe 00 37 2a 00 00 =
00 01 04 00 10 4a 00 01 10 10 22 00 01 07 10 39 00 10 e9 f3 fd c8 b8 99 d=
e 1c 76 ea ea e8 27 15 bb 53 10 14 00 20 18 88 99 1d 8b 22 74 ec 27 6a c0=
 05 2c bc 7e 1d 11 89 69 35 fc 52 8e 2b af 56 79 4f e0 8b 23 0e 10 15 00 =
20 70 1b d8 e9 bb 0e 43 f4 bd 00 c3 62 ee e7 d2 41 ff 1a e7 55 09 29 04 6=
1 8f 2c 82 16 a1 15 e1 ed 10 49 00 06 00 37 2a 00 01 20 10 05 00 08 8d 96=
 38 38 61 9e 7f 10
EAPOL: SUPP_BE entering state RECEIVE
p2p-wlan5-0: RX EAPOL from 62:21:c0:99:08:b1
RX EAPOL - hexdump(len=3D210): 02 00 00 ce 01 95 00 ce fe 00 37 2a 00 00 =
00 01 04 00 10 4a 00 01 10 10 22 00 01 08 10 1a 00 10 6b 64 05 a1 88 05 1=
7 2b 67 cc 78 5a af fe 74 35 10 3d 00 20 d7 56 31 67 ab 08 b7 77 bb bc 28=
 e6 da 61 01 2f 68 97 3f d0 d5 c2 4d 53 29 59 71 e5 62 15 33 43 10 3e 00 =
20 7c 81 8f c4 43 a6 e1 d1 99 47 6f 7b a7 d9 29 bf a1 89 0f 4c da 25 c6 a=
3 38 80 71 78 b0 3c 90 dd 10 18 00 40 97 26 c5 19 d8 5e cb dd 0e 5d 33 55=
 dc 44 32 0f cf 08 c6 e6 82 5b 0d a1 39 9d f0 33 76 01 fe 47 61 17 83 ab =
18 c0 b9 64 8e f9 b1 bf d4 52 65 3a 90 62 fe 7d cf e9 f2 e2 a8 56 c6 1a 0=
2 3f 68 b2 10 49 00 06 00 37 2a 00 01 20 10 05 00 08 11 5f 94 9d 1e 3c 6a=
 d6
EAPOL: Received EAP-Packet frame
EAPOL: SUPP_BE entering state REQUEST
EAPOL: getSuppRsp
EAP: EAP entering state RECEIVED
EAP: Received EAP-Request id=3D149 method=3D254 vendor=3D14122 vendorMeth=
od=3D1
EAP: EAP entering state METHOD
EAP-WSC: Received packet: Op-Code 4 Flags 0x0 Message Length 0
WPS: Processing received message (len=3D192 op_code=3D4)
WPS: Received WSC_MSG
WPS: Received M4
WPS: R-Hash1 - hexdump(len=3D32): d7 56 31 67 ab 08 b7 77 bb bc 28 e6 da =
61 01 2f 68 97 3f d0 d5 c2 4d 53 29 59 71 e5 62 15 33 43
WPS: R-Hash2 - hexdump(len=3D32): 7c 81 8f c4 43 a6 e1 d1 99 47 6f 7b a7 =
d9 29 bf a1 89 0f 4c da 25 c6 a3 38 80 71 78 b0 3c 90 dd
WPS: Encrypted Settings - hexdump(len=3D64): 97 26 c5 19 d8 5e cb dd 0e 5=
d 33 55 dc 44 32 0f cf 08 c6 e6 82 5b 0d a1 39 9d f0 33 76 01 fe 47 61 17=
 83 ab 18 c0 b9 64 8e f9 b1 bf d4 52 65 3a 90 62 fe 7d cf e9 f2 e2 a8 56 =
c6 1a 02 3f 68 b2
WPS: Decrypted Encrypted Settings - hexdump(len=3D48): [REMOVED]
WPS: Processing decrypted Encrypted Settings attribute
WPS: R-SNonce1 - hexdump(len=3D16): [REMOVED]
WPS: Registrar proved knowledge of the first half of the device password
EAP-WSC: MESG -> MESG
WPS: Building Message M5
WPS:  * Version (hardcoded 0x10)
WPS:  * Message Type (9)
WPS:  * Registrar Nonce
WPS:  * E-SNonce1
WPS:  * Key Wrap Authenticator
WPS:  * Encrypted Settings
Get randomness: len=3D16 entropy=3D0
WPS:  * Version2 (0x20)
WPS:  * Authenticator
EAP-WSC: MESG -> MESG
EAP-WSC: Generating Response
EAP-WSC: Sending out 120 bytes (message sent completely)
EAP-WSC: MESG -> MESG
EAP: method process -> ignore=3DFALSE methodState=3DMAY_CONT decision=3DF=
AIL
EAP: EAP entering state SEND_RESPONSE
EAP: EAP entering state IDLE
EAPOL: SUPP_BE entering state RESPONSE
EAPOL: txSuppRsp
TX EAPOL: dst=3D62:21:c0:99:08:b1
TX EAPOL - hexdump(len=3D138): 01 00 00 86 02 95 00 86 fe 00 37 2a 00 00 =
00 01 04 00 10 4a 00 01 10 10 22 00 01 09 10 39 00 10 e9 f3 fd c8 b8 99 d=
e 1c 76 ea ea e8 27 15 bb 53 10 18 00 40 64 22 bd af 84 52 47 21 c0 38 36=
 fe 43 e8 27 83 98 e3 15 db 88 bf 54 b5 63 4b 68 1d 51 78 09 7b 81 73 ed =
dc 15 74 36 ed e8 57 a7 ef be 0a 26 e9 d9 56 a8 6c 7d 47 24 fe a9 36 f4 0=
f 9f ab be e0 10 49 00 06 00 37 2a 00 01 20 10 05 00 08 c3 ab cb 02 d7 40=
 8c eb
EAPOL: SUPP_BE entering state RECEIVE
p2p-wlan5-0: RX EAPOL from 62:21:c0:99:08:b1
RX EAPOL - hexdump(len=3D138): 02 00 00 86 01 96 00 86 fe 00 37 2a 00 00 =
00 01 04 00 10 4a 00 01 10 10 22 00 01 0a 10 1a 00 10 6b 64 05 a1 88 05 1=
7 2b 67 cc 78 5a af fe 74 35 10 18 00 40 f7 3d 7f 8e 5f 1b 2a b9 72 a4 65=
 fb a1 1c b7 da df e1 c4 30 63 11 00 e0 7f 53 f8 d1 8e 62 ed a0 b0 c4 07 =
3f e1 af f0 6a b3 b4 75 17 1b 86 d9 d2 de 73 cd 4b 1e 6f 20 1e 68 ec cc 1=
7 65 fe aa 45 10 49 00 06 00 37 2a 00 01 20 10 05 00 08 4a e4 59 eb 4a 7d=
 1f 67
EAPOL: Received EAP-Packet frame
EAPOL: SUPP_BE entering state REQUEST
EAPOL: getSuppRsp
EAP: EAP entering state RECEIVED
EAP: Received EAP-Request id=3D150 method=3D254 vendor=3D14122 vendorMeth=
od=3D1
EAP: EAP entering state METHOD
EAP-WSC: Received packet: Op-Code 4 Flags 0x0 Message Length 0
WPS: Processing received message (len=3D120 op_code=3D4)
WPS: Received WSC_MSG
WPS: Received M6
WPS: Encrypted Settings - hexdump(len=3D64): f7 3d 7f 8e 5f 1b 2a b9 72 a=
4 65 fb a1 1c b7 da df e1 c4 30 63 11 00 e0 7f 53 f8 d1 8e 62 ed a0 b0 c4=
 07 3f e1 af f0 6a b3 b4 75 17 1b 86 d9 d2 de 73 cd 4b 1e 6f 20 1e 68 ec =
cc 17 65 fe aa 45
WPS: Decrypted Encrypted Settings - hexdump(len=3D48): [REMOVED]
WPS: Processing decrypted Encrypted Settings attribute
WPS: R-SNonce2 - hexdump(len=3D16): [REMOVED]
WPS: Registrar proved knowledge of the second half of the device password=

EAP-WSC: MESG -> MESG
WPS: Building Message M7
WPS:  * Version (hardcoded 0x10)
WPS:  * Message Type (11)
WPS:  * Registrar Nonce
WPS:  * E-SNonce2
WPS:  * Key Wrap Authenticator
WPS:  * Encrypted Settings
Get randomness: len=3D16 entropy=3D0
WPS:  * Version2 (0x20)
WPS:  * Authenticator
EAP-WSC: MESG -> MESG
EAP-WSC: Generating Response
EAP-WSC: Sending out 120 bytes (message sent completely)
EAP-WSC: MESG -> MESG
EAP: method process -> ignore=3DFALSE methodState=3DMAY_CONT decision=3DF=
AIL
EAP: EAP entering state SEND_RESPONSE
EAP: EAP entering state IDLE
EAPOL: SUPP_BE entering state RESPONSE
EAPOL: txSuppRsp
TX EAPOL: dst=3D62:21:c0:99:08:b1
TX EAPOL - hexdump(len=3D138): 01 00 00 86 02 96 00 86 fe 00 37 2a 00 00 =
00 01 04 00 10 4a 00 01 10 10 22 00 01 0b 10 39 00 10 e9 f3 fd c8 b8 99 d=
e 1c 76 ea ea e8 27 15 bb 53 10 18 00 40 7e d2 df e4 7d 47 52 62 85 dd 4e=
 ab 0a 21 8f 92 dc f5 87 a2 fa af 61 02 5d 47 cf 66 a2 25 b4 29 17 31 6a =
53 6a 25 39 63 c9 a8 40 5e c8 f8 eb 1d ce 56 53 eb 23 d9 95 a1 b1 f9 93 4=
c 98 9e 8a 50 10 49 00 06 00 37 2a 00 01 20 10 05 00 08 29 df 12 6c 49 87=
 fd b9
EAPOL: SUPP_BE entering state RECEIVE
p2p-wlan5-0: RX EAPOL from 62:21:c0:99:08:b1
RX EAPOL - hexdump(len=3D234): 02 00 00 e6 01 97 00 e6 fe 00 37 2a 00 00 =
00 01 04 00 10 4a 00 01 10 10 22 00 01 0c 10 1a 00 10 6b 64 05 a1 88 05 1=
7 2b 67 cc 78 5a af fe 74 35 10 18 00 a0 8b 5a 41 70 40 1f d6 75 50 53 da=
 6e ce 4f c3 d6 a6 ea 90 75 b1 0c 03 ba 81 8e e2 22 80 f5 37 1c a0 7d 5c =
fd e8 a1 f6 93 74 3f b8 44 75 b7 07 a9 3b 0b 35 96 95 48 61 2b 4f 67 2d 1=
6 01 a6 3c c0 e2 63 8f ce e2 97 a0 ff d4 f0 bc af 90 f3 0b a6 31 ba 14 5a=
 2a 86 b2 cd 86 dc de 7c 9e 7c e2 f9 04 81 fc 12 af f7 8d 0a b7 36 5f 33 =
35 2a 8e 05 4e 2b 68 4a be de ca ff ed 36 33 91 67 27 35 dc 38 6a e1 3c 8=
0 44 45 40 c6 6a 8d 6e fe e9 ee 5c 62 79 b0 44 e1 34 74 66 dd 42 07 45 80=
 87 f0 b3 10 49 00 06 00 37 2a 00 01 20 10 05 00 08 7f 2f d1 2d 0d b8 2a =
71
EAPOL: Received EAP-Packet frame
EAPOL: SUPP_BE entering state REQUEST
EAPOL: getSuppRsp
EAP: EAP entering state RECEIVED
EAP: Received EAP-Request id=3D151 method=3D254 vendor=3D14122 vendorMeth=
od=3D1
EAP: EAP entering state METHOD
EAP-WSC: Received packet: Op-Code 4 Flags 0x0 Message Length 0
WPS: Processing received message (len=3D216 op_code=3D4)
WPS: Received WSC_MSG
WPS: Received M8
WPS: Encrypted Settings - hexdump(len=3D160): 8b 5a 41 70 40 1f d6 75 50 =
53 da 6e ce 4f c3 d6 a6 ea 90 75 b1 0c 03 ba 81 8e e2 22 80 f5 37 1c a0 7=
d 5c fd e8 a1 f6 93 74 3f b8 44 75 b7 07 a9 3b 0b 35 96 95 48 61 2b 4f 67=
 2d 16 01 a6 3c c0 e2 63 8f ce e2 97 a0 ff d4 f0 bc af 90 f3 0b a6 31 ba =
14 5a 2a 86 b2 cd 86 dc de 7c 9e 7c e2 f9 04 81 fc 12 af f7 8d 0a b7 36 5=
f 33 35 2a 8e 05 4e 2b 68 4a be de ca ff ed 36 33 91 67 27 35 dc 38 6a e1=
 3c 80 44 45 40 c6 6a 8d 6e fe e9 ee 5c 62 79 b0 44 e1 34 74 66 dd 42 07 =
45 80 87 f0 b3
WPS: Decrypted Encrypted Settings - hexdump(len=3D144): [REMOVED]
WPS: Processing decrypted Encrypted Settings attribute
WPS: Received Credential
WPS: Process Credential
WPS: Network Index: 1
WPS: SSID - hexdump_ascii(len=3D22):
     44 49 52 45 43 54 2d 66 43 2d 41 6e 64 72 6f 69   DIRECT-fC-Androi
     64 5f 61 37 63 61                                 d_a7ca         =20
WPS: Authentication Type: 0x20
WPS: Encryption Type: 0x8
WPS: Network Key - hexdump(len=3D64): [REMOVED]
WPS: MAC Address 02:0b:6b:7f:92:56
p2p-wlan5-0: WPS-CRED-RECEIVED=20
WPS: Received Credential attribute - hexdump(len=3D125): [REMOVED]
WPS: SSID - hexdump_ascii(len=3D22):
     44 49 52 45 43 54 2d 66 43 2d 41 6e 64 72 6f 69   DIRECT-fC-Androi
     64 5f 61 37 63 61                                 d_a7ca         =20
WPS: Authentication Type 0x20
WPS: Encryption Type 0x8
WPS: Network Key Index 0
WPS: Network Key - hexdump(len=3D64): [REMOVED]
WPS: MAC Address 02:0b:6b:7f:92:56
WPS: Replace WPS network block based on the received credential
WPS: The AP was not found from BSS table - use credential as-is
EAP-WSC: MESG -> MESG
WPS: Building Message WSC_Done
WPS:  * Version (hardcoded 0x10)
WPS:  * Message Type (15)
WPS:  * Enrollee Nonce
WPS:  * Registrar Nonce
WPS:  * Version2 (0x20)
p2p-wlan5-0: WPS-SUCCESS=20
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 21 Group Capability 49
P2P: Attribute 13 length 33
P2P: * Device Info: addr 62:21:c0:99:88:b1 primary device type 10-0050F20=
4-5 device name 'Android_a7ca' config methods 0x188
P2P: Attribute 14 length 0
P2P: * Group Info
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 21 Group Capability 49
P2P: Attribute 13 length 33
P2P: * Device Info: addr 62:21:c0:99:88:b1 primary device type 10-0050F20=
4-5 device name 'Android_a7ca' config methods 0x188
P2P: Attribute 14 length 0
P2P: * Group Info
P2P: Checking whether group is persistent: group_capab=3D0x49
P2P: GO Device Address 62:21:c0:99:88:b1
P2P: BSS 62:21:c0:99:08:b1 group_capab=3D0x49 go_dev_addr=3D62:21:c0:99:8=
8:b1
P2P: Group Formation completed successfully with 62:21:c0:99:08:b1
P2P: Clear timeout (state=3DPROVISIONING)
P2P: State PROVISIONING -> IDLE
P2P-GROUP-FORMATION-SUCCESS=20
CTRL_IFACE monitor send - hexdump(len=3D46): 2f 74 6d 70 2f 73 61 6d 70 6=
c 65 5f 77 69 64 69 5f 77 70 61 5f 73 75 70 70 6c 69 63 61 6e 74 2e 54 6b=
 4d 4e 5a 54 2f 73 6f 63 6b 65 74 00
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 21 Group Capability 49
P2P: Attribute 13 length 33
P2P: * Device Info: addr 62:21:c0:99:88:b1 primary device type 10-0050F20=
4-5 device name 'Android_a7ca' config methods 0x188
P2P: Attribute 14 length 0
P2P: * Group Info
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 21 Group Capability 49
P2P: Attribute 13 length 33
P2P: * Device Info: addr 62:21:c0:99:88:b1 primary device type 10-0050F20=
4-5 device name 'Android_a7ca' config methods 0x188
P2P: Attribute 14 length 0
P2P: * Group Info
P2P: Checking whether group is persistent: group_capab=3D0x49
P2P: GO Device Address 62:21:c0:99:88:b1
P2P: BSS 62:21:c0:99:08:b1 group_capab=3D0x49 go_dev_addr=3D62:21:c0:99:8=
8:b1
EAP-WSC: MESG -> MESG
EAP-WSC: Generating Response
EAP-WSC: Sending out 60 bytes (message sent completely)
EAP-WSC: MESG -> FAIL
EAP: method process -> ignore=3DFALSE methodState=3DDONE decision=3DFAIL
EAP: EAP entering state SEND_RESPONSE
EAP: EAP entering state IDLE
EAPOL: SUPP_BE entering state RESPONSE
EAPOL: txSuppRsp
TX EAPOL: dst=3D62:21:c0:99:08:b1
TX EAPOL - hexdump(len=3D78): 01 00 00 4a 02 97 00 4a fe 00 37 2a 00 00 0=
0 01 05 00 10 4a 00 01 10 10 22 00 01 0f 10 1a 00 10 6b 64 05 a1 88 05 17=
 2b 67 cc 78 5a af fe 74 35 10 39 00 10 e9 f3 fd c8 b8 99 de 1c 76 ea ea =
e8 27 15 bb 53 10 49 00 06 00 37 2a 00 01 20
EAPOL: SUPP_BE entering state RECEIVE
p2p-wlan5-0: RX EAPOL from 62:21:c0:99:08:b1
RX EAPOL - hexdump(len=3D8): 02 00 00 04 04 97 00 04
EAPOL: Received EAP-Packet frame
EAPOL: SUPP_BE entering state REQUEST
EAPOL: getSuppRsp
EAP: EAP entering state RECEIVED
EAP: Received EAP-Failure
EAP: Status notification: completion (param=3Dfailure)
EAP: EAP entering state FAILURE
p2p-wlan5-0: CTRL-EVENT-EAP-FAILURE EAP authentication failed
EAPOL: SUPP_PAE entering state HELD
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 62:21:c0:99:08:b1
EAPOL: SUPP_BE entering state RECEIVE
EAPOL: SUPP_BE entering state FAIL
EAPOL: SUPP_BE entering state IDLE
EAPOL authentication completed unsuccessfully
WPS: Network configuration replaced - try to associate with the received =
credential (freq=3D2412)
p2p-wlan5-0: Request to deauthenticate - bssid=3D62:21:c0:99:08:b1 pendin=
g_bssid=3D00:00:00:00:00:00 reason=3D3 state=3DASSOCIATED
wpa_driver_nl80211_deauthenticate(addr=3D62:21:c0:99:08:b1 reason_code=3D=
3)
p2p-wlan5-0: Event DEAUTH (12) received
p2p-wlan5-0: Deauthentication notification
p2p-wlan5-0:  * reason 3 (locally generated)
Deauthentication frame IE(s) - hexdump(len=3D0): [NULL]
p2p-wlan5-0: CTRL-EVENT-DISCONNECTED bssid=3D62:21:c0:99:08:b1 reason=3D3=
 locally_generated=3D1
p2p-wlan5-0: Auto connect enabled: try to reconnect (wps=3D1 wpa_state=3D=
6)
p2p-wlan5-0: Setting scan request: 0 sec 100000 usec
Added BSSID 62:21:c0:99:08:b1 into blacklist
p2p-wlan5-0: Blacklist count 1 --> request scan in 100 ms
p2p-wlan5-0: Setting scan request: 0 sec 100000 usec
p2p-wlan5-0: P2P: Station mode scan operation not pending anymore (sta_sc=
an_pending=3D0 p2p_cb_on_scan_complete=3D0)
p2p-wlan5-0: Disconnect event - remove keys
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D0 addr=3D(nil) key_idx=3D0 =
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D0 addr=3D(nil) key_idx=3D1 =
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D0 addr=3D(nil) key_idx=3D2 =
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D0 addr=3D(nil) key_idx=3D3 =
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D0 addr=3D0x1fa9540 key_idx=3D=
0 set_tx=3D0 seq_len=3D0 key_len=3D0
   addr=3D62:21:c0:99:08:b1
p2p-wlan5-0: State: ASSOCIATED -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=3D-1, operstate=3D5
P2P: Do not use P2P group idle timeout while waiting for initial 4-way ha=
ndshake to complete
EAPOL: External notification - portEnabled=3D0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
EAPOL: SUPP_BE entering state INITIALIZE
EAP: EAP entering state DISABLED
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
EAPOL: External notification - portValid=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
p2p-wlan5-0: No keys have been configured - skip key clearing
p2p-wlan5-0: State: DISCONNECTED -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=3D-1, operstate=3D5
EAPOL: External notification - portEnabled=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
EAPOL: External notification - portValid=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
WPS: Checking whether fast association without a new scan can be used
p2p-wlan5-0: Selecting BSS from priority group 0
p2p-wlan5-0: 0: 62:21:c0:99:08:b1 ssid=3D'DIRECT-fC-Android_a7ca' wpa_ie_=
len=3D0 rsn_ie_len=3D20 caps=3D0x511 level=3D-15 wps
p2p-wlan5-0:    skip - blacklisted (count=3D1 limit=3D0)
p2p-wlan5-0: No APs found - clear blacklist and try again
Removed BSSID 62:21:c0:99:08:b1 from blacklist (clear)
p2p-wlan5-0: Selecting BSS from priority group 0
p2p-wlan5-0: 0: 62:21:c0:99:08:b1 ssid=3D'DIRECT-fC-Android_a7ca' wpa_ie_=
len=3D0 rsn_ie_len=3D20 caps=3D0x511 level=3D-15 wps
p2p-wlan5-0:    selected based on RSN IE
p2p-wlan5-0:    selected BSS 62:21:c0:99:08:b1 ssid=3D'DIRECT-fC-Android_=
a7ca'
p2p-wlan5-0: Selecting BSS from priority group 0
p2p-wlan5-0: 0: 62:21:c0:99:08:b1 ssid=3D'DIRECT-fC-Android_a7ca' wpa_ie_=
len=3D0 rsn_ie_len=3D20 caps=3D0x511 level=3D-15 wps
p2p-wlan5-0:    selected based on RSN IE
p2p-wlan5-0:    selected BSS 62:21:c0:99:08:b1 ssid=3D'DIRECT-fC-Android_=
a7ca'
p2p-wlan5-0: Considering connect request: reassociate: 1  selected: 62:21=
:c0:99:08:b1  bssid: 00:00:00:00:00:00  pending: 00:00:00:00:00:00  wpa_s=
tate: DISCONNECTED  ssid=3D0x1faae00  current_ssid=3D(nil)
p2p-wlan5-0: Request association with 62:21:c0:99:08:b1
p2p-wlan5-0: Automatic auth_alg selection: 0x1
p2p-wlan5-0: Overriding auth_alg selection: 0x1
RSN: PMKSA cache search - network_ctx=3D(nil) try_opportunistic=3D0
RSN: Search for BSSID 62:21:c0:99:08:b1
RSN: No PMKSA cache entry found
p2p-wlan5-0: RSN: using IEEE 802.11i/D9.0
p2p-wlan5-0: WPA: Selected cipher suites: group 16 pairwise 16 key_mgmt 2=
 proto 2
p2p-wlan5-0: WPA: clearing AP WPA IE
WPA: set AP RSN IE - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 00 00 =
0f ac 04 01 00 00 0f ac 02 0c 00
p2p-wlan5-0: WPA: using GTK CCMP
p2p-wlan5-0: WPA: using PTK CCMP
p2p-wlan5-0: WPA: using KEY_MGMT WPA-PSK
WPA: Set own WPA IE default - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 =
01 00 00 0f ac 04 01 00 00 0f ac 02 00 00
P2P: * P2P IE header
P2P: * Capability dev=3D27 group=3D00
P2P: * Device Info
p2p-wlan5-0: Cancelling scan request
p2p-wlan5-0: P2P: Station mode scan operation not pending anymore (sta_sc=
an_pending=3D0 p2p_cb_on_scan_complete=3D0)
p2p-wlan5-0: SME: Trying to authenticate with 62:21:c0:99:08:b1 (SSID=3D'=
DIRECT-fC-Android_a7ca' freq=3D2412 MHz)
p2p-wlan5-0: No keys have been configured - skip key clearing
p2p-wlan5-0: State: DISCONNECTED -> AUTHENTICATING
EAPOL: External notification - EAP success=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
EAPOL: External notification - EAP fail=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
EAPOL: External notification - portControl=3DAuto
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
nl80211: Authenticate (ifindex=3D6)
  * bssid=3D62:21:c0:99:08:b1
  * freq=3D2412
  * SSID - hexdump_ascii(len=3D22):
     44 49 52 45 43 54 2d 66 43 2d 41 6e 64 72 6f 69   DIRECT-fC-Androi
     64 5f 61 37 63 61                                 d_a7ca         =20
  * IEs - hexdump(len=3D0): [NULL]
  * Auth Type 0
nl80211: Authentication request send successfully
nl80211: Event message available
nl80211: Delete station 62:21:c0:99:08:b1
nl80211: Event message available
nl80211: MLME event 39 on p2p-wlan5-0(02:0b:6b:7f:92:56) A1=3D62:21:c0:99=
:08:b1 A2=3D02:0b:6b:7f:92:56
nl80211: MLME event frame - hexdump(len=3D26): c0 00 00 00 62 21 c0 99 08=
 b1 02 0b 6b 7f 92 56 62 21 c0 99 08 b1 00 00 03 00
nl80211: Deauthenticate event
p2p-wlan5-0: Event DEAUTH (12) received
p2p-wlan5-0: Deauthentication notification
p2p-wlan5-0:  * reason 3 (locally generated)
p2p-wlan5-0:  * address 62:21:c0:99:08:b1
Deauthentication frame IE(s) - hexdump(len=3D0): [NULL]
p2p-wlan5-0: CTRL-EVENT-DISCONNECTED bssid=3D62:21:c0:99:08:b1 reason=3D3=
 locally_generated=3D1
p2p-wlan5-0: Auto connect enabled: try to reconnect (wps=3D0 wpa_state=3D=
4)
p2p-wlan5-0: Do not request new immediate scan
Added BSSID 62:21:c0:99:08:b1 into blacklist
p2p-wlan5-0: Blacklist count 2 --> request scan in 500 ms
p2p-wlan5-0: Setting scan request: 0 sec 500000 usec
p2p-wlan5-0: P2P: Station mode scan operation not pending anymore (sta_sc=
an_pending=3D0 p2p_cb_on_scan_complete=3D0)
p2p-wlan5-0: Disconnect event - remove keys
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D0 addr=3D(nil) key_idx=3D0 =
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D0 addr=3D(nil) key_idx=3D1 =
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D0 addr=3D(nil) key_idx=3D2 =
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D0 addr=3D(nil) key_idx=3D3 =
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D0 addr=3D0x1fa9540 key_idx=3D=
0 set_tx=3D0 seq_len=3D0 key_len=3D0
   addr=3D00:00:00:00:00:00
p2p-wlan5-0: State: AUTHENTICATING -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=3D-1, operstate=3D5
EAPOL: External notification - portEnabled=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
EAPOL: External notification - portValid=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
EAPOL: External notification - EAP success=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
p2p-wlan5-0: SME: Allow pending authentication to proceed after disconnec=
tion event
p2p-wlan5-0: State: DISCONNECTED -> AUTHENTICATING
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x1003 ([UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan5-0' added
nl80211: if_removed already cleared - ignore event
nl80211: Event message available
nl80211: Ignore disconnect event when using userspace SME
nl80211: Event message available
nl80211: New station 62:21:c0:99:08:b1
nl80211: Event message available
nl80211: MLME event 37 on p2p-wlan5-0(02:0b:6b:7f:92:56) A1=3D02:0b:6b:7f=
:92:56 A2=3D62:21:c0:99:08:b1
nl80211: MLME event frame - hexdump(len=3D41): b0 00 3c 00 02 0b 6b 7f 92=
 56 62 21 c0 99 08 b1 62 21 c0 99 08 b1 a0 02 00 00 02 00 00 00 dd 09 00 =
10 18 02 00 00 0c 00 00
nl80211: Authenticate event
p2p-wlan5-0: Event AUTH (11) received
p2p-wlan5-0: SME: Authentication response: peer=3D62:21:c0:99:08:b1 auth_=
type=3D0 auth_transaction=3D2 status_code=3D0
SME: Authentication response IEs - hexdump(len=3D11): dd 09 00 10 18 02 0=
0 00 0c 00 00
p2p-wlan5-0: Trying to associate with 62:21:c0:99:08:b1 (SSID=3D'DIRECT-f=
C-Android_a7ca' freq=3D2412 MHz)
p2p-wlan5-0: State: AUTHENTICATING -> ASSOCIATING
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=3D-1, operstate=3D5
WPA: set own WPA/RSN IE - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 0=
0 00 0f ac 04 01 00 00 0f ac 02 00 00
nl80211: Associate (ifindex=3D6)
  * bssid=3D62:21:c0:99:08:b1
  * freq=3D2412
  * SSID - hexdump_ascii(len=3D22):
     44 49 52 45 43 54 2d 66 43 2d 41 6e 64 72 6f 69   DIRECT-fC-Androi
     64 5f 61 37 63 61                                 d_a7ca         =20
  * IEs - hexdump(len=3D80): 30 14 01 00 00 0f ac 04 01 00 00 0f ac 04 01=
 00 00 0f ac 02 00 00 dd 0d 50 6f 9a 0a 00 00 06 00 11 00 00 00 00 dd 29 =
50 6f 9a 09 02 02 00 27 00 0d 1d 00 00 0b 6b 7f 92 56 01 08 00 01 00 50 f=
2 04 00 01 00 10 11 00 08 6b 65 76 69 6e 2d 70 63
  * pairwise=3D0xfac04
  * group=3D0xfac04
  * P2P group
nl80211: Association request send successfully
nl80211: Event message available
nl80211: Regulatory domain change
p2p-wlan5-0: Event CHANNEL_LIST_CHANGED (31) received
nl80211: Regulatory information - country=3D00
nl80211: 2402-2472 @ 40 MHz
nl80211: 2457-2482 @ 20 MHz
nl80211: 2474-2494 @ 20 MHz
nl80211: 5170-5250 @ 40 MHz
nl80211: 5735-5835 @ 40 MHz
nl80211: Added 802.11b mode based on 802.11g information
P2P: Add operating class 81
P2P: Channels - hexdump(len=3D11): 01 02 03 04 05 06 07 08 09 0a 0b
P2P: Update channel list
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan5-0' added
nl80211: if_removed already cleared - ignore event
RTM_NEWLINK: operstate=3D0 ifi_flags=3D0x11003 ([UP][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan5-0' added
nl80211: if_removed already cleared - ignore event
nl80211: Event message available
nl80211: MLME event 38 on p2p-wlan5-0(02:0b:6b:7f:92:56) A1=3D02:0b:6b:7f=
:92:56 A2=3D62:21:c0:99:08:b1
nl80211: MLME event frame - hexdump(len=3D176): 10 00 3c 00 02 0b 6b 7f 9=
2 56 62 21 c0 99 08 b1 62 21 c0 99 08 b1 b0 02 31 04 00 00 01 c0 01 08 8c=
 12 98 24 b0 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 3d 16 01 08 04 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00 00 00 00 00 00 dd 0d 50 6f 9a 0a 00 00 06 01 10 c0 00 00=
 28 dd 18 00 50 f2 04 10 4a 00 01 10 10 3b 00 01 03 10 49 00 06 00 37 2a =
00 01 20 dd 09 00 10 18 02 00 00 0c 00 00 dd 18 00 50 f2 02 01 01 84 00 0=
3 64 00 00 27 a4 00 00 41 43 5e 00 61 32 2f 00 dd 04 50 6f 9a 09
nl80211: Associate event
p2p-wlan5-0: Event ASSOC (0) received
p2p-wlan5-0: Association info event
resp_ies - hexdump(len=3D146): 01 08 8c 12 98 24 b0 48 60 6c 2d 1a 20 10 =
1a ff 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 3=
d 16 01 08 04 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 dd=
 0d 50 6f 9a 0a 00 00 06 01 10 c0 00 00 28 dd 18 00 50 f2 04 10 4a 00 01 =
10 10 3b 00 01 03 10 49 00 06 00 37 2a 00 01 20 dd 09 00 10 18 02 00 00 0=
c 00 00 dd 18 00 50 f2 02 01 01 84 00 03 64 00 00 27 a4 00 00 41 43 5e 00=
 61 32 2f 00 dd 04 50 6f 9a 09
p2p-wlan5-0: freq=3D2412 MHz
p2p-wlan5-0: State: ASSOCIATING -> ASSOCIATED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=3D-1, operstate=3D5
p2p-wlan5-0: Associated to a new BSS: BSSID=3D62:21:c0:99:08:b1
p2p-wlan5-0: No keys have been configured - skip key clearing
p2p-wlan5-0: Associated with 62:21:c0:99:08:b1
p2p-wlan5-0: WPA: Association event - clear replay counter
p2p-wlan5-0: WPA: Clear old PTK
EAPOL: External notification - portEnabled=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 62:21:c0:99:08:b1
EAPOL: External notification - portValid=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 62:21:c0:99:08:b1
EAPOL: External notification - portEnabled=3D1
EAPOL: SUPP_PAE entering state CONNECTING
EAPOL: SUPP_BE entering state IDLE
p2p-wlan5-0: Setting authentication timeout: 10 sec 0 usec
p2p-wlan5-0: Cancelling scan request
p2p-wlan5-0: P2P: Station mode scan operation not pending anymore (sta_sc=
an_pending=3D0 p2p_cb_on_scan_complete=3D0)
nl80211: Event message available
nl80211: Ignore connect event (cmd=3D46) when using userspace SME
nl80211: Event message available
nl80211: Regulatory domain change
p2p-wlan5-0: Event CHANNEL_LIST_CHANGED (31) received
nl80211: Regulatory information - country=3DUS
nl80211: 2402-2472 @ 40 MHz
nl80211: 5170-5250 @ 40 MHz
nl80211: 5250-5330 @ 40 MHz
nl80211: 5490-5600 @ 40 MHz
nl80211: 5650-5710 @ 40 MHz
nl80211: 5735-5835 @ 40 MHz
nl80211: Added 802.11b mode based on 802.11g information
P2P: Add operating class 81
P2P: Channels - hexdump(len=3D11): 01 02 03 04 05 06 07 08 09 0a 0b
P2P: Update channel list
nl80211: Event message available
nl80211: Regulatory domain change
p2p-wlan5-0: Event CHANNEL_LIST_CHANGED (31) received
nl80211: Regulatory information - country=3DGB
nl80211: 2402-2482 @ 40 MHz
nl80211: 5170-5250 @ 40 MHz
nl80211: 5250-5330 @ 40 MHz
nl80211: 5490-5710 @ 40 MHz
nl80211: Added 802.11b mode based on 802.11g information
P2P: Add operating class 81
P2P: Channels - hexdump(len=3D11): 01 02 03 04 05 06 07 08 09 0a 0b
P2P: Update channel list
p2p-wlan5-0: RX EAPOL from 62:21:c0:99:08:b1
RX EAPOL - hexdump(len=3D99): 02 03 00 5f 02 00 8a 00 10 00 00 00 00 00 0=
0 00 01 67 66 bd 2c 37 f9 5c 35 40 9e cf 1b 61 86 d0 3d 38 e9 7b a1 10 38=
 ac 5b 1b 8e fd 49 41 66 23 27 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00 00 00 00 00 00 00
p2p-wlan5-0: Setting authentication timeout: 10 sec 0 usec
EAPOL: Ignoring WPA EAPOL-Key frame in EAPOL state machines
p2p-wlan5-0: IEEE 802.1X RX: version=3D2 type=3D3 length=3D95
p2p-wlan5-0:   EAPOL-Key type=3D2
p2p-wlan5-0:   key_info 0x8a (ver=3D2 keyidx=3D0 rsvd=3D0 Pairwise Ack)
p2p-wlan5-0:   key_length=3D16 key_data_length=3D0
  replay_counter - hexdump(len=3D8): 00 00 00 00 00 00 00 01
  key_nonce - hexdump(len=3D32): 67 66 bd 2c 37 f9 5c 35 40 9e cf 1b 61 8=
6 d0 3d 38 e9 7b a1 10 38 ac 5b 1b 8e fd 49 41 66 23 27
  key_iv - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00
  key_rsc - hexdump(len=3D8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=3D8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00
WPA: RX EAPOL-Key - hexdump(len=3D99): 02 03 00 5f 02 00 8a 00 10 00 00 0=
0 00 00 00 00 01 67 66 bd 2c 37 f9 5c 35 40 9e cf 1b 61 86 d0 3d 38 e9 7b=
 a1 10 38 ac 5b 1b 8e fd 49 41 66 23 27 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00 00 00 00 00 00 00 00 00 00 00 00 00 00
p2p-wlan5-0: State: ASSOCIATED -> 4WAY_HANDSHAKE
p2p-wlan5-0: WPA: RX message 1 of 4-Way Handshake from 62:21:c0:99:08:b1 =
(ver=3D2)
RSN: msg 1/4 key data - hexdump(len=3D0):
Get randomness: len=3D32 entropy=3D1
WPA: Renewed SNonce - hexdump(len=3D32): d3 c2 e7 ac 0e 53 af 0f 75 13 c3=
 d1 9a c6 00 12 cc 5a f5 d3 f2 37 cf 41 60 7b be ab c0 08 87 55
WPA: PTK derivation - A1=3D02:0b:6b:7f:92:56 A2=3D62:21:c0:99:08:b1
WPA: Nonce1 - hexdump(len=3D32): d3 c2 e7 ac 0e 53 af 0f 75 13 c3 d1 9a c=
6 00 12 cc 5a f5 d3 f2 37 cf 41 60 7b be ab c0 08 87 55
WPA: Nonce2 - hexdump(len=3D32): 67 66 bd 2c 37 f9 5c 35 40 9e cf 1b 61 8=
6 d0 3d 38 e9 7b a1 10 38 ac 5b 1b 8e fd 49 41 66 23 27
WPA: PMK - hexdump(len=3D32): [REMOVED]
WPA: PTK - hexdump(len=3D48): [REMOVED]
WPA: WPA IE for msg 2/4 - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 0=
0 00 0f ac 04 01 00 00 0f ac 02 00 00
WPA: Replay Counter - hexdump(len=3D8): 00 00 00 00 00 00 00 01
p2p-wlan5-0: WPA: Sending EAPOL-Key 2/4
WPA: KCK - hexdump(len=3D16): [REMOVED]
WPA: Derived Key MIC - hexdump(len=3D16): 5b 7d 84 c5 4a 6f 06 17 07 d0 4=
d 21 e7 17 ac 35
WPA: TX EAPOL-Key - hexdump(len=3D121): 01 03 00 75 02 01 0a 00 00 00 00 =
00 00 00 00 00 01 d3 c2 e7 ac 0e 53 af 0f 75 13 c3 d1 9a c6 00 12 cc 5a f=
5 d3 f2 37 cf 41 60 7b be ab c0 08 87 55 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 5b 7d 84 =
c5 4a 6f 06 17 07 d0 4d 21 e7 17 ac 35 00 16 30 14 01 00 00 0f ac 04 01 0=
0 00 0f ac 04 01 00 00 0f ac 02 00 00
p2p-wlan5-0: RX EAPOL from 62:21:c0:99:08:b1
RX EAPOL - hexdump(len=3D155): 02 03 00 97 02 13 ca 00 10 00 00 00 00 00 =
00 00 02 67 66 bd 2c 37 f9 5c 35 40 9e cf 1b 61 86 d0 3d 38 e9 7b a1 10 3=
8 ac 5b 1b 8e fd 49 41 66 23 27 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e6 83 5c 0b 60 99 =
aa c0 fc 36 13 58 b8 27 24 fa 00 38 e7 bb bd a3 24 3e 66 f4 54 b3 a2 99 6=
9 2b 7a f1 b5 f4 77 e1 87 ae 03 ca ed e2 eb 89 e7 0a 02 0c c2 f7 98 67 5a=
 d5 bc d3 57 3d 0d 55 5b c1 e4 fc 0d fc b7 8f d1 a8 e9 3d
EAPOL: Ignoring WPA EAPOL-Key frame in EAPOL state machines
p2p-wlan5-0: IEEE 802.1X RX: version=3D2 type=3D3 length=3D151
p2p-wlan5-0:   EAPOL-Key type=3D2
p2p-wlan5-0:   key_info 0x13ca (ver=3D2 keyidx=3D0 rsvd=3D0 Pairwise Inst=
all Ack MIC Secure Encr)
p2p-wlan5-0:   key_length=3D16 key_data_length=3D56
  replay_counter - hexdump(len=3D8): 00 00 00 00 00 00 00 02
  key_nonce - hexdump(len=3D32): 67 66 bd 2c 37 f9 5c 35 40 9e cf 1b 61 8=
6 d0 3d 38 e9 7b a1 10 38 ac 5b 1b 8e fd 49 41 66 23 27
  key_iv - hexdump(len=3D16): 00 00 00 00 00 00 00 00 00 00 00 00 00 00 0=
0 00
  key_rsc - hexdump(len=3D8): 00 00 00 00 00 00 00 00
  key_id (reserved) - hexdump(len=3D8): 00 00 00 00 00 00 00 00
  key_mic - hexdump(len=3D16): e6 83 5c 0b 60 99 aa c0 fc 36 13 58 b8 27 =
24 fa
WPA: RX EAPOL-Key - hexdump(len=3D155): 02 03 00 97 02 13 ca 00 10 00 00 =
00 00 00 00 00 02 67 66 bd 2c 37 f9 5c 35 40 9e cf 1b 61 86 d0 3d 38 e9 7=
b a1 10 38 ac 5b 1b 8e fd 49 41 66 23 27 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 e6 83 5c =
0b 60 99 aa c0 fc 36 13 58 b8 27 24 fa 00 38 e7 bb bd a3 24 3e 66 f4 54 b=
3 a2 99 69 2b 7a f1 b5 f4 77 e1 87 ae 03 ca ed e2 eb 89 e7 0a 02 0c c2 f7=
 98 67 5a d5 bc d3 57 3d 0d 55 5b c1 e4 fc 0d fc b7 8f d1 a8 e9 3d
RSN: encrypted key data - hexdump(len=3D56): e7 bb bd a3 24 3e 66 f4 54 b=
3 a2 99 69 2b 7a f1 b5 f4 77 e1 87 ae 03 ca ed e2 eb 89 e7 0a 02 0c c2 f7=
 98 67 5a d5 bc d3 57 3d 0d 55 5b c1 e4 fc 0d fc b7 8f d1 a8 e9 3d
WPA: decrypted EAPOL-Key key data - hexdump(len=3D48): [REMOVED]
p2p-wlan5-0: State: 4WAY_HANDSHAKE -> 4WAY_HANDSHAKE
p2p-wlan5-0: WPA: RX message 3 of 4-Way Handshake from 62:21:c0:99:08:b1 =
(ver=3D2)
WPA: IE KeyData - hexdump(len=3D48): 30 14 01 00 00 0f ac 04 01 00 00 0f =
ac 04 01 00 00 0f ac 02 0c 00 dd 16 00 0f ac 01 01 00 c9 06 7b c6 46 5e 7=
2 fa 2a 29 66 da 13 80 ea ff dd 00
WPA: RSN IE in EAPOL-Key - hexdump(len=3D22): 30 14 01 00 00 0f ac 04 01 =
00 00 0f ac 04 01 00 00 0f ac 02 0c 00
WPA: GTK in EAPOL-Key - hexdump(len=3D24): [REMOVED]
p2p-wlan5-0: WPA: Sending EAPOL-Key 4/4
WPA: KCK - hexdump(len=3D16): [REMOVED]
WPA: Derived Key MIC - hexdump(len=3D16): 84 42 d9 78 a4 2b fc 74 d3 ff 3=
f 6c 53 6c c8 b6
WPA: TX EAPOL-Key - hexdump(len=3D99): 01 03 00 5f 02 03 0a 00 00 00 00 0=
0 00 00 00 00 02 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 84 42 d9 7=
8 a4 2b fc 74 d3 ff 3f 6c 53 6c c8 b6 00 00
p2p-wlan5-0: WPA: Installing PTK to the driver
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D3 addr=3D0x1faa158 key_idx=3D=
0 set_tx=3D1 seq_len=3D6 key_len=3D16
   addr=3D62:21:c0:99:08:b1
EAPOL: External notification - portValid=3D1
p2p-wlan5-0: State: 4WAY_HANDSHAKE -> GROUP_HANDSHAKE
RSN: received GTK in pairwise handshake - hexdump(len=3D18): [REMOVED]
WPA: Group Key - hexdump(len=3D16): [REMOVED]
p2p-wlan5-0: WPA: Installing GTK to the driver (keyidx=3D1 tx=3D0 len=3D1=
6)
WPA: RSC - hexdump(len=3D6): 00 00 00 00 00 00
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D3 addr=3D0x4a6636 key_idx=3D=
1 set_tx=3D0 seq_len=3D6 key_len=3D16
   broadcast key
p2p-wlan5-0: WPA: Key negotiation completed with 62:21:c0:99:08:b1 [PTK=3D=
CCMP GTK=3DCCMP]
p2p-wlan5-0: Cancelling authentication timeout
Removed BSSID 62:21:c0:99:08:b1 from blacklist
p2p-wlan5-0: State: GROUP_HANDSHAKE -> COMPLETED
p2p-wlan5-0: CTRL-EVENT-CONNECTED - Connection to 62:21:c0:99:08:b1 compl=
eted [id=3D0 id_str=3D]
wpa_driver_nl80211_set_operstate: operstate 0->1 (UP)
netlink: Operstate: linkmode=3D-1, operstate=3D6
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 21 Group Capability 49
P2P: Attribute 13 length 33
P2P: * Device Info: addr 62:21:c0:99:88:b1 primary device type 10-0050F20=
4-5 device name 'Android_a7ca' config methods 0x188
P2P: Attribute 14 length 0
P2P: * Group Info
P2P: Parsing P2P IE
P2P: Attribute 2 length 2
P2P: * Device Capability 21 Group Capability 49
P2P: Attribute 13 length 33
P2P: * Device Info: addr 62:21:c0:99:88:b1 primary device type 10-0050F20=
4-5 device name 'Android_a7ca' config methods 0x188
P2P: Attribute 14 length 0
P2P: * Group Info
P2P: Checking whether group is persistent: group_capab=3D0x49
P2P: GO Device Address 62:21:c0:99:88:b1
P2P: BSS 62:21:c0:99:08:b1 group_capab=3D0x49 go_dev_addr=3D62:21:c0:99:8=
8:b1
P2P-GROUP-STARTED p2p-wlan5-0 client ssid=3D"DIRECT-fC-Android_a7ca" freq=
=3D2412 psk=3D6cdd0179f543dac4eed2aa00b905049640e9ab2f98c87df5d8db7e96616=
783f3 go_dev_addr=3D62:21:c0:99:88:b1
CTRL_IFACE monitor send - hexdump(len=3D46): 2f 74 6d 70 2f 73 61 6d 70 6=
c 65 5f 77 69 64 69 5f 77 70 61 5f 73 75 70 70 6c 69 63 61 6e 74 2e 54 6b=
 4d 4e 5a 54 2f 73 6f 63 6b 65 74 00
p2p-wlan5-0: P2P: Station mode scan operation not pending anymore (sta_sc=
an_pending=3D0 p2p_cb_on_scan_complete=3D0)
EAPOL: External notification - portValid=3D1
EAPOL: External notification - EAP success=3D1
EAPOL: SUPP_PAE entering state AUTHENTICATING
EAPOL: SUPP_BE entering state SUCCESS
EAP: EAP entering state DISABLED
EAPOL: SUPP_PAE entering state AUTHENTICATED
EAPOL: Supplicant port status: Authorized
nl80211: Set supplicant port authorized for 62:21:c0:99:08:b1
EAPOL: SUPP_BE entering state IDLE
EAPOL authentication completed successfully
RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan5-0' added
nl80211: if_removed already cleared - ignore event
RX ctrl_iface - hexdump_ascii(len=3D26):
     50 32 50 5f 50 45 45 52 20 36 32 3a 32 31 3a 63   P2P_PEER 62:21:c
     30 3a 39 39 3a 38 38 3a 62 31                     0:99:88:b1     =20
wlan5: Control interface command 'P2P_PEER 62:21:c0:99:88:b1'
RTM_NEWLINK: operstate=3D1 ifi_flags=3D0x11043 ([UP][RUNNING][LOWER_UP])
RTM_NEWLINK, IFLA_IFNAME: Interface 'p2p-wlan5-0' added
nl80211: if_removed already cleared - ignore event
EAPOL: startWhen --> 0
EAPOL: disable timer tick
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D60:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D116): 40 00 00 00 ff ff ff ff f=
f ff 60 21 c0 99 88 b1 ff ff ff ff ff ff 20 0a 00 00 01 04 02 04 0b 16 32=
 08 0c 12 18 24 30 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 01 dd 09 00 10 18 02 00 00 0=
0 00 00 dd 1e 00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D60:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D116): 40 00 00 00 ff ff ff ff f=
f ff 60 21 c0 99 88 b1 ff ff ff ff ff ff 30 0a 00 00 01 04 02 04 0b 16 32=
 08 0c 12 18 24 30 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 01 dd 09 00 10 18 02 00 00 0=
0 00 00 dd 1e 00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D60:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D116): 40 00 00 00 ff ff ff ff f=
f ff 60 21 c0 99 88 b1 ff ff ff ff ff ff 40 0a 00 00 01 04 02 04 0b 16 32=
 08 0c 12 18 24 30 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 02 dd 09 00 10 18 02 00 00 0=
0 00 00 dd 1e 00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
nl80211: Event message available
nl80211: MLME event 59 on wlan5(00:0b:6b:7f:92:56) A1=3Dff:ff:ff:ff:ff:ff=
 A2=3D60:21:c0:99:88:b1
nl80211: MLME event frame - hexdump(len=3D116): 40 00 00 00 ff ff ff ff f=
f ff 60 21 c0 99 88 b1 ff ff ff ff ff ff 50 0a 00 00 01 04 02 04 0b 16 32=
 08 0c 12 18 24 30 48 60 6c 2d 1a 20 10 1a ff 00 00 00 00 00 00 00 00 00 =
00 00 00 00 00 00 00 00 00 00 00 00 00 03 01 02 dd 09 00 10 18 02 00 00 0=
0 00 00 dd 1e 00 90 4c 33 20 10 1a ff 00 00 00 00 00 00 00 00 00 00 00 00=
 00 00 00 00 00 00 00 00 00 00
nl80211: Frame event
wlan5: Event RX_MGMT (20) received
RX ctrl_iface - hexdump_ascii(len=3D18):
     53 45 54 20 77 69 66 69 5f 64 69 73 70 6c 61 79   SET wifi_display
     20 31                                              1             =20
wlan5: Control interface command 'SET wifi_display 1'
CTRL_IFACE SET 'wifi_display'=3D'1'
WFD: Wi-Fi Display enabled
WFD: Update WFD IE
WFD: WFD IE for Beacon - hexdump(len=3D15): dd 0d 50 6f 9a 0a 00 00 06 00=
 11 00 00 00 00
WFD: WFD IE for (Re)Association Request - hexdump(len=3D15): dd 0d 50 6f =
9a 0a 00 00 06 00 11 00 00 00 00
WFD: WFD IE for GO Negotiation - hexdump(len=3D15): dd 0d 50 6f 9a 0a 00 =
00 06 00 11 00 00 00 00
WFD: WFD IE for Provision Discovery Request - hexdump(len=3D15): dd 0d 50=
 6f 9a 0a 00 00 06 00 11 00 00 00 00
WFD: WFD IE for Probe Request - hexdump(len=3D15): dd 0d 50 6f 9a 0a 00 0=
0 06 00 11 00 00 00 00
WFD: WFD IE for Probe Response - hexdump(len=3D15): dd 0d 50 6f 9a 0a 00 =
00 06 00 11 00 00 00 00
WFD: WFD IE for P2P Invitation - hexdump(len=3D15): dd 0d 50 6f 9a 0a 00 =
00 06 00 11 00 00 00 00
WFD: WFD IE for Provision Discovery Response - hexdump(len=3D15): dd 0d 5=
0 6f 9a 0a 00 00 06 00 11 00 00 00 00
RX ctrl_iface - hexdump_ascii(len=3D10):
     50 32 50 5f 43 41 4e 43 45 4c                     P2P_CANCEL     =20
wlan5: Control interface command 'P2P_CANCEL'
P2P: Request to cancel group formation
P2P: Stopping find
P2P: Clear timeout (state=3DIDLE)
P2P: State IDLE -> IDLE
P2P: Clear timeout (state=3DIDLE)
nl80211: Disable Probe Request reporting nl_preq=3D0x1fa68c0
P2P: No ongoing group formation found
RX ctrl_iface - hexdump_ascii(len=3D28):
     50 32 50 5f 47 52 4f 55 50 5f 52 45 4d 4f 56 45   P2P_GROUP_REMOVE
     20 70 32 70 2d 77 6c 61 6e 35 2d 30                p2p-wlan5-0   =20
wlan5: Control interface command 'P2P_GROUP_REMOVE p2p-wlan5-0'
p2p-wlan5-0: Request to deauthenticate - bssid=3D62:21:c0:99:08:b1 pendin=
g_bssid=3D00:00:00:00:00:00 reason=3D3 state=3DCOMPLETED
wpa_driver_nl80211_deauthenticate(addr=3D62:21:c0:99:08:b1 reason_code=3D=
3)
p2p-wlan5-0: Event DEAUTH (12) received
p2p-wlan5-0: Deauthentication notification
p2p-wlan5-0:  * reason 3 (locally generated)
Deauthentication frame IE(s) - hexdump(len=3D0): [NULL]
p2p-wlan5-0: CTRL-EVENT-DISCONNECTED bssid=3D62:21:c0:99:08:b1 reason=3D3=
 locally_generated=3D1
p2p-wlan5-0: Auto connect disabled: do not try to re-connect
p2p-wlan5-0: Ignore connection failure indication since interface has bee=
n put into disconnected state
p2p-wlan5-0: Disconnect event - remove keys
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D0 addr=3D(nil) key_idx=3D0 =
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D0 addr=3D(nil) key_idx=3D1 =
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D0 addr=3D(nil) key_idx=3D2 =
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D0 addr=3D(nil) key_idx=3D3 =
set_tx=3D0 seq_len=3D0 key_len=3D0
wpa_driver_nl80211_set_key: ifindex=3D6 alg=3D0 addr=3D0x1fa9540 key_idx=3D=
0 set_tx=3D0 seq_len=3D0 key_len=3D0
   addr=3D62:21:c0:99:08:b1
p2p-wlan5-0: State: COMPLETED -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 1->0 (DORMANT)
netlink: Operstate: linkmode=3D-1, operstate=3D5
P2P: Set P2P group idle timeout to 10 seconds
EAPOL: External notification - portEnabled=3D0
EAPOL: SUPP_PAE entering state DISCONNECTED
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
EAPOL: SUPP_BE entering state INITIALIZE
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
EAPOL: External notification - portValid=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
p2p-wlan5-0: No keys have been configured - skip key clearing
p2p-wlan5-0: State: DISCONNECTED -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=3D-1, operstate=3D5
EAPOL: External notification - portEnabled=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
EAPOL: External notification - portValid=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
P2P-GROUP-REMOVED p2p-wlan5-0 client reason=3DREQUESTED
CTRL_IFACE monitor send - hexdump(len=3D46): 2f 74 6d 70 2f 73 61 6d 70 6=
c 65 5f 77 69 64 69 5f 77 70 61 5f 73 75 70 70 6c 69 63 61 6e 74 2e 54 6b=
 4d 4e 5a 54 2f 73 6f 63 6b 65 74 00
P2P: Cancelled P2P group idle timeout
P2P: Remove group interface p2p-wlan5-0
p2p-wlan5-0: Removing interface p2p-wlan5-0
p2p-wlan5-0: Request to deauthenticate - bssid=3D00:00:00:00:00:00 pendin=
g_bssid=3D00:00:00:00:00:00 reason=3D3 state=3DDISCONNECTED
p2p-wlan5-0: No keys have been configured - skip key clearing
p2p-wlan5-0: State: DISCONNECTED -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=3D-1, operstate=3D5
EAPOL: External notification - portEnabled=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
EAPOL: External notification - portValid=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
p2p-wlan5-0: No keys have been configured - skip key clearing
EAP: deinitialize previously used EAP method (254, WSC) at EAP deinit
p2p-wlan5-0: BSS: Remove id 0 BSSID 62:21:c0:99:08:b1 SSID 'DIRECT-fC-And=
roid_a7ca' due to wpa_bss_flush
p2p-wlan5-0: Cancelling scan request
p2p-wlan5-0: P2P: Station mode scan operation not pending anymore (sta_sc=
an_pending=3D0 p2p_cb_on_scan_complete=3D0)
p2p-wlan5-0: Cancelling authentication timeout
netlink: Operstate: linkmode=3D0, operstate=3D6
nl80211: Set mode ifindex 6 iftype 2 (STATION)
nl80211: Unsubscribe mgmt frames handle 0x1fa8b10 (mode change)
Control interface directory not empty - leaving it behind
nl80211: wpa_driver_nl80211_if_remove(type=3D4 ifname=3Dp2p-wlan5-0) ifin=
dex=3D6
nl80211: Remove interface ifindex=3D6
nl80211: Ignore event for foreign ifindex 6
nl80211: Ignore event for foreign ifindex 6
nl80211: Ignore event for foreign ifindex 6
nl80211: Ignore event for foreign ifindex 6
nl80211: Ignore dellink event for foreign ifindex 6
nl80211: Event message available
nl80211: Event message available
nl80211: Event message available
nl80211: Event message available
nl80211: Regulatory domain change
wlan5: Event CHANNEL_LIST_CHANGED (31) received
nl80211: Regulatory information - country=3DUS
nl80211: 2402-2472 @ 40 MHz
nl80211: 5170-5250 @ 40 MHz
nl80211: 5250-5330 @ 40 MHz
nl80211: 5490-5600 @ 40 MHz
nl80211: 5650-5710 @ 40 MHz
nl80211: 5735-5835 @ 40 MHz
nl80211: Added 802.11b mode based on 802.11g information
P2P: Add operating class 81
P2P: Channels - hexdump(len=3D11): 01 02 03 04 05 06 07 08 09 0a 0b
P2P: Update channel list
nl80211: Event message available
nl80211: Regulatory domain change
wlan5: Event CHANNEL_LIST_CHANGED (31) received
nl80211: Regulatory information - country=3DUS
nl80211: 2402-2472 @ 40 MHz
nl80211: 5170-5250 @ 40 MHz
nl80211: 5250-5330 @ 40 MHz
nl80211: 5490-5600 @ 40 MHz
nl80211: 5650-5710 @ 40 MHz
nl80211: 5735-5835 @ 40 MHz
nl80211: Added 802.11b mode based on 802.11g information
P2P: Add operating class 81
P2P: Channels - hexdump(len=3D11): 01 02 03 04 05 06 07 08 09 0a 0b
P2P: Update channel list
RX ctrl_iface - hexdump_ascii(len=3D10):
     50 32 50 5f 4c 49 53 54 45 4e                     P2P_LISTEN     =20
wlan5: Control interface command 'P2P_LISTEN'
P2P: Stopping find
P2P: Clear timeout (state=3DIDLE)
P2P: State IDLE -> IDLE
P2P: Going to listen(only) state
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: Enable Probe Request reporting nl_preq=3D0x1fa8730
nl80211: Register frame type=3D0x40 nl_handle=3D0x1fa8730
nl80211: Register frame match - hexdump(len=3D0): [NULL]
nl80211: Remain-on-channel cookie 0xffff880406407f00 for freq=3D2412 MHz =
duration=3D5000
P2P: State IDLE -> LISTEN_ONLY
RX ctrl_iface - hexdump_ascii(len=3D19):
     53 45 54 20 70 32 70 5f 67 6f 5f 69 6e 74 65 6e   SET p2p_go_inten
     74 20 30                                          t 0            =20
wlan5: Control interface command 'SET p2p_go_intent 0'
CTRL_IFACE SET 'p2p_go_intent'=3D'0'
p2p_go_intent=3D0
RX ctrl_iface - hexdump_ascii(len=3D26):
     53 45 54 20 70 65 72 73 69 73 74 65 6e 74 5f 72   SET persistent_r
     65 63 6f 6e 6e 65 63 74 20 31                     econnect 1     =20
wlan5: Control interface command 'SET persistent_reconnect 1'
CTRL_IFACE SET 'persistent_reconnect'=3D'1'
persistent_reconnect=3D1
RX ctrl_iface - hexdump_ascii(len=3D24):
     53 45 54 20 64 65 76 69 63 65 5f 6e 61 6d 65 20   SET device_name=20
     6b 65 76 69 6e 2d 70 63                           kevin-pc       =20
wlan5: Control interface command 'SET device_name kevin-pc'
CTRL_IFACE SET 'device_name'=3D'kevin-pc'
device_name=3D'kevin-pc'
RX ctrl_iface - hexdump_ascii(len=3D17):
     53 45 54 20 6d 6f 64 65 6c 5f 6e 61 6d 65 20 70   SET model_name p
     63                                                c              =20
wlan5: Control interface command 'SET model_name pc'
CTRL_IFACE SET 'model_name'=3D'pc'
model_name=3D'pc'
RX ctrl_iface - hexdump_ascii(len=3D30):
     53 45 54 20 6d 61 6e 75 66 61 63 74 75 72 65 72   SET manufacturer
     20 5b 70 6c 61 63 65 68 6f 6c 64 65 72 5d          [placeholder] =20
wlan5: Control interface command 'SET manufacturer [placeholder]'
CTRL_IFACE SET 'manufacturer'=3D'[placeholder]'
manufacturer=3D'[placeholder]'
RX ctrl_iface - hexdump_ascii(len=3D24):
     53 45 54 20 6d 6f 64 65 6c 5f 6e 75 6d 62 65 72   SET model_number
     20 34 2e 30 2e 30 2e 30                            4.0.0.0       =20
wlan5: Control interface command 'SET model_number 4.0.0.0'
CTRL_IFACE SET 'model_number'=3D'4.0.0.0'
model_number=3D'4.0.0.0'
RX ctrl_iface - hexdump_ascii(len=3D31):
     53 45 54 20 73 65 72 69 61 6c 5f 6e 75 6d 62 65   SET serial_numbe
     72 20 5b 70 6c 61 63 65 68 6f 6c 64 65 72 5d      r [placeholder]=20
wlan5: Control interface command 'SET serial_number [placeholder]'
CTRL_IFACE SET 'serial_number'=3D'[placeholder]'
serial_number=3D'[placeholder]'
RX ctrl_iface - hexdump_ascii(len=3D35):
     57 46 44 5f 53 55 42 45 4c 45 4d 5f 53 45 54 20   WFD_SUBELEM_SET=20
     30 30 20 30 30 30 36 30 30 31 31 30 30 30 30 30   00 0006001100000
     30 30 30                                          000            =20
wlan5: Control interface command 'WFD_SUBELEM_SET 00 0006001100000000'
WFD: Set subelement 0
WFD: Update WFD IE
WFD: WFD IE for Beacon - hexdump(len=3D15): dd 0d 50 6f 9a 0a 00 00 06 00=
 11 00 00 00 00
WFD: WFD IE for (Re)Association Request - hexdump(len=3D15): dd 0d 50 6f =
9a 0a 00 00 06 00 11 00 00 00 00
WFD: WFD IE for GO Negotiation - hexdump(len=3D15): dd 0d 50 6f 9a 0a 00 =
00 06 00 11 00 00 00 00
WFD: WFD IE for Provision Discovery Request - hexdump(len=3D15): dd 0d 50=
 6f 9a 0a 00 00 06 00 11 00 00 00 00
WFD: WFD IE for Probe Request - hexdump(len=3D15): dd 0d 50 6f 9a 0a 00 0=
0 06 00 11 00 00 00 00
WFD: WFD IE for Probe Response - hexdump(len=3D15): dd 0d 50 6f 9a 0a 00 =
00 06 00 11 00 00 00 00
WFD: WFD IE for P2P Invitation - hexdump(len=3D15): dd 0d 50 6f 9a 0a 00 =
00 06 00 11 00 00 00 00
WFD: WFD IE for Provision Discovery Response - hexdump(len=3D15): dd 0d 5=
0 6f 9a 0a 00 00 06 00 11 00 00 00 00
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2412 channel_type=3D0=
 duration=3D5000 cookie=3D0xffff880406407f00 (match))
wlan5: Event REMAIN_ON_CHANNEL (22) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(n=
il))
P2P: Starting Listen timeout(5,0) on freq=3D2412 based on callback
P2P: Set timeout (state=3DLISTEN_ONLY): 5.020000 sec
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D1 freq=3D2412 channel_type=3D0=
 duration=3D0 cookie=3D0xffff880406407f00 (match))
wlan5: Event CANCEL_REMAIN_ON_CHANNEL (23) received
P2P: Cancel remain-on-channel callback (p2p_long_listen=3D3600000 ms pend=
ing_action_tx=3D(nil))
P2P: Driver ended Listen state (freq=3D2412)
P2P: Continuing long Listen state
P2P: Going to listen(only) state
WPS:  * Version (hardcoded 0x10)
WPS:  * UUID-E
WPS:  * Version2 (0x20)
P2P: * P2P IE header
P2P: * Capability dev=3D25 group=3D00
P2P: * Device Info
nl80211: Probe Request reporting already on! nl_preq=3D0x1fa8730
nl80211: Remain-on-channel cookie 0xffff8803acc14f00 for freq=3D2412 MHz =
duration=3D5000
P2P: State LISTEN_ONLY -> LISTEN_ONLY
P2P: Timeout (state=3DLISTEN_ONLY)
nl80211: Event message available
nl80211: Remain-on-channel event (cancel=3D0 freq=3D2412 channel_type=3D0=
 duration=3D5000 cookie=3D0xffff8803acc14f00 (match))
wlan5: Event REMAIN_ON_CHANNEL (22) received
Off-channel: Send Action callback (without_roc=3D0 pending_action_tx=3D(n=
il))
P2P: Starting Listen timeout(5,0) on freq=3D2412 based on callback
P2P: Set timeout (state=3DLISTEN_ONLY): 5.020000 sec
^CP2P: Stopping find
P2P: Clear timeout (state=3DLISTEN_ONLY)
P2P: State LISTEN_ONLY -> IDLE
P2P: Clear timeout (state=3DIDLE)
P2P: Clear drv_in_listen (2412)
nl80211: Cancel remain-on-channel with cookie 0xffff8803acc14f00
nl80211: Disable Probe Request reporting nl_preq=3D0x1fa8730
P2P-DEVICE-LOST p2p_dev_addr=3D62:21:c0:99:88:b1
CTRL_IFACE monitor send - hexdump(len=3D46): 2f 74 6d 70 2f 73 61 6d 70 6=
c 65 5f 77 69 64 69 5f 77 70 61 5f 73 75 70 70 6c 69 63 61 6e 74 2e 54 6b=
 4d 4e 5a 54 2f 73 6f 63 6b 65 74 00
CTRL_IFACE monitor[0]: 111 - Connection refused
wlan5: Removing interface wlan5
wlan5: Request to deauthenticate - bssid=3D00:00:00:00:00:00 pending_bssi=
d=3D00:00:00:00:00:00 reason=3D3 state=3DINACTIVE
wlan5: No keys have been configured - skip key clearing
wlan5: State: INACTIVE -> DISCONNECTED
wpa_driver_nl80211_set_operstate: operstate 0->0 (DORMANT)
netlink: Operstate: linkmode=3D-1, operstate=3D5
EAPOL: External notification - portEnabled=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
EAPOL: External notification - portValid=3D0
EAPOL: Supplicant port status: Unauthorized
nl80211: Set supplicant port unauthorized for 00:00:00:00:00:00
wlan5: No keys have been configured - skip key clearing
wlan5: Cancelling scan request
wlan5: P2P: Station mode scan operation not pending anymore (sta_scan_pen=
ding=3D0 p2p_cb_on_scan_complete=3D0)
wlan5: Cancelling authentication timeout
netlink: Operstate: linkmode=3D0, operstate=3D6
nl80211: Set mode ifindex 4 iftype 2 (STATION)
nl80211: Unsubscribe mgmt frames handle 0x1fa52f0 (mode change)
wlan5: CTRL-EVENT-TERMINATING=20
CTRL_IFACE monitor send - hexdump(len=3D46): 2f 74 6d 70 2f 73 61 6d 70 6=
c 65 5f 77 69 64 69 5f 77 70 61 5f 73 75 70 70 6c 69 63 61 6e 74 2e 54 6b=
 4d 4e 5a 54 2f 73 6f 63 6b 65 74 00
CTRL_IFACE monitor[0]: 111 - Connection refused
CTRL_IFACE wait for attached monitors to receive messages

--------------000609010609010501060509--
