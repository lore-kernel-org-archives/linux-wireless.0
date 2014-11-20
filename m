Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41042 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756884AbaKTVPL (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Thu, 20 Nov 2014 16:15:11 -0500
Date: Thu, 20 Nov 2014 16:10:42 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211-next 2014-11-20
Message-ID: <20141120211041.GF31881@tuxdriver.com> (sfid-20141120_221536_475374_8EBE05A3)
References: <1416497339.8557.8.camel@sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1416497339.8557.8.camel@sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Thu, Nov 20, 2014 at 04:28:59PM +0100, Johannes Berg wrote:
> Hi John,
> 
> Here's another relatively large batch of changes - arguably the most
> important being the VHT fix from Felix :-)
> 
> Let me know of any problems!
> 
> johannes
> 
> The following changes since commit 47b6308b643302e642ca2a5cb6470926f7e1c428:
> 
>   ath9k: Move roc completion to the offchannel timer (2014-11-17 15:32:17 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git tags/mac80211-next-for-john-2014-11-20
> 
> for you to fetch changes up to 75769c80e381653994293b5aa5a8cfec50088f9f:
> 
>   mac80211: minstrel_ht: add a small optimization to minstrel_aggr_check (2014-11-19 19:31:07 +0100)
> 
> ----------------------------------------------------------------
> It has been a while since my last pull request, so we accumulated
> another relatively large set of changes:
>  * TDLS off-channel support set from Arik/Liad, with some support
>    patches I did
>  * custom regulatory fixes from Arik
>  * minstrel VHT fix (and a small optimisation) from Felix
>  * add back radiotap vendor namespace support (myself)
>  * random MAC address scanning for cfg80211/mac80211/hwsim (myself)
>  * CSA improvements (Luca)
>  * WoWLAN Net Detect (wake on network found) support (Luca)
>  * and lots of other smaller changes from many people

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
