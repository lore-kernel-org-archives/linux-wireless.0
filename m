Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34524 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754726Ab3KEVAW (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 5 Nov 2013 16:00:22 -0500
Date: Tue, 5 Nov 2013 15:49:56 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211 2013-10-21
Message-ID: <20131105204956.GD8264@tuxdriver.com> (sfid-20131105_220026_413525_B62AED24)
References: <1382361031.14310.51.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1382361031.14310.51.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Mon, Oct 21, 2013 at 03:10:31PM +0200, Johannes Berg wrote:
> John,
> 
> Unfortunately we have yet more fixes for mac80211.
> 
> I have two DFS fixes (ath9k already supports DFS) and a fix for a
> pointer race.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> The following changes since commit 095d81cee742fc31e1218077ca6ca8f0df07c613:
> 
>   mac80211: disable WMM with invalid parameters (2013-10-17 15:38:22 +0200)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to bbe09bbcf4454e826e3fb08e87d81f32c0030658:
> 
>   cfg80211: update dfs_state_entered upon dfs_state change (2013-10-21 14:50:27 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
