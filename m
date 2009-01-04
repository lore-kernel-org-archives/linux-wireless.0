Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from main.gmane.org ([80.91.229.2]:48928 "EHLO ciao.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751306AbZADLdb (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sun, 4 Jan 2009 06:33:31 -0500
Received: from list by ciao.gmane.org with local (Exim 4.43)
	id 1LJREX-0002kE-LZ
	for linux-wireless@vger.kernel.org; Sun, 04 Jan 2009 11:33:29 +0000
Received: from 77.21.169.220 ([77.21.169.220])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 04 Jan 2009 11:33:29 +0000
Received: from feldmann_markus by 77.21.169.220 with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Sun, 04 Jan 2009 11:33:29 +0000
To: linux-wireless@vger.kernel.org
From: feldmaus <feldmann_markus@gmx.de>
Subject: Re: Do not get BCM4303 to work
Date: Sun, 04 Jan 2009 12:34:51 +0100
Message-ID: <gjq6q1$gvc$1@ger.gmane.org> (sfid-20090104_123336_520339_1F428929)
References: <ga2fra$9q$1@ger.gmane.org> <gjob72$t2j$1@ger.gmane.org> <495FB6DD.1060807@lwfinger.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
In-Reply-To: <495FB6DD.1060807@lwfinger.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Larry Finger schrieb:
> Your log does not indicate that you pressed the button to turn the
> wifi on. All we see is that the hardware switch was off.
Yes you are right.

Here is the log during Boot up:
[   21.389448] b43legacy-phy0: Broadcom 4301 WLAN found
[   21.451790] b43legacy-phy0 debug: Found PHY: Analog 0, Type 1, Revision 4
[   21.451814] b43legacy-phy0 debug: Found Radio: Manuf 0x17F, Version 
0x2050, Revision 2
[   21.488040] b43legacy-phy0 debug: Radio initialized
[   41.176020] input: b43legacy-phy0 as /class/input/input9
[   41.276065] b43legacy ssb0:0: firmware: requesting b43legacy/ucode2.fw
[   41.340931] b43legacy ssb0:0: firmware: requesting b43legacy/pcm4.fw
[   41.415190] b43legacy ssb0:0: firmware: requesting 
b43legacy/b0g0initvals2.fw
[   41.624053] b43legacy-phy0: Loading firmware version 0x127, patch 
level 14 (2005-04-18 02:36:27)
[   41.736308] b43legacy-phy0 debug: Chip initialized
[   41.736617] b43legacy-phy0 debug: 30-bit DMA initialized
[   41.736769] Registered led device: b43legacy-phy0:tx
[   41.744956] Registered led device: b43legacy-phy0:rx
[   41.753043] Registered led device: b43legacy-phy0:radio
[   41.760983] b43legacy-phy0 debug: Wireless interface started
[   41.760990] b43legacy-phy0 debug: Adding Interface type 2
[   42.221213] b43legacy-phy0: Radio hardware status changed to DISABLED
[   42.230568] b43legacy-phy0 debug: Radio initialized
[   42.512043] b43legacy-phy0: Radio turned on by software
[   42.520110] b43legacy-phy0: The hardware RF-kill button still turns 
the radio physically off. Press the button to turn it on.


Then i deactivated the wlan with  my networkmanager:
[  626.730050] b43legacy-phy0 debug: Removing Interface type 2
[  626.738361] b43legacy-phy0 debug: Wireless interface stopped
[  626.738524] b43legacy-phy0 debug: DMA-30 0x0260 (RX) max used slots: 1/64
[  626.738579] b43legacy-phy0 debug: DMA-30 0x0200 (RX) max used slots: 0/64
[  626.738643] b43legacy-phy0 debug: DMA-30 0x02A0 (TX) max used slots: 
0/128
[  626.744048] b43legacy-phy0 debug: DMA-30 0x0280 (TX) max used slots: 
0/128
[  626.752047] b43legacy-phy0 debug: DMA-30 0x0260 (TX) max used slots: 
0/128
[  626.762293] b43legacy-phy0 debug: DMA-30 0x0240 (TX) max used slots: 
0/128
[  626.768035] b43legacy-phy0 debug: DMA-30 0x0220 (TX) max used slots: 
2/128
[  626.776035] b43legacy-phy0 debug: DMA-30 0x0200 (TX) max used slots: 
0/128
[  626.784038] b43legacy-phy0 debug: Radio initialized
[  626.784049] b43legacy-phy0 debug: Radio initialized


Then i activated my wlan with my networkmanager:
[  651.401677] input: b43legacy-phy0 as /class/input/input10
[  651.572038] b43legacy-phy0: Loading firmware version 0x127, patch 
level 14 (2005-04-18 02:36:27)
[  651.680310] b43legacy-phy0 debug: Chip initialized
[  651.680628] b43legacy-phy0 debug: 30-bit DMA initialized
[  651.680788] Registered led device: b43legacy-phy0:tx
[  651.680827] Registered led device: b43legacy-phy0:rx
[  651.680866] Registered led device: b43legacy-phy0:radio
[  651.680896] b43legacy-phy0 debug: Wireless interface started
[  651.680903] b43legacy-phy0 debug: Adding Interface type 2
[  652.420046] b43legacy-phy0: Radio hardware status changed to DISABLED


Regards Markus

