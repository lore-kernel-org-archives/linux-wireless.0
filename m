Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from lo.gmane.org ([80.91.229.12]:46481 "EHLO lo.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755327Ab1ATKPl (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Jan 2011 05:15:41 -0500
Received: from list by lo.gmane.org with local (Exim 4.69)
	(envelope-from <glkwg-linux-wireless@m.gmane.org>)
	id 1PfrYH-0006x0-Ui
	for linux-wireless@vger.kernel.org; Thu, 20 Jan 2011 11:15:37 +0100
Received: from dslb-084-059-120-020.pools.arcor-ip.net ([84.59.120.20])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 11:15:37 +0100
Received: from alexander.simon by dslb-084-059-120-020.pools.arcor-ip.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <linux-wireless@vger.kernel.org>; Thu, 20 Jan 2011 11:15:37 +0100
To: linux-wireless@vger.kernel.org
From: Alexander Simon <alexander.simon@saxnet.de>
Subject: Re: [RFC 1/4] mac80211: support for IEEE80211N in IBSS
Date: Thu, 20 Jan 2011 10:15:26 +0000 (UTC)
Message-ID: <loom.20110120T110320-779@post.gmane.org>
References: <201101191438.01161.alexander.simon@saxnet.de>  <1295447708.4685.5.camel@jlt3.sipsolutions.net>  <loom.20110120T093834-982@post.gmane.org>  <1295515469.3693.17.camel@jlt3.sipsolutions.net>  <loom.20110120T103741-140@post.gmane.org> <1295517283.3693.31.camel@jlt3.sipsolutions.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

> Of course I'd accept that  Reducing duplicated code is good, and I
> can deal with patches touching many files. Though it'd be nice to do the
> necessary refactoring first.
Ok give me some time and I'll have a look at util.c.
> 
> A nice touch, btw, would be if you included a diffstat. Maybe you should
> look at using quilt or git to submit patches which help you automate a
> lot of things.
Actually I don't like git, but when this is getting something bigger,I'll agree
to use it :)


> > But i would appreciate if you could comment on the design of the patch
itself.
> > Basically i just took Benoits approach and made it running. A separate 
option
> > for setting channel_type isn't necessary. You could also tell by iw whether
to
> > use HT or not. Or no option at all, a module option ibss_ht etc. Or even 
setting
> > full options as hostapd does via iw.
> 
> I'm sorry, I don't understand what you mean by "a separate option"? With
> the approach that you've posted patches for you need to tell iw whether
> you want HT or not, right?
What i mean is, right now there's just one option - setting the HT channel.
There could be less (the card automatically enables HT and uses it for a station
that advertises HT), or even more (as in hostapd.confs HT section). Or there
could be a module option to switch ht for ibss on or off. So, i'm asking about
the "ideal" interface...

