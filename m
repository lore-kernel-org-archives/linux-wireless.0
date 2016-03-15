Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:48494 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965404AbcCOORk (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 10:17:40 -0400
Message-ID: <1458051456.2871.21.camel@sipsolutions.net> (sfid-20160315_151743_717041_852444C6)
Subject: Re: [PATCH-v2 1/2] mac80211: Take bitrates into account when
 building IEs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 15 Mar 2016 15:17:36 +0100
In-Reply-To: <56E1B556.4080004@candelatech.com>
References: <1445361858-24976-1-git-send-email-greearb@candelatech.com>
	 <1453807009.2759.23.camel@sipsolutions.net>
	 <56A78E8F.1080505@candelatech.com>
	 <1454576521.2564.6.camel@sipsolutions.net> <56B38FD1.40902@candelatech.com>
	 <1455827536.2084.35.camel@sipsolutions.net>
	 <56C62C4E.7020600@candelatech.com>
	 <1455828330.2084.38.camel@sipsolutions.net>
	 <56C630B7.7020604@candelatech.com>
	 <1455830078.2084.47.camel@sipsolutions.net>
	 <56C63D8B.9020900@candelatech.com>
	 <1456225589.2041.24.camel@sipsolutions.net>
	 <56E1B556.4080004@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, 2016-03-10 at 09:56 -0800, Ben Greear wrote:
> 
> With regard to my original patch, are there any other things that I
> could do to make it more acceptable without making copies of the
> driver data?
> 

Oops, saw this too late.

I can't really think of anything that would really make me think it
gets much better - by way of how it works we'd have to put code into
every single place using this data, and I can't think of a way to
abstract that out easily.

Perhaps if you can find a way to have some kind of "accessor functions"
that would do the overrides, but I don't really see how that'd be
possible.

johannes
