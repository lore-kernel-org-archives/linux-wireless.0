Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:55333 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756161Ab3JNRpY (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 14 Oct 2013 13:45:24 -0400
Date: Mon, 14 Oct 2013 13:34:38 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2013-10-14
Message-ID: <20131014173438.GA17149@tuxdriver.com> (sfid-20131014_194527_652350_EC8E6AE5)
References: <1381736981.13092.4.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1381736981.13092.4.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 14, 2013 at 09:49:45AM +0200, Johannes Berg wrote:
> John,
> 
> I know it's getting later in the game (rc5 is out) and my last pull
> request hasn't even made it into Linus's tree, but we still have some
> fixes ...
> 
> This time I have two fixes from Emmanuel for RF-kill issues, and fixed
> two issues reported by Evan Huus and Thomas Lindroth respectively.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> The following changes since commit 22c4ceed0184318ec5a6182c6d75d398452c2e39:
> 
>   mac80211: Run deferred scan if last roc_list item is not started (2013-09-30 12:36:56 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to d86aa4f8ca58898ec6a94c0635da20b948171ed7:
> 
>   mac80211: fix crash if bitrate calculation goes wrong (2013-10-14 09:47:08 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
