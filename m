Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:47087 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753579Ab2EaRAh (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 13:00:37 -0400
Message-ID: <1338483631.9102.9.camel@jlt3.sipsolutions.net> (sfid-20120531_190041_029844_379D383D)
Subject: Re: Master mode support in iwlagn?
From: Johannes Berg <johannes@sipsolutions.net>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Dan Williams <dcbw@redhat.com>,
	Arend van Spriel <arend@broadcom.com>,
	Erwin Van de Velde <erwin.vandevelde@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Florian Fainelli <florian@openwrt.org>
Date: Thu, 31 May 2012 19:00:31 +0200
In-Reply-To: <1338483124.1817.53.camel@aeonflux>
References: <5252852.vpKViOerhF@sylvesterjr.cmi.ua.ac.be>
	 <5625918.SuzapvkoUg@sylvesterjr.cmi.ua.ac.be>
	 <4FC75DA4.2090909@broadcom.com>
	 <1999855.FUDAX7EfOH@sylvesterjr.cmi.ua.ac.be> <4FC76389.70600@broadcom.com>
	 <1338474236.2242.1.camel@dcbw.foobar.com>
	 <1338483124.1817.53.camel@aeonflux>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-31 at 18:52 +0200, Marcel Holtmann wrote:

> > The problem with Ad-Hoc as "hotspot" is that many devices like Android
> > phones simply ignore adhoc networks due to security issues (as stupid as
> > that may be, since anyone can set up an AP-mode network too).  Which is
> > why real AP mode is nice, but clearly not all wifi hardware is going to
> > support it.
> 
> the security issue is the missing proper encryption for IBSS networks.
> Even while in theory you can have RSN, but who is really supporting this
> on the other end.

We are actually supporting this now, and supposedly it interoperates
with Windows too :-)

johannes

