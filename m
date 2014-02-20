Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:42137 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751286AbaBTVAO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Feb 2014 16:00:14 -0500
Date: Thu, 20 Feb 2014 15:45:44 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211 2014-02-20
Message-ID: <20140220204544.GG3657@tuxdriver.com> (sfid-20140220_220018_799443_E1BA2D65)
References: <1392887140.5073.10.camel@jlt4.sipsolutions.net>
 <1392906648.5073.31.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392906648.5073.31.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Feb 20, 2014 at 03:30:48PM +0100, Johannes Berg wrote:
> John,
> 
> I've got a few more fixes for some issues here now.
> 
> This time, I have a fix from Arik for scheduled scan recovery (something
> that only recently went into the tree), a memory leak fix from Eytan and
> a small regulatory bugfix from Inbal. The EAPOL change from Felix makes
> rekeying more stable while lots of traffic is flowing, and there's
> Emmanuel's and my fixes for a race in the code handling powersaving
> clients.
> 
> Please pull.
> 
> Thanks,
> johannes
> 
> 
> The following changes since commit fab57a6cc227468ca9e6a4c7ff8d3b10727785ee:
> 
>   mac80211: fix virtual monitor interface iteration (2014-02-06 09:55:22 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to e3685e03b40f5ec7926d9a75bf63467fc4071df9:
> 
>   mac80211: fix station wakeup powersave race (2014-02-20 11:54:09 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
