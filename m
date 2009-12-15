Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ew0-f219.google.com ([209.85.219.219]:45643 "EHLO
	mail-ew0-f219.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759599AbZLOLKr (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Dec 2009 06:10:47 -0500
Received: by ewy19 with SMTP id 19so346774ewy.21
        for <linux-wireless@vger.kernel.org>; Tue, 15 Dec 2009 03:10:41 -0800 (PST)
Subject: p54: unknown rssi calibration data packing
From: Gerhard van Gorkum <gerhard7@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain
Date: Tue, 15 Dec 2009 12:10:38 +0100
Message-Id: <1260875438.8291.8.camel@linus1.gentoo.dynalias.org>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

  I have 3 Dell 1450 Wireless USB adapters, and 2 of them give me issues
with 'unknown rssi calibration data packing'.  Should I just report it
here?


usb 2-2: new full speed USB device using uhci_hcd and address 4
usb 2-2: not running at top speed; connect to a high speed hub
usb 2-2: configuration #1 chosen from 1 choice
usb 2-2: reset full speed USB device using uhci_hcd and address 4
usb 2-2: firmware: requesting isl3887usb
phy2: p54 detected a LM87 firmware
p54: rx_mtu reduced from 3240 to 2384
phy2: FW rev 2.13.24.0 - Softmac protocol 5.9
phy2: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
phy2: unknown rssi calibration data packing  type:(1908) len:14.
rssical:00 00 8f 09 87 00 71 fe 78 14 81 00 7c fe        ......q.x...|.
phy2: please report this issue.
phy2: hwaddr 00:14:a5:95:5e:78, MAC:isl3892 RF:Xbow
phy2: Selected rate control algorithm 'minstrel'
Registered led device: p54-phy2::assoc
Registered led device: p54-phy2::tx
Registered led device: p54-phy2::rx
Registered led device: p54-phy2::radio
usb 2-2: is registered as 'phy2'
udev: renamed network interface wlan0 to wlan3
usb 2-2: USB disconnect, address 4
usb 2-2: new full speed USB device using uhci_hcd and address 5
usb 2-2: not running at top speed; connect to a high speed hub
usb 2-2: configuration #1 chosen from 1 choice
usb 2-2: reset full speed USB device using uhci_hcd and address 5
usb 2-2: firmware: requesting isl3887usb
phy3: p54 detected a LM87 firmware
p54: rx_mtu reduced from 3240 to 2384
phy3: FW rev 2.13.24.0 - Softmac protocol 5.9
phy3: cryptographic accelerator WEP:YES, TKIP:YES, CCMP:YES
phy3: unknown rssi calibration data packing  type:(1908) len:14.
rssical:00 00 8f 09 85 00 76 fe 78 14 81 00 7c fe        ......v.x...|.
phy3: please report this issue.
phy3: hwaddr 00:14:a5:d0:0a:1a, MAC:isl3892 RF:Xbow
phy3: Selected rate control algorithm 'minstrel'
Registered led device: p54-phy3::assoc
Registered led device: p54-phy3::tx
Registered led device: p54-phy3::rx
Registered led device: p54-phy3::radio
usb 2-2: is registered as 'phy3'
udev: renamed network interface wlan0 to wlan1
usb 2-2: USB disconnect, address 5



