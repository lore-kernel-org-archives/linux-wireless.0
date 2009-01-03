Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mtiwmhc11.worldnet.att.net ([204.127.131.115]:44240 "EHLO
	mtiwmhc11.worldnet.att.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1758234AbZACTFH (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 3 Jan 2009 14:05:07 -0500
Message-ID: <495FB6DD.1060807@lwfinger.net> (sfid-20090103_200511_281111_7C752234)
Date: Sat, 03 Jan 2009 13:05:01 -0600
From: Larry Finger <Larry.Finger@lwfinger.net>
MIME-Version: 1.0
To: feldmaus <feldmann_markus@gmx.de>
CC: linux-wireless@vger.kernel.org
Subject: Re: Do not get BCM4303 to work
References: <ga2fra$9q$1@ger.gmane.org> <gjob72$t2j$1@ger.gmane.org>
In-Reply-To: <gjob72$t2j$1@ger.gmane.org>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

feldmaus wrote:
> Hi All,
> 
> My actually Sydtem is:
> HP Pavilion Laptop zv5000
> Debian Lenny(Testing)
> Linux Kernel 2.6.28 from kernel.org
> Broadcom Wlan card BCM4303
> 
> My System doesnt work at all.
> 
> My Boot Messages are:
> [   21.331095] b43legacy-phy0: Broadcom 4301 WLAN found
> [   21.412214] b43legacy-phy0 debug: Found PHY: Analog 0, Type 1,
> Revision 4
> [   21.412240] b43legacy-phy0 debug: Found Radio: Manuf 0x17F, Version
> 0x2050, Revision 2
> [   21.436305] b43legacy-phy0 debug: Radio initialized
> [   40.529192] input: b43legacy-phy0 as /class/input/input9
> [   40.632070] b43legacy ssb0:0: firmware: requesting b43legacy/ucode2.fw
> [   40.696281] b43legacy ssb0:0: firmware: requesting b43legacy/pcm4.fw
> [   40.757265] b43legacy ssb0:0: firmware: requesting
> b43legacy/b0g0initvals2.fw
> [   40.984045] b43legacy-phy0: Loading firmware version 0x127, patch
> level 14 (2005-04-18 02:36:27)
> [   41.100298] b43legacy-phy0 debug: Chip initialized
> [   41.100599] b43legacy-phy0 debug: 30-bit DMA initialized
> [   41.100748] Registered led device: b43legacy-phy0:tx
> [   41.109182] Registered led device: b43legacy-phy0:rx
> [   41.117508] Registered led device: b43legacy-phy0:radio
> [   41.125678] b43legacy-phy0 debug: Wireless interface started
> [   41.125685] b43legacy-phy0 debug: Adding Interface type 2
> [   41.584048] b43legacy-phy0: Radio hardware status changed to DISABLED
> [   41.593709] b43legacy-phy0 debug: Radio initialized
> [   41.924035] b43legacy-phy0: Radio turned on by software
> [   41.932354] b43legacy-phy0: The hardware RF-kill button still turns
> the radio physically off. Press the button to turn it on.
> 
> Actually i am looking whether i missing some Kernel
> Options.
> 
> As we can see in the Boot Messages i have to activate the RF-kill
> Button by pressing, but this does not activate my wlan.

Your log does not indicate that you pressed the button to turn the
wifi on. All we see is that the hardware switch was off.

Is your radio on/off button one that generates a keycode, or does it
need the WMI magic to be detected? If you are running X, then switch
away by CTRL/ALT/F1 and log in. Use the showkey command and press the
radio on/off switch. If it shows a scan code, report it back here. You
get back to X with CTRL/ALT/F7.

Larry
