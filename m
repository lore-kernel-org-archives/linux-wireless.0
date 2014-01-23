Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.windriver.com ([147.11.1.11]:33438 "EHLO
	mail.windriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750831AbaAWIlW convert rfc822-to-8bit (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 23 Jan 2014 03:41:22 -0500
From: "Liu, Bopeng" <Bopeng.Liu@windriver.com>
To: Emmanuel Grumbach <egrumbach@gmail.com>,
	zhuyj <zyjzyj2000@gmail.com>
CC: Krishna Chaitanya <chaitanya.mgit@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>
Subject: RE: 802.11a is supported in AP mode or not?
Date: Thu, 23 Jan 2014 08:41:20 +0000
Message-ID: <DE84205DFC6FCF4A904A2F75D822FABA558C37D2@ALA-MBB.corp.ad.wrs.com> (sfid-20140123_094125_859237_C5F10A5F)
References: <52DF947E.40800@gmail.com>
	<CABPxzYLwL5p86jWUSzdyN7Q73ETyiiUhANVPuwBy2sWj=xQomw@mail.gmail.com>
	<DE84205DFC6FCF4A904A2F75D822FABA558C352A@ALA-MBB.corp.ad.wrs.com>
	<CABPxzY+URNQRYTteZjbEKAD45Y5QBvtYqx20dM8MqFsaueHSPw@mail.gmail.com>
	<52E0BA40.7090203@gmail.com>,<CANUX_P05h39mPbhPBhKzVZb+vtyxtfsPMwOcv4UgJR_yJRcXdw@mail.gmail.com>,<DE84205DFC6FCF4A904A2F75D822FABA558C37BC@ALA-MBB.corp.ad.wrs.com>
In-Reply-To: <DE84205DFC6FCF4A904A2F75D822FABA558C37BC@ALA-MBB.corp.ad.wrs.com>
Content-Type: text/plain; charset="us-ascii"
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Thanks, but after I run the command:

iwconfig wlan0

it shows the wlan0 supports a b g n mode.

Can you give me a explanation on it?

Best Regards.
--------------------------------------
Bopeng Liu
WIND RIVER | China Development Center
Phone: 8610-6483-5012



________________________________________
From: linux-wireless-owner@vger.kernel.org [linux-wireless-owner@vger.kernel.org] on behalf of Liu, Bopeng [Bopeng.Liu@windriver.com]
Sent: Thursday, January 23, 2014 4:36 PM
To: Emmanuel Grumbach; zhuyj
Cc: Krishna Chaitanya; linux-wireless
Subject: RE: 802.11a is supported in AP mode or not?

Not yet,please tell me..... Please,thanks very much.

Best Regards.
--------------------------------------
Bopeng Liu
WIND RIVER | China Development Center
Phone: 8610-6483-5012



________________________________________
From: Emmanuel Grumbach [egrumbach@gmail.com]
Sent: Thursday, January 23, 2014 4:23 PM
To: zhuyj
Cc: Krishna Chaitanya; Liu, Bopeng; linux-wireless
Subject: Re: 802.11a is supported in AP mode or not?

On Thu, Jan 23, 2014 at 8:44 AM, zhuyj <zyjzyj2000@gmail.com> wrote:
> On 01/23/2014 02:15 PM, Krishna Chaitanya wrote:
>>
>> hostapd -dd -B /etc/hostapd.conf
>
> root@wind-desktop:~# hostapd -dd -B /etc/hostapd.conf
>
> random: Trying to read entropy from /dev/random
> Configuration file: /etc/hostapd.conf
> ctrl_interface_group=0
> nl80211: interface wlan0 in phy phy0
> rfkill: initial event: idx=0 type=1 op=0 soft=0 hard=0
> nl80211: Using driver-based off-channel TX
> nl80211: Register frame command failed (type=208): ret=-114 (Operation
> already in progress)
> nl80211: Register frame match - hexdump(len=2): 04 0a
> nl80211: Failed to register Action frame processing - ignore for now
> nl80211: Add own interface ifindex 3
> nl80211: Set mode ifindex 3 iftype 3 (AP)
> nl80211: Create interface iftype 6 (MONITOR)
> nl80211: New interface mon.wlan0 created: ifindex=4
> nl80211: Add own interface ifindex 4
> BSS count 1, BSSID mask 00:00:00:00:00:00 (0 bits)
> nl80211: Regulatory information - country=00
> nl80211: 2402-2472 @ 40 MHz
> nl80211: 2457-2482 @ 40 MHz
> nl80211: 2474-2494 @ 20 MHz
> nl80211: 5170-5250 @ 40 MHz
> nl80211: 5735-5835 @ 40 MHz
> nl80211: Added 802.11b mode based on 802.11g information
> Allowed channel: mode=1 chan=1 freq=2412 MHz max_tx_power=15 dBm
> Allowed channel: mode=1 chan=2 freq=2417 MHz max_tx_power=15 dBm
> Allowed channel: mode=1 chan=3 freq=2422 MHz max_tx_power=15 dBm
> Allowed channel: mode=1 chan=4 freq=2427 MHz max_tx_power=15 dBm
> Allowed channel: mode=1 chan=5 freq=2432 MHz max_tx_power=15 dBm
> Allowed channel: mode=1 chan=6 freq=2437 MHz max_tx_power=15 dBm
> Allowed channel: mode=1 chan=7 freq=2442 MHz max_tx_power=15 dBm
> Allowed channel: mode=1 chan=8 freq=2447 MHz max_tx_power=15 dBm
> Allowed channel: mode=1 chan=9 freq=2452 MHz max_tx_power=15 dBm
> Allowed channel: mode=1 chan=10 freq=2457 MHz max_tx_power=15 dBm
> Allowed channel: mode=1 chan=11 freq=2462 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=1 freq=2412 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=2 freq=2417 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=3 freq=2422 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=4 freq=2427 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=5 freq=2432 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=6 freq=2437 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=7 freq=2442 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=8 freq=2447 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=9 freq=2452 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=10 freq=2457 MHz max_tx_power=15 dBm
> Allowed channel: mode=0 chan=11 freq=2462 MHz max_tx_power=15 dBm
> wlan0: IEEE 802.11 Configured channel (1) not found from the channel list of
> current mode (2) IEEE 802.11a
>
> wlan0: IEEE 802.11 Hardware does not support configured channel
> Could not select hw_mode and channel. (-4)
> wlan0: Unable to setup interface.
> Flushing old station entries
> Deauthenticate all stations
> rmdir[ctrl_interface]: No such file or directory
> nl80211: Remove interface ifindex=4
> netlink: Operstate: linkmode=0, operstate=6
> nl80211: Set mode ifindex 3 iftype 2 (STATION)
> root@wind-desktop:~#
>
>
> root@wind-desktop:~# hostapd -v

I think you have the answer to your question, don't you?
--
To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
