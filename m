Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from nm22-vm3.bullet.mail.ird.yahoo.com ([212.82.109.253]:27011 "HELO
	nm22-vm3.bullet.mail.ird.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S932927Ab2GYN77 convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Jul 2012 09:59:59 -0400
References: <CAKjQTCesBzbjbv4T+RPRutrgTyJoXJciwsKqPAxZDDcvot=q5g@mail.gmail.com> <CAKjQTCex5oXLkPOZeoccT5a0CxMDpdpmSqcJy4SV7h1eaeo=pA@mail.gmail.com> <1343074978.66314.YahooMailNeo@web28904.mail.ir2.yahoo.com> <1343075460.1623.YahooMailNeo@web28905.mail.ir2.yahoo.com> <500DBD17.7070706@lwfinger.net> <1343138030.94415.YahooMailNeo@web28906.mail.ir2.yahoo.com> <1343138193.40429.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EBA0C.106@lwfinger.net> <1343143522.46747.YahooMailNeo@web28903.mail.ir2.yahoo.com> <1343149616.67668.YahooMailNeo@web28904.mail.ir2.yahoo.com> <500EE086.6000304@lwfinger.net>
Message-ID: <1343224463.22151.YahooMailNeo@web28906.mail.ir2.yahoo.com> (sfid-20120725_160011_822325_F7D2CB84)
Date: Wed, 25 Jul 2012 14:54:23 +0100 (BST)
From: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Reply-To: Xavier de Almeida <xavierdealmeida@yahoo.fr>
Subject: Re: Tr : Tr : Can't make RTL8188CE work with hostapd (rtl8192ce)
To: Larry Finger <Larry.Finger@lwfinger.net>,
	"linux-wireless@vger.kernel.org" <linux-wireless@vger.kernel.org>
In-Reply-To: <500EE086.6000304@lwfinger.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

For some reason my system has become unstable since the installation of the compat-wireless drivers. :-(

I installed those drivers "compat-wireless-2012-07-03" by doing a make/ make install

modinfo rtl8192ce
filename:       /lib/modules/3.2.23-030223-generic/updates/drivers/net/wireless/rtlwifi/rtl8192ce/rtl8192ce.ko
firmware:       rtlwifi/rtl8192cfwU_B.bin
firmware:       rtlwifi/rtl8192cfwU.bin
firmware:       rtlwifi/rtl8192cfw.bin
description:    Realtek 8192C/8188C 802.11n PCI wireless
license:        GPL
author:         Larry Finger<Larry.Finger@lwfinger.net>
author:         Realtek WlanFAE<wlanfae@realtek.com>
author:         lizhaoming<chaoming_li@realsil.com.cn>
srcversion:     DC0B6C089A8681E6916F078
alias:          pci:v000010ECd00008176sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008177sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008178sv*sd*bc*sc*i*
alias:          pci:v000010ECd00008191sv*sd*bc*sc*i*
depends:        rtlwifi,rtl8192c-common,compat,mac80211
vermagic:       3.2.23-030223-generic SMP mod_unload modversions 686 
parm:           swenc:Set to 1 for software crypto (default 0)
parm:           ips:Set to 0 to not use link power save (default 1)

parm:           swlps:Set to 1 to use SW control power save (default 0)

parm:           fwlps:Set to 1 to use FW control power save (default 1)

parm:           debug:Set debug level (0-5) (default 0) (int)


Remote VNC works ok but it s difficult to get a ssh session established.

When I launch sudo hostpad, I can't do a ctrl C anymore to stop it.

I see this in kernel:

Jul 25 15:45:53 HTPC kernel: [  409.493352] device wlan0 entered promiscuous mode
Jul 25 15:45:53 HTPC kernel: [  409.493979] ADDRCONF(NETDEV_UP): wlan0: link is not ready
Jul 25 15:45:53 HTPC kernel: [  409.530751] cfg80211: Calling CRDA for country: FR
Jul 25 15:45:53 HTPC kernel: [  409.541016] cfg80211: Updating information on frequency 2412 MHz for a 20 MHz width channel with reg
ulatory rule:
Jul 25 15:45:53 HTPC kernel: [  409.541024] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Jul 25 15:45:53 HTPC kernel: [  409.541029] cfg80211: Updating information on frequency 2417 MHz for a 20 MHz width channel with reg
ulatory rule:
Jul 25 15:45:53 HTPC kernel: [  409.541035] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Jul 25 15:45:53 HTPC kernel: [  409.541039] cfg80211: Updating information on frequency 2422 MHz for a 20 MHz width channel with reg
ulatory rule:
Jul 25 15:45:53 HTPC kernel: [  409.541045] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Jul 25 15:45:53 HTPC kernel: [  409.541049] cfg80211: Updating information on frequency 2427 MHz for a 20 MHz width channel with reg
ulatory rule:
Jul 25 15:45:53 HTPC kernel: [  409.541055] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Jul 25 15:45:53 HTPC kernel: [  409.541059] cfg80211: Updating information on frequency 2432 MHz for a 20 MHz width channel with reg
ulatory rule:
Jul 25 15:45:53 HTPC kernel: [  409.541065] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Jul 25 15:45:53 HTPC kernel: [  409.541069] cfg80211: Updating information on frequency 2437 MHz for a 20 MHz width channel with reg
ulatory rule:
Jul 25 15:45:53 HTPC kernel: [  409.541075] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Jul 25 15:45:53 HTPC kernel: [  409.541079] cfg80211: Updating information on frequency 2442 MHz for a 20 MHz width channel with reg
ulatory rule:
Jul 25 15:45:53 HTPC kernel: [  409.541085] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Jul 25 15:45:53 HTPC kernel: [  409.541089] cfg80211: Updating information on frequency 2447 MHz for a 20 MHz width channel with reg
ulatory rule:
Jul 25 15:45:53 HTPC kernel: [  409.541095] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Jul 25 15:45:53 HTPC kernel: [  409.541099] cfg80211: Updating information on frequency 2452 MHz for a 20 MHz width channel with reg
ulatory rule:
Jul 25 15:45:53 HTPC kernel: [  409.541105] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Jul 25 15:45:53 HTPC kernel: [  409.541109] cfg80211: Updating information on frequency 2457 MHz for a 20 MHz width channel with reg
ulatory rule:
Jul 25 15:45:53 HTPC kernel: [  409.541115] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Jul 25 15:45:53 HTPC kernel: [  409.541119] cfg80211: Updating information on frequency 2462 MHz for a 20 MHz width channel with reg
ulatory rule:
Jul 25 15:45:53 HTPC kernel: [  409.541125] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Jul 25 15:45:53 HTPC kernel: [  409.541129] cfg80211: Updating information on frequency 2467 MHz for a 20 MHz width channel with reg
ulatory rule:
Jul 25 15:45:53 HTPC kernel: [  409.541135] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Jul 25 15:45:53 HTPC kernel: [  409.541139] cfg80211: Updating information on frequency 2472 MHz for a 20 MHz width channel with reg
ulatory rule:
Jul 25 15:45:53 HTPC kernel: [  409.541145] cfg80211: 2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A mBi, 2000 mBm)
Jul 25 15:45:53 HTPC kernel: [  409.541149] cfg80211: Disabling freq 2484 MHz
Jul 25 15:45:53 HTPC kernel: [  409.541155] cfg80211: Regulatory domain changed to country: FR
Jul 25 15:45:53 HTPC kernel: [  409.541158] cfg80211:   (start_freq - end_freq @ bandwidth), (max_antenna_gain, max_eirp)
Jul 25 15:45:53 HTPC kernel: [  409.541164] cfg80211:   (2402000 KHz - 2482000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 25 15:45:53 HTPC kernel: [  409.541168] cfg80211:   (5170000 KHz - 5250000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 25 15:45:53 HTPC kernel: [  409.541173] cfg80211:   (5250000 KHz - 5330000 KHz @ 40000 KHz), (N/A, 2000 mBm)
Jul 25 15:45:53 HTPC kernel: [  409.541178] cfg80211:   (5490000 KHz - 5710000 KHz @ 40000 KHz), (N/A, 2700 mBm)
Jul 25 15:45:53 HTPC kernel: [  409.563665] ADDRCONF(NETDEV_CHANGE): wlan0: link becomes ready
Jul 25 15:45:53 HTPC kernel: [  409.563758] br0: port 2(wlan0) entering forwarding state
Jul 25 15:45:53 HTPC kernel: [  409.563781] br0: port 2(wlan0) entering forwarding state
Jul 25 15:46:04 HTPC kernel: [  420.264454] wlan0: no IPv6 routers present
Jul 25 15:46:08 HTPC kernel: [  424.582630] br0: port 2(wlan0) entering forwarding state
Jul 25 15:46:29 HTPC kernel: [  445.538319] device wlan0 left promiscuous mode
Jul 25 15:46:29 HTPC kernel: [  445.538334] br0: port 2(wlan0) entering forwarding state
Jul 25 15:49:05 HTPC kernel: [  600.912155] INFO: task whoopsie:1394 blocked for more than 120 seconds.
Jul 25 15:49:05 HTPC kernel: [  600.912162] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 25 15:49:05 HTPC kernel: [  600.912167] whoopsie        D 00000000     0  1394      1 0x00000000
Jul 25 15:49:05 HTPC kernel: [  600.912176]  d51bfd00 00200082 00000067 00000000 00000000 f3908ca0 c18d5380 c18d5380
Jul 25 15:49:05 HTPC kernel: [  600.912189]  bc9d12b6 00000067 f77cb380 f2e81940 d489bf20 c146b95e f4d342a0 d43db540
Jul 25 15:49:05 HTPC kernel: [  600.912201]  d3ebb280 d51bfd08 c156f209 d3ebb280 c1811c88 d51be000 d3ebb280 00000000
Jul 25 15:49:05 HTPC kernel: [  600.912213] Call Trace:

and then 120s after
Jul 25 15:51:05 HTPC kernel: [  720.861476] INFO: task whoopsie:1394 blocked for more than 120 seconds.
Jul 25 15:51:05 HTPC kernel: [  720.861482] "echo 0 > /proc/sys/kernel/hung_task_timeout_secs" disables this message.
Jul 25 15:51:05 HTPC kernel: [  720.861488] whoopsie        D 00000000     0  1394      1 0x00000000
Jul 25 15:51:05 HTPC kernel: [  720.861496]  d51bfd00 00200082 00000067 00000000 00000000 f3908ca0 c18d5380 c18d5380
Jul 25 15:51:05 HTPC kernel: [  720.861509]  bc9d12b6 00000067 f77cb380 f2e81940 d489bf20 c146b95e f4d342a0 d43db540
Jul 25 15:51:05 HTPC kernel: [  720.861521]  d3ebb280 d51bfd08 c156f209 d3ebb280 c1811c88 d51be000 d3ebb280 00000000
Jul 25 15:51:05 HTPC kernel: [  720.861533] Call Trace:
Jul 25 15:51:05 HTPC kernel: [  720.861546]  [<c146b95e>] ? kfree_skbmem+0x2e/0x80
Jul 25 15:51:05 HTPC kernel: [  720.861554]  [<c156f209>] ? apic_timer_interrupt+0x31/0x38
Jul 25 15:51:05 HTPC kernel: [  720.861561]  [<c156cfd5>] schedule+0x35/0x50
Jul 25 15:51:05 HTPC kernel: [  720.861567]  [<c156db76>] __mutex_lock_slowpath+0xc6/0x120
Jul 25 15:51:05 HTPC kernel: [  720.861573]  [<c156d824>] mutex_lock+0x24/0x40
Jul 25 15:51:05 HTPC kernel: [  720.861579]  [<c14844b2>] rtnl_lock+0x12/0x20
Jul 25 15:51:05 HTPC kernel: [  720.861585]  [<c14844d0>] rtnetlink_rcv+0x10/0x30
Jul 25 15:51:05 HTPC kernel: [  720.861592]  [<c149b189>] netlink_unicast+0x239/0x290
Jul 25 15:51:05 HTPC kernel: [  720.861598]  [<c149b3c8>] netlink_sendmsg+0x1e8/0x310
Jul 25 15:51:05 HTPC kernel: [  720.861605]  [<c14648f7>] sock_sendmsg+0xf7/0x120
Jul 25 15:51:05 HTPC kernel: [  720.861610]  [<c156ebdd>] ? _raw_spin_lock_irqsave+0x2d/0x40
Jul 25 15:51:05 HTPC kernel: [  720.861618]  [<c113aa50>] ? page_symlink+0x30/0x30
Jul 25 15:51:05 HTPC kernel: [  720.861624]  [<c114c1f8>] ? mntput+0x18/0x30
Jul 25 15:51:05 HTPC kernel: [  720.861629]  [<c113ab6a>] ? path_put+0x1a/0x20
Jul 25 15:51:05 HTPC kernel: [  720.861636]  [<c1031895>] ? __wake_up+0x45/0x60
Jul 25 15:51:05 HTPC kernel: [  720.861643]  [<c12a0b42>] ? _copy_from_user+0x42/0x60
Jul 25 15:51:05 HTPC kernel: [  720.861649]  [<c1465f7f>] ? move_addr_to_kernel+0x5f/0x70
Jul 25 15:51:05 HTPC kernel: [  720.861655]  [<c146694e>] sys_sendto+0x10e/0x150
Jul 25 15:51:05 HTPC kernel: [  720.861661]  [<c156e9ad>] ? _raw_spin_lock+0xd/0x10
Jul 25 15:51:05 HTPC kernel: [  720.861667]  [<c1144e54>] ? __d_instantiate+0xa4/0xe0
Jul 25 15:51:05 HTPC kernel: [  720.861673]  [<c1132bc0>] ? alloc_file+0x20/0xb0
Jul 25 15:51:05 HTPC kernel: [  720.861679]  [<c1464ad4>] ? sock_alloc_file+0x84/0xf0
Jul 25 15:51:05 HTPC kernel: [  720.861685]  [<c156e9ad>] ? _raw_spin_lock+0xd/0x10
Jul 25 15:51:05 HTPC kernel: [  720.861690]  [<c112f93c>] ? fd_install+0x4c/0x60
Jul 25 15:51:05 HTPC kernel: [  720.861696]  [<c12a09af>] ? __copy_from_user_ll+0x1f/0x40
Jul 25 15:51:05 HTPC kernel: [  720.861702]  [<c1467360>] sys_socketcall+0x1b0/0x2c0
Jul 25 15:51:05 HTPC kernel: [  720.861709]  [<c1575bdf>] sysenter_do_call+0x12/0x28
