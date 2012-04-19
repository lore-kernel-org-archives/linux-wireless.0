Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-iy0-f174.google.com ([209.85.210.174]:40970 "EHLO
	mail-iy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752640Ab2DSHzc (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 19 Apr 2012 03:55:32 -0400
Received: by iagz16 with SMTP id z16so11575513iag.19
        for <linux-wireless@vger.kernel.org>; Thu, 19 Apr 2012 00:55:31 -0700 (PDT)
MIME-Version: 1.0
Date: Thu, 19 Apr 2012 09:55:31 +0200
Message-ID: <CAG=oC7T88XrVB9qyeAs5QgUQtLrs_fDBdzZ2Vpky1ip40FS7eg@mail.gmail.com> (sfid-20120419_095534_619819_93ECD378)
Subject: ath3k device
From: "mark.baas@gmail.com" <mark.baas@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Sorry all, I have already sent this message, but I have received no
replies until now. I changed the subject.

I have a Acer Timelinex 4830TG with a 0489:e03c Foxconn / Hon Hai
Bluetooth usb device. This device usually loads fine, but cannot
detect any devices. I believe this is a Atheros (?3012), so I added
the device to the btusb.c blacklist and enabled it in ath3k.c. However
it won't load as it comes with the error:
Bluetooth: Error in firmware loading err = -110,len = 0, size = 4096
ath3k: probe of 1-1.6:1.0 failed with error -110

Can it be that the firmware has to be modified to support this device?
Or possible it is not a 3012 or 3011 device, however i am quite sure
it is a Atheros device: http://listing.driveragent.com/c/usb/0489/e03c
Can anyone help me figure out what needs to be done to get this device
supported?

Greetings,

Mark
