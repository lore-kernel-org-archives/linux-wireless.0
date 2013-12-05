Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mout.web.de ([212.227.15.4]:49779 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753124Ab3LESK6 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 5 Dec 2013 13:10:58 -0500
Received: from [192.168.178.20] ([88.217.180.24]) by smtp.web.de (mrweb102)
 with ESMTPSA (Nemesis) id 0M40zO-1VXNgY1lru-00rUqV for
 <linux-wireless@vger.kernel.org>; Thu, 05 Dec 2013 19:10:56 +0100
Message-ID: <52A0C1A8.5020504@web.de> (sfid-20131205_191100_817495_DC796F89)
Date: Thu, 05 Dec 2013 19:10:48 +0100
From: Sam <blue-t@web.de>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: AVM Fritz Stick N v2 has troubles loading the driver rt2x00
References: <528BBFAE.4050900@web.de>
In-Reply-To: <528BBFAE.4050900@web.de>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>


Hello,

I recently tried to get my AVM Fritz Stick N v2 working under Kubuntu
13.04 with a new 3.12 kernel from the mainline ppa after i
heard it was supported in this driver.

Here some diagnostic logs:

lsusb

Bus 001 Device 004: ID 057c:8501 AVM GmbH 

uname -a


Linux greyback 3.12.0-031200rc2-generic #201309231935 SMP Mon Sep 23 23:37:12 UTC 2013 x86_64 x86_64 x86_64 GNU/Linux


Error from dmesg:

[   23.011160] ieee80211 phy0: rt2x00_set_rt: Info - RT chipset 5592, rev 0222 detected
[   23.048498] ieee80211 phy0: rt2x00usb_vendor_request: Error - Vendor Request 0x09 failed for offset 0x0000 with error -32
[   23.048539] ieee80211 phy0: rt2x00lib_probe_dev: Error - Failed to allocate device
[   23.048586] rt2800usb: probe of 1-1.3:1.0 failed with error -32
[   23.048641] usbcore: registered new interface driver rt2800usb

It is detected , driver modules are loaded according to lsmod. 
According to the internet this stick is featuring a RT 5572, even though this log says something different.

What is going south here? 

Regards
Sam

