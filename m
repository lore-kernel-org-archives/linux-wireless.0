Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:47783 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750843Ab3F0APJ (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 26 Jun 2013 20:15:09 -0400
Date: Wed, 26 Jun 2013 20:05:58 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: iwlwifi-next 2013-06-25
Message-ID: <20130627000558.GB2139@tuxdriver.com> (sfid-20130627_021514_012700_B7702232)
References: <1372160186.8372.13.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1372160186.8372.13.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Tue, Jun 25, 2013 at 01:36:26PM +0200, Johannes Berg wrote:
> Hi John,
> 
> This is hopefully going to be the last big pull request for
> iwlwifi-next, luckily it actually mostly removes code ;-)
> 
> Emmanuel removed some unneeded/unsupported module parameters and adds a
> Bluetooth 1x1 lookup-table for some upcoming products. From Alex I have
> an older patch to add low-power receive support, this depended on a
> mac80211 commit that only just came in with the merge from wireless-next
> I did. Ilan made beacon timings better, and Eytan added some debug
> statements for thermal throttling. I have a few cleanups, a fix for a
> long-standing but rare warning, and, arguably the most important patch
> here, the firmware API version bump for the 7260/3160 devices.
> 
> Let me know if there are any issues.
> 
> johannes
> 
> 
> 
> The following changes since commit 9fbdc75116f7a2b183464d42f3abccb616584105:
> 
>   Merge branch 'for-upstream' of git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth-next (2013-06-24 14:45:50 -0400)
> 
> are available in the git repository at:
> 
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/iwlwifi/iwlwifi-next.git for-john
> 
> for you to fetch changes up to bd4ace2a36e7c87bb5f3eceb54d3b304d395dcf0:
> 
>   iwlwifi: mvm: Add support for Low Power RX (2013-06-25 12:21:19 +0200)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
