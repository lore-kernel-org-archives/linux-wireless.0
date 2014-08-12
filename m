Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mimamau.de ([62.75.248.232]:43252 "EHLO mimamau.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751318AbaHLRUt (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 12 Aug 2014 13:20:49 -0400
Received: from [192.168.0.74] (p5B221BEB.dip0.t-ipconnect.de [91.34.27.235])
	by mimamau.de (Postfix) with ESMTPA id 80030146838C
	for <linux-wireless@vger.kernel.org>; Tue, 12 Aug 2014 19:12:04 +0200 (CEST)
Message-ID: <53EA4AE4.8040204@mimamau.de> (sfid-20140812_192052_368269_EC544903)
Date: Tue, 12 Aug 2014 19:12:04 +0200
From: =?UTF-8?B?TWFyaXVzIFNjaMOkZmVy?= <mschaefer@mimamau.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: hostapd not working any more
Content-Type: text/plain; charset=utf-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I'm developing an embedded system and I don't know what I've changed but 
now hostapd doesn't work any more. It has been working the last time I 
worked on that system. Hardware is a usb stick with rt2770 chip.

# hostapd -dd /etc/hostapd.conf
random: Trying to read entropy from /dev/random
Configuration file: /etc/hostapd.conf
rfkill: initial event: idx=1 type=1 op=0 soft=0 hard=0
nl80211: Supported cipher 00-0f-ac:1
nl80211: Supported cipher 00-0f-ac:5
nl80211: Supported cipher 00-0f-ac:2
nl80211: Supported cipher 00-0f-ac:4
nl80211: Using driver-based off-channel TX
nl80211: interface wlan0 in phy phy1
nl80211: Set mode ifindex 3 iftype 3 (AP)
nl80211: Failed to set interface 3 to mode 3: -16 (Device or resource busy)
nl80211: Try mode change after setting interface down
nl80211: Set mode ifindex 3 iftype 3 (AP)
nl80211: Mode change succeeded while interface is down
nl80211: Setup AP(wlan0) - device_ap_sme=0 use_monitor=0
nl80211: Subscribe to mgmt frames with AP handle 0x843dfc8
nl80211: Register frame type=0xb0 nl_handle=0x843dfc8 match=
nl80211: Register frame type=0x0 nl_handle=0x843dfc8 match=
nl80211: Register frame type=0x20 nl_handle=0x843dfc8 match=
nl80211: Register frame type=0xa0 nl_handle=0x843dfc8 match=
nl80211: Register frame type=0xc0 nl_handle=0x843dfc8 match=
nl80211: Register frame type=0xd0 nl_handle=0x843dfc8 match=
nl80211: Register frame type=0x40 nl_handle=0x843dfc8 match=
nl80211: Remove monitor interface: refcount=0
nl80211: Remove beacon (ifindex=3)
netlink: Operstate: ifindex=3 linkmode=0 (kernel-control), operstate=6 
(IF_OPER_UP)
nl80211: Set mode ifindex 3 iftype 2 (STATION)
nl80211: Failed to set interface 3 to mode 2: -16 (Device or resource busy)
nl80211: Try mode change after setting interface down
nl80211: Set mode ifindex 3 iftype 2 (STATION)
nl80211: Mode change succeeded while interface is down
nl80211: Teardown AP(wlan0) - device_ap_sme=0 use_monitor=0
nl80211: Unsubscribe mgmt frames handle 0x80cb5741 (AP teardown)
nl80211 driver initialization failed.
hostapd_interface_deinit_free(0x843c3c8)
hostapd_interface_deinit_free: num_bss=1 conf->num_bss=1
hostapd_interface_deinit(0x843c3c8)
hostapd_bss_deinit: deinit bss wlan0
hostapd_cleanup(hapd=0x843c8c0 (wlan0))
hostapd_free_hapd_data: Interface wlan0 wasn't started
hostapd_interface_deinit_free: driver=(nil) drv_priv=(nil) -> hapd_deinit
hostapd_interface_free(0x843c3c8)
hostapd_interface_free: free hapd 0x843c8c0
hostapd_cleanup_iface(0x843c3c8)
hostapd_cleanup_iface_partial(0x843c3c8)
hostapd_cleanup_iface: free iface=0x843c3c8


Thank you
Marius Schäfer
