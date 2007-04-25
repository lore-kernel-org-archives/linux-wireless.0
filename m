Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from fmmailgate02.web.de ([217.72.192.227]:50850 "EHLO
	fmmailgate02.web.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1030877AbXDYNrW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 25 Apr 2007 09:47:22 -0400
From: Chr <chunkeey@web.de>
To: Stefan Puch <stefan.puch@mail.uni-oldenburg.de>
Subject: Re: prism54: WPA/RSN support for fullmac cards
Date: Wed, 25 Apr 2007 15:47:20 +0200
Cc: linux-net@vger.kernel.org, linux-wireless@vger.kernel.org
References: <462336B1.4090006@mail.uni-oldenburg.de> <200704172123.30956.chunkeey@web.de> <462E55EA.4030900@mail.uni-oldenburg.de>
In-Reply-To: <462E55EA.4030900@mail.uni-oldenburg.de>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Message-Id: <200704251547.20248.chunkeey@web.de>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tuesday, 24. April 2007, Stefan Puch wrote:
> Chr wrote:
> >> I thought that at least chunkeey got a working connection.... obviously not.
> >>
> > Of course it works! But not with every AP... only with "hostapd".
> > (I don't have anything else to try).
> 
> Perhaps we can do a meeting after your ABI and do some tests with another AP?
Now, I'm "finish" with the "practical" part... ;-).
But, I won't be here the next few weeks, (field excursion, another field excursion 
and did I mention lots of field excursion?) . 

> 
> > But please, before you waste your time with _some_ fullmac anomalies,
> > 
> > get the last wireless-dev.git tree. 
> > There is a SOFTMAC driver for all prism54 chips now! 
> > 
> > You only need a firmware: 
> > http://daemonizer.de/prism54/prism54-fw/fw-softmac/lmac_2.7.0.0.arm
> > (rename it to "isl3886" and put it in the right place).
> 
> - I got the wireless-dev.git tree version g5363171f.
> - I could successfully use the SOFTMAC driver with my Netgear WG511 and the
>   Fritz!Box Fon WLAN 7170
> - WPA and WPA2 encryption worked fine (very good work Thanks!)
> - only the "Act" (yellow) LED on the WLAN-Adapter was flashing very very fast
>   the whole time, I hope it doesn't give up to fast (perhaps someone could set
>   the rate a little bit down?)
> 

Na, don't worry, I've copied more than 4 GB over the WIFI link, it should be stable.
But, I know that some cheap APs may have "stability" problems, I ditched my old 
Netgear WG624 for that reason. 

> - if I can do some further testings that may help you let me know
> 

(Do you know why your AP rejects the FULLMAC driver?
If you have another card you can "monitor" for "deauth" or
"disassoc" mlmes, they include a "reason" code)

Thanks,
	Chr.

