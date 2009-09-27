Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from casper.infradead.org ([85.118.1.10]:43047 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753110AbZI0PWY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Sun, 27 Sep 2009 11:22:24 -0400
Subject: Re: Porting AR6K to use cfg80211
From: Samuel Ortiz <samuel@sortiz.org>
To: Dave <kilroyd@googlemail.com>
Cc: Matthew Ryan <rudicus@gmail.com>, linux-wireless@vger.kernel.org
In-Reply-To: <4ABD2ECE.50501@gmail.com>
References: <loom.20090925T193922-290@post.gmane.org>
	 <200909252005.23746.mb@bu3sch.de> <loom.20090925T222532-791@post.gmane.org>
	 <4ABD2ECE.50501@gmail.com>
Content-Type: text/plain
Date: Sun, 27 Sep 2009 17:24:21 +0200
Message-Id: <1254065061.2747.6.camel@sortiz-mobl>
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

Hi Dave,

On Fri, 2009-09-25 at 21:57 +0100, Dave wrote:
> Matthew Ryan wrote:
> > Michael Buesch <mb@...> writes:
> >> On Friday 25 September 2009 19:40:52 Matthew Ryan wrote:
> >>> I was curious if I could get a few expert opinions on if its possible to port
> >>> this driver to use mac80211, and how difficult/ what pitfalls there may be.
> >> The device is fullmac, so it does not require mac80211.
> >> I guess however, ar6k can be ported to use cfg80211.
> >>
> > 
> > Do you know of any examples in the source tree which are fullmac, but utilize
> > cfg80211 that I could use as a base to get started?
> 
> There are a few fullmac drivers in wireless-testing that use cfg80211. I
> don't think these are in the recently released 2.6.31, but are queued
> for 2.6.32.
At least iwmc3200wifi is in 2.6.31.

Cheers,
Samuel.

> iwmc3200wifi and rndis_wlan are furthest along. orinoco is in the
> process of conversion (it uses cfg80211, but relies on the wext
> compatibility code for a large portion of functionality).
> 
> 
> Dave.
> --
> To unsubscribe from this list: send the line "unsubscribe linux-wireless" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html

