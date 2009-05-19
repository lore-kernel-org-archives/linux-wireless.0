Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:57877 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753163AbZESQ7c (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 19 May 2009 12:59:32 -0400
Subject: Re: DHCP broken when using A-band only
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
In-Reply-To: <1242720983.29049.16.camel@johannes.local>
References: <1242701451.3147.2.camel@localhost.localdomain>
	 <1242720983.29049.16.camel@johannes.local>
Content-Type: text/plain
Date: Tue, 19 May 2009 09:59:19 -0700
Message-Id: <1242752359.3147.9.camel@localhost.localdomain>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > so I am running the latest wireless-testing.git tree based on 2.6.30-rc6
> > and when connecting to my A-band only configured AP, I don't get any
> > packets through. Even DHCP fails. The only thing I see in dmesg is
> > 
> > [ 3221.246392] wlan0: dropped frame to 00:1f:f3:xx:xx:xx (unauthorized port)
> > 
> > The wireless-testing.git tree based on 2.6.30-rc5 was working fine with
> > that access point. I was actually happily using the A-band since it is
> > less busy here. Any ideas why this might broke?
> 
> Not at all, sorry. Were there any driver changes? There shouldn't be
> many changes at all maybe you could bisect?

I will make sure I can bisect this as quickly as possible.

One other thing is that I disabled every feature in my DIR-615 access
point. So no 802.11d, no protection no WMM, no nothing and switched back
to 802.11g instead of 802.11n.

And after starting a download for 600 MB image, it stopped half-way
through and my connection broke down. The AP kept working for any other
device that was connected to it. So this issue is way strange.

Regards

Marcel


