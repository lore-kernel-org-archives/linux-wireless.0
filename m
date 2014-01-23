Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail1.windriver.com ([147.11.146.13]:37849 "EHLO
	mail1.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751143AbaAWGhx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 01:37:53 -0500
From: "Liu, Bopeng" <Bopeng.Liu@windriver.com>
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>
CC: zhuyj <zyjzyj2000@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: 802.11a is supported in AP mode or not?
Date: Thu, 23 Jan 2014 06:37:51 +0000
Message-ID: <DE84205DFC6FCF4A904A2F75D822FABA558C36C9@ALA-MBB.corp.ad.wrs.com> (sfid-20140123_073758_694849_418B3C61)
References: <52DF947E.40800@gmail.com>
 <CABPxzYLwL5p86jWUSzdyN7Q73ETyiiUhANVPuwBy2sWj=xQomw@mail.gmail.com>
 <DE84205DFC6FCF4A904A2F75D822FABA558C352A@ALA-MBB.corp.ad.wrs.com>,<CABPxzY+URNQRYTteZjbEKAD45Y5QBvtYqx20dM8MqFsaueHSPw@mail.gmail.com>
In-Reply-To: <CABPxzY+URNQRYTteZjbEKAD45Y5QBvtYqx20dM8MqFsaueHSPw@mail.gmail.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

root@WR-IntelligentDevice:/etc# hostapd -dd -B /etc/hostapd.conf
random: Trying to read entropy from /dev/random
Configuration file: /etc/hostapd.conf
ctrl_interface_group=0
nl80211: interface wlan0 in phy phy0
nl80211: Using driver-based off-channel TX
nl80211: Use separate P2P group interface (driver advertised support)
nl80211: Add own interface ifindex 15
nl80211: Set mode ifindex 15 iftype 3 (AP)
nl80211: Create interface iftype 6 (MONITOR)
nl80211: New interface mon.wlan0 created: ifindex=16
nl80211: Add own interface ifindex 16
BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
nl80211: Regulatory information - country=US
nl80211: 2402-2472 @ 40 MHz
nl80211: 5170-5250 @ 80 MHz
nl80211: 5250-5330 @ 80 MHz
nl80211: 5735-5835 @ 80 MHz
nl80211: 57240-63720 @ 2160 MHz
nl80211: Added 802.11b mode based on 802.11g information
Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=0 dBm
Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=0 dBm
Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=0 dBm
Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=0 dBm
Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=0 dBm
Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=0 dBm
Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=0 dBm
Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=0 dBm
Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=0 dBm
Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=0 dBm
Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=0 dBm
Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=0 dBm
Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=0 dBm
Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=0 dBm
Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=0 dBm
Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=0 dBm
Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=0 dBm
Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=0 dBm
Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=0 dBm
Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=0 dBm
Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=0 dBm
Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=0 dBm
channel [19] (149) is disabled for use in AP mode, flags: 0x7
wlan0: IEEE 802.11 Configured channel (149) not found from the channel list of current mode (2) IEEE 802.11a
wlan0: IEEE 802.11 Hardware does not support configured channel
Could not select hw_mode and channel. (-4)
wlan0: Unable to setup interface.
Flushing old station entries
Deauthenticate all stations
rmdir[ctrl_interface]: No such file or directory
nl80211: Remove interface ifindex=16
netlink: Operstate: linkmode=0, operstate=6
nl80211: Set mode ifindex 15 iftype 2 (STATION)
root@WR-IntelligentDevice:/etc#


root@WR-IntelligentDevice:/etc# hostapd -v
hostapd v1.0
User space daemon for IEEE 802.11 AP management,
IEEE 802.1X/WPA/WPA2/EAP/RADIUS Authenticator
Copyright (c) 2002-2012, Jouni Malinen <j@w1.fi> and contributors
root@WR-IntelligentDevice:/etc#


root@WR-IntelligentDevice:/etc# iw phy
Wiphy phy0
        Band 1:
                Frequencies:
                        * 2412 MHz [1] (0.0 dBm)
                        * 2417 MHz [2] (0.0 dBm)
                        * 2422 MHz [3] (0.0 dBm)
                        * 2427 MHz [4] (0.0 dBm)
                        * 2432 MHz [5] (0.0 dBm)
                        * 2437 MHz [6] (0.0 dBm)
                        * 2442 MHz [7] (0.0 dBm)
                        * 2447 MHz [8] (0.0 dBm)
                        * 2452 MHz [9] (0.0 dBm)
                        * 2457 MHz [10] (0.0 dBm)
                        * 2462 MHz [11] (0.0 dBm)
                        * 2467 MHz [12] (disabled)
                        * 2472 MHz [13] (disabled)
                Bitrates (non-HT):
                        * 1.0 Mbps
                        * 2.0 Mbps (short preamble supported)
                        * 5.5 Mbps (short preamble supported)
                        * 11.0 Mbps (short preamble supported)
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        Band 2:
                Frequencies:
                        * 5180 MHz [36] (0.0 dBm) (passive scanning, no IBSS)
                        * 5200 MHz [40] (0.0 dBm) (passive scanning, no IBSS)
                        * 5220 MHz [44] (0.0 dBm) (passive scanning, no IBSS)
                        * 5240 MHz [48] (0.0 dBm) (passive scanning, no IBSS)
                        * 5260 MHz [52] (0.0 dBm) (passive scanning, no IBSS, radar detection)
                        * 5280 MHz [56] (0.0 dBm) (passive scanning, no IBSS, radar detection)
                        * 5300 MHz [60] (0.0 dBm) (passive scanning, no IBSS, radar detection)
                        * 5320 MHz [64] (0.0 dBm) (passive scanning, no IBSS, radar detection)
                        * 5500 MHz [100] (disabled)
                        * 5520 MHz [104] (disabled)
                        * 5540 MHz [108] (disabled)
                        * 5560 MHz [112] (disabled)
                        * 5580 MHz [116] (disabled)
                        * 5600 MHz [120] (disabled)
                        * 5620 MHz [124] (disabled)
                        * 5640 MHz [128] (disabled)
                        * 5660 MHz [132] (disabled)
                        * 5680 MHz [136] (disabled)
                        * 5700 MHz [140] (disabled)
                        * 5745 MHz [149] (0.0 dBm) (passive scanning, no IBSS)
                        * 5765 MHz [153] (0.0 dBm) (passive scanning, no IBSS)
                        * 5785 MHz [157] (0.0 dBm) (passive scanning, no IBSS)
                        * 5805 MHz [161] (0.0 dBm) (passive scanning, no IBSS)
                        * 5825 MHz [165] (0.0 dBm) (passive scanning, no IBSS)
                Bitrates (non-HT):
                        * 6.0 Mbps
                        * 9.0 Mbps
                        * 12.0 Mbps
                        * 18.0 Mbps
                        * 24.0 Mbps
                        * 36.0 Mbps
                        * 48.0 Mbps
                        * 54.0 Mbps
        max # scan SSIDs: 20
        max scan IEs length: 255 bytes
        Coverage class: 0 (up to 0m)
        Supported Ciphers:
                * WEP40 (00-0f-ac:1)
                * WEP104 (00-0f-ac:5)
                * TKIP (00-0f-ac:2)
                * CCMP (00-0f-ac:4)
                * CMAC (00-0f-ac:6)
        Available Antennas: TX 0 RX 0
        Supported interface modes:
                 * IBSS
                 * managed
                 * AP
                 * AP/VLAN
                 * monitor
                 * P2P-client
                 * P2P-GO
        software interface modes (can always be added):
                 * AP/VLAN
                 * monitor
        valid interface combinations:
                 * #{ managed } <= 1, #{ AP, P2P-GO } <= 1,
                   total <= 2, #channels <= 1, STA/AP BI must match
                 * #{ managed } <= 2, #{ P2P-client } <= 1,
                   total <= 2, #channels <= 1
        Supported commands:
                 * new_interface
                 * set_interface
                 * new_key
                 * start_ap
                 * new_station
                 * new_mpath
                 * set_mesh_config
                 * set_bss
                 * authenticate
                 * associate
                 * deauthenticate
                 * disassociate
                 * join_ibss
                 * join_mesh
                 * remain_on_channel
                 * set_tx_bitrate_mask
                 * frame
                 * frame_wait_cancel
                 * set_wiphy_netns
                 * set_channel
                 * set_wds_peer
                 * probe_client
                 * set_noack_map
                 * register_beacons
                 * testmode
                 * connect
                 * disconnect
        Supported TX frame types:
                 * IBSS: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * managed: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * AP: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * AP/VLAN: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * mesh point: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * P2P-client: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
                 * P2P-GO: 0x00 0x10 0x20 0x30 0x40 0x50 0x60 0x70 0x80 0x90 0xa0 0xb0 0xc0 0xd0 0xe0 0xf0
        Supported RX frame types:
                 * IBSS: 0xd0
                 * managed: 0x40 0xd0
                 * AP: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
                 * AP/VLAN: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
                 * mesh point: 0xb0 0xc0 0xd0
                 * P2P-client: 0x40 0xd0
                 * P2P-GO: 0x00 0x20 0x40 0xa0 0xb0 0xc0 0xd0
        Device supports RSN-IBSS.
        WoWLAN support:
                 * wake up on disconnect
                 * wake up on magic packet
                 * wake up on pattern match, up to 20 patterns of 16-128 bytes
                 * can do GTK rekeying
                 * wake up on GTK rekey failure
                 * wake up on EAP identity request
                 * wake up on rfkill release
        HT Capability overrides:
                 * MCS: ff ff ff ff ff ff ff ff ff ff
                 * maximum A-MSDU length
                 * supported channel width
                 * short GI for 40 MHz
                 * max A-MPDU length exponent
                 * min MPDU start spacing
        Device supports TX status socket option.
        Device supports HT-IBSS.
root@WR-IntelligentDevice:/etc#




Best Regards.
--------------------------------------
Bopeng Liu
WIND RIVER | China Development Center
Phone: 8610-6483-5012



________________________________________
From: Krishna Chaitanya [chaitanya.mgit@gmail.com]
Sent: Thursday, January 23, 2014 2:15 PM
To: Liu, Bopeng
Cc: zhuyj; linux-wireless
Subject: Re: 802.11a is supported in AP mode or not?

On Thu, Jan 23, 2014 at 7:30 AM, Liu, Bopeng <Bopeng.Liu@windriver.com> wrote:
> Thanks for your mail, but very pity, after checking, it doesn't as well. May you test it on your board?
>
>
> # iw reg get
> country US:
>         (2402 - 2472 @ 40), (30, 0)
>         (5170 - 5250 @ 80), (17, 0)
>         (5250 - 5330 @ 80), (23, 0)
>         (5735 - 5835 @ 80), (30, 0)
>         (57240 - 63720 @ 2160), (40, 0)
>
> country_code=US
> hw_mode=a
> channel=149
>
> #hostapd -B /etc/hostapd.conf
> Configuration file: /etc/hostapd.conf
> channel [19] (149) is disabled for use in AP mode, flags: 0x7
> wlan0: IEEE 802.11 Configured channel (149) not found from the channel list of current mode (2) IEEE 802.11a
> wlan0: IEEE 802.11 Hardware does not support configured channel
> Could not select hw_mode and channel. (-4)
> wlan0: Unable to setup interface.
> rmdir[ctrl_interface]: No such file or directory
>
Can you use "hostapd -dd -B /etc/hostapd.conf"and send the output?
Also "hostapd -v" and "iw phy" as well.
