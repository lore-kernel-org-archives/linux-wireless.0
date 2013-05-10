Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from mail.candelatech.com ([208.74.158.172]:49509 "EHLO
	ns3.lanforge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756103Ab3EJO0a (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 10 May 2013 10:26:30 -0400
Message-ID: <518D0390.90006@candelatech.com> (sfid-20130510_162636_555254_123697C2)
Date: Fri, 10 May 2013 07:26:24 -0700
From: Ben Greear <greearb@candelatech.com>
MIME-Version: 1.0
To: Johannes Berg <johannes@sipsolutions.net>
CC: linux-wireless@vger.kernel.org
Subject: Re: [RFC 0/4] cfg80211/mac80211: simplify locking
References: <1368187689-29706-1-git-send-email-johannes@sipsolutions.net>
In-Reply-To: <1368187689-29706-1-git-send-email-johannes@sipsolutions.net>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On 05/10/2013 05:08 AM, Johannes Berg wrote:
> I got a little fed up with all the locking, and decided to simplify.
>
> This should still work, but I've only done some very simple tests.
> I'm hoping it'll fix some of the weird corner cases that Ben and
> others have found, which may be due to different locks in different
> cases and things racing against each other ... I'm not convinced it
> really will though, but hey, who knows :)

I'm stacked high with tasks at the moment, but will try to
run this through some testing soon.

These are in your tree?

Thanks,
Ben

>
> johannes
>


-- 
Ben Greear <greearb@candelatech.com>
Candela Technologies Inc  http://www.candelatech.com

