Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smarthost3.win.pl ([195.88.31.150]:1144 "EHLO smarthost3.win.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752248Ab0CZVj5 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Fri, 26 Mar 2010 17:39:57 -0400
Message-ID: <4BAD27E6.1030708@ode2.com>
Date: Fri, 26 Mar 2010 22:32:22 +0100
From: =?ISO-8859-2?Q?Dominik_Wn=EAk?= <dominik@ode2.com>
MIME-Version: 1.0
To: linux-wireless@vger.kernel.org
Subject: ar9170: USB dongle locks up until replugged
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hello,

I asked a question about this on the IRC channel and was told it was 
worth writing to the mailing list as well. I also filed a bug about this 
to Canonical here: 
https://bugs.launchpad.net/ubuntu/+source/network-manager/+bug/549140

In short: On Ubuntu 10.04 (currently in Beta 1), the USB dongle (Netgear 
WNDA3100) locks up and the radio stops working after a random amount of 
time (from a minute to a few hours). The dongle has to be unplugged and 
replugged to start working again. Restarting NM and/or unloading and 
reloading the module has no effect. This is clearly a problem between 
Network Manager and the ar9170usb module, since removing NM makes it go 
away.

It was, however, suggested to me that perhaps the driver shouldn't allow 
for something like this to happen in the first place, which is why I'm 
writing here.

dmesg and daemon.log which includes messages from nm don't include any 
interesting info; I'll be willing to provide other logs if anyone thinks 
they are relevant. The launchpad bug I refer to above has some debugging 
information attached.

Thanks,

Dominik



