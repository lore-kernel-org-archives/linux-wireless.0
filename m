Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56517 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753911AbaACUaQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 3 Jan 2014 15:30:16 -0500
Date: Fri, 3 Jan 2014 15:25:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211-next 2013-12-19
Message-ID: <20140103202543.GA6353@tuxdriver.com> (sfid-20140103_213032_977703_2FE89FC7)
References: <1387484847.4298.21.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1387484847.4298.21.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Dec 19, 2013 at 09:27:27PM +0100, Johannes Berg wrote:
> John,
> 
> Yeah, I know what you're going to say ... but here are some (locking)
> fixes for mac80211-next that people may want to use over the
> holidays :-)
> 
> Felix adds some helper functions for P2P NoA software tracking, Joe
> fixes alignment (but as this apparently never caused issues I didn't
> send it to 3.13), Kyeyoon/Jouni add QoS-mapping support (a Hotspot 2.0
> feature), Weilong fixed a bunch of checkpatch errors and I get to play
> fire-fighter or so and clean up other people's locking issues. I also
> added nl80211 vendor-specific events, as we'd discussed at the wireless
> summit.
> 
> Let me know if there's any problem; however, with this, I'm going on
> vacation until January 6th. I'll check in to see if there are any
> important issues that need my attention, but I don't expect to send you
> any more pull requests this year.
> 
> johannes
> ---
> The following changes since commit 204e35a91c4b3327b7239d7687fbd4923edbbf08:
> 
>   nl80211: add VHT support for set_bitrate_mask (2013-12-16 16:05:17 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to 32db6b54dfba38aa8fa4072b2a3fc6425139166a:
> 
>   mac80211: Add support for QoS mapping (2013-12-19 16:30:58 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
