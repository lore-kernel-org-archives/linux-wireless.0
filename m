Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-fx0-f46.google.com ([209.85.161.46]:41600 "EHLO
	mail-fx0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751159Ab1AHTV3 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 8 Jan 2011 14:21:29 -0500
Received: by fxm20 with SMTP id 20so17824458fxm.19
        for <linux-wireless@vger.kernel.org>; Sat, 08 Jan 2011 11:21:28 -0800 (PST)
MIME-Version: 1.0
Date: Sat, 8 Jan 2011 14:21:27 -0500
Message-ID: <AANLkTimj11OJRbjO2GBn=C36D7UDUURvguERS5XYoJ7W@mail.gmail.com>
Subject: 5GHz 802.11n USB Adapter
From: Jason Andryuk <jandryuk@gmail.com>
To: linux-wireless@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I am looking for a linux-supported dual band 802.11n USB Adapter that
can operate at both 2.4GHz and 5GHz.

According to wireless.kernel.org, it seems like the possibilities are:
carl9170/ar9170, rt2800usb and maybe ath9k_htc.

Atheros involvement with linux development is appealing, so I would
prefer an adapter based on their chips.  I also have the feeling their
drivers are more mature than the Ralink ones.

The carl9170 wiki page mentions "It's worth mentioning that the chip
was designed, produced and sold in the early 802.11n-draft period.
Compatibility will always be an issue."  So a product based on the
finalized 802.11n standard is more desirable.

For ath9k_htc, ar7010 devices with the ar9280 radio should support
dual bands.  However, the wiki does not list any devices with that
chip aside from the generic Atheros VID/PID.  Are dual band ar7010 USB
devices commercially available in the US?

Are there any limitations for rt2800usb devices?  The wiki is short on
information as is rt2x00.serialmonkey.com.  Does rt2800usb support AP
mode like rt2800pci?

Are their any other drivers/devices I have overlooked and should consider?

Recommendations of specific devices are appreciated.

Thanks,

Jason
