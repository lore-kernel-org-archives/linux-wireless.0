Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from charlotte.tuxdriver.com ([70.61.120.58]:46863 "EHLO
	smtp.tuxdriver.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752847Ab3DLRaO (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Fri, 12 Apr 2013 13:30:14 -0400
Date: Fri, 12 Apr 2013 13:21:33 -0400
From: "John W. Linville" <linville@tuxdriver.com>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: linux-wireless@vger.kernel.org
Subject: Re: pull-request: mac80211 2013-04-10
Message-ID: <20130412172132.GA7787@tuxdriver.com> (sfid-20130412_193019_186559_C92DDF3E)
References: <1365623386.4235.40.camel@jlt4.sipsolutions.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
In-Reply-To: <1365623386.4235.40.camel@jlt4.sipsolutions.net>
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Wed, Apr 10, 2013 at 09:49:46PM +0200, Johannes Berg wrote:
> John,
> 
> Yet one more!
> 
> This fixes a fairly important/annoying bug -- when roaming between
> multiple APs of the same network, the system could get stuck thinking it
> was connected to the old one while it really wasn't.
> 
> I hope this can still go to 3.9, but it's tagged for stable either way.
> 
> johannes
> 
> 
> The following changes since commit 62a40a15554d6924a58b3e9f8756e0d683dc9c0c:
> 
>   mac80211: fix LED in idle handling (2013-04-08 13:12:05 +0200)
> 
> are available in the git repository at:
> 
>   git://x-git.kernel.org/pub/scm/linux/kernel/git/jberg/mac80211.git for-john
> 
> for you to fetch changes up to 7b119dc06d871405fc7c3e9a73a6c987409ba639:
> 
>   mac80211: fix cfg80211 interaction on auth/assoc request (2013-04-10 21:38:36 +0200)
> 
> ----------------------------------------------------------------
> Johannes Berg (1):
>       mac80211: fix cfg80211 interaction on auth/assoc request
> 
>  net/mac80211/mlme.c | 24 ++++++++++++++++++++----
>  1 file changed, 20 insertions(+), 4 deletions(-)
> 

Pulling now...


-- 
John W. Linville		Someday the world will need a hero, and you
linville@tuxdriver.com			might be all we have.  Be ready.
