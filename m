Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:57660 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751965Ab3LBSaN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 2 Dec 2013 13:30:13 -0500
Date: Mon, 2 Dec 2013 13:22:09 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211 2013-12-01
Message-ID: <20131202182209.GD26033@tuxdriver.com> (sfid-20131202_193019_481817_AB0242E9)
References: <1386000525.20277.8.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1386000525.20277.8.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Dec 02, 2013 at 05:08:45PM +0100, Johannes Berg wrote:
> John,
> 
> Another pull request for 3.13.
> 
> These are just two patches disabling the broken CSA code. Once this goes
> into your tree I'll merge it into mac80211-next and revert there (since
> we fixed the bugs there)
> 
> johannes
> 
> The following changes since commit 24d47300d118c5909a51b7270276d749cce150a2:
> 
>   mac80211: set hw initial idle state (2013-11-25 16:56:54 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to 0834ae3c3af44480834cce128b6fef83006e537f:
> 
>   mac80211: check csa wiphy flag in ibss before switching (2013-12-02 11:54:13 +0100)
> 
> ----------------------------------------------------------------
> Simon Wunderlich (2):
>       cfg80211: disable CSA for all drivers
>       mac80211: check csa wiphy flag in ibss before switching
> 
>  net/mac80211/ibss.c | 4 ++++
>  net/wireless/core.c | 6 ++++++
>  2 files changed, 10 insertions(+)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
