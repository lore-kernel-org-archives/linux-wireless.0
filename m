Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:58773 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752545AbaBXUPO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Mon, 24 Feb 2014 15:15:14 -0500
Date: Mon, 24 Feb 2014 15:03:58 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless <linux-wireless@vger.kernel.org>
Subject: Re: pull-request: mac80211-next 2014-02-21
Message-ID: <20140224200358.GG24810@tuxdriver.com> (sfid-20140224_211519_456239_EE124068)
References: <1392976254.4346.45.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1392976254.4346.45.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Fri, Feb 21, 2014 at 10:50:54AM +0100, Johannes Berg wrote:
> Hi John,
> 
> More content for -next ... :) I've merged wireless-next to get the TDLS
> patch to apply properly without causing undue conflicts in mwifiex.
> 
> This time, I have a number of small fixes and improvements, and those
> are fairly straight-forward. More interesting changes come from Luca
> with some preparations for the CSA work, mostly around interface/channel
> combinations checking. One other possibly interesting change is a small
> one by myself to add NAPI support back to mac80211, which can help
> improve TCP behaviour through GRO.
> 
> Let me know if there's any problem!
> 
> johannes
> 
> ---
> 
> The following changes since commit 35582ad9d342025653aaf28ed321bf5352488d7f:
> 
>   Staging: rtl8812ae: remove modules field of rate_control_ops (2014-02-13 15:23:23 -0500)
> 
> are available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211-next.git for-john
> 
> for you to fetch changes up to 6658ab80fd4ef940fc2366ddb66690a15ea69c18:
> 
>   mac80211: ibss: handle cfg80211_chandef_dfs_required() error codes (2014-02-21 09:37:46 +0100)

Pulling now...

-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
