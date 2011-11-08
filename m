Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:42114 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755009Ab1KHRSu (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 12:18:50 -0500
Subject: Re: [RFT/FYI] mac80211: revert on-channel work optimisations
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4EB96416.5040700@candelatech.com>
References: <1320772222.24797.22.camel@jlt3.sipsolutions.net>
	 <4EB96416.5040700@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Tue, 08 Nov 2011 18:18:47 +0100
Message-ID: <1320772727.24797.23.camel@jlt3.sipsolutions.net> (sfid-20111108_181853_244828_0C48D049)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2011-11-08 at 09:17 -0800, Ben Greear wrote:
> On 11/08/2011 09:10 AM, Johannes Berg wrote:
> > FYI -- I'm going to test this a bit more but I am going to put it in.
> > The code is a mess -- look at how much code I remove below (and that's
> > after everybody elses cleanups!) for a dubious optimisation.
> >
> > I agree that we should address this and we need to really do this to not
> > mess up our aggregation state, but the current code is too complex and
> > causing too many issues. We also need to think about this in the context
> > of multi-virtual-channel support.
> 
> Well crap.  Why don't you try to fix it right instead?

Can't even understand it, I have a better chance just rewriting it.

Like I said -- I know I'll have to do that, but I need to think about
this in the context of using different channels on different virtual
interfaces etc. and probably rework the channel config logic in mac80211
significantly...

johannes

