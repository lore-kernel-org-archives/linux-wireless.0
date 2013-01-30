Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:50724 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755586Ab3A3TaW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 30 Jan 2013 14:30:22 -0500
Date: Wed, 30 Jan 2013 14:22:42 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2013-01-28 (was: pull-request:
 mac80211-next 2013-01-24)
Message-ID: <20130130192242.GD2167@tuxdriver.com> (sfid-20130130_203048_620542_11CF3268)
References: <1359045496.21908.11.camel@jlt4.sipsolutions.net>
 <1359375945.8120.13.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1359375945.8120.13.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jan 28, 2013 at 01:25:45PM +0100, Johannes Berg wrote:
> John,
> 
> Please ignore the previous pull request. I've updated my branch with a
> few more commits, this is the combined pull request.
> 
> I've included
>  * AKM definitions from Bing,
>  * mesh fixes from Thomas, including a fix from him for me breaking his
>    patch while applying,
>  * channel check fix from Simon,
>  * an old patch from Yoni Divinsky who doesn't even work for TI any
>    more, to configure the WEP TX key for ARP offload etc.
>  * MAC ACL API from Vasanth
>  * a fix for the infamous chanctx_conf warning from Arnd
>  * from myself, a fix for my previous aggregation changes, some cleanup
>    and some improvements and fixes for WoWLAN
> 
> Let me know if there are any problems.
> 
> Thanks,
> johannes
> 
> The following changes since commit 5a32aff37a02ebc959837f08d09ac8ba65d4f1b0:
> 
>   mac80211: split out chandef tracing macros (2013-01-16 23:57:51 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to 3b4797bce0050570e84bedd10e1b14e9320a3551:
> 
>   mac80211: fix mesh_sta_info_get() reshuffle damage (2013-01-28 13:15:34 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
