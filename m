Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from smtpsrv03.uni-oldenburg.de ([134.106.87.11]:43951 "EHLO
	smtpsrv03.uni-oldenburg.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1423029AbXDXTJb (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 24 Apr 2007 15:09:31 -0400
Message-ID: <462E55EA.4030900@mail.uni-oldenburg.de>
Date: Tue, 24 Apr 2007 21:09:30 +0200
From: Stefan Puch <stefan.puch@mail.uni-oldenburg.de>
MIME-Version: 1.0
To: linux-net@vger.kernel.org
CC: linux-wireless@vger.kernel.org
Subject: Re: prism54: WPA/RSN support for fullmac cards
References: <462336B1.4090006@mail.uni-oldenburg.de> <1176732546.27418.9.camel@localhost.localdomain> <4625130F.4090104@mail.uni-oldenburg.de> <200704172123.30956.chunkeey@web.de>
In-Reply-To: <200704172123.30956.chunkeey@web.de>
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Chr wrote:
>> I thought that at least chunkeey got a working connection.... obviously not.
>>
> Of course it works! But not with every AP... only with "hostapd".
> (I don't have anything else to try).

Perhaps we can do a meeting after your ABI and do some tests with another AP?


> But please, before you waste your time with _some_ fullmac anomalies,
> 
> get the last wireless-dev.git tree. 
> There is a SOFTMAC driver for all prism54 chips now! 
> 
> You only need a firmware: 
> http://daemonizer.de/prism54/prism54-fw/fw-softmac/lmac_2.7.0.0.arm
> (rename it to "isl3886" and put it in the right place).

- I got the wireless-dev.git tree version g5363171f.
- I could successfully use the SOFTMAC driver with my Netgear WG511 and the
  Fritz!Box Fon WLAN 7170
- WPA and WPA2 encryption worked fine (very good work Thanks!)
- only the "Act" (yellow) LED on the WLAN-Adapter was flashing very very fast
  the whole time, I hope it doesn't give up to fast (perhaps someone could set
  the rate a little bit down?)

- if I can do some further testings that may help you let me know

Regards Stefan

