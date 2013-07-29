Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:52818 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752613Ab3G2TAL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 29 Jul 2013 15:00:11 -0400
Date: Mon, 29 Jul 2013 14:48:45 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2013-07-26
Message-ID: <20130729184845.GG31172@tuxdriver.com> (sfid-20130729_210019_298199_54577691)
References: <1374828153.8248.19.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1374828153.8248.19.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Jul 26, 2013 at 10:42:33AM +0200, Johannes Berg wrote:
> John,
> 
> And another one for mac80211 - that's all for now then :-)
> 
> I only have three fixes this time, a fix for a suspend regression, a
> patch correcting the initiator in regulatory code and one fix for mesh
> station powersave.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> 
> The following changes since commit 5c9fc93bc9bc417418fc1b6366833ae6a07b804d:
> 
>   mac80211/minstrel: fix NULL pointer dereference issue (2013-07-16 17:48:14 +0300)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to 23df0b731954502a9391e739b92927cee4360343:
> 
>   regulatory: use correct regulatory initiator on wiphy register (2013-07-25 09:52:46 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
