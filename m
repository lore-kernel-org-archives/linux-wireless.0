Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:38190 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935157Ab3DJRqG (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 10 Apr 2013 13:46:06 -0400
Date: Wed, 10 Apr 2013 13:31:07 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2013-04-08
Message-ID: <20130410173107.GC15428@tuxdriver.com> (sfid-20130410_194612_786620_1BDC5A13)
References: <1365421170.25475.9.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1365421170.25475.9.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 08, 2013 at 01:39:30PM +0200, Johannes Berg wrote:
> John,
> 
> Here's another big pull request for the -next stream. This one has a ton
> of driver updates, which hopefully addresses all drivers, but maybe you
> have more new drivers than I have in my tree? Not entirely sure, let me
> know if this is the case and then I can merge wireless-next.
> 
> I'm including a large number of small changes, see the shortlog. The two
> bigger things are making VHT compatible with not using channel contexts
> (from Karl) and the stop-while-suspended fixes I developed together with
> Stanislaw.
> 
> Let me know if there are any problems.
> 
> johannes
> 
> 
> 
> The following changes since commit f00f188f8212fec9976394976c4fd5d4a3bc4dcf:
> 
>   cfg80211: fix error return code in cfg80211_init() (2013-03-20 14:09:56 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to ddc4db2e3d5393ede7a9222bb3b7522a603a4678:
> 
>   mac80211: make ieee802_11_parse_elems an inline (2013-04-08 11:08:32 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
