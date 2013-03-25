Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42160 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758901Ab3CYUpt (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Mar 2013 16:45:49 -0400
Date: Mon, 25 Mar 2013 16:39:41 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2013-03-20
Message-ID: <20130325203940.GD17454@tuxdriver.com> (sfid-20130325_214609_266285_A7D1E4CD)
References: <1363785882.8224.3.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1363785882.8224.3.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 20, 2013 at 02:24:42PM +0100, Johannes Berg wrote:
> John,
> 
> I have accumulated a bunch of changes for -next as well.
> 
> Here I have a bunch of minstrel fixes from Felix, per-interface
> multicast filtering from Alex, set_tim debouncing from Ilan,
> per-interface debugfs cleanups from Stanislaw, an error return fix from
> Wei and a number of small improvements and fixes that I made myself.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> 
> The following changes since commit 87f59c70ce6d1abeaaf97594835be29f746b81a0:
> 
>   mac80211: init mesh timer for user authed STAs (2013-03-06 16:36:14 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to f00f188f8212fec9976394976c4fd5d4a3bc4dcf:
> 
>   cfg80211: fix error return code in cfg80211_init() (2013-03-20 14:09:56 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
