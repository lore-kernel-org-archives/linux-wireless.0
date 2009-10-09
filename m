Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from bu3sch.de ([62.75.166.246]:60913 "EHLO vs166246.vserver.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760594AbZJIJnA (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 9 Oct 2009 05:43:00 -0400
From: Michael Buesch <mb@bu3sch.de>
To: bcm43xx-dev@lists.berlios.de
Subject: Broadcom cards for free
Date: Fri, 9 Oct 2009 11:39:33 +0200
Cc: linux-wireless@vger.kernel.org
MIME-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Message-Id: <200910091139.36089.mb@bu3sch.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi,

I've currently got two Broadcom cards to offer for free.
http://bu3sch.de/misc/bcmcards.JPG

The cardbus one is a WPC300N V1 802.11n card.
It can be used for development of the b43 N-PHY code.

The USB one is BCM4320 which works over RNDIS-WLAN.
This device is disassembled and the EEPROM, which contains
the on-board operating system, is unsoldered and connected through a pinheader.
That means it can be read and/or reprogrammed outside of the device.
The RF-shield on the RF-side of the board was removed.
The device should work properly. It properly registers to the kernel, but I did
not try if it works with the rndis-wlan driver.

-- 
Greetings, Michael.
