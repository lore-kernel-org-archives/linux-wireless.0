Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52440 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760747Ab2EPXZF (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Wed, 16 May 2012 19:25:05 -0400
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1SUnaZ-0008IR-F3
	for linux-wireless@vger.kernel.org; Thu, 17 May 2012 01:25:03 +0200
Received: from lns-bzn-48f-81-56-242-144.adsl.proxad.net ([81.56.242.144])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 01:25:03 +0200
Received: from alexandre.alouit by lns-bzn-48f-81-56-242-144.adsl.proxad.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 17 May 2012 01:25:03 +0200
To: linux-wireless@vger.kernel.org
From: Alex Alouit <alexandre.alouit@gmail.com>
Subject: Module Carl9170, firmware won't load properly
Date: Wed, 16 May 2012 23:19:56 +0000 (UTC)
Message-ID: <loom.20120517T011514-623@post.gmane.org> (sfid-20120517_012510_153224_85315299)
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello, 

I want to use an Netgear WN111v2 (AR9170 usb wireless) with Vyatta 6.4, 
I copied the firmware (http://linuxwireless.org/en/users/Drivers/carl9170), 
(carl9170-1.fw in /usr/local/lib/firmware version 1.9.2 (kernel 3.0.23)) 
but it seems that the module doesn't load correctly the firmware. 


dmesg output: 
Code:

usb 1-1: new high speed USB device number 2 using ehci_hcd 
usb 1-1: New USB device found, idVendor=0846, idProduct=9001 
usb 1-1: New USB device strings: Mfr=16, Product=32, SerialNumber=48 
usb 1-1: Product: USB2.0 WLAN 
usb 1-1: Manufacturer: ATHER 
usb 1-1: SerialNumber: 12345 
usb 1-1: reset high speed USB device number 2 using ehci_hcd 
usbcore: registered new interface driver carl9170 
usb 1-1: driver   API: 1.9.2 2011-01-22 [1-1] 
usb 1-1: firmware API: 1.9.2 2010-12-25 
usb 1-1: firmware upload failed (-110). 


It's the module or firmware that is buggy? How can I fix this?

Excuse my English, is not my native language. 


Best regards

