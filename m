Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail-gx0-f214.google.com ([209.85.217.214]:35424 "EHLO
	mail-gx0-f214.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751084AbZFSRyq (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 19 Jun 2009 13:54:46 -0400
Received: by gxk10 with SMTP id 10so3088552gxk.13
        for <linux-wireless@vger.kernel.org>; Fri, 19 Jun 2009 10:54:49 -0700 (PDT)
MIME-Version: 1.0
Date: Fri, 19 Jun 2009 10:54:49 -0700
Message-ID: <45e8e6c40906191054k3fce4d27od827bdbf8ed76d09@mail.gmail.com>
Subject: ar9170usb and module link in sysfs?
From: Andrey Yurovsky <andrey@cozybit.com>
To: linux-wireless <linux-wireless@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

I'm curious about the ar9170usb driver and its 'module' links (or
rather, lack there of) in sysfs.  For other drivers, I can look up a
wlanN interface's module by doing looking at
device/driver/module/drivers:

# ls /sys/class/net/wlan0/device/driver/module/drivers/
pci:ath5k
# ls /sys/class/net/wlan1/device/driver/module/drivers/
usb:zd1211rw

For ar9170usb, the driver directory doesn't have a module subdirectory
and I can't seem to find a link to /sys/bus/usb/drivers/ar9170usb via
/sys/class/wlanN like I'd expect to.  Is this normal or does ar9170usb
do something different with respect to sysfs that I'm missing?
Thanks,

  -Andrey
