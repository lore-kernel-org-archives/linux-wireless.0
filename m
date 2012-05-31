Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from senator.holtmann.net ([87.106.208.187]:57541 "EHLO
	mail.holtmann.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933245Ab2EaUAd (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 16:00:33 -0400
Message-ID: <1338494428.1817.56.camel@aeonflux> (sfid-20120531_220050_037810_8FAA6129)
Subject: Re: Master mode support in iwlagn?
From: Marcel Holtmann <marcel@holtmann.org>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: Dan Williams <dcbw@redhat.com>,
	Arend van Spriel <arend@broadcom.com>,
	Erwin Van de Velde <erwin.vandevelde@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Florian Fainelli <florian@openwrt.org>
Date: Thu, 31 May 2012 22:00:28 +0200
In-Reply-To: <1338483631.9102.9.camel@jlt3.sipsolutions.net>
References: <5252852.vpKViOerhF@sylvesterjr.cmi.ua.ac.be>
	 <5625918.SuzapvkoUg@sylvesterjr.cmi.ua.ac.be>
	 <4FC75DA4.2090909@broadcom.com>
	 <1999855.FUDAX7EfOH@sylvesterjr.cmi.ua.ac.be> <4FC76389.70600@broadcom.com>
	 <1338474236.2242.1.camel@dcbw.foobar.com>
	 <1338483124.1817.53.camel@aeonflux>
	 <1338483631.9102.9.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Johannes,

> > > The problem with Ad-Hoc as "hotspot" is that many devices like Android
> > > phones simply ignore adhoc networks due to security issues (as stupid as
> > > that may be, since anyone can set up an AP-mode network too).  Which is
> > > why real AP mode is nice, but clearly not all wifi hardware is going to
> > > support it.
> > 
> > the security issue is the missing proper encryption for IBSS networks.
> > Even while in theory you can have RSN, but who is really supporting this
> > on the other end.
> 
> We are actually supporting this now, and supposedly it interoperates
> with Windows too :-)

I still don't see the benefit of it. Android and iOS do proper Tethering
via AP mode. And so does Tizen since it uses ConnMan.

IBSS and also WEP support can be remove for all I care ;)

Regards

Marcel


