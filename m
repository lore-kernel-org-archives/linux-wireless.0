Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from static-87-79-73-36.netcologne.de ([87.79.73.36]:38835 "EHLO
	kjanke.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751871Ab2AUIAO (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 21 Jan 2012 03:00:14 -0500
Received: from [192.168.27.121] (unknown [192.168.27.121])
	by kjanke.com (Postfix) with ESMTPS id 6B65929E2
	for <linux-wireless@vger.kernel.org>; Sat, 21 Jan 2012 07:40:06 +0100 (CET)
Message-ID: <4F1A6F08.5040108@kjanke.com> (sfid-20120121_090019_139815_D0F8A48E)
Date: Sat, 21 Jan 2012 08:53:44 +0100
From: Kristoffer Janke <privat@kjanke.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: p54usb (LM87) not correctly working with usb1
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,
i have an older server that only has usb 1.1 ports and attached a 
"Siemens Gigaset USB Adapter 54 V2" (chip: ISL3887, vid/pid: 
0x083a/0x4521), with the firmware 
http://daemonizer.de/prism54/prism54-fw/fw-usb/2.13.25.0.lm87.arm the 
device comes up and everything looks fine.

the only problem is, that hostapd does not work correctly, no wlan 
client can connect (but the device is in their list).
because i read somewhere that usb1.1 together with this device is not 
working correctly with hostapd, i tried it on a different machine, 
routed the device through virtual box usb driver and there it was 
working perfect; to check that its really a usb1.1 problem, i disabled 
the usb2.0 controllers and retried on that same machine -> not working, 
same behaviour as on the older server; i tested it again with usb 2.0 -> 
worked, 1.1 -> non working, 2.0 -> working.

so it looks like there is something bahving wrong if the device is 
connected to an usb 1.0/1.1 port.

im willing to debug this stuff if i get some pointers...

regards,
Kristoffer Janke
