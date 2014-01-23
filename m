Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-pa0-f47.google.com ([209.85.220.47]:57041 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753090AbaAWGoZ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 01:44:25 -0500
Received: by mail-pa0-f47.google.com with SMTP id kp14so1464035pab.20
        for <linux-wireless@vger.kernel.org>; Wed, 22 Jan 2014 22:44:24 -0800 (PST)
Message-ID: <52E0BA40.7090203@gmail.com> (sfid-20140123_074428_845850_A236A85F)
Date: Thu, 23 Jan 2014 14:44:16 +0800
From: zhuyj <zyjzyj2000@gmail.com>
MIME-Version: 1.0
To: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	"Liu, Bopeng" <Bopeng.Liu@windriver.com>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: 802.11a is supported in AP mode or not?
References: <52DF947E.40800@gmail.com> <CABPxzYLwL5p86jWUSzdyN7Q73ETyiiUhANVPuwBy2sWj=xQomw@mail.gmail.com> <DE84205DFC6FCF4A904A2F75D822FABA558C352A@ALA-MBB.corp.ad.wrs.com> <CABPxzY+URNQRYTteZjbEKAD45Y5QBvtYqx20dM8MqFsaueHSPw@mail.gmail.com>
In-Reply-To: <CABPxzY+URNQRYTteZjbEKAD45Y5QBvtYqx20dM8MqFsaueHSPw@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 01/23/2014 02:15 PM, Krishna Chaitanya wrote:
> hostapd -dd -B /etc/hostapd.conf
root@wind-desktop:~# hostapd -dd -B /etc/hostapd.conf
random: Trying to read entropy from /dev/random
Configuration file: /etc/hostapd.conf
ctrl_interface_group=0
nl80211: interface wlan0 in phy phy0
rfkill: initial event: idx=0 type=1 op=0 soft=0 hard=0
nl80211: Using driver-based off-channel TX
nl80211: Register frame command failed (type=208): ret=-114 (Operation 
already in progress)
nl80211: Register frame match - hexdump(len=2): 04 0a
nl80211: Failed to register Action frame processing - ignore for now
nl80211: Add own interface ifindex 3
nl80211: Set mode ifindex 3 iftype 3 (AP)
nl80211: Create interface iftype 6 (MONITOR)
nl80211: New interface mon.wlan0 created: ifindex=4
nl80211: Add own interface ifindex 4
BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
nl80211: Regulatory information - country=00
nl80211: 2402-2472 @ 40 MHz
nl80211: 2457-2482 @ 40 MHz
nl80211: 2474-2494 @ 20 MHz
nl80211: 5170-5250 @ 40 MHz
nl80211: 5735-5835 @ 40 MHz
nl80211: Added 802.11b mode based on 802.11g information
Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=15 dBm
Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=15 dBm
Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=15 dBm
Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=15 dBm
Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=15 dBm
Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=15 dBm
Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=15 dBm
Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=15 dBm
Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=15 dBm
Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=15 dBm
Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=15 dBm
Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=15 dBm
Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=15 dBm
Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=15 dBm
Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=15 dBm
Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=15 dBm
Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=15 dBm
Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=15 dBm
Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=15 dBm
Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=15 dBm
Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=15 dBm
Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=15 dBm
wlan0: IEEE 802.11 Configured channel (1) not found from the channel 
list of current mode (2) IEEE 802.11a
wlan0: IEEE 802.11 Hardware does not support configured channel
Could not select hw_mode and channel. (-4)
wlan0: Unable to setup interface.
Flushing old station entries
Deauthenticate all stations
rmdir[ctrl_interface]: No such file or directory
nl80211: Remove interface ifindex=4
netlink: Operstate: linkmode=0, operstate=6
nl80211: Set mode ifindex 3 iftype 2 (STATION)
root@wind-desktop:~#


root@wind-desktop:~# hostapd -v
hostapd v1.0
User space daemon for IEEE 802.11 AP management,
IEEE 802.1X/WPA/WPA2/EAP/RADIUS Authenticator
Copyright (c) 2002-2012, Jouni Malinen <j@w1.fi> and contributors

