Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:33412 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751064Ab2EaQwK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 12:52:10 -0400
Message-ID: <1338483124.1817.53.camel@aeonflux> (sfid-20120531_185214_596190_614D5A27)
Subject: Re: Master mode support in iwlagn?
From: Marcel Holtmann <marcel@holtmann.org>
To: Dan Williams <dcbw@redhat.com>
Cc: Arend van Spriel <arend@broadcom.com>,
	Erwin Van de Velde <erwin.vandevelde@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Florian Fainelli <florian@openwrt.org>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 31 May 2012 18:52:04 +0200
In-Reply-To: <1338474236.2242.1.camel@dcbw.foobar.com>
References: <5252852.vpKViOerhF@sylvesterjr.cmi.ua.ac.be>
	 <5625918.SuzapvkoUg@sylvesterjr.cmi.ua.ac.be>
	 <4FC75DA4.2090909@broadcom.com>
	 <1999855.FUDAX7EfOH@sylvesterjr.cmi.ua.ac.be> <4FC76389.70600@broadcom.com>
	 <1338474236.2242.1.camel@dcbw.foobar.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dan,

> > > I have one ethernet connection and want to share that connection over 
> > > wireless, preferably in AP mode although I guess ad hoc mode is possible too. 
> > > Just not sure if NetworkManager supports that.
> > 
> > NetworkManager does support ad-hoc, but your hardware need to support
> > beacon transmission for that as well. You could consider buying an AP.
> > They are not that expensive ;-)
> 
> The problem with Ad-Hoc as "hotspot" is that many devices like Android
> phones simply ignore adhoc networks due to security issues (as stupid as
> that may be, since anyone can set up an AP-mode network too).  Which is
> why real AP mode is nice, but clearly not all wifi hardware is going to
> support it.

the security issue is the missing proper encryption for IBSS networks.
Even while in theory you can have RSN, but who is really supporting this
on the other end.

For example ConnMan ignores IBSS networks as well for the exact above
reason. And it only provides Tethering via AP mode with RSN. If the
hardware does not support it, then you can not use Tethering.

We have enough crappy Windows machines and printers trying to play IBSS
tricks all the time. We do not need any extra ones ;)

Regards

Marcel


