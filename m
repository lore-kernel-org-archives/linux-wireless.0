Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52974 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754050Ab3EQSaI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 17 May 2013 14:30:08 -0400
Date: Fri, 17 May 2013 14:21:43 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2013-05-16
Message-ID: <20130517182143.GA2012@tuxdriver.com> (sfid-20130517_203026_722623_D10998AA)
References: <1368737568.8253.7.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1368737568.8253.7.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, May 16, 2013 at 10:52:48PM +0200, Johannes Berg wrote:
> John,
> 
> Here's my first pull request for the 3.10 fixes stream. Unfortunately, a
> fairly large number of these also had to be tagged for stable.
> 
> This is what I have:
>  * a patch from Felix to fix RCU usage in his rate table code
>  * a patch from Ilan to add the wdev id to some notifications so they
> can
>    actually be used by userspace
>  * Sasha Levin found an issue in how hwsim handles devices
>  * a fix for a bug in the wiphy_register() error path that's been there
> forever
>  * three fixes for WoWLAN
>  * AP mode frame matching was erroneously giving frames to all virtual
> AP
>    interfaces (reported by Jouni)
>  * a fix for HT handling in my CSA changes, found by Sujith
>  * a fix for some locking simplifications gone wrong
>  * Ben Greear found more cfg80211/mac80211 state confusion
>  * and a fix for another bug found by Jouni: local state changes need to
> be
>    reported by mac80211 to cfg80211 so it disconnects properly.
> 
> Please pull. Thanks,
> johannes
> 
> 
> 
> The following changes since commit 61f1598278876527314f5fc1d00cf0a4d525c1f7:
> 
>   Merge branch 'wireless' (2013-05-10 09:44:05 -0700)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to e248ad30204eff6559b4d2d94d49d9d46c08185a:
> 
>   cfg80211: fix sending WoWLAN TCP wakeup settings (2013-05-16 22:38:09 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
