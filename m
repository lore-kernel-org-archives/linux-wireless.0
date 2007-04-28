Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpsrv03.uni-oldenburg.de ([134.106.87.11]:40564 "EHLO
	smtpsrv03.uni-oldenburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1161530AbXD1PcJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sat, 28 Apr 2007 11:32:09 -0400
Message-ID: <463368EC.3060608@mail.uni-oldenburg.de>
Date: Sat, 28 Apr 2007 17:31:56 +0200
From: Stefan Puch <stefan.puch@mail.uni-oldenburg.de>
MIME-Version: 1.0
To: Chr <chunkeey@web.de>
CC: linux-net@vger.kernel.org, linux-wireless@vger.kernel.org
Subject: Re: prism54: WPA/RSN support for fullmac cards
References: <462336B1.4090006@mail.uni-oldenburg.de> <200704261228.01889.chunkeey@web.de> <46320D71.60409@mail.uni-oldenburg.de> <200704271821.53323.chunkeey@web.de>
In-Reply-To: <200704271821.53323.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> It looks like you've tried your luck with the unmodified kernel driver, right?

Yes, I did not modify to driver, I used the one provided with kernel-2.6.20

> Here is an older driver (updated, compiled & tested with 2.6.21-rc5 (actually,
> it's an older wireless-dev git) and a Makefile to build it outside of the kernel tree). 
> Unfortunatly, It can a while until you get an connection. (So, please wait about 5 mins)

I compiled the driver and tested it with kernel-2.6.21.2 and
kernel-2.6.21-rc6-g5363171f
I've attached the logfile from wpa_supplicant and iwevent, and an iwevent output
when using p54 (SOFTMAC driver) as reference, too. The logfiles show only a
short time, but I did some further test (one about 10mins) with the same output,
too. But I did never get a connection, for this Mail I'm using the p54 one...

> untar it, run make and insmod prism54.ko (don't use modprobe, or you may end up 
> with the wrong kernel module). Also, please check your wpa_supplicant.conf too, 
> you must enable ONLY TKIP (for group & pairwise) and nothing else!

I attached the wpa_supplicant.conf, too. (I think the options "ssid, key_mgmt,
proto and psk" must be set, too don't they?)

If there are important infos missing or if I could test something new, let me
know, I'm still looking forward to get the prism54 one working, too ;-)

Regards Stefan

