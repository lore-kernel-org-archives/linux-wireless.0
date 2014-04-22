Return-path: <linux-wireless-owner@vger.kernel.org>
Received: from s3.sipsolutions.net ([144.76.43.152]:42547 "EHLO
	sipsolutions.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751346AbaDVOna (ORCPT
	<rfc822;linux-wireless@vger.kernel.org>);
	Tue, 22 Apr 2014 10:43:30 -0400
Message-ID: <1398177796.4211.6.camel@jlt4.sipsolutions.net> (sfid-20140422_164333_778663_A9111FEE)
Subject: Re: [PATCH 0/3] fix and improvements
From: Johannes Berg <johannes@sipsolutions.net>
To: "Zhao, Gang" <gamerh2o@gmail.com>
Cc: linux-wireless@vger.kernel.org
Date: Tue, 22 Apr 2014 16:43:16 +0200
In-Reply-To: <87bnvwsm91.fsf@gmail.com> (sfid-20140420_053922_588543_497340E2)
References: <cover.1397924746.git.gamerh2o@gmail.com>
	 <87bnvwsm91.fsf@gmail.com> (sfid-20140420_053922_588543_497340E2)
Content-Type: text/plain; charset="UTF-8"
Mime-Version: 1.0
Sender: linux-wireless-owner@vger.kernel.org
List-ID: <linux-wireless.vger.kernel.org>

On Sun, 2014-04-20 at 11:39 +0800, Zhao, Gang wrote:

> I found that the incorrect checking of return value problem had already
> been fixed in mac80211-next 2beb6dab2d79 ("cfg80211/mac80211: refactor
> cfg80211_chandef_dfs_required()"). But not on mac80211 tree.
> 
> I think the fix may worth going to mac80211 and also
> stable-3.14. Johannes, you can decide whether to apply this patch or it
> needs to be modified, since if it's applied, it will surely cause
> conflict in future time.

I'll let the DFS folk worry about that, I don't use that myself ... if
they need it then they might find the issue or whatever. Chances are,
since CSA isn't there, they won't care much.

> The following two improvement patches should be ignored, since I found
> they need to be rebased to be applied on mac80211-next.

OK.

johannes

