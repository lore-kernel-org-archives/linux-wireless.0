Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:44700 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965976Ab3E2TAI (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 29 May 2013 15:00:08 -0400
Date: Wed, 29 May 2013 14:51:12 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-next 2013-05-29
Message-ID: <20130529185112.GD8770@tuxdriver.com> (sfid-20130529_210027_576449_B16E99B2)
References: <1369658029.14740.7.camel@jlt4.sipsolutions.net>
 <1369811155.8414.1.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1369811155.8414.1.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, May 29, 2013 at 09:05:55AM +0200, Johannes Berg wrote:
> [resending, same text but new commit IDs]
> 
> > John,
> > 
> > I have accumulated a bunch of new things in iwlwifi-next. Unfortunately,
> > to resolve a (semantic) conflict, I had to merge iwlwifi, which pulled
> > in some ath9k/mwifiex changes we well since you didn't merge wireless
> > into wireless-next at any point. If you want to handle this differently
> > let me know. The shortlog below also looks inflated because of that,
> > I've also pasted the 'real' one below the pull request.
> > 
> > The 'big features' I have are powersave related, including beacon
> > filtering and connection monitor (which I have been sitting on for a
> > while because it required a mac80211 patch) and thermal throttling/CT
> > kill. The rest is mostly cleanups and small(ish) improvements.
> > 
> > Please pull.
> > 
> > Thanks,
> > johannes
> 
> The following changes since commit f722406faae2d073cc1d01063d1123c35425939e:
> 
>   Linux 3.10-rc1 (2013-05-11 17:14:08 -0700)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> 
> for you to fetch changes up to b571a69745dc90aec3d0505a7ceac2702a93861b:
> 
>   iwlwifi: mvm: add debugfs for powersave (2013-05-29 09:03:24 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
