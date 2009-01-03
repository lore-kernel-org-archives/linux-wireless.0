Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:48695 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757952AbZACSgg (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 13:36:36 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LJBMM-00046Y-Iv
	for linux-wireless@vger.kernel.org; Sat, 03 Jan 2009 18:36:30 +0000
Received: from 77.21.169.220 ([77.21.169.220])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 03 Jan 2009 18:36:30 +0000
Received: from feldmann_markus by 77.21.169.220 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sat, 03 Jan 2009 18:36:30 +0000
To: linux-wireless@vger.kernel.org
From: feldmaus <feldmann_markus@gmx.de>
Subject: Re: Do not get BCM4303 to work
Date: Sat, 03 Jan 2009 19:37:46 +0100
Message-ID: <gjob72$t2j$1@ger.gmane.org> (sfid-20090103_193640_265863_431A4321)
References: <ga2fra$9q$1@ger.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
In-Reply-To: <ga2fra$9q$1@ger.gmane.org>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi All,

My actually Sydtem is:
HP Pavilion Laptop zv5000
Debian Lenny(Testing)
Linux Kernel 2.6.28 from kernel.org
Broadcom Wlan card BCM4303

My System doesnt work at all.

My Boot Messages are:
[   21.331095] b43legacy-phy0: Broadcom 4301 WLAN found
[   21.412214] b43legacy-phy0 debug: Found PHY: Analog 0, Type 1, Revision 4
[   21.412240] b43legacy-phy0 debug: Found Radio: Manuf 0x17F, Version 
0x2050, Revision 2
[   21.436305] b43legacy-phy0 debug: Radio initialized
[   40.529192] input: b43legacy-phy0 as /class/input/input9
[   40.632070] b43legacy ssb0:0: firmware: requesting b43legacy/ucode2.fw
[   40.696281] b43legacy ssb0:0: firmware: requesting b43legacy/pcm4.fw
[   40.757265] b43legacy ssb0:0: firmware: requesting 
b43legacy/b0g0initvals2.fw
[   40.984045] b43legacy-phy0: Loading firmware version 0x127, patch 
level 14 (2005-04-18 02:36:27)
[   41.100298] b43legacy-phy0 debug: Chip initialized
[   41.100599] b43legacy-phy0 debug: 30-bit DMA initialized
[   41.100748] Registered led device: b43legacy-phy0:tx
[   41.109182] Registered led device: b43legacy-phy0:rx
[   41.117508] Registered led device: b43legacy-phy0:radio
[   41.125678] b43legacy-phy0 debug: Wireless interface started
[   41.125685] b43legacy-phy0 debug: Adding Interface type 2
[   41.584048] b43legacy-phy0: Radio hardware status changed to DISABLED
[   41.593709] b43legacy-phy0 debug: Radio initialized
[   41.924035] b43legacy-phy0: Radio turned on by software
[   41.932354] b43legacy-phy0: The hardware RF-kill button still turns 
the radio physically off. Press the button to turn it on.

Actually i am looking whether i missing some Kernel
Options.

As we can see in the Boot Messages i have to activate the RF-kill
Button by pressing, but this does not activate my wlan.

Any Ideas?

Regards Markus

