Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail18.bluewin.ch ([195.186.19.64]:53559 "EHLO
	mail18.bluewin.ch" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751967Ab0J3Iz4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 30 Oct 2010 04:55:56 -0400
Received: from ps28zhh.bluewin.ch (localhost [127.0.0.1])
	by ps28zhh.bluewin.ch (Postfix) with ESMTP id 258FD10926
	for <linux-wireless@vger.kernel.org>; Sat, 30 Oct 2010 08:48:51 +0000 (GMT)
Message-ID: <13216803.15461288428531150.JavaMail.webmail@bluewin.ch>
Date: Sat, 30 Oct 2010 08:48:51 +0000 (GMT+00:00)
From: "benjmeier@bluewin.ch" <benjmeier@bluewin.ch>
Reply-To: benjmeier@bluewin.ch
To: linux-wireless@vger.kernel.org
Subject: USB Setup failed (-32)
MIME-Version: 1.0
Content-Type: text/plain;charset="UTF-8"
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I have a Olimex SAM9-L9260-Board (http://www.olimex.com/dev/sam9-L9260.html), which has an ARM-Processor.

I used many 
devices on this hardware, mostly over usb (UMTS-Modems, Sticks...). Everything worked.
I saw that i can use the 
ar9170usb-driver for wireless, so i bought a Netgear WN111v2 (http://linuxwireless.org/en/users/Drivers/ar9170).

Then 
i installed the needed firmware. But it didnt work. This is the output:

usb 1-1.3: new full speed USB device using 
at91_ohci and address 3
usb 1-1.3: New USB device found, idVendor=0846, idProduct=9001
usb 1-1.3: New USB device 
strings: Mfr=16, Product=32, SerialNumber=48
usb 1-1.3: Product: USB2.0 WLAN
usb 1-1.3: Manufacturer: ATHER
usb 1-1.3: 
SerialNumber: 12345
cfg80211: Calling CRDA to update world regulatory domain
usb 1-1.3: reset full speed USB device 
using at91_ohci and address 3
usbcore: registered new interface driver ar9170usb
usb 1-1.3: firmware: requesting ar9170.
fw
usb 1-1.3: USB setup failed (-32).

I searched everywhere the errormessage with the errorcode -32, but i didnt find 
a meaning.
On the pc the wireless-stick works perfectly (with the same firmware).

Has someone an idea what i can do?


Thanks
Best Regards
