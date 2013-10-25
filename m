Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from tur.go2.pl ([193.17.41.50]:51896 "EHLO tur.go2.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751855Ab3JYIhN (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 25 Oct 2013 04:37:13 -0400
Received: from moh1-ve3.go2.pl (moh1-ve3.go2.pl [193.17.41.134])
	by tur.go2.pl (Postfix) with ESMTP id 813046989D9
	for <linux-wireless@vger.kernel.org>; Fri, 25 Oct 2013 10:03:10 +0200 (CEST)
Received: from moh1-ve3.go2.pl (unknown [10.0.0.134])
	by moh1-ve3.go2.pl (Postfix) with ESMTP id 23335664B23
	for <linux-wireless@vger.kernel.org>; Fri, 25 Oct 2013 10:02:27 +0200 (CEST)
Received: from unknown (unknown [10.0.0.74])
	by moh1-ve3.go2.pl (Postfix) with SMTP
	for <linux-wireless@vger.kernel.org>; Fri, 25 Oct 2013 10:02:27 +0200 (CEST)
Message-ID: <526A2593.6050001@o2.pl> (sfid-20131025_103719_120308_9EC4E299)
Date: Fri, 25 Oct 2013 10:02:27 +0200
From: Piotr Kaczorek <kacz0r1984@o2.pl>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Monitor mode stopped working after kernel upgrade
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

So far I was using monitor mode on my Debian Lenny with custom 3.2.24 
kernel.
I needed support for new hardware so I've compiled a new kernel version 
(3.10.12).
I've used the config from old kernel version and set up new kernel 
modules (mostly default).

After recompiling the kernel and installing it the monitor mode stopped 
returning packets that I got before.
I can see only Beacons, Probe Requests and Probe Responses now (no Data 
packets etc...).
The monitor mode is created with airmon-ng start wlan0 (I know there is 
already mon.wlan0 at start but I need also the extra headers which the 
airmon-ng enables).
Anyway - on both interfaces (mon.wlan0 and mon0) I don't see the 
required packets anymore.
The WiFi cards I tried are based on Atheros 2413 (ath5k) or Prism 
(p54pci) chipsets.
Both worked before upgrade, none of them works after upgrade.

Any ideas what have changed ?
Maybe I've chosen wrong option in case of one of the new kernel 
modules/options ?

Regards,
Piotr
