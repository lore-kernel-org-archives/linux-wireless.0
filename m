Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from sapphire.tuxdriver.com ([70.61.120.61]:47798 "EHLO
	linville-x1.hq.tuxdriver.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755021Ab3DVTBQ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 22 Apr 2013 15:01:16 -0400
Date: Mon, 22 Apr 2013 14:59:29 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2013-04-22
Message-ID: <20130422185928.GF2055@tuxdriver.com> (sfid-20130422_210131_099662_95E0C5C7)
References: <1366640761.8637.30.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1366640761.8637.30.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Apr 22, 2013 at 04:26:01PM +0200, Johannes Berg wrote:
> Hi John,
> 
> One more and probably last pull request for -next. Still pretty big,
> mostly because I had some catching up to do wrt. merging.
> 
> This time I have a relatively large number of fixes and small
> improvements, the most important one being Bob's RCU fix. The two big
> things are Felix's work on rate scaling tables (with a big thanks to
> Karl too) and my own work on CSA handling to finally properly handle HT
> (and some VHT.)
> 
> Oh, I merged wireless-next once to resolve some conflicts.
> 
> Please pull.
> 
> Thanks,
> johannes
> 
> The following changes since commit 9b383672452bb1097124c76fcb4903e0021f6baf:
> 
>   b43: use bcma_pmu_spuravoid_pllupdate() (2013-04-12 15:29:14 -0400)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to 1eb32179f0593051e7536378a879f5bdd108416a:
> 
>   mac80211_hwsim: handle IEEE80211_HW_SUPPORTS_RC_TABLE (2013-04-22 16:19:16 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
