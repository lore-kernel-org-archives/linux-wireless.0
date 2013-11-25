Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:45318 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750855Ab3KYVAN (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 25 Nov 2013 16:00:13 -0500
Date: Mon, 25 Nov 2013 15:57:02 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211 2013-11-25
Message-ID: <20131125205702.GD8228@tuxdriver.com> (sfid-20131125_220023_597092_A9850994)
References: <1385408827.4443.61.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1385408827.4443.61.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Nov 25, 2013 at 08:47:07PM +0100, Johannes Berg wrote:
> John,
> 
> First pull request from me - it took me a while to get my trees in
> order.
> 
> For now I have various fixes all over, mostly for issues introduced in
> relatively recent patches. There's no real pattern to it. Some of the
> issues like go back longer, but still seemed 3.13 material.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> The following changes since commit 91398a0992c8aa18eb7749060b75761ece5ddc57:
> 
>   genetlink: fix genl_set_err() group ID (2013-11-21 13:09:43 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to 24d47300d118c5909a51b7270276d749cce150a2:
> 
>   mac80211: set hw initial idle state (2013-11-25 16:56:54 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
