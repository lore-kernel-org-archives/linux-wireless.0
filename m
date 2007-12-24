Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from server19320154104.serverpool.info ([193.201.54.104]:49565 "EHLO
	hauke-m.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750779AbXLXQ1q (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Dec 2007 11:27:46 -0500
Message-ID: <476FD6F0.4010605@hauke-m.de> (sfid-20071224_162755_556893_4EFD280C)
Date: Mon, 24 Dec 2007 16:57:36 +0100
From: Hauke Mehrtens <hauke@hauke-m.de>
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@winlab.rutgers.edu>
CC: linux-wireless@vger.kernel.org
Subject: rtl8187 Failed to select rate control algorithm 2.6.24-rc6
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi

The compat-wireless-2.6 package is compiling on Kernel 2.6.24-rc6.

Now I have the next problem. I want to load the rtl8187 module out of
the compat-wireless-2.6 package into kernel 2.6.24-rc6, but I get the
following message:

phy0: Failed to select rate control algorithm
phy0: Failed to initialize rate control algorithm
rtl8187: Cannot register device
rtl8187: probe of 6-3:1.0 failed with error -2
usbcore: registered new interface driver rtl8187

And no wireless device is created at iwconfig


When loading the module from vanilla kernel 2.6.24-rc6 it prints out the
following messages:

phy0: Selected rate control algorithm 'simple'
phy0: hwaddr 00:15:af:03:ab:79, rtl8187 V1 + rtl8225z2
usbcore: registered new interface driver rtl8187

And a wireless device is created at iwconfig and everything is working
as it should.

I downloaded the compat-wireless-2.6 package 1 hour ago.

I have got the same problem on kernel 2.6.22.
I loaded the following modules:
cfg80211.ko ; mac80211.ko ; eeprom_93cx6.ko ; rtl8187.ko

-- 
Merry Christmas

Hauke Mehrtens
