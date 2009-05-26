Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from web36808.mail.mud.yahoo.com ([209.191.85.59]:39958 "HELO
	web36808.mail.mud.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1753018AbZEZDni convert rfc822-to-8bit
	(ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 May 2009 23:43:38 -0400
Message-ID: <394878.84106.qm@web36808.mail.mud.yahoo.com>
Date: Mon, 25 May 2009 20:43:40 -0700 (PDT)
From: Jean-Pierre Poulin <jeanpierrepoulin@yahoo.com>
Subject: Suggestions on low-cost Linux/ARM-friendly WiFi module or chipset...
To: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello,
 
May I obtain your recommendation on a Linux + ARM friendly WiFi module or chipset?
 
The solution we’re looking for must have the following features:
- WiFi features: 802.11b + 802.11g with WPA & WEP encryption.
- Driver: Binary driver built for Linux+ARM9 *or* Driver source buildable for Linux 2.6.28.2
- Electronic Interface: SDIO (strongly) preferred, then parallel bus, then SPI, and least preferred: USB
- Physical interface: SMD-mounting (strongly) preferred, then SD-card, then USB stick
- Size: Smaller the better (especially on ‘thickness’), but not critical.
- Power efficiency: Irrelevant / Not critical.
- Cost: Extremely critical!!
- Range: The greater the better, but low-cost is much more important.
- Antenna considerations: Small built-in chip antenna preferred.  External whip antenna a minus.
 
Working backwards on this from the currently available drivers (we’re building our Linux image ontop OpenWRT for the $2.80 NXP LPC313x), the following drivers are ‘easily accessible’ in OpenWRT… but we have yet to find the low-cost manufacturers that can provide the physical WiFi solution itself…
 
               
kmod-libertas............................ Marvell 88W8015 Wireless Driver 
kmod-mac80211..................... Linux 802.11 Wireless Networking Stack 
kmod-mac80211-hwsim........................ mac80211 HW simulation device 
kmod-p54-common................................. Prism54 Drivers (COMMON) 
kmod-p54-usb....................................... Prism54 Drivers (USB) 
kmod-rt2500-usb............. Ralink Drivers for RT2x00 cards (RT2500 USB) 
kmod-rt2800-usb............. Ralink Drivers for RT2x00 cards (RT2870 USB) 
kmod-rt2x00-lib.................... Ralink Drivers for RT2x00 cards (LIB) 
kmod-rt2x00-usb.................... Ralink Drivers for RT2x00 cards (USB) 
kmod-rt73-usb................. Ralink Drivers for RT2x00 cards (RT73 USB) 
kmod-zd1211rw....................................... Zydas ZD1211 support 
 
In addition, searching through the list of drivers at Linux Wireless, we were impressed by the comprehensive selection but – as device prices are not listed – it is very difficult to ascertain which inexpensive WiFi solution can run on our board.
 
Finally, as the cost of the total WiFi solution is so important, our ‘upper range’ for cost is about $11 per interface (1K qty), as our ‘plan B’ is simply to insert one of the many $13 USB-WiFi interface (such as those found on eBay) inside the product enclosure.  Some questions:
 
Q1: Given our above-stated needs… which do you recommend: the ‘module approach’, the ‘chipset approach’ or the ‘insert consumer product’ approach?
 
Q2: What is the ‘most famous’ / ‘most supported’ Linux/ARM-friendly low-cost WiFi solution currently available?
 
Q3: Can you recommend some low-cost (Taiwanese / Chinese) WiFi manufacturers that supplies low-cost Linux-compatible solutions?
 
Q4: For reference, what do you think is the cost of the ‘absolute lowest cost’ WiFi solution currently available?
 
Many thanks for any hint / suggestion you can provide!
 
   Jean-Pierre


      
