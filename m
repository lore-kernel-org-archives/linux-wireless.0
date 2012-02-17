Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:33415 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753259Ab2BQPo4 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 10:44:56 -0500
Subject: Re: [RFT/FYI] mac80211: revert on-channel work optimisations
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4EB96416.5040700@candelatech.com> (sfid-20111108_181718_795911_9F0A2B63)
References: <1320772222.24797.22.camel@jlt3.sipsolutions.net>
	 <4EB96416.5040700@candelatech.com> (sfid-20111108_181718_795911_9F0A2B63)
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Feb 2012 16:44:51 +0100
Message-ID: <1329493491.3786.6.camel@jlt3.sipsolutions.net> (sfid-20120217_164617_851210_A8782AAE)
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
> 
> I'll probably end up carrying this in my own tree so
> that multiple vifs work well and don't constantly
> reset the ath9k causing it to shit itself...

Given the auth/assoc redesign that went in now, are you still carrying
this? Does the redesign address your problem?

johannes

