Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([5.9.151.49]:50231 "EHLO sipsolutions.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933176AbcCOUU3 (ORCPT <rfc822;linux-wireless@vger.kernel.org>);
	Tue, 15 Mar 2016 16:20:29 -0400
Message-ID: <1458073224.2871.22.camel@sipsolutions.net> (sfid-20160315_212033_385331_19091BC6)
Subject: Re: [PATCH-v2 1/2] mac80211: Take bitrates into account when
 building IEs.
From: Johannes Berg <johannes@sipsolutions.net>
To: Ben Greear <greearb@candelatech.com>,
	linux-wireless@vger.kernel.org
Date: Tue, 15 Mar 2016 21:20:24 +0100
In-Reply-To: <56E833FE.1080904@candelatech.com>
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
	 <1458051349.2871.19.camel@sipsolutions.net>
	 <56E833FE.1080904@candelatech.com>
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, 2016-03-15 at 09:10 -0700, Ben Greear wrote:
> 
> The logic I wrote is basically exactly this.  It uses the configured
> rates to specify which of the hardware's rates are allowed and
> disabled.
> 

I understand that. I just take issue with the fact that we have to
sprinkle "magic pixie dust" (in form of the override function calls)
everywhere throughout the code.

johannes
