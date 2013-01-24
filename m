Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:55240 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750721Ab3AXPb4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 24 Jan 2013 10:31:56 -0500
Message-ID: <1359041539.21908.6.camel@jlt4.sipsolutions.net> (sfid-20130124_163159_641980_47B2C65C)
Subject: Re: [RFC v2] cfg80211/mac80211: support reporting wakeup reason
From: Johannes Berg <johannes@sipsolutions.net>
To: Luciano Coelho <coelho@ti.com>
Cc: linux-wireless@vger.kernel.org
Date: Thu, 24 Jan 2013 16:32:19 +0100
In-Reply-To: <1359018746.6252.189.camel@cumari.coelho.fi>
References: <1358958882-14246-1-git-send-email-johannes@sipsolutions.net>
	 <1359010005.6252.185.camel@cumari.coelho.fi>
	 <1359018633.4639.2.camel@jlt4.sipsolutions.net>
	 <1359018746.6252.189.camel@cumari.coelho.fi>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2013-01-24 at 11:12 +0200, Luciano Coelho wrote:

> > > Also, is there any specific reason you want to know the original length?
> > > Just to check whether the packet was truncated or not?
> > 
> > Yeah our device has a certain buffer size only (it's pretty large) but
> > the packet could be truncated due to that, so I added that to be able to
> > see that truncation.
> 
> The actual length of the packet is irrelevant isn't it? Maybe a boolean
> just indicating it's truncated? Not really that important though, just
> for a bit more clarity.

I have no idea if the actual length is irrelevant ;-)

Most likely it is, but maybe somebody wants to know how much data was
missing? I have the information, so I didn't want to hide it...

johannes

