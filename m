Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:41515 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932096Ab3AITaS (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Wed, 9 Jan 2013 14:30:18 -0500
Date: Wed, 9 Jan 2013 14:28:43 -0500
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211-next 2013-01-09
Message-ID: <20130109192843.GB17321@tuxdriver.com> (sfid-20130109_203023_596667_4BACF70B)
References: <1357736439.9757.11.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1357736439.9757.11.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Jan 09, 2013 at 02:00:39PM +0100, Johannes Berg wrote:
> John,
> 
> We found two bugs in the previous code, so I'm sending you a pull
> request again this soon.
> 
> This contains two regulatory bug fixes, some of Thomas's hwsim beacon
> timer work and a documentation fix from Bob.
> 
> johannes

Pulling now...
 
> The following changes since commit ba23d2068d85f6616ea5f92320c04e87d4b9e141:
> 
>   cfg80211: disallow more station changes (2013-01-03 13:01:45 +0100)
> 
> are available in the git repository at:
> 
>   git://git.sipsolutions.net/mac80211-next.git for-john
> 
> for you to fetch changes up to 2d31986764926630a6df72123a5e217219b32594:
> 
>   regulatory: fix restore_regulatory_settings (2013-01-09 12:19:52 +0100)
> 
> ----------------------------------------------------------------
> Bob Copeland (1):
>       mac80211: fix mesh_hwmp kerneldoc
> 
> Johannes Berg (2):
>       regulatory: fix uevent
>       regulatory: fix restore_regulatory_settings
> 
> Thomas Pedersen (3):
>       mac80211_hwsim: fix tsf adjustment
>       mac80211_hwsim: hrtimer beacon
>       mac80211_hwsim: fix beacon timing
> 
>  drivers/net/wireless/mac80211_hwsim.c | 90 +++++++++++++++++++++++++----------
>  net/mac80211/mesh_hwmp.c              |  5 +-
>  net/wireless/reg.c                    | 21 +++++---
>  3 files changed, 83 insertions(+), 33 deletions(-)
> 



-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
