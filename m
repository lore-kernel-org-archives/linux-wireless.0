Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-ee0-f46.google.com ([74.125.83.46]:51224 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750763Ab2DQUB2 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 17 Apr 2012 16:01:28 -0400
Received: by eekc41 with SMTP id c41so1714816eek.19
        for <linux-wireless@vger.kernel.org>; Tue, 17 Apr 2012 13:01:27 -0700 (PDT)
Message-ID: <4F8DCC15.8080006@gmail.com> (sfid-20120417_220132_602326_93F97827)
Date: Tue, 17 Apr 2012 22:01:25 +0200
From: Mark Baas <mark.baas@gmail.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: 0489:e03c Foxconn / Hon Hai
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Dear all,

I have a Acer Timelinex 4830TG with a 0489:e03c Foxconn / Hon Hai 
Bluetooth usb device. This device usually loads fine, but cannot detect 
any devices. I believe this is a Atheros (?3012), so I added the device 
to the btusb.c blacklist and enabled it in ath3k.c. However it won't 
load as it comes with the error:
Bluetooth: Error in firmware loading err = -110,len = 0, size = 4096
ath3k: probe of 1-1.6:1.0 failed with error -110

Can it be that the firmware has to be modified to support this device? 
Or possible it is not a 3012 or 3011 device, however i am quite sure it 
is a Atheros device: http://listing.driveragent.com/c/usb/0489/e03c
Can anyone help me figure out what needs to be done to get this device 
supported?

Greetings,

Mark

