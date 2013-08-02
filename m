Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58547 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754273Ab3HBTAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 2 Aug 2013 15:00:17 -0400
Date: Fri, 2 Aug 2013 14:59:26 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2013-07-31
Message-ID: <20130802185926.GC10800@tuxdriver.com> (sfid-20130802_210022_253638_A4A213FB)
References: <1375298735.8289.25.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1375298735.8289.25.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jul 31, 2013 at 09:25:35PM +0200, Johannes Berg wrote:
> John,
> 
> Another pull request for mac80211 - this time with a bunch of important
> fixes.
> 
> I have a fix from Chris for an infinite loop along with fixes from
> myself to prevent it entering the loop to start with (continue using
> disabled channels, many thanks to Chris for his debug/test help) and a
> workaround for broken APs that advertise a bad HT primary channel in
> their beacons. Additionally, a fix for another attrbuf race in mac80211
> and a fix to clean up properly while P2P GO interfaces go down.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> The following changes since commit 23df0b731954502a9391e739b92927cee4360343:
> 
>   regulatory: use correct regulatory initiator on wiphy register (2013-07-25 09:52:46 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to ddfe49b42d8ad4bfdf92d63d4a74f162660d878d:
> 
>   mac80211: continue using disabled channels while connected (2013-07-31 21:18:17 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
