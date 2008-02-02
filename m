Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bay0-omc3-s6.bay0.hotmail.com ([65.54.246.206]:36443 "EHLO
	bay0-omc3-s6.bay0.hotmail.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754929AbYBBOZc convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Sat, 2 Feb 2008 09:25:32 -0500
Message-ID: <BAY101-W12F4D19DA27A5DA9F177E1C8310@phx.gbl> (sfid-20080202_142537_726375_237DE106)
From: Adam Turk <bofh1234@hotmail.com>
To: <linux-wireless@vger.kernel.org>
Subject: rt73 driver doesn't work in 2.6.24
Date: Sat, 2 Feb 2008 09:18:19 -0500
Content-Type: text/plain; charset=US-ASCII
MIME-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello,

I was rather pleased to see that my Edimax ew7318usg was supported by mainline.  I created a new config, compiled, (no errors), and rebooted with the wireless card plugged in and I get errors on module load. Here is the output from dmesg:

rt73usb 1-1:1.0: usb_probe_interface
rt73usb 1-1:1.0: usb_probe_interface - got id
phy0 -> rt73usb_validate_eeprom: EEPROM recovery - NIC: 0xffef
phy0 -> rt73usb_validate_eeprom: EEPROM recovery - Led: 0xe000
phy0 -> rt73usb_validate_eeprom: EEPROM recovery - RSSI OFFSET BG: 0x0000
phy0 -> rt2x00_set_chip: Info - Chipset detected - rt: 1300, rf: 0002, rev: 0002573a.
phy0: Selected rate control algorithm 'simple'
phy0: Failed to initialize wep
phy0 -> rt2x00lib_probe_dev: Error - Failed to initialize hw.
rt73usb: probe of 1-1:1.0 failed with error -12
usbcore: registered new interface driver rt73usb

What do I need to do to get a working rt73usb driver?
Thanks,
Adam
_________________________________________________________________
Shed those extra pounds with MSN and The Biggest Loser!
http://biggestloser.msn.com/