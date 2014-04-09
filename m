Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from ironport2-out.teksavvy.com ([206.248.154.181]:62067 "EHLO
	ironport2-out.teksavvy.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S933100AbaDIPrU (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Apr 2014 11:47:20 -0400
Message-ID: <3b045ae380adf4cae45a6e7cd1741ba6.squirrel@www.infidigm.net> (sfid-20140409_174724_198895_D39F4A93)
Date: Wed, 9 Apr 2014 11:27:48 -0400
Subject: QCA ar9375 in Ubuntu 14.04 beta 2 not working
From: drwho@infidigm.net
To: linux-wireless@vger.kernel.org
Cc: ath6kl-devel@qca.qualcomm.com
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I just got a UB134C which has a QCA ar9375.  I tried it in Ubuntu 14.04
beta 2 kernel =
3.13.0-22-generic #44-Ubuntu SMP Wed Apr 2 20:04:41 UTC 2014 i686

I'm told the 9375 is an ath6kl, but it doesn't look like the ath6kl driver
supports it.  kernel output.....

new high-speed USB device number 4 using ehci-pci
[175257.129911] usb 1-2: New USB device found, idVendor=0cf3, idProduct=9375
[175257.129923] usb 1-2: New USB device strings: Mfr=1, Product=2,
SerialNumber=3
[175257.129931] usb 1-2: Product: USBWLAN
[175257.129939] usb 1-2: Manufacturer: Qualcomm Atheros.
[175257.129946] usb 1-2: SerialNumber: 12345678

Jon

