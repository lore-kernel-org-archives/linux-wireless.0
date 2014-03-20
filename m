Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:60487 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932255AbaCTQAP (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Mar 2014 12:00:15 -0400
Date: Thu, 20 Mar 2014 11:53:51 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211-next 2014-03-19
Message-ID: <20140320155350.GA12987@tuxdriver.com> (sfid-20140320_170036_190372_925EBAE7)
References: <1395261190.4142.34.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1395261190.4142.34.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Mar 19, 2014 at 09:33:10PM +0100, Johannes Berg wrote:
> John,
> 
> Following your announcement, I figured I should get some code to you
> still, if only because I'm lazy and don't want to disentangle the code I
> already have later to break it up into fixes and features ...
> 
> This has a whole bunch of bugfixes for things that went into -next
> previously as well as some other bugfixes I didn't want to rush into
> 3.14 at this point. The rest of it is some cleanups and a few small
> features, the biggest of which is probably Janusz's regulatory DFS CAC
> time code.
> 
> Please let me know if there's any problem.
> 
> johannes
> 
> ---
> 
> The following changes since commit 6658ab80fd4ef940fc2366ddb66690a15ea69c18:
> 
>   mac80211: ibss: handle cfg80211_chandef_dfs_required() error codes (2014-02-21 09:37:46 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to 73fb08e24ae840bc518facc2c605dd6bb3751fec:
> 
>   cfg80211: remove macro ASSERT_RDEV_LOCK(rdev) (2014-03-19 21:29:58 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
