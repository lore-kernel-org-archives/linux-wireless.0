Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from uxs-bsd-240-042.unaxus.net ([195.191.240.42]:16392 "EHLO
	uxs-bsd-240-042.unaxus.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752430Ab0EaQYI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 31 May 2010 12:24:08 -0400
Received: from i577a8134.versanet.de ([87.122.129.52]:41288 helo=[192.168.178.92])
	by uxs-bsd-240-042.unaxus.net with esmtpsa (TLSv1:CAMELLIA256-SHA:256)
	(Exim 4.71 (FreeBSD))
	(envelope-from <janek.bevendorff@openwebboard.org>)
	id 1OJ5tc-000Nwo-1T
	for linux-wireless@vger.kernel.org; Mon, 31 May 2010 16:23:16 +0200
Message-ID: <4C03C652.3000608@openwebboard.org>
Date: Mon, 31 May 2010 16:23:14 +0200
From: Janek Bevendorff <janek.bevendorff@openwebboard.org>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: Strange behavior of DWA-547
Content-Type: text/plain; charset=UTF-8
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hey guys!

There's a strange problem with my brand-new DWA-547 PCI WLAN card.
I use the driver ath9k for it (already tried Madwifi and ndiswrapper,
both don't work for me at all). I'm on a Gentoo Linux with a 2.6.34
kernel and linux-headers package 2.6.33 (newest in Portage). I first
used the built-in kernel module and now the bleeding edge ath9k driver
from wireless.kernel.org but it brought no change.

So what's the problem? The problem is that I have a very unsteady WLAN
connection. iwconfig wlan2 (wlan2 is the device since it's not the first
WLAN adapter I've used but all other drivers are unloaded) shows me bit
rates from 1Mb/s up to 54Mb/s depending on... yes I actually don't know
what it depends on.
The actual data rate is between 0kB/s and 700kB/s, sometimes it has tips
up to 1,3/MB/s for a second or so. But the average data rate is about
120-200kB/s or below. But that's very slow. I had another WLAN device
which had a more stable connection. Sometimes I have a data rate of
fantastic 700kB/s and then it suddenly goes down to 60kB/s. And of
course one connection has a significantly different data rate than the
previous connection. So when I connect with a good speed, then
disconnect and reconnect it can be that I now have not even half of the
speed I had before but I haven't changed the position of the antennas at
all.
Adjusting the antennas of course has an effect on the speed but not
significantly. I can adjust them in a way that I get 0kB/s but anyway
when I already have a very slow connection I can only advance the speed
about 80-100kB/s, not more.

I've googled a lot the last few days and found many similar problems
with ath9k but none of them solved my problem. I use WICD as my network
manager and most of the time it shows an orange bar for the connection
quality (~45-50%), seldom a green bar but never 100%. Sometimes it even
shows a red bar (<25%) whereas my old WLAN card always had a green bar
and that with only one antenna (DWA-547 has three).

Here's what lspci says about my WLAN card:
0c:02.0 Network controller: Atheros Communications Inc. AR922X Wireless
Network Adapter (rev 01)


I hope someone can help me.

Thanks
Janek
