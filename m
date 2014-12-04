Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:34446 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932092AbaLDQpK (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 4 Dec 2014 11:45:10 -0500
Date: Thu, 4 Dec 2014 11:32:11 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211-next 2014-12-03
Message-ID: <20141204163211.GB2842@tuxdriver.com> (sfid-20141204_174526_093824_AB146DA3)
References: <1417592902.2640.1.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1417592902.2640.1.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Dec 03, 2014 at 08:48:22AM +0100, Johannes Berg wrote:
> Hi John,
> 
> Yes, you were right - I must have missed that you merged my other pull
> request. I hope you can still pull this in time for the next merge
> window.
> 
> Unfortunately I can't send a signed tag because I forgot my yubikey at
> home and thus can't upload anything to kernel.org. I hope you can accept
> signed pgp email instead.
> 
> This time I have Felix's no-status rate control work, which will allow
> drivers to work better with rate control even if they don't have perfect
> status reporting. In addition to this, a small hwsim fix from Patrik,
> one of the regulatory patches from Arik, and a number of cleanups and
> fixes I did myself.
> 
> Of note is a patch where I disable CFG80211_WEXT so that compatibility
> is no longer selectable - this is intended as a wake-up call for anyone
> who's still using it, and is still easily worked around (it's a one-line
> patch) before we fully remove the code as well in the future.
> 
> Let me know if there's any problem.
> 
> johannes
> 
> 
> 
> The following changes since commit 75769c80e381653994293b5aa5a8cfec50088f9f:
> 
>   mac80211: minstrel_ht: add a small optimization to minstrel_aggr_check (2014-11-19 19:31:07 +0100)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git 
> 
> for you to fetch changes up to f027c2aca0cf43e0f15fc8de8841f7b566163d94:
> 
>   mac80211: add ieee80211_tx_status_noskb (2014-11-28 15:01:51 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
