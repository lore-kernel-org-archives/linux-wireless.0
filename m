Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:33772 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754448Ab1KHRRP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 8 Nov 2011 12:17:15 -0500
Message-ID: <4EB96416.5040700@candelatech.com> (sfid-20111108_181718_795911_9F0A2B63)
Date: Tue, 08 Nov 2011 09:17:10 -0800
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: [RFT/FYI] mac80211: revert on-channel work optimisations
References: <1320772222.24797.22.camel@jlt3.sipsolutions.net>
In-Reply-To: <1320772222.24797.22.camel@jlt3.sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 11/08/2011 09:10 AM, Johannes Berg wrote:
> FYI -- I'm going to test this a bit more but I am going to put it in.
> The code is a mess -- look at how much code I remove below (and that's
> after everybody elses cleanups!) for a dubious optimisation.
>
> I agree that we should address this and we need to really do this to not
> mess up our aggregation state, but the current code is too complex and
> causing too many issues. We also need to think about this in the context
> of multi-virtual-channel support.

Well crap.  Why don't you try to fix it right instead?

I'll probably end up carrying this in my own tree so
that multiple vifs work well and don't constantly
reset the ath9k causing it to shit itself...

Thanks,
Ben

-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

