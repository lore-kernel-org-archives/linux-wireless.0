Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:46799 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753505Ab2EaO0z (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 31 May 2012 10:26:55 -0400
Message-ID: <1338474236.2242.1.camel@dcbw.foobar.com> (sfid-20120531_163830_698531_EAB936B8)
Subject: Re: Master mode support in iwlagn?
From: Dan Williams <dcbw@redhat.com>
To: Arend van Spriel <arend@broadcom.com>
Cc: Erwin Van de Velde <erwin.vandevelde@gmail.com>,
	linux-wireless <linux-wireless@vger.kernel.org>,
	Florian Fainelli <florian@openwrt.org>,
	Johannes Berg <johannes@sipsolutions.net>
Date: Thu, 31 May 2012 09:23:56 -0500
In-Reply-To: <4FC76389.70600@broadcom.com>
References: <5252852.vpKViOerhF@sylvesterjr.cmi.ua.ac.be>
	 <5625918.SuzapvkoUg@sylvesterjr.cmi.ua.ac.be>
	 <4FC75DA4.2090909@broadcom.com>
	 <1999855.FUDAX7EfOH@sylvesterjr.cmi.ua.ac.be> <4FC76389.70600@broadcom.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2012-05-31 at 14:26 +0200, Arend van Spriel wrote:
> On 05/31/2012 02:16 PM, Erwin Van de Velde wrote:
> > I have one ethernet connection and want to share that connection over 
> > wireless, preferably in AP mode although I guess ad hoc mode is possible too. 
> > Just not sure if NetworkManager supports that.
> 
> NetworkManager does support ad-hoc, but your hardware need to support
> beacon transmission for that as well. You could consider buying an AP.
> They are not that expensive ;-)

The problem with Ad-Hoc as "hotspot" is that many devices like Android
phones simply ignore adhoc networks due to security issues (as stupid as
that may be, since anyone can set up an AP-mode network too).  Which is
why real AP mode is nice, but clearly not all wifi hardware is going to
support it.

Dan

