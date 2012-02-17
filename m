Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from he.sipsolutions.net ([78.46.109.217]:40767 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752084Ab2BQST0 (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 Feb 2012 13:19:26 -0500
Subject: Re: [RFT/FYI] mac80211: revert on-channel work optimisations
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
In-Reply-To: <4F3E7CA5.7010207@candelatech.com>
References: <1320772222.24797.22.camel@jlt3.sipsolutions.net>
	 <4EB96416.5040700@candelatech.com>
	 (sfid-20111108_181718_795911_9F0A2B63) <1329493491.3786.6.camel@jlt3.sipsolutions.net>
	 <4F3E7CA5.7010207@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Date: Fri, 17 Feb 2012 19:19:21 +0100
Message-ID: <1329502761.3330.0.camel@jlt3.sipsolutions.net> (sfid-20120217_191929_706493_6A1AA73F)
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, 2012-02-17 at 08:13 -0800, Ben Greear wrote:

> > Given the auth/assoc redesign that went in now, are you still carrying
> > this? Does the redesign address your problem?
> 
> I haven't looked yet...still stuck back on 3.0 kernel for the
> most part.
> 
> I should be moving to 3.3 sometime soon, and will see how it works.
> 
> I was thinking that I would ignore the work logic for now and probably
> just focus on re-applying the on-channel scan optimization first.
> 
> Are you done, or mostly done with the re-architecture you were working on?

Yes, I'm done.

> I know you didn't like the scan optimization from before...do you have any
> ideas on how it might be done more to your liking?

I, umm, don't even remember what that was about :)

johannes

