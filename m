Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:56604 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934785AbbLQQAR (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 17 Dec 2015 11:00:17 -0500
Date: Thu, 17 Dec 2015 10:56:33 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Bob Copeland <me@bobcopeland.com>
Cc: linux-wireless@vger.kernel.org
Subject: Re: [ANNOUNCE] New location for wireless-testing tree
Message-ID: <20151217155633.GC6910@tuxdriver.com> (sfid-20151217_170021_722287_E8598492)
References: <20151216173223.GF4073@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <20151216173223.GF4073@localhost>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 16, 2015 at 12:32:23PM -0500, Bob Copeland wrote:
> As reported previously[1], John Linville will be moving on from maintenance
> of the wireless-testing[2] tree at the end of the year.  A huge thank you to
> John for doing all this work for so many years!
> 
> We now have a shared wireless directory on kernel.org where we (currently
> myself and Kalle as backup) will continue to maintain this tree going
> forward.  The new tree can be found at:
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/wireless/wireless-testing.git
> 
> Note: unlike John's tree, we are going to try rebasing this tree on every
> build (like linux-next) instead of merging the downstream trees, in order
> to avoid certain merge problems when those trees are rebased.
> 
> This means that if you are working directly off of wireless-testing, use
> 'git pull --rebase' to sync, instead of just 'git pull'.
> 
> We'll see how this goes and reassess after a couple of cycles.
> 
> Please let me know of any issues.
> 
> [1] http://comments.gmane.org/gmane.linux.kernel.wireless.general/145291
> 
> [2] wireless-testing is an integration testing tree, consisting of:
> 
>  * Linus's latest -rc
>  * patches in mac80211 and wireless-drivers (for the upcoming release)
>  * patches in mac80211-next and wireless-drivers-next (for the next release)
> 
> It is not pulled into any upstream tree, but it should be a pretty good
> indication of what is baking in Linux wireless for the next release, without
> having unrelated changes from all the other subsystems as in linux-next.

Given this most welcome announcement, I will hereby cease maintenance
of the predecessor wireless-testing tree in favor of this new
canonical source.

Thanks guys!

John
-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
