Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:51965 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758113Ab3FCUpI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 3 Jun 2013 16:45:08 -0400
Date: Mon, 3 Jun 2013 16:34:53 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2013-06-03
Message-ID: <20130603203452.GI2727@tuxdriver.com> (sfid-20130603_224512_680736_4F91E803)
References: <1370271087.8227.8.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1370271087.8227.8.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Jun 03, 2013 at 04:51:27PM +0200, Johannes Berg wrote:
> John,
> 
> Here's another small pull request for mac80211-next, I wanted to get a
> few fixes out. I have more stuff pending but not sure I can get that
> reviewed right away and don't want anyone waiting for the warning fix.
> 
> I have two reverts for patches I accidentally merged in via a tree I
> shouldn't have merged and a the locking fix for the locking rework I
> did. On top of that, Felix's active monitor implementation, a patch to
> always send multicast on the CAB queue to avoid races and a small
> cleanup.
> 
> johannes
> 
> 
> The following changes since commit 6abb9cb99f33b20c2f32f18a3ae9cc7543e46edb:
> 
>   cfg80211: make WoWLAN configuration available to drivers (2013-05-27 15:10:58 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to ed405be5cb5e8e494e8dcd83b6eb1add34dc752a:
> 
>   mac80211: fix sdata locking around __ieee80211_request_smps (2013-06-03 13:51:59 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
